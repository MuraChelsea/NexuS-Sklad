import test from 'node:test';
import assert from 'node:assert/strict';

import { ApiError } from '../core/api.ts';
import { executeConfirmedSessionAction, executeSessionAction } from '../core/session-actions.ts';

test('executeSessionAction retries owner action after session refresh', async () => {
  const calls = [];
  const session = { accessToken: 'old-access', refreshToken: 'old-refresh' };
  const refreshed = { accessToken: 'next-access', refreshToken: 'next-refresh' };

  const completed = await executeSessionAction({
    session,
    operation: async (activeSession) => {
      calls.push(activeSession.accessToken);
      if (calls.length === 1) {
        throw new ApiError('Сессия истекла. Войди снова.', 401, 'AUTH_TOKEN_EXPIRED');
      }
    },
    refreshSession: async (activeSession) => {
      assert.equal(activeSession.accessToken, 'old-access');
      return refreshed;
    },
    fallbackMessage: 'Не удалось выполнить owner action',
  });

  assert.equal(completed, true);
  assert.deepEqual(calls, ['old-access', 'next-access']);
});

test('executeSessionAction stops when refresh cannot recover session', async () => {
  let expiredCode = null;

  const completed = await executeSessionAction({
    session: { accessToken: 'old-access', refreshToken: 'old-refresh' },
    operation: async () => {
      throw new ApiError('Сессия истекла. Войди снова.', 401, 'AUTH_TOKEN_EXPIRED');
    },
    refreshSession: async () => null,
    onSessionExpired: (error) => {
      expiredCode = error.code;
    },
    fallbackMessage: 'Не удалось выполнить owner action',
  });

  assert.equal(completed, false);
  assert.equal(expiredCode, 'AUTH_TOKEN_EXPIRED');
});

test('executeSessionAction does not retry forbidden owner action', async () => {
  let errorMessage = null;
  let refreshCalls = 0;
  let operationCalls = 0;

  const completed = await executeSessionAction({
    session: { accessToken: 'owner-access', refreshToken: 'owner-refresh' },
    operation: async () => {
      operationCalls += 1;
      throw new ApiError('Недостаточно прав для этого действия.', 403, 'FORBIDDEN');
    },
    refreshSession: async () => {
      refreshCalls += 1;
      return null;
    },
    onError: (message) => {
      errorMessage = message;
    },
    fallbackMessage: 'Не удалось выполнить owner action',
  });

  assert.equal(completed, false);
  assert.equal(operationCalls, 1);
  assert.equal(refreshCalls, 0);
  assert.equal(errorMessage, 'Недостаточно прав для этого действия.');
});



test('executeSessionAction notifies recovered session for team invite flow', async () => {
  const attempts = [];
  const recoveredSessions = [];
  const invitePayload = { email: 'manager@example.com', role: 'MANAGER' };
  const session = { accessToken: 'old-access', refreshToken: 'old-refresh' };
  const refreshed = { accessToken: 'next-access', refreshToken: 'next-refresh' };

  const completed = await executeSessionAction({
    session,
    operation: async (activeSession) => {
      attempts.push({ token: activeSession.accessToken, payload: invitePayload });
      if (attempts.length == 1) {
        throw new ApiError('Сессия истекла. Войди снова.', 401, 'AUTH_TOKEN_EXPIRED');
      }
    },
    refreshSession: async () => refreshed,
    onSessionRecovered: (activeSession) => {
      recoveredSessions.push(activeSession.accessToken);
    },
    fallbackMessage: 'Не удалось создать приглашение',
  });

  assert.equal(completed, true);
  assert.deepEqual(recoveredSessions, ['next-access']);
  assert.deepEqual(attempts, [
    { token: 'old-access', payload: invitePayload },
    { token: 'next-access', payload: invitePayload },
  ]);
});

test('executeSessionAction retries inventory follow-up chain with recovered session', async () => {
  const operations = [];
  const session = { accessToken: 'old-access', refreshToken: 'old-refresh' };
  const refreshed = { accessToken: 'next-access', refreshToken: 'next-refresh' };

  const completed = await executeSessionAction({
    session,
    operation: async (activeSession) => {
      operations.push(`start:${activeSession.accessToken}`);
      if (operations.length === 1) {
        throw new ApiError('Сессия истекла. Войди снова.', 401, 'AUTH_TOKEN_EXPIRED');
      }
      operations.push(`refresh-admin:${activeSession.accessToken}`);
    },
    refreshSession: async () => refreshed,
    fallbackMessage: 'Не удалось завершить инвентаризацию',
  });

  assert.equal(completed, true);
  assert.deepEqual(operations, [
    'start:old-access',
    'start:next-access',
    'refresh-admin:next-access',
  ]);
});

