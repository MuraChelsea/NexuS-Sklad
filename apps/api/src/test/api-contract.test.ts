import assert from 'node:assert/strict';
import test from 'node:test';

import type { FastifyInstance } from 'fastify';
import type { InjectPayload, Response as InjectResponse } from 'light-my-request';

import { buildApp } from '../app.js';

type JsonObject = Record<string, unknown>;

type AuthSessionResponse = {
  user: {
    id: string;
    company: {
      id: string;
      name: string;
    };
  };
  accessToken: string;
  refreshToken: string;
  module: string;
  action: string;
};

type CompanyContext = {
  app: FastifyInstance;
  companyId: string;
  ownerAccessToken: string;
  suffix: string;
};

test('health and auth endpoints expose stable contract shape', async () => {
  const app = buildApp();
  await app.ready();

  try {
    const health = await requestJson(app, {
      method: 'GET',
      url: '/health',
    });

    assert.equal(health.statusCode, 200);
    assert.equal(health.body.status, 'ok');
    assert.equal(health.body.service, 'nexussklad-api');
    assert.equal(typeof health.body.timestamp, 'string');
    assert.equal(health.response.headers['x-content-type-options'], 'nosniff');
    assert.equal(health.response.headers['x-frame-options'], 'DENY');
    assert.equal(health.response.headers['referrer-policy'], 'no-referrer');
    assert.equal(health.response.headers['cache-control'], 'no-store');

    const readiness = await requestJson(app, {
      method: 'GET',
      url: '/health/ready',
    });

    assert.equal(readiness.statusCode, 200);
    assert.equal(readiness.body.status, 'ok');
    assert.equal(readiness.body.service, 'nexussklad-api');
    assert.equal(typeof readiness.body.timestamp, 'string');
    assert.equal(asJsonObject(readiness.body.checks).database, 'ok');
    assert.equal(readiness.response.headers['x-content-type-options'], 'nosniff');

    await withFreshCompany(async ({ app: companyApp, ownerAccessToken }) => {
      const me = await requestJson(companyApp, {
        method: 'GET',
        url: '/v1/auth/me',
        token: ownerAccessToken,
      });

      assert.equal(me.statusCode, 200);
      assert.equal(me.body.module, 'auth');
      assert.equal(me.body.action, 'me');
      assert.ok(asJsonObject(me.body.user).id);
    });
  } finally {
    await app.close();
  }
});

test('item, list and report envelopes stay consistent across core modules', async () => {
  await withFreshCompany(async ({ app, ownerAccessToken, suffix }) => {
    const category = await requestJson(app, {
      method: 'POST',
      url: '/v1/categories',
      token: ownerAccessToken,
      payload: {
        name: `Category ${suffix}`,
      },
    });
    assertItemEnvelope(category, 'categories');
    const categoryId = asJsonObject(category.body.item).id as string;

    const categoryList = await requestJson(app, {
      method: 'GET',
      url: '/v1/categories',
      token: ownerAccessToken,
    });
    assertListEnvelope(categoryList, 'categories');

    const product = await requestJson(app, {
      method: 'POST',
      url: '/v1/products',
      token: ownerAccessToken,
      payload: {
        categoryId,
        name: `Product ${suffix}`,
        unit: 'шт',
        minStock: 1,
        currentStock: 3,
      },
    });
    assertItemEnvelope(product, 'products');
    const productId = asJsonObject(product.body.item).id as string;

    const movement = await requestJson(app, {
      method: 'POST',
      url: '/v1/movements/income',
      token: ownerAccessToken,
      payload: {
        productId,
        quantity: 2,
        comment: 'contract income',
      },
    });
    assertItemEnvelope(movement, 'movements');

    const inventory = await requestJson(app, {
      method: 'POST',
      url: '/v1/inventory/start',
      token: ownerAccessToken,
      payload: {
        productIds: [productId],
      },
    });
    assertItemEnvelope(inventory, 'inventory');

    const stockReport = await requestJson(app, {
      method: 'GET',
      url: '/v1/reports/stock',
      token: ownerAccessToken,
    });
    assertReportEnvelope(stockReport, 'stock');

    const audit = await requestJson(app, {
      method: 'GET',
      url: '/v1/audit?limit=10',
      token: ownerAccessToken,
    });
    assertListEnvelope(audit, 'audit');
  });
});

