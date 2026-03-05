import type { OpenApiComponents } from '@nexussklad/shared';

import { ApiClient } from '../../core/api';

type InventorySession = OpenApiComponents['schemas']['InventorySession'];
type InventoryItem = OpenApiComponents['schemas']['InventoryItem'];
type StartInventoryRequest = OpenApiComponents['schemas']['StartInventoryRequest'];
type UpdateInventoryItemRequest = OpenApiComponents['schemas']['UpdateInventoryItemRequest'];
type FinishInventoryRequest = OpenApiComponents['schemas']['FinishInventoryRequest'];

export async function startInventory(
  accessToken: string,
  payload: StartInventoryRequest = {},
): Promise<InventorySession> {
  const api = new ApiClient(accessToken);
  return api.postItem<InventorySession>('/v1/inventory/start', 'inventory', payload);
}

export async function fetchInventorySession(
  accessToken: string,
  inventoryId: string,
): Promise<InventorySession> {
  const api = new ApiClient(accessToken);
  return api.getItem<InventorySession>(`/v1/inventory/${inventoryId}`, 'inventory');
}

export async function updateInventoryItem(
  accessToken: string,
  inventoryId: string,
  itemId: string,
  payload: UpdateInventoryItemRequest,
): Promise<InventoryItem> {
  const api = new ApiClient(accessToken);
  return api.patchItem<InventoryItem>(`/v1/inventory/${inventoryId}/items/${itemId}`, 'inventory', payload);
}

export async function finishInventory(
  accessToken: string,
  inventoryId: string,
  payload: FinishInventoryRequest = {},
): Promise<InventorySession> {
  const api = new ApiClient(accessToken);
  return api.postItem<InventorySession>(`/v1/inventory/${inventoryId}/finish`, 'inventory', payload);
}
