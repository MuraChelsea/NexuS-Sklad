export const errorEnvelopeSchema = {
  type: 'object',
  required: ['error'],
  additionalProperties: false,
  properties: {
    error: {
      type: 'object',
      required: ['code', 'message'],
      additionalProperties: false,
      properties: {
        code: { type: 'string' },
        message: { type: 'string' },
      },
    },
  },
} as const;

const objectItemSchema = {
  type: 'object',
  additionalProperties: true,
} as const;

const objectListSchema = {
  type: 'array',
  items: {
    type: 'object',
    additionalProperties: true,
  },
} as const;

export function itemEnvelopeSchema(module: string, action?: string) {
  return {
    type: 'object',
    required: action ? ['item', 'module', 'action'] : ['item', 'module'],
    additionalProperties: false,
    properties: {
      item: objectItemSchema,
      module: { const: module },
      ...(action ? { action: { const: action } } : {}),
    },
  } as const;
}

export function listEnvelopeSchema(module: string) {
  return {
    type: 'object',
    required: ['items', 'module'],
    additionalProperties: false,
    properties: {
      items: objectListSchema,
      module: { const: module },
    },
  } as const;
}

export function reportEnvelopeSchema(report: string) {
  return {
    type: 'object',
    required: ['item', 'module', 'report'],
    additionalProperties: false,
    properties: {
      item: objectItemSchema,
      module: { const: 'reports' },
      report: { const: report },
    },
  } as const;
}

export function authSessionSchema(action: string) {
  return {
    type: 'object',
    required: ['accessToken', 'refreshToken', 'user', 'module', 'action'],
    additionalProperties: false,
    properties: {
      accessToken: { type: 'string' },
      refreshToken: { type: 'string' },
      user: objectItemSchema,
      module: { const: 'auth' },
      action: { const: action },
    },
  } as const;
}

export const authMeSchema = {
  type: 'object',
  required: ['user', 'module', 'action'],
  additionalProperties: false,
  properties: {
    user: objectItemSchema,
    module: { const: 'auth' },
    action: { const: 'me' },
  },
} as const;

export const inviteResponseSchema = {
  type: 'object',
  required: ['user', 'inviteToken', 'module', 'action'],
  additionalProperties: false,
  properties: {
    user: objectItemSchema,
    inviteToken: { type: 'string' },
    module: { const: 'users' },
    action: { const: 'invite' },
  },
} as const;

export const healthResponseSchema = {
  type: 'object',
  required: ['status', 'service', 'timestamp'],
  additionalProperties: false,
  properties: {
    status: { const: 'ok' },
    service: { const: 'nexussklad-api' },
    timestamp: { type: 'string' },
  },
} as const;

export const readinessResponseSchema = {
  type: 'object',
  required: ['status', 'service', 'timestamp', 'checks'],
  additionalProperties: false,
  properties: {
    status: {
      enum: ['ok', 'error'],
    },
    service: { const: 'nexussklad-api' },
    timestamp: { type: 'string' },
    checks: {
      type: 'object',
      required: ['database'],
      additionalProperties: false,
      properties: {
        database: {
          enum: ['ok', 'error'],
        },
      },
    },
  },
} as const;

export const commonErrorResponses = {
  500: errorEnvelopeSchema,
} as const;

export const authErrorResponses = {
  400: errorEnvelopeSchema,
  401: errorEnvelopeSchema,
  429: errorEnvelopeSchema,
  500: errorEnvelopeSchema,
} as const;

export const protectedReadErrorResponses = {
  400: errorEnvelopeSchema,
  401: errorEnvelopeSchema,
  404: errorEnvelopeSchema,
  500: errorEnvelopeSchema,
} as const;

export const protectedWriteErrorResponses = {
  400: errorEnvelopeSchema,
  401: errorEnvelopeSchema,
  403: errorEnvelopeSchema,
  404: errorEnvelopeSchema,
  500: errorEnvelopeSchema,
} as const;

export const protectedListErrorResponses = {
  400: errorEnvelopeSchema,
  401: errorEnvelopeSchema,
  403: errorEnvelopeSchema,
  500: errorEnvelopeSchema,
} as const;

export const conflictErrorResponses = {
  400: errorEnvelopeSchema,
  401: errorEnvelopeSchema,
  403: errorEnvelopeSchema,
  404: errorEnvelopeSchema,
  409: errorEnvelopeSchema,
  500: errorEnvelopeSchema,
} as const;

export const deleteResponseSchemas = {
  204: { type: 'null' },
  401: errorEnvelopeSchema,
  403: errorEnvelopeSchema,
  404: errorEnvelopeSchema,
  500: errorEnvelopeSchema,
} as const;
