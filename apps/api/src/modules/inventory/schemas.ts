import type { FastifySchema } from 'fastify';

export const inventoryParamsSchema: FastifySchema = {
  params: {
    type: 'object',
    required: ['inventoryId'],
    additionalProperties: false,
    properties: {
      inventoryId: { type: 'string', format: 'uuid' },
    },
  },
};

export const inventoryItemParamsSchema: FastifySchema = {
  params: {
    type: 'object',
    required: ['inventoryId', 'itemId'],
    additionalProperties: false,
    properties: {
      inventoryId: { type: 'string', format: 'uuid' },
      itemId: { type: 'string', format: 'uuid' },
    },
  },
};

export const startInventorySchema: FastifySchema = {
  body: {
    type: 'object',
    additionalProperties: false,
    properties: {
      categoryId: { type: 'string', format: 'uuid' },
      productIds: {
        type: 'array',
        minItems: 1,
        items: { type: 'string', format: 'uuid' },
      },
      comment: { type: 'string', maxLength: 500, nullable: true },
    },
  },
};

export const updateInventoryItemSchema: FastifySchema = {
  params: inventoryItemParamsSchema.params,
  body: {
    type: 'object',
    required: ['actualQty'],
    additionalProperties: false,
    properties: {
      actualQty: { type: 'number', minimum: 0 },
      comment: { type: 'string', maxLength: 500, nullable: true },
    },
  },
};

export const finishInventorySchema: FastifySchema = {
  params: inventoryParamsSchema.params,
  body: {
    type: 'object',
    additionalProperties: false,
    properties: {
      comment: { type: 'string', maxLength: 500, nullable: true },
    },
  },
};
