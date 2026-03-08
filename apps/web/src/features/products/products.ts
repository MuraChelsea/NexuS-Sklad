import { ApiClient } from '../../core/api';

import type { OpenApiComponents } from '@nexussklad/shared';

type Product = OpenApiComponents['schemas']['Product'];
type Category = OpenApiComponents['schemas']['Category'];
type CreateProductRequest = OpenApiComponents['schemas']['CreateProductRequest'];
type UpdateProductRequest = OpenApiComponents['schemas']['UpdateProductRequest'];
type ProductImportApplyRequest = OpenApiComponents['schemas']['ProductImportApplyRequest'];
type ProductImportResult = OpenApiComponents['schemas']['ProductImportResult'];
type CreateCategoryRequest = OpenApiComponents['schemas']['CreateCategoryRequest'];
type UpdateCategoryRequest = OpenApiComponents['schemas']['UpdateCategoryRequest'];

export async function fetchProducts(accessToken: string, search?: string): Promise<Product[]> {
  const api = new ApiClient(accessToken);
  const suffix = search && search.trim() ? `?search=${encodeURIComponent(search.trim())}` : '';
  return api.getList<Product>(`/v1/products${suffix}`, 'products');
}

export async function fetchCategories(accessToken: string): Promise<Category[]> {
  const api = new ApiClient(accessToken);
  return api.getList<Category>('/v1/categories', 'categories');
}

export async function createProduct(
  accessToken: string,
  payload: CreateProductRequest,
): Promise<Product> {
  const api = new ApiClient(accessToken);
  return api.postItem<Product>('/v1/products', 'products', payload);
}

export async function updateProduct(
  accessToken: string,
  productId: string,
  payload: UpdateProductRequest,
): Promise<Product> {
  const api = new ApiClient(accessToken);
  return api.patchItem<Product>(`/v1/products/${productId}`, 'products', payload);
}

export async function importProducts(
  accessToken: string,
  payload: ProductImportApplyRequest,
): Promise<ProductImportResult> {
  const api = new ApiClient(accessToken);
  return api.postItem<ProductImportResult>('/v1/products/import', 'products', payload);
}

export async function deleteProduct(accessToken: string, productId: string): Promise<void> {
  const api = new ApiClient(accessToken);
  await api.requestVoid(`/v1/products/${productId}`, 'DELETE');
}

export async function createCategory(
  accessToken: string,
  payload: CreateCategoryRequest,
): Promise<Category> {
  const api = new ApiClient(accessToken);
  return api.postItem<Category>('/v1/categories', 'categories', payload);
}

export async function updateCategory(
  accessToken: string,
  categoryId: string,
  payload: UpdateCategoryRequest,
): Promise<Category> {
  const api = new ApiClient(accessToken);
  return api.patchItem<Category>(`/v1/categories/${categoryId}`, 'categories', payload);
}

export async function deleteCategory(accessToken: string, categoryId: string): Promise<void> {
  const api = new ApiClient(accessToken);
  await api.requestVoid(`/v1/categories/${categoryId}`, 'DELETE');
}
