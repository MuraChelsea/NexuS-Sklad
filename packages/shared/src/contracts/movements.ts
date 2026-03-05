import type {
  DecimalString,
  EntityId,
  IsoDateTime,
  MovementType,
  UserRole,
} from './common.js';

export type MovementActorDto = {
  id: EntityId;
  name: string;
  role: UserRole;
};

export type MovementProductDto = {
  id: EntityId;
  name: string;
  sku: string | null;
  unit: string;
};

export type StockMovementDto = {
  id: EntityId;
  companyId: EntityId;
  productId: EntityId;
  createdById: EntityId;
  movementType: MovementType;
  quantity: DecimalString;
  beforeQty: DecimalString;
  afterQty: DecimalString;
  comment: string | null;
  createdAt: IsoDateTime;
  product: MovementProductDto;
  createdBy: MovementActorDto;
};

export type CreateMovementRequestDto = {
  productId: EntityId;
  quantity: number;
  comment?: string | null;
};

export type CreateAdjustmentRequestDto = {
  productId: EntityId;
  targetQty: number;
  comment?: string | null;
};
