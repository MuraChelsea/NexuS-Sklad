# NexusSklad API

Backend API для проекта `NexusSklad`.

## Планируемый стек

- `Node.js`
- `TypeScript`
- `Fastify`
- `Prisma`
- `PostgreSQL`

## Быстрый старт

```bash
npm install
cp .env.example .env
npm run db:up
npm run prisma:generate
npm run prisma:migrate:dev -- --name init
npm run prisma:seed
npm run dev
```

Smoke checks:

```bash
npm run check
npm run test:contract
npm run test:smoke
```

## Staging / container start

`npm run start` запускает собранный сервер из:

- `dist/apps/api/src/server.js`

Для staging Docker-контур описан в:

- `../../infra/deploy/docker-compose.staging.yml`

## Что уже подготовлено

- базовый Fastify entrypoint;
- конфигурация окружения;
- каркас модулей;
- Prisma schema для MVP.

## Локальная база данных

Для локальной разработки используется `PostgreSQL` через Docker Compose:

```bash
npm run db:up
```

Подключение по умолчанию:

- host: `localhost`
- port: `5432`
- db: `nexussklad`
- user: `postgres`
- password: `postgres`

После `npm run prisma:seed` будет доступна dev-компания:

- `DEFAULT_COMPANY_ID`: `11111111-1111-1111-1111-111111111111`
- `DEFAULT_USER_ID`: `22222222-2222-2222-2222-222222222222`

## Automated smoke checks

- `npm run test:smoke` поднимает `Fastify` через `buildApp()` и гоняет реальные `inject()` сценарии.
- Текущее покрытие:
  - `auth/register -> me -> refresh -> logout`
  - `users/invite -> auth/accept-invite`
  - `categories/products`
  - `movements`
  - `inventory`
  - `reports`
  - `audit`

## Contract checks

- `npm run test:contract` валидирует:
  - `health` contract;
  - `auth` contract;
  - `item/list/report` envelope shape для core модулей;
  - error envelope для `AppError`;
  - error envelope для `404 NOT_FOUND`.
- route-level `schema.response` теперь включен для:
  - `health`
  - `auth`
  - `company`
  - `users`
  - `categories`
  - `products`
  - `movements`
  - `inventory`
  - `reports`
  - `audit`
- validation errors теперь нормализуются в stable envelope:
  - status: `400`
  - code: `VALIDATION_ERROR`

API now keeps a stable not-found envelope:

```json
{
  "error": {
    "code": "NOT_FOUND",
    "message": "Route not found"
  }
}
```

## Что уже работает

- `GET /health`
- `POST /v1/auth/register`
- `POST /v1/auth/login`
- `POST /v1/auth/refresh`
- `POST /v1/auth/logout`
- `POST /v1/auth/accept-invite`
- `GET /v1/auth/me`

Auth endpoints use a basic in-memory rate limit for:

- `POST /v1/auth/register`
- `POST /v1/auth/login`
- `POST /v1/auth/accept-invite`

Runtime settings:

- `AUTH_RATE_LIMIT_MAX=10`
- `AUTH_RATE_LIMIT_WINDOW_MS=60000`
- `GET /v1/company`
- `GET /v1/audit`
- `PATCH /v1/company`
- `GET /v1/users`
- `POST /v1/users`
- `POST /v1/users/invite`
- `PATCH /v1/users/:userId`
- `GET /v1/reports/daily`
- `GET /v1/reports/stock`
- `POST /v1/inventory/start`
- `GET /v1/inventory/:inventoryId`
- `PATCH /v1/inventory/:inventoryId/items/:itemId`
- `POST /v1/inventory/:inventoryId/finish`
- `GET /v1/categories`
- `GET /v1/categories/:categoryId`
- `POST /v1/categories`
- `PATCH /v1/categories/:categoryId`
- `DELETE /v1/categories/:categoryId`
- `GET /v1/products`
- `GET /v1/products/:productId`
- `POST /v1/products`
- `PATCH /v1/products/:productId`
- `DELETE /v1/products/:productId`
- `GET /v1/movements`
- `POST /v1/movements/income`
- `POST /v1/movements/expense`
- `POST /v1/movements/adjustment`

`/v1/products` поддерживает query-параметры:

- `search`
- `categoryId`

`/v1/movements` поддерживает query-параметры:

- `productId`
- `movementType`
- `limit`

`/v1/reports/daily` поддерживает query-параметр:

- `date`

`/v1/reports/stock` поддерживает query-параметры:

