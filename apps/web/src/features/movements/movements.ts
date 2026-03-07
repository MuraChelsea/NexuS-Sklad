import type { OpenApiComponents } from '@nexussklad/shared';

import { ApiClient } from '../../core/api';

type StockMovement = OpenApiComponents['schemas']['StockMovement'];
type CreateMovementRequest = OpenApiComponents['schemas']['CreateMovementRequest'];
type CreateAdjustmentRequest = OpenApiComponents['schemas']['CreateAdjustmentRequest'];
type Product = OpenApiComponents['schemas']['Product'];

type FetchMovementsFilters = {
  productId?: string;
  movementType?: StockMovement['movementType'];
  limit?: number;
  offset?: number;
  dateFrom?: string;
  dateTo?: string;
};

function buildMovementListPath(filters: FetchMovementsFilters = {}) {
  const params = new URLSearchParams();
  if (filters.productId) params.set('productId', filters.productId);
  if (filters.movementType) params.set('movementType', filters.movementType);
  if (filters.limit != null) params.set('limit', String(filters.limit));
  if (filters.offset != null) params.set('offset', String(filters.offset));
  if (filters.dateFrom) params.set('dateFrom', filters.dateFrom);
  if (filters.dateTo) params.set('dateTo', filters.dateTo);
  const suffix = params.toString() ? `?${params.toString()}` : '';
  return `/v1/movements${suffix}`;
}

export async function fetchMovements(accessToken: string, filters: FetchMovementsFilters = {}): Promise<StockMovement[]> {
  const api = new ApiClient(accessToken);
  return api.getList<StockMovement>(buildMovementListPath(filters), 'movements');
}

export async function fetchAllMovements(accessToken: string, filters: Omit<FetchMovementsFilters, 'limit' | 'offset'> = {}) {
  const pageSize = 100;
  const items: StockMovement[] = [];
  let offset = 0;

  while (true) {
    const batch = await fetchMovements(accessToken, {
      ...filters,
      limit: pageSize,
      offset,
    });
    items.push(...batch);

    if (batch.length < pageSize) {
      return items;
    }

    offset += batch.length;
  }
}

export async function createIncome(
  accessToken: string,
  payload: CreateMovementRequest,
): Promise<StockMovement> {
  const api = new ApiClient(accessToken);
  return api.postItem<StockMovement>('/v1/movements/income', 'movements', payload);
}

export async function createExpense(
  accessToken: string,
  payload: CreateMovementRequest,
): Promise<StockMovement> {
  const api = new ApiClient(accessToken);
  return api.postItem<StockMovement>('/v1/movements/expense', 'movements', payload);
}

export async function createAdjustment(
  accessToken: string,
  payload: CreateAdjustmentRequest,
): Promise<StockMovement> {
  const api = new ApiClient(accessToken);
  return api.postItem<StockMovement>('/v1/movements/adjustment', 'movements', payload);
}

export function canAdjust(role: string | undefined): boolean {
  return role === 'OWNER' || role === 'MANAGER';
}

export function formatMovementSummary(item: StockMovement): string {
  return `${item.product.name} · ${item.createdBy.name}`;
}

export function sortProducts(products: Product[]): Product[] {
  return [...products].sort((a, b) => a.name.localeCompare(b.name, 'ru'));
}
