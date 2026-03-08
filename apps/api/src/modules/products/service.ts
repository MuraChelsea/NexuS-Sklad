import { MovementType, Prisma, type PrismaClient } from '@prisma/client';

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

type ImportProductInput = {
  companyId: string;
  userId: string;
  rows: Array<{
    line: number;
    mode: 'create' | 'update';
    name: string;
    productId?: string | null;
    createPayload?: Omit<CreateProductInput, 'companyId' | 'userId'>;
    updatePayload?: Omit<UpdateProductInput, 'companyId' | 'userId' | 'productId'>;
    targetQty?: number | null;
  }>;
};

type ImportProductResult = {
  applied: boolean;
  createdCount: number;
  updatedCount: number;
  adjustedCount: number;
  skippedCount: number;
  rows: Array<{
    line: number;
    mode: 'create' | 'update' | 'skip';
    productId: string | null;
    name: string;
    message: string;
  }>;
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
    return this.prisma.$transaction((tx) => this.createProductTx(tx, input));
  }

  async update(input: UpdateProductInput) {
    return this.prisma.$transaction((tx) => this.updateProductTx(tx, input));
  }

  async importApply(input: ImportProductInput): Promise<ImportProductResult> {
    if (input.rows.length === 0) {
      throw new AppError(400, 'PRODUCT_IMPORT_EMPTY', 'Import plan must contain at least one row');
    }

    return this.prisma.$transaction(async (tx) => {
      const touchedTargets = new Set<string>();
      const result: ImportProductResult = {
        applied: true,
        createdCount: 0,
        updatedCount: 0,
        adjustedCount: 0,
        skippedCount: 0,
        rows: [],
      };

      for (const row of input.rows) {
        if (row.mode === 'create') {
          if (!row.createPayload) {
            throw new AppError(400, 'PRODUCT_IMPORT_PLAN_INVALID', 'Create import row must include createPayload');
          }

          const createKey = `create:${this.normalizeOptionalString(row.createPayload.sku) ?? ''}:${this.normalizeOptionalString(row.createPayload.barcode) ?? ''}:${row.name.trim().toLowerCase()}`;
          if (touchedTargets.has(createKey)) {
            throw new AppError(409, 'PRODUCT_IMPORT_DUPLICATE_TARGET', 'Import plan contains duplicate create targets');
          }
          touchedTargets.add(createKey);

          const product = await this.createProductTx(tx, {
            companyId: input.companyId,
            userId: input.userId,
            ...row.createPayload,
          });

          result.createdCount += 1;
          result.rows.push({
            line: row.line,
            mode: 'create',
            productId: product.id,
            name: product.name,
            message: 'Товар создан',
          });
          continue;
        }

        if (!row.productId) {
          throw new AppError(400, 'PRODUCT_IMPORT_PLAN_INVALID', 'Update import row must include productId');
        }

        const updateKey = `update:${row.productId}`;
        if (touchedTargets.has(updateKey)) {
          throw new AppError(409, 'PRODUCT_IMPORT_DUPLICATE_TARGET', 'Import plan contains duplicate update targets');
        }
        touchedTargets.add(updateKey);

        let product = await this.getByIdTx(tx, input.companyId, row.productId);
        let cardUpdated = false;
        let stockAdjusted = false;

        if (row.updatePayload && Object.keys(row.updatePayload).length > 0) {
          product = await this.updateProductTx(tx, {
            companyId: input.companyId,
            userId: input.userId,
            productId: row.productId,
            ...row.updatePayload,
          });
          cardUpdated = true;
          result.updatedCount += 1;
        }

        if (row.targetQty !== undefined && row.targetQty !== null) {
          const currentStock = Number(product.currentStock);
          if (!Number.isFinite(row.targetQty) || row.targetQty < 0) {
            throw new AppError(400, 'TARGET_QTY_INVALID', 'Target quantity must be zero or greater');
          }
          if (currentStock !== row.targetQty) {
            await this.createAdjustmentTx(tx, {
              companyId: input.companyId,
              userId: input.userId,
              productId: row.productId,
              targetQty: row.targetQty,
              comment: `Импорт каталога, строка ${row.line}`,
            });
            stockAdjusted = true;
            result.adjustedCount += 1;
          }
        }

        if (!cardUpdated && !stockAdjusted) {
          result.skippedCount += 1;
          result.rows.push({
            line: row.line,
            mode: 'skip',
            productId: product.id,
            name: product.name,
            message: 'Без изменений',
          });
          continue;
        }

        result.rows.push({
          line: row.line,
          mode: 'update',
          productId: product.id,
          name: product.name,
          message: cardUpdated && stockAdjusted
            ? 'Карточка и остаток обновлены'
            : cardUpdated
              ? 'Карточка товара обновлена'
              : 'Остаток выровнен корректировкой',
        });
      }

      return result;
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

  private async createProductTx(
    tx: Prisma.TransactionClient,
    input: CreateProductInput,
  ) {
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

    await this.ensureCategoryTx(tx, input.companyId, input.categoryId);
    await this.ensureUniqueFieldsTx(tx, input.companyId, sku, barcode);

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
      include: this.productInclude,
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
  }

  private async updateProductTx(
    tx: Prisma.TransactionClient,
    input: UpdateProductInput,
  ) {
    const existing = await this.getByIdTx(tx, input.companyId, input.productId);

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

    await this.ensureCategoryTx(tx, input.companyId, input.categoryId);
    await this.ensureUniqueFieldsTx(
      tx,
      input.companyId,
      sku,
      barcode,
      input.productId,
    );

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
      include: this.productInclude,
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
  }

  private async createAdjustmentTx(
    tx: Prisma.TransactionClient,
    input: {
      companyId: string;
      userId: string;
      productId: string;
      targetQty: number;
      comment?: string | null;
    },
  ) {
    const product = await this.getByIdTx(tx, input.companyId, input.productId);
    const beforeQty = new Prisma.Decimal(product.currentStock);
    const afterQty = new Prisma.Decimal(input.targetQty);
    const delta = afterQty.minus(beforeQty);
    const comment = this.normalizeOptionalString(input.comment);

    const movement = await tx.stockMovement.create({
      data: {
        companyId: input.companyId,
        productId: input.productId,
        createdById: input.userId,
        movementType: MovementType.ADJUSTMENT,
        quantity: delta,
        beforeQty,
        afterQty,
        comment,
      },
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
          comment,
        },
      },
    });
  }

  private async getByIdTx(
    tx: Prisma.TransactionClient,
    companyId: string,
    productId: string,
  ) {
    const product = await tx.product.findFirst({
      where: {
        companyId,
        id: productId,
      },
      include: this.productInclude,
    });

    if (!product) {
      throw new AppError(404, 'PRODUCT_NOT_FOUND', 'Product not found');
    }

    return product;
  }

  private async ensureCategoryTx(
    tx: Prisma.TransactionClient,
    companyId: string,
    categoryId?: string | null,
  ) {
    if (!categoryId) {
      return;
    }

    const category = await tx.category.findFirst({
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

  private async ensureUniqueFieldsTx(
    tx: Prisma.TransactionClient,
    companyId: string,
    rawSku?: string | null,
    rawBarcode?: string | null,
    excludeProductId?: string,
  ) {
    const sku = rawSku?.trim();
    const barcode = rawBarcode?.trim();

    if (sku) {
      const duplicateSku = await tx.product.findFirst({
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
      const duplicateBarcode = await tx.product.findFirst({
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

  private readonly productInclude = {
    category: {
      select: {
        id: true,
        name: true,
      },
    },
  } satisfies Prisma.ProductInclude;
}
