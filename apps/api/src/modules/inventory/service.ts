import {
  InventoryStatus,
  MovementType,
  Prisma,
  type PrismaClient,
} from '@prisma/client';

import { AppError } from '../../lib/app-error.js';

type StartInventoryInput = {
  companyId: string;
  userId: string;
  categoryId?: string;
  productIds?: string[];
  comment?: string | null;
};

type UpdateInventoryItemInput = {
  companyId: string;
  userId: string;
  inventoryId: string;
  itemId: string;
  actualQty: number;
  comment?: string | null;
};

type FinishInventoryInput = {
  companyId: string;
  userId: string;
  inventoryId: string;
  comment?: string | null;
};

export class InventoryService {
  constructor(private readonly prisma: PrismaClient) {}

  async start(input: StartInventoryInput) {
    if (input.productIds && input.productIds.length === 0) {
      throw new AppError(400, 'INVENTORY_PRODUCTS_EMPTY', 'Inventory product list must not be empty');
    }

    return this.prisma.$transaction(async (tx) => {
      await this.ensureActingUser(tx, input.companyId, input.userId);
      await this.ensureCategory(tx, input.companyId, input.categoryId);

      const products = await tx.product.findMany({
        where: {
          companyId: input.companyId,
          ...(input.categoryId ? { categoryId: input.categoryId } : {}),
          ...(input.productIds ? { id: { in: input.productIds } } : {}),
        },
        orderBy: [{ name: 'asc' }],
        select: {
          id: true,
          currentStock: true,
        },
      });

      if (products.length === 0) {
        throw new AppError(400, 'INVENTORY_NO_PRODUCTS', 'No products found for inventory session');
      }

      const session = await tx.inventorySession.create({
        data: {
          companyId: input.companyId,
          startedById: input.userId,
          status: InventoryStatus.IN_PROGRESS,
          comment: this.normalizeComment(input.comment),
          items: {
            create: products.map((product) => ({
              productId: product.id,
              expectedQty: product.currentStock,
              actualQty: product.currentStock,
              difference: new Prisma.Decimal(0),
            })),
          },
        },
        include: this.sessionInclude,
      });

      await tx.auditLog.create({
        data: {
          companyId: input.companyId,
          userId: input.userId,
          action: 'inventory.started',
          entityType: 'inventory_session',
          entityId: session.id,
          payload: {
            itemCount: session.items.length,
            categoryId: input.categoryId ?? null,
            productIds: input.productIds ?? null,
            comment: this.normalizeComment(input.comment),
          },
        },
      });

      return session;
    });
  }

  async getById(companyId: string, inventoryId: string) {
    const session = await this.prisma.inventorySession.findFirst({
      where: {
        id: inventoryId,
        companyId,
      },
      include: this.sessionInclude,
    });

    if (!session) {
      throw new AppError(404, 'INVENTORY_NOT_FOUND', 'Inventory session not found');
    }

    return session;
  }

  async updateItem(input: UpdateInventoryItemInput) {
    if (input.actualQty < 0) {
      throw new AppError(400, 'INVENTORY_ACTUAL_QTY_INVALID', 'Actual quantity must be zero or greater');
    }

    return this.prisma.$transaction(async (tx) => {
      await this.ensureActingUser(tx, input.companyId, input.userId);

      const session = await tx.inventorySession.findFirst({
        where: {
          id: input.inventoryId,
          companyId: input.companyId,
        },
        select: {
          id: true,
          status: true,
        },
      });

      if (!session) {
        throw new AppError(404, 'INVENTORY_NOT_FOUND', 'Inventory session not found');
      }

      if (session.status !== InventoryStatus.IN_PROGRESS) {
        throw new AppError(409, 'INVENTORY_NOT_ACTIVE', 'Inventory session is not active');
      }

      const item = await tx.inventoryItem.findFirst({
        where: {
          id: input.itemId,
          sessionId: input.inventoryId,
        },
        include: {
          product: {
            select: {
              id: true,
              name: true,
              sku: true,
              unit: true,
            },
          },
        },
      });

      if (!item) {
        throw new AppError(404, 'INVENTORY_ITEM_NOT_FOUND', 'Inventory item not found');
      }

      const actualQty = new Prisma.Decimal(input.actualQty);
      const difference = actualQty.minus(item.expectedQty);

      const updatedItem = await tx.inventoryItem.update({
        where: { id: input.itemId },
        data: {
          actualQty,
          difference,
          comment: this.normalizeComment(input.comment),
        },
        include: {
          product: {
            select: {
              id: true,
              name: true,
              sku: true,
              unit: true,
            },
          },
        },
      });

      await tx.auditLog.create({
        data: {
          companyId: input.companyId,
          userId: input.userId,
          action: 'inventory.item.updated',
          entityType: 'inventory_item',
          entityId: updatedItem.id,
          payload: {
            inventoryId: input.inventoryId,
            productId: updatedItem.productId,
            expectedQty: updatedItem.expectedQty.toString(),
            actualQty: updatedItem.actualQty.toString(),
            difference: updatedItem.difference.toString(),
            comment: updatedItem.comment,
          },
        },
      });

      return updatedItem;
    });
  }

