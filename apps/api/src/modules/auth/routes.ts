import type { FastifyPluginAsync, FastifyRequest } from 'fastify';
import type {
  OpenApiComponents,
} from '@nexussklad/shared';

import { AppError } from '../../lib/app-error.js';
import {
  authErrorResponses,
  authMeSchema,
  authSessionSchema,
} from '../../lib/response-schemas.js';
import {
  acceptInviteSchema,
  loginSchema,
  logoutSchema,
  refreshSchema,
  registerSchema,
} from './schemas.js';
import { AuthService } from './service.js';

type OpenApiSchemas = OpenApiComponents['schemas'];

export const authRoutes: FastifyPluginAsync = async (app) => {
  const authService = new AuthService(app.prisma);
  const rateLimitAttempts = new Map<string, number[]>();

  const enforceAuthRateLimit = (scope: string) => {
    return async (request: FastifyRequest) => {
      const now = Date.now();
      const cutoff = now - app.appEnv.authRateLimitWindowMs;
      const forwardedFor = request.headers['x-forwarded-for'];
      const clientIp =
        typeof forwardedFor === 'string' && forwardedFor.trim().length > 0
          ? forwardedFor.split(',')[0]!.trim()
          : request.ip;
      const key = `${scope}:${clientIp}`;
      const attempts = (rateLimitAttempts.get(key) ?? []).filter((stamp) => stamp > cutoff);

      if (attempts.length >= app.appEnv.authRateLimitMax) {
        throw new AppError(429, 'AUTH_RATE_LIMITED', 'Too many authentication attempts. Try again later.');
      }

      attempts.push(now);
      rateLimitAttempts.set(key, attempts);
    };
  };

  app.post('/auth/register', {
    schema: {
      ...registerSchema,
      response: {
        200: authSessionSchema('register'),
        ...authErrorResponses,
      },
    },
    preHandler: enforceAuthRateLimit('register'),
  }, async (request) => {
    const body = request.body as OpenApiSchemas['RegisterRequest'];

    const response: OpenApiSchemas['AuthSessionRegisterResponse'] = {
      ...(await authService.register(body, {
        accessSecret: app.appEnv.jwtAccessSecret,
        refreshSecret: app.appEnv.jwtRefreshSecret,
      }, {
        allowPublicRegistration: app.appEnv.allowPublicRegistration,
      })),
      module: 'auth',
      action: 'register',
    };
    return response;
  });

  app.post('/auth/login', {
    schema: {
      ...loginSchema,
      response: {
        200: authSessionSchema('login'),
        ...authErrorResponses,
      },
    },
    preHandler: enforceAuthRateLimit('login'),
  }, async (request) => {
    const body = request.body as OpenApiSchemas['LoginRequest'];

    const response: OpenApiSchemas['AuthSessionLoginResponse'] = {
      ...(await authService.login(body, {
        accessSecret: app.appEnv.jwtAccessSecret,
        refreshSecret: app.appEnv.jwtRefreshSecret,
      })),
      module: 'auth',
      action: 'login',
    };
    return response;
  });

  app.post('/auth/refresh', {
    schema: {
      ...refreshSchema,
      response: {
        200: authSessionSchema('refresh'),
        ...authErrorResponses,
      },
    },
  }, async (request) => {
    const body = request.body as OpenApiSchemas['RefreshRequest'];

    const response: OpenApiSchemas['AuthSessionRefreshResponse'] = {
      ...(await authService.refresh(body.refreshToken, {
        accessSecret: app.appEnv.jwtAccessSecret,
        refreshSecret: app.appEnv.jwtRefreshSecret,
      })),
      module: 'auth',
      action: 'refresh',
    };
    return response;
  });

  app.get('/auth/me', {
    schema: {
      response: {
        200: authMeSchema,
        ...authErrorResponses,
      },
    },
  }, async (request) => {
    if (!request.authUser) {
      throw new AppError(401, 'AUTH_REQUIRED', 'Authentication required');
    }

    const response: OpenApiSchemas['AuthMeResponse'] = {
      user: await authService.me(request.authUser.userId, request.authUser.companyId),
      module: 'auth',
      action: 'me',
    };
    return response;
  });

  app.post('/auth/logout', {
    schema: {
      ...logoutSchema,
      response: {
        204: { type: 'null' },
        ...authErrorResponses,
      },
    },
  }, async (request, reply) => {
    const body = request.body as OpenApiSchemas['LogoutRequest'];

    await authService.logout(body.refreshToken, {
      refreshSecret: app.appEnv.jwtRefreshSecret,
    });

    return reply.status(204).send();
  });

  app.post('/auth/accept-invite', {
    schema: {
      ...acceptInviteSchema,
      response: {
        200: authSessionSchema('accept-invite'),
        ...authErrorResponses,
      },
    },
    preHandler: enforceAuthRateLimit('accept-invite'),
  }, async (request) => {
    const body = request.body as OpenApiSchemas['AcceptInviteRequest'];

    const response: OpenApiSchemas['AuthSessionAcceptInviteResponse'] = {
      ...(await authService.acceptInvite(body, {
        accessSecret: app.appEnv.jwtAccessSecret,
        refreshSecret: app.appEnv.jwtRefreshSecret,
      })),
      module: 'auth',
      action: 'accept-invite',
    };
    return response;
  });
};