test('executeSessionAction uses fallback message for unknown failures', async () => {
  let errorMessage = null;

  const completed = await executeSessionAction({
    session: { accessToken: 'owner-access', refreshToken: 'owner-refresh' },
    operation: async () => {
      throw new Error('boom');
    },
    refreshSession: async () => null,
    onError: (message) => {
      errorMessage = message;
    },
    fallbackMessage: 'Не удалось выполнить owner action',
  });

  assert.equal(completed, false);
  assert.equal(errorMessage, 'Не удалось выполнить owner action');
});



test('executeSessionAction supports invite modal flow after refresh', async () => {
  const attempts = [];
  let inviteResponse = null;
  let inviteToken = null;
  const session = { accessToken: 'old-access', refreshToken: 'old-refresh' };
  const refreshed = { accessToken: 'next-access', refreshToken: 'next-refresh' };

  const completed = await executeSessionAction({
    session,
    operation: async (activeSession) => {
      attempts.push(activeSession.accessToken);
      if (attempts.length === 1) {
        throw new ApiError('Сессия истекла. Войди снова.', 401, 'AUTH_TOKEN_EXPIRED');
      }
      inviteResponse = { inviteToken: 'invite-123' };
    },
    refreshSession: async () => refreshed,
    fallbackMessage: 'Не удалось создать приглашение',
  });

  if (completed && inviteResponse) {
    inviteToken = inviteResponse.inviteToken;
  }

  assert.equal(completed, true);
  assert.equal(inviteToken, 'invite-123');
  assert.deepEqual(attempts, ['old-access', 'next-access']);
});

test('executeSessionAction supports company modal save flow after refresh', async () => {
  const timeline = [];
  const recoveredSessions = [];
  let modalOpen = true;
  let savedSession = null;
  const session = { accessToken: 'old-access', refreshToken: 'old-refresh', user: { role: 'OWNER' } };
  const refreshed = { accessToken: 'next-access', refreshToken: 'next-refresh', user: { role: 'OWNER' } };

  const completed = await executeSessionAction({
    session,
    operation: async (activeSession) => {
      timeline.push(`save-company:${activeSession.accessToken}`);
      if (timeline.length === 1) {
        throw new ApiError('Сессия истекла. Войди снова.', 401, 'AUTH_TOKEN_EXPIRED');
      }
      savedSession = {
        ...activeSession,
        user: { ...activeSession.user, companyName: 'North Depot' },
      };
      timeline.push(`refresh-admin:${savedSession.accessToken}`);
    },
    refreshSession: async () => refreshed,
    onSessionRecovered: (activeSession) => {
      recoveredSessions.push(activeSession.accessToken);
    },
    fallbackMessage: 'Не удалось обновить компанию',
  });

  if (completed && savedSession) {
    modalOpen = false;
  }

  assert.equal(completed, true);
  assert.equal(modalOpen, false);
  assert.equal(savedSession.user.companyName, 'North Depot');
  assert.deepEqual(recoveredSessions, ['next-access']);
  assert.deepEqual(timeline, [
    'save-company:old-access',
    'save-company:next-access',
    'refresh-admin:next-access',
  ]);
});



test('executeSessionAction supports team update flow after refresh', async () => {
  const attempts = [];
  const payload = {
    name: 'Warehouse Lead',
    email: 'lead@example.com',
    role: 'MANAGER',
    isActive: true,
  };
  let refreshAdminToken = null;
  const session = { accessToken: 'old-access', refreshToken: 'old-refresh' };
  const refreshed = { accessToken: 'next-access', refreshToken: 'next-refresh' };

  const completed = await executeSessionAction({
    session,
    operation: async (activeSession) => {
      attempts.push({ token: activeSession.accessToken, payload });
      if (attempts.length === 1) {
        throw new ApiError('Сессия истекла. Войди снова.', 401, 'AUTH_TOKEN_EXPIRED');
      }
      refreshAdminToken = activeSession.accessToken;
    },
    refreshSession: async () => refreshed,
    fallbackMessage: 'Не удалось обновить сотрудника',
  });

  assert.equal(completed, true);
  assert.equal(refreshAdminToken, 'next-access');
  assert.deepEqual(attempts, [
    { token: 'old-access', payload },
    { token: 'next-access', payload },
  ]);
});