  async finish(input: FinishInventoryInput) {
    return this.prisma.$transaction(async (tx) => {
      await this.ensureActingUser(tx, input.companyId, input.userId);

      const session = await tx.inventorySession.findFirst({
        where: {
          id: input.inventoryId,
          companyId: input.companyId,
        },
        include: {
          items: {
            include: {
              product: {
                select: {
                  id: true,
                  name: true,
                  sku: true,
                  unit: true,
                  currentStock: true,
                },
              },
            },
            orderBy: [{ id: 'asc' }],
          },
        },
      });

      if (!session) {
        throw new AppError(404, 'INVENTORY_NOT_FOUND', 'Inventory session not found');
      }

      if (session.status !== InventoryStatus.IN_PROGRESS) {
        throw new AppError(409, 'INVENTORY_NOT_ACTIVE', 'Inventory session is not active');
      }

      const changedProducts = session.items.filter((item) => !item.difference.isZero());

      for (const item of session.items) {
        if (!item.product.currentStock.equals(item.expectedQty)) {
          throw new AppError(
            409,
            'INVENTORY_STALE_STOCK',
            'Product stock changed after inventory started. Restart the session.',
          );
        }
      }

      for (const item of changedProducts) {
        await tx.stockMovement.create({
          data: {
            companyId: input.companyId,
            productId: item.productId,
            createdById: input.userId,
            movementType: MovementType.INVENTORY_DIFF,
            quantity: item.difference,
            beforeQty: item.expectedQty,
            afterQty: item.actualQty,
            comment: item.comment ?? this.normalizeComment(input.comment),
          },
        });

        await tx.product.update({
          where: { id: item.productId },
          data: {
            currentStock: item.actualQty,
          },
        });

        await tx.auditLog.create({
          data: {
            companyId: input.companyId,
            userId: input.userId,
            action: 'movement.inventory_diff.created',
            entityType: 'product',
            entityId: item.productId,
            payload: {
              inventoryId: input.inventoryId,
              productId: item.productId,
              beforeQty: item.expectedQty.toString(),
              afterQty: item.actualQty.toString(),
              difference: item.difference.toString(),
            },
          },
        });
      }

      const finishedSession = await tx.inventorySession.update({
        where: { id: input.inventoryId },
        data: {
          status: InventoryStatus.COMPLETED,
          finishedAt: new Date(),
          comment: this.normalizeComment(input.comment) ?? session.comment,
        },
        include: this.sessionInclude,
      });

      await tx.auditLog.create({
        data: {
          companyId: input.companyId,
          userId: input.userId,
          action: 'inventory.finished',
          entityType: 'inventory_session',
          entityId: finishedSession.id,
          payload: {
            changedItemsCount: changedProducts.length,
            totalItemsCount: session.items.length,
            comment: this.normalizeComment(input.comment) ?? session.comment,
          },
        },
      });

      return finishedSession;
    });
  }

  private async ensureActingUser(
    tx: Prisma.TransactionClient,
    companyId: string,
    userId: string,
  ) {
    const user = await tx.user.findFirst({
      where: {
        id: userId,
        companyId,
        isActive: true,
      },
      select: { id: true },
    });

    if (!user) {
      throw new AppError(400, 'ACTING_USER_NOT_FOUND', 'Acting user not found');
    }
  }

  private async ensureCategory(
    tx: Prisma.TransactionClient,
    companyId: string,
    categoryId?: string,
  ) {
    if (!categoryId) {
      return;
    }

    const category = await tx.category.findFirst({
      where: {
        id: categoryId,
        companyId,
      },
      select: { id: true },
    });

    if (!category) {
      throw new AppError(400, 'INVENTORY_CATEGORY_NOT_FOUND', 'Category not found');
    }
  }

  private normalizeComment(value?: string | null) {
    const trimmed = value?.trim();
    return trimmed ? trimmed : null;
  }

  private readonly sessionInclude = {
    startedBy: {
      select: {
        id: true,
        name: true,
        role: true,
      },
    },
    items: {
      include: {
        product: {
          select: {
            id: true,
            name: true,
            sku: true,
            unit: true,
            currentStock: true,
          },
        },
      },
      orderBy: [{ product: { name: 'asc' } }],
    },
  } satisfies Prisma.InventorySessionInclude;
}
