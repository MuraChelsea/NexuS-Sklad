import type { FastifySchema } from 'fastify';

export const listAuditLogsSchema: FastifySchema = {
  querystring: {
    type: 'object',
    additionalProperties: false,
    properties: {
      userId: { type: 'string', format: 'uuid' },
      entityType: { type: 'string', minLength: 1, maxLength: 64 },
      action: { type: 'string', minLength: 1, maxLength: 120 },
      limit: { type: 'integer', minimum: 1, maximum: 200 },
    },
  },
};
