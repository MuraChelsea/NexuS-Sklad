import type { PrismaClient } from '@prisma/client';

import { AppError } from '../../lib/app-error.js';

type CreateCategoryInput = {
  companyId: string;
  userId: string;
  name: string;
  parentId?: string | null;
};

type UpdateCategoryInput = {
  companyId: string;
  userId: string;
  categoryId: string;
  name?: string;
  parentId?: string | null;
};

export class CategoryService {
  constructor(private readonly prisma: PrismaClient) {}

  async list(companyId: string) {
    return this.prisma.category.findMany({
      where: { companyId },
      include: {
        _count: {
          select: {
            children: true,
            products: true,
          },
        },
      },
      orderBy: [{ name: 'asc' }],
    });
  }

  async getById(companyId: string, categoryId: string) {
    const category = await this.prisma.category.findFirst({
      where: {
        companyId,
        id: categoryId,
      },
      include: {
        _count: {
          select: {
            children: true,
            products: true,
          },
        },
      },
    });

    if (!category) {
      throw new AppError(404, 'CATEGORY_NOT_FOUND', 'Category not found');
    }

    return category;
  }

  async create(input: CreateCategoryInput) {
    const name = input.name.trim();
    if (!name) {
      throw new AppError(400, 'CATEGORY_NAME_EMPTY', 'Category name must not be empty');
    }

    await this.ensureParentCategory(input.companyId, input.parentId);
    await this.ensureUniqueName(input.companyId, name, input.parentId ?? null);

    return this.prisma.$transaction(async (tx) => {
      const category = await tx.category.create({
        data: {
          companyId: input.companyId,
          name,
          parentId: input.parentId ?? null,
        },
      });

      await tx.auditLog.create({
        data: {
          companyId: input.companyId,
          userId: input.userId,
          action: 'category.created',
          entityType: 'category',
          entityId: category.id,
          payload: {
            name: category.name,
            parentId: category.parentId,
          },
        },
      });

      return category;
    });
  }

  async update(input: UpdateCategoryInput) {
    const existing = await this.getById(input.companyId, input.categoryId);

    const nextName = input.name?.trim();
    if (input.name !== undefined && !nextName) {
      throw new AppError(400, 'CATEGORY_NAME_EMPTY', 'Category name must not be empty');
    }

    if (input.parentId === input.categoryId) {
      throw new AppError(400, 'CATEGORY_PARENT_INVALID', 'Category cannot be its own parent');
    }

    await this.ensureParentCategory(input.companyId, input.parentId);

    if (nextName) {
      await this.ensureUniqueName(
        input.companyId,
        nextName,
        input.parentId === undefined ? existing.parentId : input.parentId ?? null,
        input.categoryId,
      );
    }

    return this.prisma.$transaction(async (tx) => {
      const category = await tx.category.update({
        where: { id: input.categoryId },
        data: {
          name: nextName,
          parentId: input.parentId,
        },
      });

      await tx.auditLog.create({
        data: {
          companyId: input.companyId,
          userId: input.userId,
          action: 'category.updated',
          entityType: 'category',
          entityId: category.id,
          payload: {
            before: {
              name: existing.name,
              parentId: existing.parentId,
            },
            after: {
              name: category.name,
              parentId: category.parentId,
            },
          },
        },
      });

      return category;
    });
  }

  async remove(companyId: string, userId: string, categoryId: string) {
    const existing = await this.getById(companyId, categoryId);

    const [childrenCount, productsCount] = await Promise.all([
      this.prisma.category.count({
        where: {
          companyId,
          parentId: categoryId,
        },
      }),
      this.prisma.product.count({
        where: {
          companyId,
          categoryId,
        },
      }),
    ]);

    if (childrenCount > 0 || productsCount > 0) {
      throw new AppError(
        409,
        'CATEGORY_NOT_EMPTY',
        'Category still has subcategories or products',
      );
    }

    await this.prisma.$transaction(async (tx) => {
      await tx.category.delete({
        where: { id: categoryId },
      });

      await tx.auditLog.create({
        data: {
          companyId,
          userId,
          action: 'category.deleted',
          entityType: 'category',
          entityId: categoryId,
          payload: {
            name: existing.name,
            parentId: existing.parentId,
          },
        },
      });
    });
  }

  private async ensureParentCategory(companyId: string, parentId?: string | null) {
    if (!parentId) {
      return;
    }

    const parent = await this.prisma.category.findFirst({
      where: {
        companyId,
        id: parentId,
      },
      select: { id: true },
    });

    if (!parent) {
      throw new AppError(400, 'CATEGORY_PARENT_NOT_FOUND', 'Parent category not found');
    }
  }

  private async ensureUniqueName(
    companyId: string,
    name: string,
    parentId: string | null,
    excludeCategoryId?: string,
  ) {
    const duplicate = await this.prisma.category.findFirst({
      where: {
        companyId,
        name,
        parentId,
        ...(excludeCategoryId ? { id: { not: excludeCategoryId } } : {}),
      },
      select: { id: true },
    });

    if (duplicate) {
      throw new AppError(
        409,
        'CATEGORY_NAME_TAKEN',
        'Category with the same name already exists in this section',
      );
    }
  }
}
