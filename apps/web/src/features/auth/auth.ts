import type { OpenApiComponents } from '@nexussklad/shared';

import { ApiClient, readModuleContract } from '../../core/api';

export type AuthSession = OpenApiComponents['schemas']['AuthSessionLoginResponse'];
export type CurrentUser = OpenApiComponents['schemas']['AuthMeResponse']['user'];
type LoginRequest = OpenApiComponents['schemas']['LoginRequest'];
type RefreshRequest = OpenApiComponents['schemas']['RefreshRequest'];
type AuthMeResponse = OpenApiComponents['schemas']['AuthMeResponse'];

export async function login(email: string, password: string): Promise<AuthSession> {
  const api = new ApiClient();
  const payload: LoginRequest = { email, password };
  return readModuleContract<AuthSession>(
    await api.post<unknown>('/v1/auth/login', payload),
    'auth',
  );
}

export async function me(accessToken: string): Promise<CurrentUser> {
  const api = new ApiClient(accessToken);
  const response = readModuleContract<AuthMeResponse>(
    await api.get<unknown>('/v1/auth/me'),
    'auth',
  );
  return response.user;
}

export async function refresh(refreshToken: string): Promise<AuthSession> {
  const api = new ApiClient();
  const payload: RefreshRequest = { refreshToken };
  return readModuleContract<AuthSession>(
    await api.post<unknown>('/v1/auth/refresh', payload),
    'auth',
  );
}
