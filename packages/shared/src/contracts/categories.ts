import type { EntityId, IsoDateTime } from './common.js';

export type CategoryDto = {
  id: EntityId;
  companyId: EntityId;
  parentId: EntityId | null;
  name: string;
  createdAt: IsoDateTime;
};

export type CreateCategoryRequestDto = {
  name: string;
};

export type UpdateCategoryRequestDto = {
  name?: string;
};
