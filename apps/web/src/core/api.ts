import type { OpenApiComponents } from '@nexussklad/shared';

import { appConfig } from './config';

type ErrorResponse = OpenApiComponents['schemas']['ErrorResponse'];
type ApiItemEnvelope<T> = {
  item: T;
  module: string;
  action?: string;
};

type ApiListEnvelope<T> = {
  items: T[];
  module: string;
  action?: string;
};

type ApiReportEnvelope<T> = {
  item: T;
  module: 'reports';
  report: string;
};

export class ApiError extends Error {
  constructor(
    message: string,
    readonly statusCode?: number,
    readonly code?: string,
    readonly backendMessage?: string,
  ) {
    super(message);
  }
}

export class ApiContractError extends ApiError {
  constructor(message: string) {
    super(message, undefined, 'API_CONTRACT_ERROR');
  }
}

export function isSessionExpiredApiError(error: ApiError): boolean {
  return error.statusCode === 401 || (
    error.code != null && [
      'AUTH_REQUIRED',
      'AUTH_TOKEN_INVALID',
      'AUTH_TOKEN_TYPE_INVALID',
      'AUTH_TOKEN_EXPIRED',
      'AUTH_USER_NOT_FOUND',
      'AUTH_REFRESH_REVOKED',
    ].includes(error.code)
  );
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null;
}

export function toApiError(json: unknown, statusCode?: number): ApiError {
  let code: string | undefined;
  let backendMessage: string | undefined;
  if (
    isRecord(json) &&
    'error' in json &&
    isRecord(json.error) &&
    typeof json.error.message === 'string'
  ) {
    code = typeof json.error.code === 'string' ? json.error.code : undefined;
    backendMessage = json.error.message;
    return new ApiError(
      mapApiErrorMessage({
        statusCode,
        code,
        backendMessage,
      }),
      statusCode,
      code,
      backendMessage,
    );
  }

  return new ApiError(
    mapApiErrorMessage({
      statusCode,
      backendMessage: 'Request failed',
    }),
    statusCode,
    undefined,
    'Request failed',
  );
}

function mapApiErrorMessage({
  statusCode,
  code,
  backendMessage,
}: {
  statusCode?: number;
  code?: string;
  backendMessage?: string;
}): string {
  switch (code) {
    case 'VALIDATION_ERROR':
      return 'Проверь введенные данные и повтори попытку.';
    case 'FORBIDDEN':
      return 'Недостаточно прав для этого действия.';
    case 'AUTH_REQUIRED':
    case 'AUTH_TOKEN_INVALID':
    case 'AUTH_TOKEN_TYPE_INVALID':
    case 'AUTH_TOKEN_EXPIRED':
    case 'AUTH_USER_NOT_FOUND':
    case 'AUTH_REFRESH_REVOKED':
      return 'Сессия истекла. Войди снова.';
    case 'AUTH_INVALID_CREDENTIALS':
      return 'Неверный email или пароль.';
    case 'INSUFFICIENT_STOCK':
      return 'Недостаточно остатка. Обнови данные и повтори операцию.';
    case 'INVENTORY_STALE_STOCK':
      return 'Остатки изменились после старта инвентаризации. Обнови сессию.';
    case 'INVENTORY_NOT_ACTIVE':
      return 'Сессия инвентаризации уже закрыта. Открой актуальную сессию.';
    case 'NOT_FOUND':
      return 'Запись не найдена. Возможно, она уже удалена.';
  }

  if (statusCode == 403) {
    return 'Недостаточно прав для этого действия.';
  }

  if (statusCode == 401) {
    return 'Сессия истекла. Войди снова.';
  }

  if (statusCode == 404) {
    return 'Запись не найдена. Возможно, она уже удалена.';
  }

  if (statusCode == 409) {
    return 'Данные на сервере уже изменились. Обнови экран и повтори попытку.';
  }

  return backendMessage ?? 'Request failed';
}

function assertModule(value: unknown, expectedModule: string): void {
  if (!isRecord(value) || value.module !== expectedModule) {
    throw new ApiContractError(`Unexpected API module. Expected "${expectedModule}".`);
  }
}

export function readModuleContract<T>(value: unknown, expectedModule: string): T {
  assertModule(value, expectedModule);
  return value as T;
}

export function readItemEnvelope<T>(
  value: unknown,
  expectedModule: string,
): ApiItemEnvelope<T> {
  assertModule(value, expectedModule);
  const record = value as Record<string, unknown>;
  if (!('item' in record)) {
    throw new ApiContractError('Missing "item" in API response.');
  }

  return value as ApiItemEnvelope<T>;
}

export function readListEnvelope<T>(
  value: unknown,
  expectedModule: string,
): ApiListEnvelope<T> {
  assertModule(value, expectedModule);
  const record = value as Record<string, unknown>;
  if (!('items' in record) || !Array.isArray(record.items)) {
    throw new ApiContractError('Missing "items" array in API response.');
  }

  return value as ApiListEnvelope<T>;
}

export function readReportEnvelope<T>(
  value: unknown,
  expectedReport: string,
): ApiReportEnvelope<T> {
  assertModule(value, 'reports');
  const record = value as Record<string, unknown>;
  if (!('item' in record)) {
    throw new ApiContractError('Missing "item" in report response.');
  }
  if (!('report' in record) || record.report !== expectedReport) {
    throw new ApiContractError(`Unexpected report type. Expected "${expectedReport}".`);
  }

  return value as ApiReportEnvelope<T>;
}

export class ApiClient {
  constructor(private readonly accessToken?: string) {}

  async get<T>(path: string): Promise<T> {
    return this.request<T>(path, { method: 'GET' });
  }

  async post<T>(path: string, body?: unknown): Promise<T> {
    return this.request<T>(path, {
      method: 'POST',
      body,
    });
  }

  async patch<T>(path: string, body?: unknown): Promise<T> {
    return this.request<T>(path, {
      method: 'PATCH',
      body,
    });
  }

  async requestVoid(path: string, method: string): Promise<void> {
    await this.request<void>(path, { method });
  }

  async getItem<T>(path: string, expectedModule: string): Promise<T> {
    return readItemEnvelope<T>(await this.get<unknown>(path), expectedModule).item;
  }

  async getList<T>(path: string, expectedModule: string): Promise<T[]> {
    return readListEnvelope<T>(await this.get<unknown>(path), expectedModule).items;
  }

  async getReport<T>(path: string, expectedReport: string): Promise<T> {
    return readReportEnvelope<T>(await this.get<unknown>(path), expectedReport).item;
  }

  async postItem<T>(path: string, expectedModule: string, body?: unknown): Promise<T> {
    return readItemEnvelope<T>(await this.post<unknown>(path, body), expectedModule).item;
  }

  async patchItem<T>(path: string, expectedModule: string, body?: unknown): Promise<T> {
    return readItemEnvelope<T>(await this.patch<unknown>(path, body), expectedModule).item;
  }

  private async request<T>(path: string, init: { method: string; body?: unknown }): Promise<T> {
    const response = await fetch(`${appConfig.apiBaseUrl}${path}`, {
      method: init.method,
      headers: {
        'Content-Type': 'application/json',
        ...(this.accessToken ? { Authorization: `Bearer ${this.accessToken}` } : {}),
      },
      body: init.body === undefined ? undefined : JSON.stringify(init.body),
    });

    if (response.status === 204) {
      return undefined as T;
    }

    const json = (await response.json()) as unknown;
    if (!response.ok) {
      throw toApiError(json as ErrorResponse | unknown, response.status);
    }

    return json as T;
  }
}
