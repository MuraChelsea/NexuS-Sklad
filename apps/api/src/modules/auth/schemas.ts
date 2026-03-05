import type { FastifySchema } from 'fastify';

export const registerSchema: FastifySchema = {
  body: {
    type: 'object',
    required: ['companyName', 'ownerName', 'email', 'password'],
    additionalProperties: false,
    properties: {
      companyName: { type: 'string', minLength: 1, maxLength: 160 },
      companyCity: { type: 'string', maxLength: 120, nullable: true },
      companyPhone: { type: 'string', maxLength: 40, nullable: true },
      ownerName: { type: 'string', minLength: 1, maxLength: 120 },
      email: { type: 'string', format: 'email', maxLength: 200 },
      phone: { type: 'string', maxLength: 40, nullable: true },
      password: { type: 'string', minLength: 6, maxLength: 200 },
    },
  },
};

export const loginSchema: FastifySchema = {
  body: {
    type: 'object',
    required: ['email', 'password'],
    additionalProperties: false,
    properties: {
      email: { type: 'string', format: 'email', maxLength: 200 },
      password: { type: 'string', minLength: 6, maxLength: 200 },
    },
  },
};

export const refreshSchema: FastifySchema = {
  body: {
    type: 'object',
    required: ['refreshToken'],
    additionalProperties: false,
    properties: {
      refreshToken: { type: 'string', minLength: 20 },
    },
  },
};

export const logoutSchema: FastifySchema = refreshSchema;

export const acceptInviteSchema: FastifySchema = {
  body: {
    type: 'object',
    required: ['inviteToken', 'name', 'password'],
    additionalProperties: false,
    properties: {
      inviteToken: { type: 'string', minLength: 20, maxLength: 200 },
      name: { type: 'string', minLength: 1, maxLength: 120 },
      phone: { type: 'string', maxLength: 40, nullable: true },
      password: { type: 'string', minLength: 6, maxLength: 200 },
    },
  },
};
