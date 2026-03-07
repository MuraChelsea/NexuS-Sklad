import test from 'node:test';
import assert from 'node:assert/strict';

import {
  ApiContractError,
  ApiError,
  isSessionExpiredApiError,
  readItemEnvelope,
  readListEnvelope,
  readModuleContract,
  readReportEnvelope,
  toApiError,
} from '../core/api.ts';
import { fetchAllAuditLogs } from '../features/audit/audit.ts';
import { fetchStockReport } from '../features/dashboard/dashboard.ts';
import { fetchAllMovements } from '../features/movements/movements.ts';

test('readItemEnvelope returns item for matching module', () => {
  const envelope = readItemEnvelope({ module: 'products', item: { id: 'p1' } }, 'products');
  assert.deepEqual(envelope.item, { id: 'p1' });
});

test('readListEnvelope rejects wrong module', () => {
  assert.throws(
    () => readListEnvelope({ module: 'inventory', items: [] }, 'products'),
    (error) => error instanceof ApiContractError && /Expected "products"/.test(error.message),
  );
});

test('readReportEnvelope rejects wrong report type', () => {
  assert.throws(
    () => readReportEnvelope({ module: 'reports', report: 'stock', item: {} }, 'daily'),
    (error) => error instanceof ApiContractError && /Expected "daily"/.test(error.message),
  );
});

test('readModuleContract accepts auth response module', () => {
  const payload = readModuleContract({ module: 'auth', action: 'login', accessToken: 'a' }, 'auth');
  assert.equal(payload.module, 'auth');
});

test('toApiError maps stock conflicts to user-facing message and preserves backend message', () => {
  const error = toApiError({ error: { code: 'INSUFFICIENT_STOCK', message: 'Недостаточно остатка' } }, 409);
  assert.equal(error.statusCode, 409);
  assert.equal(error.code, 'INSUFFICIENT_STOCK');
  assert.equal(error.message, 'Недостаточно остатка. Обнови данные и повтори операцию.');
  assert.equal(error.backendMessage, 'Недостаточно остатка');
});

test('toApiError maps validation error to stable user-facing message', () => {
  const error = toApiError({ error: { code: 'VALIDATION_ERROR', message: 'body/name must be string' } }, 400);
  assert.equal(error.statusCode, 400);
  assert.equal(error.code, 'VALIDATION_ERROR');
  assert.equal(error.message, 'Проверь введенные данные и повтори попытку.');
  assert.equal(error.backendMessage, 'body/name must be string');
});

test('toApiError falls back on malformed payload', () => {
  const error = toApiError({ message: 'bad' }, 500);
  assert.equal(error.statusCode, 500);
  assert.equal(error.code, undefined);
  assert.equal(error.message, 'Request failed');
  assert.equal(error.backendMessage, 'Request failed');
});

test('isSessionExpiredApiError detects auth expiry conditions', () => {
  assert.equal(
    isSessionExpiredApiError(new ApiError('expired', 401, 'AUTH_TOKEN_EXPIRED')),
    true,
  );
  assert.equal(
    isSessionExpiredApiError(new ApiError('forbidden', 403, 'FORBIDDEN')),
    false,
  );
});

test('fetchAllMovements paginates through the full movement history', async () => {
  const originalFetch = global.fetch;
  const requests = [];
  global.fetch = async (input) => {
    requests.push(String(input));
    const page = requests.length === 1
      ? { module: 'movements', items: Array.from({ length: 100 }, (_, index) => ({ id: `movement-${index + 1}` })) }
      : { module: 'movements', items: [{ id: 'movement-101' }] };
    return {
      ok: true,
      status: 200,
      json: async () => page,
    };
  };

  try {
    const movements = await fetchAllMovements('access-token');
    assert.equal(movements.length, 101);
    assert.equal(requests.length, 2);
    assert.match(requests[0], /\/v1\/movements\?limit=100&offset=0$/);
    assert.match(requests[1], /\/v1\/movements\?limit=100&offset=100$/);
  } finally {
    global.fetch = originalFetch;
  }
});

