import type { PrismaClient } from '@prisma/client';

import { AppError } from '../../lib/app-error.js';

type CreateProductInput = {
  companyId: string;
  userId: string;
  categoryId?: string | null;
  name: string;
  sku?: string | null;
  barcode?: string | null;
  unit: string;
  description?: string | null;
  minStock?: number | null;
  currentStock?: number | null;
};

type ListProductsInput = {
  companyId: string;
  search?: string;
  categoryId?: string;
};

type UpdateProductInput = {
  companyId: string;
  userId: string;
  productId: string;
  categoryId?: string | null;
  name?: string;
  sku?: string | null;
  barcode?: string | null;
  unit?: string;
  description?: string | null;
  minStock?: number | null;
};

export class ProductService {
  constructor(private readonly prisma: PrismaClient) {}

  async list(input: ListProductsInput) {
    const search = input.search?.trim();

    return this.prisma.product.findMany({
      where: {
        companyId: input.companyId,
        ...(input.categoryId ? { categoryId: input.categoryId } : {}),
        ...(search
          ? {
              OR: [
                { name: { contains: search, mode: 'insensitive' } },
                { sku: { contains: search, mode: 'insensitive' } },
                { barcode: { contains: search, mode: 'insensitive' } },
              ],
            }
          : {}),
      },
      include: {
        category: {
          select: {
            id: true,
            name: true,
          },
        },
      },
      orderBy: [{ updatedAt: 'desc' }, { createdAt: 'desc' }],
    });
  }

  async getById(companyId: string, productId: string) {
    const product = await this.prisma.product.findFirst({
      where: {
        companyId,
        id: productId,
      },
      include: {
        category: {
          select: {
            id: true,
            name: true,
          },
        },
      },
    });

    if (!product) {
      throw new AppError(404, 'PRODUCT_NOT_FOUND', 'Product not found');
    }

    return product;
  }

  async create(input: CreateProductInput) {
    const name = input.name.trim();
    const unit = input.unit.trim();
    const sku = this.normalizeOptionalString(input.sku);
    const barcode = this.normalizeOptionalString(input.barcode);
    const description = this.normalizeOptionalString(input.description);

    if (!name) {
      throw new AppError(400, 'PRODUCT_NAME_EMPTY', 'Product name must not be empty');
    }

    if (!unit) {
      throw new AppError(400, 'PRODUCT_UNIT_EMPTY', 'Unit must not be empty');
    }

    await this.ensureCategory(input.companyId, input.categoryId);
    await this.ensureUniqueFields(input.companyId, sku, barcode);

    return this.prisma.$transaction(async (tx) => {
      const product = await tx.product.create({
        data: {
          companyId: input.companyId,
          categoryId: input.categoryId ?? null,
          name,
          sku,
          barcode,
          unit,
          description,
          minStock: input.minStock ?? 0,
          currentStock: input.currentStock ?? 0,
        },
        include: {
          category: {
            select: {
              id: true,
              name: true,
            },
          },
        },
      });

      await tx.auditLog.create({
        data: {
          companyId: input.companyId,
          userId: input.userId,
          action: 'product.created',
          entityType: 'product',
          entityId: product.id,
          payload: {
            name: product.name,
            categoryId: product.categoryId,
            sku: product.sku,
            barcode: product.barcode,
            unit: product.unit,
            minStock: product.minStock.toString(),
            currentStock: product.currentStock.toString(),
          },
        },
      });

      return product;
    });
  }

