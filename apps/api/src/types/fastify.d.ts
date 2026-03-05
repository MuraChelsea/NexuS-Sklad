import type { PrismaClient } from '@prisma/client';
import type { AppEnv, AppUserRole } from '../config/env.js';

declare module 'fastify' {
  interface FastifyInstance {
    appEnv: AppEnv;
    prisma: PrismaClient;
  }

  interface FastifyRequest {
    authUser: {
      userId: string;
      companyId: string;
      role: AppUserRole;
    } | null;
  }
}
