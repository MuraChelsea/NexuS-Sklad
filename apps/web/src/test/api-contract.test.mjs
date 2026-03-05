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
