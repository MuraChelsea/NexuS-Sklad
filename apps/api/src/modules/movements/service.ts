import { MovementType, Prisma, type PrismaClient } from '@prisma/client';

import { AppError } from '../../lib/app-error.js';

type ListMovementsInput = {
  companyId: string;
  productId?: string;
  movementType?: MovementType;
  limit?: number;
  offset?: number;
  dateFrom?: string;
  dateTo?: string;
};

type CreateMovementInput = {
  companyId: string;
  userId: string;
  productId: string;
  quantity: number;
  comment?: string | null;
};

type CreateAdjustmentInput = {
  companyId: string;
  userId: string;
  productId: string;
  targetQty: number;
  comment?: string | null;
};

export class MovementService {
  constructor(private readonly prisma: PrismaClient) {}

  async list(input: ListMovementsInput) {
    const createdAt = this.resolveCreatedAtFilter(input.dateFrom, input.dateTo);

    return this.prisma.stockMovement.findMany({
      where: {
        companyId: input.companyId,
        ...(input.productId ? { productId: input.productId } : {}),
        ...(input.movementType ? { movementType: input.movementType } : {}),
        ...(createdAt ? { createdAt } : {}),
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
        createdBy: {
          select: {
            id: true,
            name: true,
            role: true,
          },
        },
      },
      orderBy: [{ createdAt: 'desc' }],
      take: input.limit ?? 50,
      skip: input.offset ?? 0,
    });
  }

  private resolveCreatedAtFilter(dateFrom?: string, dateTo?: string) {
    if (!dateFrom && !dateTo) {
      return undefined;
    }

    const createdAt: { gte?: Date; lte?: Date } = {};

    if (dateFrom) {
      const parsedDateFrom = new Date(dateFrom);
      if (Number.isNaN(parsedDateFrom.getTime())) {
        throw new AppError(400, 'MOVEMENT_DATE_INVALID', 'Invalid movement date range');
      }
      createdAt.gte = parsedDateFrom;
    }

    if (dateTo) {
      const parsedDateTo = new Date(dateTo);
      if (Number.isNaN(parsedDateTo.getTime())) {
        throw new AppError(400, 'MOVEMENT_DATE_INVALID', 'Invalid movement date range');
      }
      createdAt.lte = parsedDateTo;
    }

    if (createdAt.gte && createdAt.lte && createdAt.gte > createdAt.lte) {
      throw new AppError(400, 'MOVEMENT_DATE_INVALID', 'Invalid movement date range');
    }

    return createdAt;
  }

  async createIncome(input: CreateMovementInput) {
    return this.createDeltaMovement({
      ...input,
      movementType: MovementType.INCOME,
      delta: input.quantity,
      auditAction: 'movement.income.created',
    });
  }

  async createExpense(input: CreateMovementInput) {
    return this.createDeltaMovement({
      ...input,
      movementType: MovementType.EXPENSE,
      delta: -input.quantity,
      auditAction: 'movement.expense.created',
    });
  }

  async createAdjustment(input: CreateAdjustmentInput) {
    if (input.targetQty < 0) {
      throw new AppError(400, 'TARGET_QTY_INVALID', 'Target quantity must be zero or greater');
    }

    return this.prisma.$transaction(async (tx) => {
      const context = await this.getMovementContext(tx, input.companyId, input.userId, input.productId);
      const beforeQty = new Prisma.Decimal(context.product.currentStock);
      const afterQty = new Prisma.Decimal(input.targetQty);
      const delta = afterQty.minus(beforeQty);

      const movement = await tx.stockMovement.create({
        data: {
          companyId: input.companyId,
          productId: input.productId,
          createdById: input.userId,
          movementType: MovementType.ADJUSTMENT,
          quantity: delta,
          beforeQty,
          afterQty,
          comment: this.normalizeComment(input.comment),
        },
        include: this.movementInclude,
      });

      await tx.product.update({
        where: { id: input.productId },
        data: {
          currentStock: afterQty,
        },
      });

      await tx.auditLog.create({
        data: {
          companyId: input.companyId,
          userId: input.userId,
          action: 'movement.adjustment.created',
          entityType: 'stock_movement',
          entityId: movement.id,
          payload: {
            productId: input.productId,
            beforeQty: beforeQty.toString(),
            afterQty: afterQty.toString(),
            delta: delta.toString(),
            comment: this.normalizeComment(input.comment),
          },
        },
      });

      return movement;
    });
  }

  private async createDeltaMovement(input: CreateMovementInput & {
    movementType: MovementType;
    delta: number;
    auditAction: string;
  }) {
    if (input.quantity <= 0) {
      throw new AppError(400, 'MOVEMENT_QTY_INVALID', 'Quantity must be greater than zero');
    }

    return this.prisma.$transaction(async (tx) => {
      const context = await this.getMovementContext(tx, input.companyId, input.userId, input.productId);
      const beforeQty = new Prisma.Decimal(context.product.currentStock);
      const delta = new Prisma.Decimal(input.delta);
      const afterQty = beforeQty.plus(delta);

      if (afterQty.isNegative()) {
        throw new AppError(
          409,
          'INSUFFICIENT_STOCK',
          'Expense operation would make stock negative',
        );
      }

      const movement = await tx.stockMovement.create({
        data: {
          companyId: input.companyId,
          productId: input.productId,
          createdById: input.userId,
          movementType: input.movementType,
          quantity: new Prisma.Decimal(input.quantity),
          beforeQty,
          afterQty,
          comment: this.normalizeComment(input.comment),
        },
        include: this.movementInclude,
      });

      await tx.product.update({
        where: { id: input.productId },
        data: {
          currentStock: afterQty,
        },
      });

      await tx.auditLog.create({
        data: {
          companyId: input.companyId,
          userId: input.userId,
          action: input.auditAction,
          entityType: 'stock_movement',
          entityId: movement.id,
          payload: {
            productId: input.productId,
            movementType: input.movementType,
            quantity: input.quantity.toString(),
            beforeQty: beforeQty.toString(),
            afterQty: afterQty.toString(),
            comment: this.normalizeComment(input.comment),
          },
        },
      });

      return movement;
    });
  }

  private async getMovementContext(
    tx: Prisma.TransactionClient,
    companyId: string,
    userId: string,
    productId: string,
  ) {
    const [user, product] = await Promise.all([
      tx.user.findFirst({
        where: {
          id: userId,
          companyId,
          isActive: true,
        },
        select: { id: true },
      }),
      tx.product.findFirst({
        where: {
          id: productId,
          companyId,
        },
        select: {
          id: true,
          currentStock: true,
        },
      }),
    ]);

    if (!user) {
      throw new AppError(400, 'ACTING_USER_NOT_FOUND', 'Acting user not found');
    }

    if (!product) {
      throw new AppError(404, 'PRODUCT_NOT_FOUND', 'Product not found');
    }

    return { user, product };
  }

  private normalizeComment(value?: string | null) {
    const trimmed = value?.trim();
    return trimmed ? trimmed : null;
  }

  private readonly movementInclude = {
    product: {
      select: {
        id: true,
        name: true,
        sku: true,
        unit: true,
      },
    },
    createdBy: {
      select: {
        id: true,
        name: true,
        role: true,
      },
    },
  } satisfies Prisma.StockMovementInclude;
}
