# NexusSklad Web

React/Vite admin shell for owner and manager workflows.

## Scope of current stage

- authenticated web shell
- dashboard with daily report snapshot
- product management
  - low-stock and uncategorized summary badges
- category management
- movement creation
  - movement-type summary badges
- company and user management
  - company completeness summary
  - team summary badges by role and status
- invite flow for owner
- audit trail for owner
- inventory management:
  - start session
  - open session from daily report
  - update actual quantities
  - finish session
  - explicit empty-state CTA for the first session of the day
  - draft/completed summary badges
- stock report view
  - active filter context chips
  - reset filters action
- reporting controls:
  - daily report date filter
  - stock report filters
  - audit filters
- centralized export/report view
- export context chips and filter-aware CSV filenames
- daily summary badges inside reporting view
- owner-only destructive actions:
  - delete product
  - delete category
- lightweight CSV export:
  - products
  - movements
  - audit logs
  - stock report
- generated OpenAPI transport types are used in the web client
- reusable/testable owner workflow blocks:
  - `CompanyPanel`
  - `ProductTableRow`
  - `TeamUserRow`
  - `InventorySessionRow`
  - `StockReportRow`
  - `ExportCard`
  - `MovementTableRow`
  - `AuditLogRow`
- empty/error states are explicit for core owner workflows:
  - global admin reload
  - products/categories empty state
  - movements empty state
  - stock report empty state
  - team empty state
  - audit empty state

## Planned role of web

`apps/web` takes over the scenarios that are heavier or riskier in mobile:

- company editing
- user administration
- owner-level control
- destructive actions (`delete`)
- lightweight exports
- audits
- inventory/reporting workflows

## Environment

Uses:

- `VITE_NEXUSSKLAD_API_BASE_URL`

Example:

```bash
VITE_NEXUSSKLAD_API_BASE_URL=http://localhost:4000
```

Для staging web собирается с пустым `VITE_NEXUSSKLAD_API_BASE_URL` и работает через nginx proxy на том же origin.

Deploy-контур:

- `../../infra/deploy/docker-compose.staging.yml`
- `../../infra/deploy/web_deploy_smoke_check.sh`

Smoke UX checklist:

- `../../docs/ui_smoke_checklist.md`

## Checks

```bash
npm run check
npm run test:contract
npm run test:render
npm run build
```

Deploy smoke для собранного web shell:

```bash
../../infra/deploy/web_deploy_smoke_check.sh http://localhost:8080
```

`npm run test:render` — node-based render smoke tests for:

- critical empty-state UI
- `CompanyPanel`
- `ProductTableRow`
- `TeamUserRow`
- `InventorySessionRow`
- `StockReportRow`
- `ExportCard`
- `MovementTableRow`
- `AuditLogRow`
- `ActiveFilterChips`
- `ProductModal`
- `MovementModal`
- `CompanyModal`
- `InviteModal`
- `UserModal`
- `CategoryModal`
- modal forms now include helper text and action-specific submit labels
- reporting export context
- audit summary + filter reset

`npm run test:contract` — contract-focused tests for:

- error envelope parsing
- module mismatch detection
- item/list/report envelope guards

`src/core/api.ts` также держит centralized user-facing mapping для:

- `VALIDATION_ERROR`
- `FORBIDDEN`
- `AUTH_*`
- `INSUFFICIENT_STOCK`
- `INVENTORY_*`
- общих `404/409`

## Session expiry UX

`src/app/App.tsx` держит единый session-expiry flow:

- auth-related `401/AUTH_*` очищают текущую admin session
- transient modal state сбрасывается
- пользователь возвращается на login screen с notice о завершении сессии

Теперь перед forced sign-out `web` сначала делает:

- `POST /v1/auth/refresh`
- обновляет `accessToken/refreshToken`
- повторяет исходное действие один раз

Notice UX:

- `Сессия восстановлена. Действие повторено автоматически.`
- `Сессия истекла. Войди снова.`

Targeted coverage:

- `src/test/render-smoke.test.mjs`
- отдельный render test на `LoginForm` с одновременной проверкой:
  - `notice`
  - `error`
- отдельный render test на `InlineSessionNotice`

Auth recovery UX:

- signed-in shell показывает persistent inline notice после silent refresh
- notice можно скрыть вручную без forced logout

Owner-flow copy polish:

- destructive confirm для удаления товара/категории явно предупреждает о необратимости
- `InviteModal` показывает block `Приглашение готово` с инструкцией передать токен сотруднику
- non-owner ограничения в `TeamView` идут через общий `InlineState`
- первый `web fix pack` по реальным скриншотам admin-панели убрал смешение русского и английского в `login`, `overview`, `products`, `inventory`, `team`, `reports`, `audit`
- session/profile, роли, статусы инвентаризации, типы движений и audit labels теперь показываются в продуктовых русских формулировках
- второй `web fix pack` дочищает presentation layer:
  - audit rows показывают human-readable действия и сущности
  - payload показывается как краткая human-readable сводка без debug JSON в стандартном UI
  - export cards показывают имя файла как вторичное мета-поле, а не как основной акцент карточки

Session action recovery:

- owner/manager actions идут через общий helper:
  - `src/core/session-actions.ts`
- helper покрывает единый retry path:
  - `401/AUTH_*` -> `refreshToken` -> retry один раз
- destructive owner actions идут через confirm-aware helper:
  - `executeConfirmedSessionAction()`
- helper сначала спрашивает confirm, затем запускает delete flow
- отдельный suite:
  - `npm run test:recovery`
- recovery suite проверяет:
  - retry after refresh
  - refresh failure
  - forbidden without retry
  - fallback message for unknown errors
  - cancel destructive action
  - retry destructive action after refresh
  - invite-style retry с сохранением payload
  - invite/company modal result path after recovery
  - team/inventory action chains after recovery
  - company update / finish inventory final action chains
  - inventory-style chain с follow-up шагом после recovery
  - company save modal закрывается только после success
  - update user / update inventory item сохраняют payload и post-success chain
  - update company / finish inventory сохраняют completed-result path
  - `onSessionRecovered` для recovered session handoff

- Session persistence: `App.tsx` восстанавливает owner/manager session из `localStorage`, а logout и auth expiry очищают persisted state.
- Modal policy: закрытое состояние create/edit модалок товаров и категорий теперь хранится как `false`, create-flow — `null`, edit-flow — объект сущности; это убрало auto-open модалок после входа в панель.
- Summary badges и action-toolbar разведены по смыслу: действия остаются в верхней action-зоне, а счетчики (`Товаров`, `Категорий`, `Низкий остаток`, `Сводка за день`) вынесены в отдельные компактные chip-ряды.

- Reporting и audit секции ужаты: summary/context chips сгруппированы плотнее, audit filters выровнены в компактную сетку.
- latest web layout pass reduces top-card height, removes secondary counts from the `MovementsView` action area, and tightens `ReportingView`/stock report context blocks so summary chips, filters, and export cards read as one flow.
- Latest web pass compresses reporting/audit context layout and improves modal-form clarity for product, company, invite, and user flows.