  async update(input: UpdateProductInput) {
    const existing = await this.getById(input.companyId, input.productId);

    const name = input.name?.trim();
    const unit = input.unit?.trim();
    const sku =
      input.sku === undefined ? undefined : this.normalizeOptionalString(input.sku);
    const barcode =
      input.barcode === undefined ? undefined : this.normalizeOptionalString(input.barcode);
    const description =
      input.description === undefined
        ? undefined
        : this.normalizeOptionalString(input.description);
    const minStock = input.minStock === null ? 0 : input.minStock;

    if (input.name !== undefined && !name) {
      throw new AppError(400, 'PRODUCT_NAME_EMPTY', 'Product name must not be empty');
    }

    if (input.unit !== undefined && !unit) {
      throw new AppError(400, 'PRODUCT_UNIT_EMPTY', 'Unit must not be empty');
    }

    await this.ensureCategory(input.companyId, input.categoryId);
    await this.ensureUniqueFields(
      input.companyId,
      sku,
      barcode,
      input.productId,
    );

    return this.prisma.$transaction(async (tx) => {
      const product = await tx.product.update({
        where: { id: input.productId },
        data: {
          categoryId: input.categoryId,
          name,
          sku,
          barcode,
          unit,
          description,
          minStock,
        },
        include: {
          category: {
            select: {
              id: true,
              name: true,
            },
          },
        },
      });

      await tx.auditLog.create({
        data: {
          companyId: input.companyId,
          userId: input.userId,
          action: 'product.updated',
          entityType: 'product',
          entityId: product.id,
          payload: {
            before: {
              name: existing.name,
              categoryId: existing.categoryId,
              sku: existing.sku,
              barcode: existing.barcode,
              unit: existing.unit,
              description: existing.description,
              minStock: existing.minStock.toString(),
            },
            after: {
              name: product.name,
              categoryId: product.categoryId,
              sku: product.sku,
              barcode: product.barcode,
              unit: product.unit,
              description: product.description,
              minStock: product.minStock.toString(),
            },
          },
        },
      });

      return product;
    });
  }

  async remove(companyId: string, userId: string, productId: string) {
    const existing = await this.getById(companyId, productId);

    const [movementCount, inventoryItemCount] = await Promise.all([
      this.prisma.stockMovement.count({
        where: {
          companyId,
          productId,
        },
      }),
      this.prisma.inventoryItem.count({
        where: {
          productId,
        },
      }),
    ]);

    if (movementCount > 0 || inventoryItemCount > 0) {
      throw new AppError(
        409,
        'PRODUCT_HAS_HISTORY',
        'Product cannot be deleted because it already has stock history',
      );
    }

    await this.prisma.$transaction(async (tx) => {
      await tx.product.delete({
        where: { id: productId },
      });

      await tx.auditLog.create({
        data: {
          companyId,
          userId,
          action: 'product.deleted',
          entityType: 'product',
          entityId: productId,
          payload: {
            name: existing.name,
            categoryId: existing.categoryId,
            sku: existing.sku,
            barcode: existing.barcode,
            unit: existing.unit,
            currentStock: existing.currentStock.toString(),
          },
        },
      });
    });
  }

  private async ensureCategory(companyId: string, categoryId?: string | null) {
    if (!categoryId) {
      return;
    }

    const category = await this.prisma.category.findFirst({
      where: {
        companyId,
        id: categoryId,
      },
      select: { id: true },
    });

    if (!category) {
      throw new AppError(400, 'PRODUCT_CATEGORY_NOT_FOUND', 'Category not found');
    }
  }

  private async ensureUniqueFields(
    companyId: string,
    rawSku?: string | null,
    rawBarcode?: string | null,
    excludeProductId?: string,
  ) {
    const sku = rawSku?.trim();
    const barcode = rawBarcode?.trim();

    if (sku) {
      const duplicateSku = await this.prisma.product.findFirst({
        where: {
          companyId,
          sku,
          ...(excludeProductId ? { id: { not: excludeProductId } } : {}),
        },
        select: { id: true },
      });

      if (duplicateSku) {
        throw new AppError(409, 'PRODUCT_SKU_TAKEN', 'SKU already exists in this company');
      }
    }

    if (barcode) {
      const duplicateBarcode = await this.prisma.product.findFirst({
        where: {
          companyId,
          barcode,
          ...(excludeProductId ? { id: { not: excludeProductId } } : {}),
        },
        select: { id: true },
      });

      if (duplicateBarcode) {
        throw new AppError(
          409,
          'PRODUCT_BARCODE_TAKEN',
          'Barcode already exists in this company',
        );
      }
    }
  }

  private normalizeOptionalString(value?: string | null) {
    const trimmed = value?.trim();
    return trimmed ? trimmed : null;
  }
}
