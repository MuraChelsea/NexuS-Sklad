import type { EntityId, IsoDateTime, UserRole } from './common.js';

export type CompanyUserDto = {
  id: EntityId;
  companyId: EntityId;
  name: string;
  email: string | null;
  phone: string | null;
  role: UserRole;
  isActive: boolean;
  createdAt: IsoDateTime;
  inviteExpiresAt: IsoDateTime | null;
};

export type CreateUserRequestDto = {
  name: string;
  email: string;
  phone?: string | null;
  password: string;
  role: Extract<UserRole, 'MANAGER' | 'STAFF'>;
};

export type UpdateUserRequestDto = {
  name?: string;
  email?: string;
  phone?: string | null;
  password?: string;
  role?: Extract<UserRole, 'MANAGER' | 'STAFF'>;
  isActive?: boolean;
};

export type InviteUserRequestDto = {
  email: string;
  role: Extract<UserRole, 'MANAGER' | 'STAFF'>;
};

export type InviteUserResponseDto = {
  user: CompanyUserDto;
  inviteToken: string;
  module: 'users';
  action: 'invite';
};
