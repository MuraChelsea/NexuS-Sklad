import type { OpenApiComponents } from '@nexussklad/shared';

import { ApiClient } from '../../core/api';

type StockMovement = OpenApiComponents['schemas']['StockMovement'];
type CreateMovementRequest = OpenApiComponents['schemas']['CreateMovementRequest'];
type CreateAdjustmentRequest = OpenApiComponents['schemas']['CreateAdjustmentRequest'];
type Product = OpenApiComponents['schemas']['Product'];

export async function fetchMovements(accessToken: string): Promise<StockMovement[]> {
  const api = new ApiClient(accessToken);
  return api.getList<StockMovement>('/v1/movements?limit=30', 'movements');
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
