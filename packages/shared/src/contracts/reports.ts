import type { DecimalString, EntityId } from './common.js';

export type DailyMovementSummaryItemDto = {
  count: number;
  quantity: DecimalString;
};

export type DailyMovementSummaryDto = {
  INCOME?: DailyMovementSummaryItemDto;
  EXPENSE?: DailyMovementSummaryItemDto;
  ADJUSTMENT?: DailyMovementSummaryItemDto;
  INVENTORY_DIFF?: DailyMovementSummaryItemDto;
};

export type DailyInventorySummaryDto = {
  sessionsCount: number;
};

export type DailyStockSummaryDto = {
  totalProducts: number;
  lowStockCount: number;
};

export type DailyReportDto = {
  date: string;
  movementSummary: DailyMovementSummaryDto;
  inventory: DailyInventorySummaryDto & {
    sessions: Array<{
      id: EntityId;
      status: string;
      startedAt: string;
      finishedAt: string | null;
      comment: string | null;
      startedBy: {
        id: EntityId;
        name: string;
      };
      _count: {
        items: number;
      };
    }>;
  };
  stock: DailyStockSummaryDto;
};

export type StockReportItemDto = {
  id: EntityId;
  name: string;
  sku: string | null;
  unit: string;
  currentStock: DecimalString;
  minStock: DecimalString;
  isLowStock: boolean;
  category: {
    id: EntityId;
    name: string;
  } | null;
};

export type StockReportDto = {
  summary: {
    totalItems: number;
    lowStockItems: number;
  };
  items: StockReportItemDto[];
};
