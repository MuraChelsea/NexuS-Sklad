import type { OpenApiComponents } from '@nexussklad/shared';

import { ApiClient } from '../../core/api';

type DailyReport = OpenApiComponents['schemas']['DailyReport'];
type StockReport = OpenApiComponents['schemas']['StockReport'];

type DailyReportFilters = {
  date?: string;
};

type StockReportFilters = {
  categoryId?: string;
  search?: string;
  lowOnly?: boolean;
  limit?: number;
};

export async function fetchDailyReport(accessToken: string, filters: DailyReportFilters = {}): Promise<DailyReport> {
  const api = new ApiClient(accessToken);
  const params = new URLSearchParams();
  if (filters.date) params.set('date', filters.date);
  const suffix = params.toString() ? `?${params.toString()}` : '';
  return api.getReport<DailyReport>(`/v1/reports/daily${suffix}`, 'daily');
}

export async function fetchStockReport(accessToken: string, filters: StockReportFilters = {}): Promise<StockReport> {
  const api = new ApiClient(accessToken);
  const params = new URLSearchParams();
  if (filters.categoryId) params.set('categoryId', filters.categoryId);
  if (filters.search) params.set('search', filters.search);
  if (filters.lowOnly) params.set('lowOnly', 'true');
  if (filters.limit != null) params.set('limit', String(filters.limit));
  const suffix = params.toString() ? `?${params.toString()}` : '';
  return api.getReport<StockReport>(`/v1/reports/stock${suffix}`, 'stock');
}
