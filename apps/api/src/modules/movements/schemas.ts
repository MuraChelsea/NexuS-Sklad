import type { FastifySchema } from 'fastify';

export const listMovementsSchema: FastifySchema = {
  querystring: {
    type: 'object',
    additionalProperties: false,
    properties: {
      productId: { type: 'string', format: 'uuid' },
      movementType: {
        type: 'string',
        enum: ['INCOME', 'EXPENSE', 'ADJUSTMENT', 'INVENTORY_DIFF'],
      },
      limit: { type: 'integer', minimum: 1, maximum: 100 },
      offset: { type: 'integer', minimum: 0 },
      dateFrom: { type: 'string', format: 'date-time' },
      dateTo: { type: 'string', format: 'date-time' },
    },
  },
};

const movementBodyBase = {
  type: 'object',
  additionalProperties: false,
  required: ['productId', 'quantity'],
  properties: {
    productId: { type: 'string', format: 'uuid' },
    quantity: { type: 'number', exclusiveMinimum: 0 },
    comment: { type: 'string', maxLength: 500, nullable: true },
  },
} as const;

export const createIncomeSchema: FastifySchema = {
  body: movementBodyBase,
};

export const createExpenseSchema: FastifySchema = {
  body: movementBodyBase,
};

export const createAdjustmentSchema: FastifySchema = {
  body: {
    type: 'object',
    additionalProperties: false,
    required: ['productId', 'targetQty'],
    properties: {
      productId: { type: 'string', format: 'uuid' },
      targetQty: { type: 'number', minimum: 0 },
      comment: { type: 'string', maxLength: 500, nullable: true },
    },
  },
};
