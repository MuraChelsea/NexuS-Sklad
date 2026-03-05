import type { FastifySchema } from 'fastify';

export const categoryParamsSchema: FastifySchema = {
  params: {
    type: 'object',
    required: ['categoryId'],
    additionalProperties: false,
    properties: {
      categoryId: { type: 'string', format: 'uuid' },
    },
  },
};

export const createCategorySchema: FastifySchema = {
  body: {
    type: 'object',
    required: ['name'],
    additionalProperties: false,
    properties: {
      name: { type: 'string', minLength: 1, maxLength: 120 },
      parentId: { type: 'string', format: 'uuid', nullable: true },
    },
  },
};

export const updateCategorySchema: FastifySchema = {
  params: categoryParamsSchema.params,
  body: {
    type: 'object',
    minProperties: 1,
    additionalProperties: false,
    properties: {
      name: { type: 'string', minLength: 1, maxLength: 120 },
      parentId: { type: 'string', format: 'uuid', nullable: true },
    },
  },
};
