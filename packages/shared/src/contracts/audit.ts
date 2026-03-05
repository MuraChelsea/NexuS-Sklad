import type { EntityId, IsoDateTime, UserRole } from './common.js';

export type AuditActorDto = {
  id: EntityId;
  name: string;
  role: UserRole;
};

export type AuditLogDto = {
  id: EntityId;
  companyId: EntityId;
  userId: EntityId;
  action: string;
  entityType: string;
  entityId: EntityId | null;
  payload: Record<string, unknown> | null;
  createdAt: IsoDateTime;
  user: AuditActorDto;
};

export type AuditListResponseDto = {
  items: AuditLogDto[];
  module: 'audit';
};
