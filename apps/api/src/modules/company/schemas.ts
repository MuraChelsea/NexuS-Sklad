import type { FastifySchema } from 'fastify';

export const updateCompanySchema: FastifySchema = {
  body: {
    type: 'object',
    minProperties: 1,
    additionalProperties: false,
    properties: {
      name: { type: 'string', minLength: 1, maxLength: 160 },
      city: { type: 'string', maxLength: 120, nullable: true },
      phone: { type: 'string', maxLength: 40, nullable: true },
    },
  },
};
