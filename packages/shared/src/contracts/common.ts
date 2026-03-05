export type UserRole = 'OWNER' | 'MANAGER' | 'STAFF';

export type MovementType =
  | 'INCOME'
  | 'EXPENSE'
  | 'ADJUSTMENT'
  | 'INVENTORY_DIFF';

export type InventoryStatus = 'DRAFT' | 'IN_PROGRESS' | 'COMPLETED';

export type EntityId = string;
export type IsoDateTime = string;
export type DecimalString = string;

export type ApiItemResponse<TItem> = {
  item: TItem;
  module: string;
  action?: string;
};

export type ApiListResponse<TItem> = {
  items: TItem[];
  module: string;
  action?: string;
};

export type ApiReportResponse<TItem, TReport extends string> = {
  item: TItem;
  module: 'reports';
  report: TReport;
};

export type ApiErrorResponse = {
  error: {
    code: string;
    message: string;
  };
};
