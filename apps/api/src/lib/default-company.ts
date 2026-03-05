import type { FastifyInstance, FastifyRequest } from 'fastify';

import type { AppUserRole } from '../config/env.js';
import { AppError } from './app-error.js';

export function requireDefaultCompanyId(app: FastifyInstance) {
  if (!app.appEnv.allowDevAuthFallback) {
    throw new AppError(401, 'AUTH_REQUIRED', 'Authentication required');
  }

  const companyId = app.appEnv.defaultCompanyId;

  if (!companyId) {
    throw new AppError(
      400,
      'DEFAULT_COMPANY_ID_MISSING',
      'Set DEFAULT_COMPANY_ID in environment for local development',
    );
  }

  return companyId;
}

export function requireDefaultUserId(app: FastifyInstance) {
  if (!app.appEnv.allowDevAuthFallback) {
    throw new AppError(401, 'AUTH_REQUIRED', 'Authentication required');
  }

  const userId = app.appEnv.defaultUserId;

  if (!userId) {
    throw new AppError(
      400,
      'DEFAULT_USER_ID_MISSING',
      'Set DEFAULT_USER_ID in environment for local development',
    );
  }

  return userId;
}

export function resolveCompanyId(app: FastifyInstance, request: FastifyRequest) {
  return request.authUser?.companyId ?? requireDefaultCompanyId(app);
}

export function resolveActor(app: FastifyInstance, request: FastifyRequest) {
  if (request.authUser) {
    return {
      companyId: request.authUser.companyId,
      userId: request.authUser.userId,
      role: request.authUser.role,
    };
  }

  const role = app.appEnv.defaultUserRole;
  if (!app.appEnv.allowDevAuthFallback) {
    throw new AppError(401, 'AUTH_REQUIRED', 'Authentication required');
  }

  if (!role) {
    throw new AppError(
      400,
      'DEFAULT_USER_ROLE_MISSING',
      'Set DEFAULT_USER_ROLE in environment for local development',
    );
  }

  return {
    companyId: requireDefaultCompanyId(app),
    userId: requireDefaultUserId(app),
    role,
  };
}

export function requireRoles(
  app: FastifyInstance,
  request: FastifyRequest,
  allowedRoles: AppUserRole[],
) {
  const role = request.authUser?.role ?? (app.appEnv.allowDevAuthFallback ? app.appEnv.defaultUserRole : null);

  if (!role) {
    throw new AppError(401, 'AUTH_REQUIRED', 'Authentication required');
  }

  if (!allowedRoles.includes(role)) {
    throw new AppError(403, 'FORBIDDEN', 'You do not have permission for this action');
  }

  return role;
}
