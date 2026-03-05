import type { FastifyInstance, FastifyRequest } from 'fastify';

import type { AppUserRole } from '../config/env.js';
import { verifyAuthToken, type AuthTokenPayload } from '../lib/token.js';

export function registerAuth(app: FastifyInstance) {
  app.decorateRequest('authUser', null);

  app.addHook('onRequest', async (request) => {
    const token = getBearerToken(request);
    if (!token) {
      return;
    }

    try {
      const payload = verifyAuthToken(token, app.appEnv.jwtAccessSecret, 'access');
      request.authUser = {
        userId: payload.sub,
        companyId: payload.companyId,
        role: payload.role as AppUserRole,
      };
    } catch {
      request.authUser = null;
    }
  });
}

function getBearerToken(request: FastifyRequest) {
  const header = request.headers.authorization;

  if (!header?.startsWith('Bearer ')) {
    return null;
  }

  return header.slice('Bearer '.length).trim();
}

export function requireAuthUser(request: FastifyRequest) {
  if (!request.authUser) {
    throw new Error('AUTH_USER_MISSING');
  }

  return request.authUser;
}

export function toRequestAuthUser(payload: AuthTokenPayload) {
  return {
    userId: payload.sub,
    companyId: payload.companyId,
    role: payload.role as AppUserRole,
  };
}
