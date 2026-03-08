import type { FastifySchema } from 'fastify';

export const productParamsSchema: FastifySchema = {
  params: {
    type: 'object',
    required: ['productId'],
    additionalProperties: false,
    properties: {
      productId: { type: 'string', format: 'uuid' },
    },
  },
};

export const listProductsSchema: FastifySchema = {
  querystring: {
    type: 'object',
    additionalProperties: false,
    properties: {
      search: { type: 'string', minLength: 1, maxLength: 160 },
      categoryId: { type: 'string', format: 'uuid' },
    },
  },
};

export const createProductSchema: FastifySchema = {
  body: {
    type: 'object',
    required: ['name', 'unit'],
    additionalProperties: false,
    properties: {
      categoryId: { type: 'string', format: 'uuid', nullable: true },
      name: { type: 'string', minLength: 1, maxLength: 160 },
      sku: { type: 'string', maxLength: 80, nullable: true },
      barcode: { type: 'string', maxLength: 80, nullable: true },
      unit: { type: 'string', minLength: 1, maxLength: 40 },
      description: { type: 'string', maxLength: 1000, nullable: true },
      minStock: { type: 'number', minimum: 0, nullable: true },
      currentStock: { type: 'number', minimum: 0, nullable: true },
    },
  },
};

export const updateProductSchema: FastifySchema = {
  params: productParamsSchema.params,
  body: {
    type: 'object',
    minProperties: 1,
    additionalProperties: false,
    properties: {
      categoryId: { type: 'string', format: 'uuid', nullable: true },
      name: { type: 'string', minLength: 1, maxLength: 160 },
      sku: { type: 'string', maxLength: 80, nullable: true },
      barcode: { type: 'string', maxLength: 80, nullable: true },
      unit: { type: 'string', minLength: 1, maxLength: 40 },
      description: { type: 'string', maxLength: 1000, nullable: true },
      minStock: { type: 'number', minimum: 0, nullable: true },
    },
  },
};

export const importProductsSchema: FastifySchema = {
  body: {
    type: 'object',
    required: ['rows'],
    additionalProperties: false,
    properties: {
      rows: {
        type: 'array',
        minItems: 1,
        items: {
          type: 'object',
          required: ['line', 'mode', 'name'],
          additionalProperties: false,
          properties: {
            line: { type: 'integer', minimum: 1 },
            mode: { type: 'string', enum: ['create', 'update'] },
            name: { type: 'string', minLength: 1, maxLength: 160 },
            productId: { type: 'string', format: 'uuid', nullable: true },
            createPayload: createProductSchema.body,
            updatePayload: {
              type: 'object',
              additionalProperties: false,
              properties: {
                categoryId: { type: 'string', format: 'uuid', nullable: true },
                name: { type: 'string', minLength: 1, maxLength: 160 },
                sku: { type: 'string', maxLength: 80, nullable: true },
                barcode: { type: 'string', maxLength: 80, nullable: true },
                unit: { type: 'string', minLength: 1, maxLength: 40 },
                description: { type: 'string', maxLength: 1000, nullable: true },
                minStock: { type: 'number', minimum: 0, nullable: true },
              },
            },
            targetQty: { type: 'number', minimum: 0, nullable: true },
          },
        },
      },
    },
  },
};
