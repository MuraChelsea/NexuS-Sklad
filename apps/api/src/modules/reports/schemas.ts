import type { FastifySchema } from 'fastify';

export const dailyReportSchema: FastifySchema = {
  querystring: {
    type: 'object',
    additionalProperties: false,
    properties: {
      date: { type: 'string', format: 'date' },
    },
  },
};

export const stockReportSchema: FastifySchema = {
  querystring: {
    type: 'object',
    additionalProperties: false,
    properties: {
      categoryId: { type: 'string', format: 'uuid' },
      search: { type: 'string', minLength: 1, maxLength: 160 },
      lowOnly: { type: 'boolean' },
      limit: { type: 'integer', minimum: 1, maximum: 200 },
    },
  },
};