test('executeSessionAction supports inventory item update chain after refresh', async () => {
  const attempts = [];
  const payload = { inventoryId: 'inv-1', itemId: 'item-7', actualQty: 12 };
  let selectedInventoryUpdate = null;
  const session = { accessToken: 'old-access', refreshToken: 'old-refresh' };
  const refreshed = { accessToken: 'next-access', refreshToken: 'next-refresh' };

  const completed = await executeSessionAction({
    session,
    operation: async (activeSession) => {
      attempts.push({ token: activeSession.accessToken, payload });
      if (attempts.length === 1) {
        throw new ApiError('Сессия истекла. Войди снова.', 401, 'AUTH_TOKEN_EXPIRED');
      }
      selectedInventoryUpdate = {
        inventoryId: payload.inventoryId,
        itemId: payload.itemId,
        actualQty: payload.actualQty,
        sessionToken: activeSession.accessToken,
      };
    },
    refreshSession: async () => refreshed,
    fallbackMessage: 'Не удалось обновить позицию инвентаризации',
  });

  assert.equal(completed, true);
  assert.deepEqual(selectedInventoryUpdate, {
    inventoryId: 'inv-1',
    itemId: 'item-7',
    actualQty: 12,
    sessionToken: 'next-access',
  });
  assert.deepEqual(attempts, [
    { token: 'old-access', payload },
    { token: 'next-access', payload },
  ]);
});



test('executeSessionAction supports company update chain after refresh', async () => {
  const attempts = [];
  const payload = { name: 'North Depot', city: 'Derbent' };
  let refreshedAdminToken = null;
  const session = { accessToken: 'old-access', refreshToken: 'old-refresh', user: { role: 'OWNER' } };
  const refreshed = { accessToken: 'next-access', refreshToken: 'next-refresh', user: { role: 'OWNER' } };

  const completed = await executeSessionAction({
    session,
    operation: async (activeSession) => {
      attempts.push({ token: activeSession.accessToken, payload });
      if (attempts.length === 1) {
        throw new ApiError('Сессия истекла. Войди снова.', 401, 'AUTH_TOKEN_EXPIRED');
      }
      refreshedAdminToken = activeSession.accessToken;
    },
    refreshSession: async () => refreshed,
    fallbackMessage: 'Не удалось обновить компанию',
  });

  assert.equal(completed, true);
  assert.equal(refreshedAdminToken, 'next-access');
  assert.deepEqual(attempts, [
    { token: 'old-access', payload },
    { token: 'next-access', payload },
  ]);
});

test('executeSessionAction supports finish inventory chain after refresh', async () => {
  const attempts = [];
  let finishedInventory = null;
  const payload = { inventoryId: 'inv-77' };
  const session = { accessToken: 'old-access', refreshToken: 'old-refresh' };
  const refreshed = { accessToken: 'next-access', refreshToken: 'next-refresh' };

  const completed = await executeSessionAction({
    session,
    operation: async (activeSession) => {
      attempts.push({ token: activeSession.accessToken, payload });
      if (attempts.length === 1) {
        throw new ApiError('Сессия истекла. Войди снова.', 401, 'AUTH_TOKEN_EXPIRED');
      }
      finishedInventory = {
        id: payload.inventoryId,
        status: 'COMPLETED',
        sessionToken: activeSession.accessToken,
      };
    },
    refreshSession: async () => refreshed,
    fallbackMessage: 'Не удалось завершить инвентаризацию',
  });

  assert.equal(completed, true);
  assert.deepEqual(finishedInventory, {
    id: 'inv-77',
    status: 'COMPLETED',
    sessionToken: 'next-access',
  });
  assert.deepEqual(attempts, [
    { token: 'old-access', payload },
    { token: 'next-access', payload },
  ]);
});

test('executeConfirmedSessionAction does not run destructive action when confirm is cancelled', async () => {
  let operationCalls = 0;

  const completed = await executeConfirmedSessionAction({
    confirm: () => false,
    confirmMessage: 'Удалить товар?',
    session: { accessToken: 'owner-access', refreshToken: 'owner-refresh' },
    operation: async () => {
      operationCalls += 1;
    },
    refreshSession: async () => null,
    fallbackMessage: 'Не удалось удалить товар',
  });

  assert.equal(completed, false);
  assert.equal(operationCalls, 0);
});

test('executeConfirmedSessionAction retries destructive action after refresh', async () => {
  const operationCalls = [];
  const confirmMessages = [];
  const session = { accessToken: 'old-access', refreshToken: 'old-refresh' };
  const refreshed = { accessToken: 'next-access', refreshToken: 'next-refresh' };

  const completed = await executeConfirmedSessionAction({
    confirm: (message) => {
      confirmMessages.push(message);
      return true;
    },
    confirmMessage: 'Удалить товар?',
    session,
    operation: async (activeSession) => {
      operationCalls.push(activeSession.accessToken);
      if (operationCalls.length === 1) {
        throw new ApiError('Сессия истекла. Войди снова.', 401, 'AUTH_TOKEN_EXPIRED');
      }
    },
    refreshSession: async () => refreshed,
    fallbackMessage: 'Не удалось удалить товар',
  });

  assert.equal(completed, true);
  assert.deepEqual(confirmMessages, ['Удалить товар?']);
  assert.deepEqual(operationCalls, ['old-access', 'next-access']);
});
