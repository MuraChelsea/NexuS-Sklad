import { MovementType, Prisma, type PrismaClient } from '@prisma/client';

import { AppError } from '../../lib/app-error.js';

type DailyReportInput = {
  companyId: string;
  date?: string;
};

type StockReportInput = {
  companyId: string;
  categoryId?: string;
  search?: string;
  lowOnly?: boolean;
  limit?: number;
};

export class ReportService {
  constructor(private readonly prisma: PrismaClient) {}

  async daily(input: DailyReportInput) {
    const { dayStart, dayEnd, normalizedDate } = this.resolveDayRange(input.date);

    const [movementGroups, inventorySessions, stockSnapshot] = await Promise.all([
      this.prisma.stockMovement.groupBy({
        by: ['movementType'],
        where: {
          companyId: input.companyId,
          createdAt: {
            gte: dayStart,
            lt: dayEnd,
          },
        },
        _count: { _all: true },
        _sum: { quantity: true },
      }),
      this.prisma.inventorySession.findMany({
        where: {
          companyId: input.companyId,
          startedAt: {
            gte: dayStart,
            lt: dayEnd,
          },
        },
        orderBy: [{ startedAt: 'desc' }],
        select: {
          id: true,
          status: true,
          startedAt: true,
          finishedAt: true,
          comment: true,
          startedBy: {
            select: {
              id: true,
              name: true,
            },
          },
          _count: {
            select: {
              items: true,
            },
          },
        },
      }),
      this.prisma.product.findMany({
        where: {
          companyId: input.companyId,
        },
        select: {
          id: true,
          minStock: true,
          currentStock: true,
        },
      }),
    ]);

    const lowStockCount = stockSnapshot.filter((product) =>
      product.currentStock.lessThanOrEqualTo(product.minStock),
    ).length;
    const totalProducts = stockSnapshot.length;

    const movementSummary = {
      INCOME: this.findMovementSummary(movementGroups, MovementType.INCOME),
      EXPENSE: this.findMovementSummary(movementGroups, MovementType.EXPENSE),
      ADJUSTMENT: this.findMovementSummary(movementGroups, MovementType.ADJUSTMENT),
      INVENTORY_DIFF: this.findMovementSummary(movementGroups, MovementType.INVENTORY_DIFF),
    };

    return {
      date: normalizedDate,
      movementSummary,
      inventory: {
        sessionsCount: inventorySessions.length,
        sessions: inventorySessions,
      },
      stock: {
        totalProducts,
        lowStockCount,
      },
    };
  }

  async stock(input: StockReportInput) {
    const search = input.search?.trim();

    const products = await this.prisma.product.findMany({
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
      orderBy: [{ updatedAt: 'desc' }, { name: 'asc' }],
      ...(input.limit != null ? { take: input.limit } : {}),
    });

    const items = products
      .map((product) => ({
        ...product,
        isLowStock: product.currentStock.lessThanOrEqualTo(product.minStock),
      }))
      .filter((product) => (input.lowOnly ? product.isLowStock : true));

    const lowStockItems = items.filter((product) => product.isLowStock);

    return {
      summary: {
        totalItems: items.length,
        lowStockItems: lowStockItems.length,
      },
      items,
    };
  }

  private resolveDayRange(date?: string) {
    const baseDate = date ? new Date(`${date}T00:00:00.000Z`) : new Date();

    if (Number.isNaN(baseDate.getTime())) {
      throw new AppError(400, 'REPORT_DATE_INVALID', 'Invalid report date');
    }

    const dayStart = new Date(Date.UTC(
      baseDate.getUTCFullYear(),
      baseDate.getUTCMonth(),
      baseDate.getUTCDate(),
      0,
      0,
      0,
      0,
    ));
    const dayEnd = new Date(dayStart);
    dayEnd.setUTCDate(dayEnd.getUTCDate() + 1);

    return {
      dayStart,
      dayEnd,
      normalizedDate: dayStart.toISOString().slice(0, 10),
    };
  }

  private findMovementSummary(
    groups: Array<{
      movementType: MovementType;
      _count: { _all: number };
      _sum: { quantity: Prisma.Decimal | null };
    }>,
    movementType: MovementType,
  ) {
    const group = groups.find((item) => item.movementType === movementType);

    return {
      count: group?._count._all ?? 0,
      quantity: group?._sum.quantity ?? new Prisma.Decimal(0),
    };
  }
}
