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

export type ProductImportApplyRowDto = {
  line: number;
  mode: 'create' | 'update';
  name: string;
  productId?: EntityId | null;
  createPayload?: CreateProductRequestDto;
  updatePayload?: UpdateProductRequestDto;
  targetQty?: number | null;
};

export type ProductImportApplyRequestDto = {
  rows: ProductImportApplyRowDto[];
};

export type ProductImportResultRowDto = {
  line: number;
  mode: 'create' | 'update' | 'skip';
  productId: EntityId | null;
  name: string;
  message: string;
};

export type ProductImportResultDto = {
  applied: boolean;
  createdCount: number;
  updatedCount: number;
  adjustedCount: number;
  skippedCount: number;
  rows: ProductImportResultRowDto[];
};
