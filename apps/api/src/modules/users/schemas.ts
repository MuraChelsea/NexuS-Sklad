import type { FastifySchema } from 'fastify';

export const userParamsSchema: FastifySchema = {
  params: {
    type: 'object',
    required: ['userId'],
    additionalProperties: false,
    properties: {
      userId: { type: 'string', format: 'uuid' },
    },
  },
};

export const createUserSchema: FastifySchema = {
  body: {
    type: 'object',
    required: ['name', 'email', 'password', 'role'],
    additionalProperties: false,
    properties: {
      name: { type: 'string', minLength: 1, maxLength: 120 },
      email: { type: 'string', format: 'email', maxLength: 200 },
      phone: { type: 'string', maxLength: 40, nullable: true },
      password: { type: 'string', minLength: 6, maxLength: 200 },
      role: { type: 'string', enum: ['MANAGER', 'STAFF'] },
    },
  },
};

export const updateUserSchema: FastifySchema = {
  params: userParamsSchema.params,
  body: {
    type: 'object',
    minProperties: 1,
    additionalProperties: false,
    properties: {
      name: { type: 'string', minLength: 1, maxLength: 120 },
      email: { type: 'string', format: 'email', maxLength: 200 },
      phone: { type: 'string', maxLength: 40, nullable: true },
      password: { type: 'string', minLength: 6, maxLength: 200 },
      role: { type: 'string', enum: ['MANAGER', 'STAFF'] },
      isActive: { type: 'boolean' },
    },
  },
};

export const inviteUserSchema: FastifySchema = {
  body: {
    type: 'object',
    required: ['email', 'role'],
    additionalProperties: false,
    properties: {
      email: { type: 'string', format: 'email', maxLength: 200 },
      role: { type: 'string', enum: ['MANAGER', 'STAFF'] },
    },
  },
};
