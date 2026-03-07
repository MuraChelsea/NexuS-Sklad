import assert from 'node:assert/strict';
import test from 'node:test';

import type { FastifyInstance } from 'fastify';
import type { InjectPayload, Response as InjectResponse } from 'light-my-request';

import { buildApp } from '../app.js';

type JsonObject = Record<string, unknown>;

type AuthSessionResponse = {
  user: {
    id: string;
    companyId: string;
    email: string | null;
    role: 'OWNER' | 'MANAGER' | 'STAFF';
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
  ownerRefreshToken: string;
  ownerUserId: string;
  suffix: string;
};

test('auth lifecycle smoke covers register, invite, accept, refresh and logout', async () => {
  await withFreshCompany(async ({ app, ownerAccessToken, ownerRefreshToken, suffix }) => {
    const me = await requestJson(app, {
      method: 'GET',
      url: '/v1/auth/me',
      token: ownerAccessToken,
    });
    assert.equal(me.statusCode, 200);
    assert.equal(me.body.module, 'auth');
    assert.equal((me.body.user as JsonObject).role, 'OWNER');

    const invite = await requestJson(app, {
      method: 'POST',
      url: '/v1/users/invite',
      token: ownerAccessToken,
      payload: {
        email: `manager.${suffix}@nexussklad.test`,
        role: 'MANAGER',
      },
    });
    assert.equal(invite.statusCode, 200);
    assert.equal(invite.body.module, 'users');
    assert.equal(invite.body.action, 'invite');
    assert.equal((invite.body.user as JsonObject).role, 'MANAGER');

    const acceptInvite = await requestJson(app, {
      method: 'POST',
      url: '/v1/auth/accept-invite',
      payload: {
        inviteToken: invite.body.inviteToken,
        name: 'Smoke Manager',
        password: 'demo-manager-123',
      },
    });
    assert.equal(acceptInvite.statusCode, 200);
    assert.equal(acceptInvite.body.action, 'accept-invite');

    const managerLogin = await requestJson(app, {
      method: 'POST',
      url: '/v1/auth/login',
      payload: {
        email: `manager.${suffix}@nexussklad.test`,
        password: 'demo-manager-123',
      },
    });
    assert.equal(managerLogin.statusCode, 200);
    assert.equal((managerLogin.body.user as JsonObject).role, 'MANAGER');

    const refreshed = await requestJson(app, {
      method: 'POST',
      url: '/v1/auth/refresh',
      payload: {
        refreshToken: ownerRefreshToken,
      },
    });
    assert.equal(refreshed.statusCode, 200);
    assert.equal(refreshed.body.action, 'refresh');

    const logout = await app.inject({
      method: 'POST',
      url: '/v1/auth/logout',
      payload: {
        refreshToken: ownerRefreshToken,
      },
    });
    assert.equal(logout.statusCode, 204);

    const revokedRefresh = await requestJson(app, {
      method: 'POST',
      url: '/v1/auth/refresh',
      payload: {
        refreshToken: ownerRefreshToken,
      },
    });
    assert.equal(revokedRefresh.statusCode, 401);
    assert.equal(asErrorBody(revokedRefresh.body).error.code, 'AUTH_REFRESH_REVOKED');
  });
});

test('inventory, movements, reports and role guards stay consistent', async () => {
  await withFreshCompany(async ({ app, companyId, ownerAccessToken, suffix }) => {
    const createCategory = await requestJson(app, {
      method: 'POST',
      url: '/v1/categories',
      token: ownerAccessToken,
      payload: {
        name: 'Бытовая химия',
      },
    });
    assert.equal(createCategory.statusCode, 200);
    const categoryId = (createCategory.body.item as JsonObject).id as string;

    const createProduct = await requestJson(app, {
      method: 'POST',
      url: '/v1/products',
      token: ownerAccessToken,
      payload: {
        categoryId,
        name: 'Универсальный спрей',
        unit: 'шт',
        minStock: 2,
        currentStock: 5,
      },
    });
    assert.equal(createProduct.statusCode, 200);
    const productId = (createProduct.body.item as JsonObject).id as string;
    assert.equal((createProduct.body.item as JsonObject).currentStock, '5');

    const inviteStaff = await requestJson(app, {
      method: 'POST',
      url: '/v1/users/invite',
      token: ownerAccessToken,
      payload: {
        email: `staff.${suffix}@nexussklad.test`,
        role: 'STAFF',
      },
    });
    assert.equal(inviteStaff.statusCode, 200);

    const acceptStaff = await requestJson(app, {
      method: 'POST',
      url: '/v1/auth/accept-invite',
      payload: {
        inviteToken: inviteStaff.body.inviteToken,
        name: 'Smoke Staff',
        password: 'demo-staff-123',
      },
    });
    assert.equal(acceptStaff.statusCode, 200);
    const staffAccessToken = acceptStaff.body.accessToken as string;

    const staffIncome = await requestJson(app, {
      method: 'POST',
      url: '/v1/movements/income',
      token: staffAccessToken,
      payload: {
        productId,
        quantity: 4,
        comment: 'smoke income',
      },
    });
    assert.equal(staffIncome.statusCode, 200);
    assert.equal((staffIncome.body.item as JsonObject).afterQty, '9');

    const staffAdjustment = await requestJson(app, {
      method: 'POST',
      url: '/v1/movements/adjustment',
      token: staffAccessToken,
      payload: {
        productId,
        targetQty: 1,
      },
    });
    assert.equal(staffAdjustment.statusCode, 403);

    const tooLargeExpense = await requestJson(app, {
      method: 'POST',
      url: '/v1/movements/expense',
      token: ownerAccessToken,
      payload: {
        productId,
        quantity: 50,
      },
    });
    assert.equal(tooLargeExpense.statusCode, 409);
    assert.equal(asErrorBody(tooLargeExpense.body).error.code, 'INSUFFICIENT_STOCK');

    const inventoryStart = await requestJson(app, {
      method: 'POST',
      url: '/v1/inventory/start',
      token: ownerAccessToken,
      payload: {
        productIds: [productId],
        comment: 'smoke inventory',
      },
    });
    assert.equal(inventoryStart.statusCode, 200);
    const inventory = inventoryStart.body.item as JsonObject;
    const inventoryId = inventory.id as string;
    const inventoryItems = inventory.items as JsonObject[];
    assert.equal(inventoryItems.length, 1);
    const inventoryItemId = (inventoryItems[0] as JsonObject).id as string;

    const inventoryUpdate = await requestJson(app, {
      method: 'PATCH',
      url: `/v1/inventory/${inventoryId}/items/${inventoryItemId}`,
      token: staffAccessToken,
      payload: {
        actualQty: 7,
        comment: 'counted on shelf',
      },
    });
    assert.equal(inventoryUpdate.statusCode, 200);
    assert.equal((inventoryUpdate.body.item as JsonObject).difference, '-2');

    const inventoryFinish = await requestJson(app, {
      method: 'POST',
      url: `/v1/inventory/${inventoryId}/finish`,
      token: ownerAccessToken,
      payload: {
        comment: 'smoke finish',
      },
    });
    assert.equal(inventoryFinish.statusCode, 200);
    assert.equal((inventoryFinish.body.item as JsonObject).status, 'COMPLETED');

    const productList = await requestJson(app, {
      method: 'GET',
      url: '/v1/products?search=%D1%81%D0%BF%D1%80%D0%B5%D0%B9',
      token: ownerAccessToken,
    });
    assert.equal(productList.statusCode, 200);
    const productItems = asJsonArray(productList.body.items);
    assert.equal(productItems.length, 1);
    assert.equal((productItems[0] as JsonObject).currentStock, '7');

    const movementList = await requestJson(app, {
      method: 'GET',
      url: `/v1/movements?productId=${productId}&limit=10`,
      token: ownerAccessToken,
    });
    assert.equal(movementList.statusCode, 200);
    const movementItems = asJsonArray(movementList.body.items);
    assert.ok(movementItems.length >= 2);

    const archivedIncome = await requestJson(app, {
      method: 'POST',
      url: '/v1/movements/income',
      token: ownerAccessToken,
      payload: {
        productId,
        quantity: 1,
        comment: 'archived smoke income',
      },
    });
    assert.equal(archivedIncome.statusCode, 200);
    const archivedIncomeId = (archivedIncome.body.item as JsonObject).id as string;

    const previousDayStart = new Date('2026-03-02T00:00:00.000Z');
    const previousDayEnd = new Date('2026-03-02T23:59:59.999Z');
    await app.prisma.stockMovement.update({
      where: { id: archivedIncomeId },
      data: { createdAt: new Date('2026-03-02T12:00:00.000Z') },
    });

    const movementOffset = await requestJson(app, {
      method: 'GET',
      url: `/v1/movements?productId=${productId}&movementType=INCOME&limit=1&offset=1`,
      token: ownerAccessToken,
    });
    assert.equal(movementOffset.statusCode, 200);
    assert.equal(asJsonArray(movementOffset.body.items).length, 1);
    assert.equal((asJsonArray(movementOffset.body.items)[0] as JsonObject).id, archivedIncomeId);

    const previousDayMovementList = await requestJson(app, {
      method: 'GET',
      url: `/v1/movements?productId=${productId}&movementType=INCOME&dateFrom=${encodeURIComponent(previousDayStart.toISOString())}&dateTo=${encodeURIComponent(previousDayEnd.toISOString())}`,
      token: ownerAccessToken,
    });
    assert.equal(previousDayMovementList.statusCode, 200);
    assert.equal(asJsonArray(previousDayMovementList.body.items).length, 1);
    assert.equal((asJsonArray(previousDayMovementList.body.items)[0] as JsonObject).id, archivedIncomeId);

    const dailyReport = await requestJson(app, {
      method: 'GET',
      url: '/v1/reports/daily',
      token: ownerAccessToken,
    });
    assert.equal(dailyReport.statusCode, 200);
    assert.equal(dailyReport.body.report, 'daily');
    const dailySummary = (dailyReport.body.item as JsonObject).movementSummary as JsonObject;
    const incomeSummary = asJsonObject(dailySummary.INCOME);
    assert.equal(incomeSummary.count, 1);

    const stockReport = await requestJson(app, {
      method: 'GET',
      url: '/v1/reports/stock?lowOnly=true',
      token: ownerAccessToken,
    });
    assert.equal(stockReport.statusCode, 200);
    assert.equal(stockReport.body.report, 'stock');
    const stockItem = asJsonObject(stockReport.body.item);
    const stockSummary = asJsonObject(stockItem.summary);
    assert.equal(stockSummary.lowStockItems, 0);

    await app.prisma.product.createMany({
      data: Array.from({ length: 101 }, (_, index) => ({
        companyId,
        name: index === 100 ? 'Stock report low tail item' : `Stock report filler ${String(index + 1).padStart(3, '0')}`,
        unit: 'шт',
        minStock: index === 100 ? 5 : 1,
        currentStock: index === 100 ? 1 : 10,
      })),
    });

    const fullStockReport = await requestJson(app, {
      method: 'GET',
      url: '/v1/reports/stock',
      token: ownerAccessToken,
    });
    assert.equal(fullStockReport.statusCode, 200);
    assert.equal(fullStockReport.body.report, 'stock');
    const fullStockItem = asJsonObject(fullStockReport.body.item);
    const fullStockSummary = asJsonObject(fullStockItem.summary);
    const fullStockItems = asJsonArray(fullStockItem.items);
    assert.equal(fullStockSummary.totalItems, 102);
    assert.equal(fullStockSummary.lowStockItems, 1);
    assert.equal(fullStockItems.length, 102);

    const lowOnlyStockReport = await requestJson(app, {
      method: 'GET',
      url: '/v1/reports/stock?lowOnly=true',
      token: ownerAccessToken,
    });
    assert.equal(lowOnlyStockReport.statusCode, 200);
    assert.equal(lowOnlyStockReport.body.report, 'stock');
    const lowOnlyStockItem = asJsonObject(lowOnlyStockReport.body.item);
    const lowOnlyStockSummary = asJsonObject(lowOnlyStockItem.summary);
    const lowOnlyStockItems = asJsonArray(lowOnlyStockItem.items);
    assert.equal(lowOnlyStockSummary.totalItems, 1);
    assert.equal(lowOnlyStockSummary.lowStockItems, 1);
    assert.equal(lowOnlyStockItems.length, 1);
    assert.equal((asJsonObject(lowOnlyStockItems[0]).name), 'Stock report low tail item');

    const audit = await requestJson(app, {
      method: 'GET',
      url: '/v1/audit?entityType=product&limit=20',
      token: ownerAccessToken,
    });
    assert.equal(audit.statusCode, 200);
    assert.equal(audit.body.module, 'audit');
    const auditItems = asJsonArray(audit.body.items);
    assert.ok(auditItems.length >= 2);

    const auditOffset = await requestJson(app, {
      method: 'GET',
      url: '/v1/audit?entityType=product&limit=1&offset=1',
      token: ownerAccessToken,
    });
    assert.equal(auditOffset.statusCode, 200);
    assert.equal(auditOffset.body.module, 'audit');
    const auditOffsetItems = asJsonArray(auditOffset.body.items);
    assert.equal(auditOffsetItems.length, 1);
    assert.notEqual((auditOffsetItems[0] as JsonObject).id, (auditItems[0] as JsonObject).id);
  });
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
        companyName: `Smoke ${suffix}`,
        companyCity: 'Derbent',
        ownerName: 'Smoke Owner',
        email: `owner.${suffix}@nexussklad.test`,
        password: 'demo-owner-123',
      },
    });

    assert.equal(registered.statusCode, 200);
    companyId = registered.body.user.company.id;

    await run({
      app,
      companyId,
      ownerAccessToken: registered.body.accessToken,
      ownerRefreshToken: registered.body.refreshToken,
      ownerUserId: registered.body.user.id,
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
