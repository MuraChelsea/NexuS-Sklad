import type { DecimalString, EntityId, IsoDateTime } from './common.js';

export type ProductCategoryDto = {
  id: EntityId;
  name: string;
};

export type ProductDto = {
  id: EntityId;
  companyId: EntityId;
  categoryId: EntityId | null;
  name: string;
  sku: string | null;
  barcode: string | null;
  unit: string;
  description: string | null;
  minStock: DecimalString;
  currentStock: DecimalString;
  createdAt: IsoDateTime;
  updatedAt: IsoDateTime;
  category?: ProductCategoryDto | null;
};

export type CreateProductRequestDto = {
  categoryId?: EntityId | null;
  name: string;
  sku?: string | null;
  barcode?: string | null;
  unit: string;
  description?: string | null;
  minStock?: number;
  currentStock?: number;
};

export type UpdateProductRequestDto = {
  categoryId?: EntityId | null;
  name?: string;
  sku?: string | null;
  barcode?: string | null;
  unit?: string;
  description?: string | null;
  minStock?: number;
};
