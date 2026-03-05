import type { OpenApiComponents } from '@nexussklad/shared';

import { ApiClient, readModuleContract } from '../../core/api';

type Company = OpenApiComponents['schemas']['Company'];
type CompanyUser = OpenApiComponents['schemas']['CompanyUser'];
type InviteUserRequest = OpenApiComponents['schemas']['InviteUserRequest'];
type InviteUserResponse = OpenApiComponents['schemas']['InviteUserResponse'];
type UpdateCompanyRequest = OpenApiComponents['schemas']['UpdateCompanyRequest'];
type UpdateUserRequest = OpenApiComponents['schemas']['UpdateUserRequest'];

export async function fetchCompany(accessToken: string): Promise<Company> {
  const api = new ApiClient(accessToken);
  return api.getItem<Company>('/v1/company', 'company');
}

export async function updateCompany(
  accessToken: string,
  payload: UpdateCompanyRequest,
): Promise<Company> {
  const api = new ApiClient(accessToken);
  return api.patchItem<Company>('/v1/company', 'company', payload);
}

export async function fetchUsers(accessToken: string): Promise<CompanyUser[]> {
  const api = new ApiClient(accessToken);
  return api.getList<CompanyUser>('/v1/users', 'users');
}

export async function inviteUser(
  accessToken: string,
  payload: InviteUserRequest,
): Promise<InviteUserResponse> {
  const api = new ApiClient(accessToken);
  return readModuleContract<InviteUserResponse>(
    await api.post<unknown>('/v1/users/invite', payload),
    'users',
  );
}

export async function updateUser(
  accessToken: string,
  userId: string,
  payload: UpdateUserRequest,
): Promise<CompanyUser> {
  const api = new ApiClient(accessToken);
  return api.patchItem<CompanyUser>(`/v1/users/${userId}`, 'users', payload);
}
