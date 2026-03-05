import type {
  DecimalString,
  EntityId,
  InventoryStatus,
  IsoDateTime,
  UserRole,
} from './common.js';

export type InventoryProductDto = {
  id: EntityId;
  name: string;
  sku: string | null;
  unit: string;
};

export type InventoryStartedByDto = {
  id: EntityId;
  name: string;
  role: UserRole;
};

export type InventoryItemDto = {
  id: EntityId;
  sessionId: EntityId;
  productId: EntityId;
  expectedQty: DecimalString;
  actualQty: DecimalString;
  difference: DecimalString;
  comment: string | null;
  product: InventoryProductDto;
};

export type InventorySessionDto = {
  id: EntityId;
  companyId: EntityId;
  startedById: EntityId;
  startedBy: InventoryStartedByDto;
  status: InventoryStatus;
  comment: string | null;
  startedAt: IsoDateTime;
  finishedAt: IsoDateTime | null;
  items: InventoryItemDto[];
};

export type StartInventoryRequestDto = {
  categoryId?: EntityId;
  productIds?: EntityId[];
  comment?: string | null;
};

export type UpdateInventoryItemRequestDto = {
  actualQty: number;
  comment?: string | null;
};

export type FinishInventoryRequestDto = {
  comment?: string | null;
};
