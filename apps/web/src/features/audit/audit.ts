import type { OpenApiComponents } from '@nexussklad/shared';

import { ApiClient } from '../../core/api';

type AuditLog = OpenApiComponents['schemas']['AuditLog'];

type AuditFilters = {
  userId?: string;
  entityType?: string;
  action?: string;
  limit?: number;
};

export async function fetchAuditLogs(accessToken: string, filters: AuditFilters = {}): Promise<AuditLog[]> {
  const api = new ApiClient(accessToken);
  const params = new URLSearchParams();
  if (filters.userId) params.set('userId', filters.userId);
  if (filters.entityType) params.set('entityType', filters.entityType);
  if (filters.action) params.set('action', filters.action);
  params.set('limit', String(filters.limit ?? 60));
  return api.getList<AuditLog>(`/v1/audit?${params.toString()}`, 'audit');
}
