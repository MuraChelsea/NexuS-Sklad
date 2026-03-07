import type { OpenApiComponents } from '@nexussklad/shared';

import { ApiClient } from '../../core/api';

type AuditLog = OpenApiComponents['schemas']['AuditLog'];

type AuditFilters = {
  userId?: string;
  entityType?: string;
  action?: string;
  limit?: number;
  offset?: number;
};

function buildAuditListPath(filters: AuditFilters = {}) {
  const params = new URLSearchParams();
  if (filters.userId) params.set('userId', filters.userId);
  if (filters.entityType) params.set('entityType', filters.entityType);
  if (filters.action) params.set('action', filters.action);
  params.set('limit', String(filters.limit ?? 60));
  if (filters.offset != null) params.set('offset', String(filters.offset));
  return `/v1/audit?${params.toString()}`;
}

export async function fetchAuditLogs(accessToken: string, filters: AuditFilters = {}): Promise<AuditLog[]> {
  const api = new ApiClient(accessToken);
  return api.getList<AuditLog>(buildAuditListPath(filters), 'audit');
}

export async function fetchAllAuditLogs(accessToken: string, filters: Omit<AuditFilters, 'limit' | 'offset'> = {}): Promise<AuditLog[]> {
  const pageSize = 100;
  let offset = 0;
  const items: AuditLog[] = [];

  while (true) {
    const batch = await fetchAuditLogs(accessToken, {
      ...filters,
      limit: pageSize,
      offset,
    });
    items.push(...batch);
    if (batch.length < pageSize) {
      break;
    }
    offset += batch.length;
  }

  return items;
}
