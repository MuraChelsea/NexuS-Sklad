import type { FastifyPluginAsync } from 'fastify';

import { healthResponseSchema, readinessResponseSchema } from '../../lib/response-schemas.js';

export const healthRoutes: FastifyPluginAsync = async (app) => {
  app.get('/health', {
    schema: {
      response: {
        200: healthResponseSchema,
      },
    },
  }, async () => {
    return {
      status: 'ok',
      service: 'nexussklad-api',
      timestamp: new Date().toISOString(),
    };
  });

  app.get('/health/ready', {
    schema: {
      response: {
        200: readinessResponseSchema,
        503: readinessResponseSchema,
      },
    },
  }, async (request, reply) => {
    const timestamp = new Date().toISOString();

    try {
      await request.server.prisma.$queryRaw`SELECT 1`;

      return {
        status: 'ok',
        service: 'nexussklad-api',
        timestamp,
        checks: {
          database: 'ok',
        },
      };
    } catch {
      return reply.code(503).send({
        status: 'error',
        service: 'nexussklad-api',
        timestamp,
        checks: {
          database: 'error',
        },
      });
    }
  });
};