test('error responses keep stable envelope for app and framework errors', async () => {
  await withFreshCompany(async ({ app, ownerAccessToken, suffix }) => {
    const category = await requestJson(app, {
      method: 'POST',
      url: '/v1/categories',
      token: ownerAccessToken,
      payload: {
        name: `Error Category ${suffix}`,
      },
    });
    const categoryId = asJsonObject(category.body.item).id as string;

    const product = await requestJson(app, {
      method: 'POST',
      url: '/v1/products',
      token: ownerAccessToken,
      payload: {
        categoryId,
        name: `Error Product ${suffix}`,
        unit: 'шт',
        minStock: 1,
        currentStock: 1,
      },
    });
    const productId = asJsonObject(product.body.item).id as string;

    const stockError = await requestJson(app, {
      method: 'POST',
      url: '/v1/movements/expense',
      token: ownerAccessToken,
      payload: {
        productId,
        quantity: 99,
      },
    });
    assertErrorEnvelope(stockError, 409, 'INSUFFICIENT_STOCK');

    const notFound = await requestJson(app, {
      method: 'GET',
      url: '/v1/does-not-exist',
      token: ownerAccessToken,
    });
    assert.equal(notFound.statusCode, 404);
    const notFoundError = asErrorBody(notFound.body).error;
    assert.equal(typeof notFoundError.code, 'string');
    assert.equal(typeof notFoundError.message, 'string');
  });
});

test('validation errors keep stable bad-request envelope', async () => {
  await withFreshCompany(async ({ app, ownerAccessToken }) => {
    const invalidLogin = await requestJson(app, {
      method: 'POST',
      url: '/v1/auth/login',
      payload: {
        email: 'bad-email',
        password: '123',
      },
    });
    assertErrorEnvelope(invalidLogin, 400, 'VALIDATION_ERROR');

    const invalidProductQuery = await requestJson(app, {
      method: 'GET',
      url: '/v1/products?categoryId=not-a-uuid',
      token: ownerAccessToken,
    });
    assertErrorEnvelope(invalidProductQuery, 400, 'VALIDATION_ERROR');

    const invalidInventoryPath = await requestJson(app, {
      method: 'GET',
      url: '/v1/inventory/not-a-uuid',
      token: ownerAccessToken,
    });
    assertErrorEnvelope(invalidInventoryPath, 400, 'VALIDATION_ERROR');
  });
});

test('auth rate limit blocks repeated login attempts from the same client', async () => {
  const app = buildApp({
    NODE_ENV: 'test',
    PORT: '4000',
    HOST: '127.0.0.1',
    DATABASE_URL: 'postgresql://postgres:postgres@localhost:5432/nexussklad?schema=public',
    JWT_ACCESS_SECRET: 'test-access-secret-for-rate-limit-12345',
    JWT_REFRESH_SECRET: 'test-refresh-secret-for-rate-limit-67890',
    AUTH_RATE_LIMIT_MAX: '1',
    AUTH_RATE_LIMIT_WINDOW_MS: '60000',
  });
  await app.ready();

  try {
    const first = await requestJson(app, {
      method: 'POST',
      url: '/v1/auth/login',
      payload: {
        email: 'missing@nexussklad.test',
        password: 'wrong-password',
      },
    });
    assertErrorEnvelope(first, 401, 'AUTH_INVALID_CREDENTIALS');

    const second = await requestJson(app, {
      method: 'POST',
      url: '/v1/auth/login',
      payload: {
        email: 'missing@nexussklad.test',
        password: 'wrong-password',
      },
    });
    assertErrorEnvelope(second, 429, 'AUTH_RATE_LIMITED');
  } finally {
    await app.close();
  }
});

