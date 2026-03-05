import type { EntityId, UserRole } from './common.js';

export type AuthCompanyDto = {
  id: EntityId;
  name: string;
};

export type AuthUserDto = {
  id: EntityId;
  companyId: EntityId;
  name: string;
  email: string | null;
  phone: string | null;
  role: UserRole;
  company: AuthCompanyDto;
};

export type AuthSessionDto = {
  accessToken: string;
  refreshToken: string;
  user: AuthUserDto;
};

export type AuthSessionRouteResponse<TAction extends string> = AuthSessionDto & {
  module: 'auth';
  action: TAction;
};

export type AuthMeResponseDto = {
  user: AuthUserDto;
  module: 'auth';
  action: 'me';
};

export type RegisterRequestDto = {
  companyName: string;
  companyCity?: string | null;
  companyPhone?: string | null;
  ownerName: string;
  email: string;
  phone?: string | null;
  password: string;
};

export type LoginRequestDto = {
  email: string;
  password: string;
};

export type RefreshRequestDto = {
  refreshToken: string;
};

export type LogoutRequestDto = {
  refreshToken: string;
};

export type AcceptInviteRequestDto = {
  inviteToken: string;
  name: string;
  phone?: string | null;
  password: string;
};