- `categoryId`
- `search`
- `lowOnly`
- `limit`

`/v1/audit` поддерживает query-параметры:

- `userId`
- `entityType`
- `action`
- `limit`

Логика движений:

- `income` увеличивает остаток;
- `expense` уменьшает остаток и блокируется, если остаток уйдет в минус;
- `adjustment` устанавливает целевой остаток через `targetQty`;
- для каждого движения сохраняются `beforeQty` и `afterQty`;
- для каждого движения создается запись в `audit_logs`.

Дополнительно:

- CRUD по категориям пишет `audit_logs`;
- CRUD по товарам пишет `audit_logs`.

## Demo auth

После `npm run prisma:seed` доступен owner для локальной разработки:

- `email`: `owner@nexussklad.local`
- `password`: `demo-owner-123`
- `email`: `manager@nexussklad.local`
- `password`: `demo-manager-123`
- `email`: `staff@nexussklad.local`
- `password`: `demo-staff-123`

Маршрут `GET /v1/auth/me` требует `Authorization: Bearer <accessToken>`.

Остальные маршруты пока поддерживают два режима:

- через `Bearer` access token;
- через dev fallback (`DEFAULT_COMPANY_ID` и `DEFAULT_USER_ID`) только для локальной разработки в `NODE_ENV=development`.

В non-development окружениях dev fallback отключен и не может подменить auth-контекст.

Дополнительно:

- если `DEFAULT_COMPANY_ID`, `DEFAULT_USER_ID` или `DEFAULT_USER_ROLE` заданы вне `NODE_ENV=development`, API не стартует;
- `.env.example` больше не включает эти значения как активные defaults.
- вне `development` API также не стартует, если:
  - `JWT_ACCESS_SECRET` или `JWT_REFRESH_SECRET` короче 24 символов;
  - используются placeholder значения вида `replace-me` / `replace-with-*` / `change-me`;
  - access и refresh secret совпадают.

Refresh/logout policy:

- refresh token содержит `tokenVersion`;
- `POST /v1/auth/logout` инвалидирует текущую refresh-сессию через increment `refreshTokenVersion`;
- после logout старый refresh token больше не может использоваться;
- access token живет до истечения TTL и не хранится в БД.

Register/invite flow:

- `POST /v1/auth/register` создает новую компанию и owner;
- если `ALLOW_PUBLIC_REGISTRATION=false` и в БД уже есть компания, публичная регистрация блокируется с `403 AUTH_REGISTRATION_DISABLED`;
- `POST /v1/users/invite` создает приглашение для `MANAGER` или `STAFF`;
- `POST /v1/auth/accept-invite` активирует приглашенного пользователя и задает пароль;
- email сейчас должен быть уникален глобально, так как login идет по `email`.

## Inventory flow

- `POST /v1/inventory/start` создает активную сессию и snapshot товаров;
- `PATCH /v1/inventory/:inventoryId/items/:itemId` фиксирует фактическое количество;
- `POST /v1/inventory/:inventoryId/finish` завершает сессию;
- при завершении создаются `INVENTORY_DIFF` движения для расхождений;
- если остаток товара изменился после старта сессии, finish вернет конфликт `INVENTORY_STALE_STOCK`.

## Reports

- `GET /v1/reports/daily` возвращает сводку по движениям, инвентаризациям и low-stock за день;
- `GET /v1/reports/stock` возвращает текущий срез товаров по остаткам и low-stock флагу.

## Company and users

- `GET /v1/company` возвращает текущую компанию;
- `PATCH /v1/company` обновляет компанию, доступно только `OWNER`;
- `GET /v1/users` возвращает пользователей компании, доступно только `OWNER`;
- `POST /v1/users` создает `MANAGER` или `STAFF`, доступно только `OWNER`;
- `POST /v1/users/invite` приглашает `MANAGER` или `STAFF`, доступно только `OWNER`;
- `PATCH /v1/users/:userId` обновляет `MANAGER` или `STAFF`, доступно только `OWNER`.

## Audit

- `GET /v1/audit` возвращает audit trail компании;
- доступно только `OWNER`;
- полезно для owner-heavy сценариев в `apps/web`.

## Role guards

- `OWNER`:
  - полный доступ
- `MANAGER`:
  - create/update товаров и категорий
  - income/expense/adjustment
  - start/finish inventory
  - reports
- `STAFF`:
  - чтение каталога и движений
  - income/expense
  - update inventory item
  - без delete, reports и adjustment