test('public registration is blocked outside bootstrap once a company exists', async () => {
  const app = buildApp({
    NODE_ENV: 'production',
    PORT: '4000',
    HOST: '127.0.0.1',
    DATABASE_URL: 'postgresql://postgres:postgres@localhost:5432/nexussklad?schema=public',
    JWT_ACCESS_SECRET: 'prod-access-secret-for-contract-test-123',
    JWT_REFRESH_SECRET: 'prod-refresh-secret-for-contract-test-456',
    ALLOW_PUBLIC_REGISTRATION: 'false',
  });
  await app.ready();

  const suffix = `${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
  let companyId;

  try {
    const company = await app.prisma.company.create({
      data: {
        name: `Existing ${suffix}`,
      },
    });
    companyId = company.id;

    const response = await requestJson(app, {
      method: 'POST',
      url: '/v1/auth/register',
      payload: {
        companyName: `Blocked ${suffix}`,
        ownerName: 'Blocked Owner',
        email: `blocked.${suffix}@nexussklad.test`,
        password: 'demo-owner-123',
      },
    });

    assertErrorEnvelope(response, 403, 'AUTH_REGISTRATION_DISABLED');
  } finally {
    if (companyId) {
      await app.prisma.company.delete({ where: { id: companyId } }).catch(() => undefined);
    }
    await app.close();
  }
});

test('dev auth fallback is disabled outside development', async () => {
  const app = buildApp({
    NODE_ENV: 'production',
    PORT: '4000',
    HOST: '127.0.0.1',
    DATABASE_URL: 'postgresql://postgres:postgres@localhost:5432/nexussklad?schema=public',
    JWT_ACCESS_SECRET: 'prod-access-secret-for-contract-test-123',
    JWT_REFRESH_SECRET: 'prod-refresh-secret-for-contract-test-456',
  });
  await app.ready();

  try {
    const response = await requestJson(app, {
      method: 'GET',
      url: '/v1/company',
    });

    assertErrorEnvelope(response, 401, 'AUTH_REQUIRED');
  } finally {
    await app.close();
  }
});

test('non-development env rejects DEFAULT_* fallback variables at startup', () => {
  assert.throws(
    () =>
      buildApp({
        NODE_ENV: 'production',
        PORT: '4000',
        HOST: '127.0.0.1',
        DATABASE_URL: 'postgresql://postgres:postgres@localhost:5432/nexussklad?schema=public',
        JWT_ACCESS_SECRET: 'prod-access-secret-for-contract-test-123',
        JWT_REFRESH_SECRET: 'prod-refresh-secret-for-contract-test-456',
        DEFAULT_COMPANY_ID: '11111111-1111-1111-1111-111111111111',
      }),
    /Development auth fallback variables are not allowed outside development/,
  );
});

test('non-development env rejects placeholder or weak JWT secrets at startup', () => {
  assert.throws(
    () =>
      buildApp({
        NODE_ENV: 'production',
        PORT: '4000',
        HOST: '127.0.0.1',
        DATABASE_URL: 'postgresql://postgres:postgres@localhost:5432/nexussklad?schema=public',
        JWT_ACCESS_SECRET: 'replace-with-placeholder-secret-value-12345',
        JWT_REFRESH_SECRET: 'replace-with-another-long-random-string',
      }),
    /JWT_ACCESS_SECRET must not use placeholder values outside development/,
  );

  assert.throws(
    () =>
      buildApp({
        NODE_ENV: 'production',
        PORT: '4000',
        HOST: '127.0.0.1',
        DATABASE_URL: 'postgresql://postgres:postgres@localhost:5432/nexussklad?schema=public',
        JWT_ACCESS_SECRET: 'short-secret',
        JWT_REFRESH_SECRET: 'another-short-secret',
      }),
    /JWT_ACCESS_SECRET must be at least 24 characters outside development/,
  );
});

async function withFreshCompany(run: (context: CompanyContext) => Promise<void>) {
  const app = buildApp();
  await app.ready();

  const suffix = `${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
  let companyId: string | undefined;

  try {
    const registered = await requestJson<AuthSessionResponse>(app, {
      method: 'POST',
      url: '/v1/auth/register',
      payload: {
        companyName: `Contract ${suffix}`,
        companyCity: 'Derbent',
        ownerName: 'Contract Owner',
        email: `owner.contract.${suffix}@nexussklad.test`,
        password: 'demo-owner-123',
      },
    });

    assert.equal(registered.statusCode, 200);
    companyId = registered.body.user.company.id;

    await run({
      app,
      companyId,
      ownerAccessToken: registered.body.accessToken,
      suffix,
    });
  } finally {
    if (companyId) {
      await app.prisma.company.delete({
        where: {
          id: companyId,
        },
      }).catch(() => undefined);
    }

    await app.close();
  }
}

async function requestJson<TBody extends JsonObject = JsonObject>(
  app: FastifyInstance,
  options: {
    method: 'GET' | 'POST' | 'PATCH' | 'DELETE';
    url: string;
    payload?: InjectPayload;
    token?: string;
  },
): Promise<{ statusCode: number; body: TBody; response: InjectResponse }> {
  const response = await app.inject({
    method: options.method,
    url: options.url,
    payload: options.payload,
    headers: options.token
      ? {
          authorization: `Bearer ${options.token}`,
        }
      : undefined,
  });

  const body = response.body ? (response.json() as TBody) : ({} as TBody);

  return {
    statusCode: response.statusCode,
    body,
    response,
  };
}

function asJsonObject(value: unknown) {
  assert.equal(typeof value, 'object');
  assert.notEqual(value, null);
  return value as JsonObject;
}

function asJsonArray(value: unknown) {
  assert.ok(Array.isArray(value));
  return value;
}

function asErrorBody(value: unknown) {
  const body = asJsonObject(value);
  return {
    error: asJsonObject(body.error),
  };
}

function assertItemEnvelope(
  response: { statusCode: number; body: JsonObject },
  module: string,
) {
  assert.equal(response.statusCode, 200);
  assert.equal(response.body.module, module);
  assert.ok('item' in response.body);
  assert.equal(typeof response.body.item, 'object');
}

function assertListEnvelope(
  response: { statusCode: number; body: JsonObject },
  module: string,
) {
  assert.equal(response.statusCode, 200);
  assert.equal(response.body.module, module);
  assert.ok('items' in response.body);
  asJsonArray(response.body.items);
}

function assertReportEnvelope(
  response: { statusCode: number; body: JsonObject },
  report: string,
) {
  assert.equal(response.statusCode, 200);
  assert.equal(response.body.module, 'reports');
  assert.equal(response.body.report, report);
  assert.ok('item' in response.body);
}

function assertErrorEnvelope(
  response: { statusCode: number; body: JsonObject },
  statusCode: number,
  errorCode: string,
) {
  assert.equal(response.statusCode, statusCode);
  const error = asErrorBody(response.body).error;
  assert.equal(error.code, errorCode);
  assert.equal(typeof error.message, 'string');
}
