import type { EntityId, IsoDateTime } from './common.js';

export type CompanyDto = {
  id: EntityId;
  name: string;
  city: string | null;
  phone: string | null;
  createdAt: IsoDateTime;
};

export type UpdateCompanyRequestDto = {
  name?: string;
  city?: string | null;
  phone?: string | null;
};