test('fetchAllMovements forwards date filters for dashboard day slices', async () => {
  const originalFetch = global.fetch;
  let requestUrl = '';
  global.fetch = async (input) => {
    requestUrl = String(input);
    return {
      ok: true,
      status: 200,
      json: async () => ({ module: 'movements', items: [] }),
    };
  };

  try {
    await fetchAllMovements('access-token', {
      dateFrom: '2026-03-06T00:00:00.000Z',
      dateTo: '2026-03-06T23:59:59.999Z',
    });
    assert.match(requestUrl, /dateFrom=2026-03-06T00%3A00%3A00.000Z/);
    assert.match(requestUrl, /dateTo=2026-03-06T23%3A59%3A59.999Z/);
  } finally {
    global.fetch = originalFetch;
  }
});

test('fetchAllAuditLogs paginates through the full audit trail', async () => {
  const originalFetch = global.fetch;
  const requests = [];
  global.fetch = async (input) => {
    requests.push(String(input));
    const page = requests.length === 1
      ? { module: 'audit', items: Array.from({ length: 100 }, (_, index) => ({ id: `audit-${index + 1}` })) }
      : { module: 'audit', items: [{ id: 'audit-101' }] };
    return {
      ok: true,
      status: 200,
      json: async () => page,
    };
  };

  try {
    const logs = await fetchAllAuditLogs('access-token');
    assert.equal(logs.length, 101);
    assert.equal(requests.length, 2);
    assert.match(requests[0], /\/v1\/audit\?limit=100&offset=0$/);
    assert.match(requests[1], /\/v1\/audit\?limit=100&offset=100$/);
  } finally {
    global.fetch = originalFetch;
  }
});

test('fetchAllAuditLogs forwards active audit filters across pages', async () => {
  const originalFetch = global.fetch;
  let requestUrl = '';
  global.fetch = async (input) => {
    requestUrl = String(input);
    return {
      ok: true,
      status: 200,
      json: async () => ({ module: 'audit', items: [] }),
    };
  };

  try {
    await fetchAllAuditLogs('access-token', {
      userId: '11111111-1111-1111-1111-111111111111',
      entityType: 'product',
      action: 'product.updated',
    });
    assert.match(requestUrl, /userId=11111111-1111-1111-1111-111111111111/);
    assert.match(requestUrl, /entityType=product/);
    assert.match(requestUrl, /action=product.updated/);
    assert.match(requestUrl, /limit=100/);
    assert.match(requestUrl, /offset=0/);
  } finally {
    global.fetch = originalFetch;
  }
});

test('fetchStockReport does not force a default limit for full stock exports', async () => {
  const originalFetch = global.fetch;
  let requestUrl = '';
  global.fetch = async (input) => {
    requestUrl = String(input);
    return {
      ok: true,
      status: 200,
      json: async () => ({ module: 'reports', report: 'stock', item: { summary: { totalItems: 0, lowStockItems: 0 }, items: [] } }),
    };
  };

  try {
    await fetchStockReport('access-token', {
      lowOnly: true,
      search: 'cola',
    });
    assert.match(requestUrl, /\/v1\/reports\/stock\?/);
    assert.match(requestUrl, /lowOnly=true/);
    assert.match(requestUrl, /search=cola/);
    assert.doesNotMatch(requestUrl, /limit=/);
  } finally {
    global.fetch = originalFetch;
  }
});

test('fetchStockReport forwards explicit limit when requested', async () => {
  const originalFetch = global.fetch;
  let requestUrl = '';
  global.fetch = async (input) => {
    requestUrl = String(input);
    return {
      ok: true,
      status: 200,
      json: async () => ({ module: 'reports', report: 'stock', item: { summary: { totalItems: 0, lowStockItems: 0 }, items: [] } }),
    };
  };

  try {
    await fetchStockReport('access-token', { limit: 25 });
    assert.match(requestUrl, /limit=25/);
  } finally {
    global.fetch = originalFetch;
  }
});
