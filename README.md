# NexusSklad

Дата создания: 1 марта 2026
Статус: backend MVP, mobile shell and web admin shell in progress

`NexusSklad` — отдельный проект складского учета для малого бизнеса, стартующий с рынка Дербента.

Этот репозиторий не связан с `opt_demo`.

## Цель

Собрать отдельный рабочий контур под новый продукт:

- мобильное приложение;
- веб-интерфейс;
- backend API;
- shared contracts;
- инфраструктурные артефакты;
- продуктовая документация.

## Структура

```text
nexussklad/
├── README.md
├── docs/
│   ├── architecture.md
│   ├── bootstrap_plan.md
│   └── tech_decisions.md
├── apps/
│   ├── mobile/
│   ├── web/
│   └── api/
├── packages/
│   ├── shared/
│   └── ui/
└── infra/
    ├── docker/
    └── deploy/
```

## Архитектурная идея

- `apps/mobile` — Flutter-приложение для владельца и сотрудников;
- `apps/web` — web/admin интерфейс для владельца;
- `apps/api` — backend API на Node.js/TypeScript/Fastify;
- `packages/shared` — типы, DTO, API-контракты, доменные модели;
- `packages/ui` — общие UI-артефакты и дизайн-токены, если понадобятся для web;
- `infra` — docker, deployment и окружение.

## Текущее состояние

Уже готово:

1. продуктовые документы;
2. backend-каркас `apps/api`;
3. локальный `PostgreSQL` workflow;
4. первая Prisma migration;
5. seed для dev-компании;
6. backend-модули MVP;
7. mobile shell в `apps/mobile`;
8. Docker-based Flutter workflow;
9. mobile flows для dashboard, products, movements, inventory, company и team;
10. shared contract package в `packages/shared`;
11. backend route typing, привязанный к `packages/shared`;
12. DTO mapping в `apps/api`, нормализующий `Date` и `Decimal`;
13. первая OpenAPI-спецификация в `docs/openapi_v1.yaml`;
14. web admin shell в `apps/web`;
15. owner-only destructive/admin workflows в `apps/web`;
16. реальный TypeScript codegen из OpenAPI в `packages/shared/src/generated/openapi.ts`;
17. `apps/web` частично переведен на generated OpenAPI types;
18. `apps/api` routes переведены на generated OpenAPI schema types;
19. в `apps/mobile` добавлен contract-driven transport parsing для response envelopes и JSON decoding;
20. добавлен owner audit workflow:
    - backend `GET /v1/audit`
    - OpenAPI/generated types для audit
    - web audit screen и CSV export.
21. подготовлен Dart codegen scaffold для `apps/mobile`:
    - `docs/dart_codegen_strategy.md`
    - `apps/mobile/openapi-generator-config.yaml`
22. закрыт первый production-hardening пакет:
    - API dev auth fallback запрещен вне `development`
    - mobile session переведена на secure storage
    - offline write queues больше не маскируют runtime/contract ошибки под offline-case
23. ужесточен startup guard API:
    - non-development окружение не позволит запустить процесс с активными `DEFAULT_*` dev fallback переменными
24. закрыт production-hardening пакет 2:
    - non-development API теперь отвергает placeholder/weak JWT secrets
    - staging/prod-like переведены на отдельные runtime env files с реальными JWT secret значениями
    - `apps/mobile/tool/generate_openapi_client.sh`
    - `apps/mobile/generated/openapi_client/`
25. deploy/runtime env validation добавлена в `infra/deploy`:
    - `validate_runtime_env.sh`
    - `deploy_staging.sh`
    - deploy/backup/restore scripts теперь отклоняют placeholder или слишком слабые runtime env values
26. server-side runtime env ужесточен:
    - staging/prod-like Postgres passwords на сервере ротированы
    - после ротации внешние `8080/8081` повторно подтверждены smoke checks
27. добавлен безопасный server sync workflow:
    - `infra/deploy/sync_server.sh`
    - обычный rsync теперь не должен удалять server-only `.env.staging` / `.env.production`
28. backup/restore tooling усилен:
    - backup теперь пишет `.sql.gz` и `.sha256`
    - restore умеет читать `.sql.gz` и проверять checksum
    - добавлены `infra/deploy/verify_backup.sh` и `infra/deploy/prune_backups.sh`
29. добавлен container log retention:
    - staging/prod-like compose используют `json-file` logging с `max-size` / `max-file`
    - лог-политика задается через runtime env
30. добавлен monitoring baseline:
    - `infra/deploy/monitor_snapshot.sh`
    - `infra/deploy/monitor_check.sh`
    - можно быстро снять состояние контейнеров и проверить runtime health
31. добавлен cron-ready ops pack:
    - `infra/deploy/ops_daily.sh`
    - `infra/deploy/ops_weekly.sh`
    - `infra/deploy/ops_crontab.example`
    - `infra/deploy/install_ops_cron.sh`
    - daily backup/prune/health цикл можно запускать и ставить в cron
32. server cron уже установлен:
    - managed NexusSklad block добавлен в root crontab
    - installer проверен на idempotent-поведение
33. добавлен единый quality/release gate:
    - `run_quality_gate.sh` для локального полного контура
    - `infra/deploy/release_gate.sh` для server-side staging/prod-like проверок
    - smoke scripts проверяют и liveness, и readiness endpoint'ы
34. ops baseline расширен drill-скриптами:
    - `infra/deploy/readiness_check.sh` валидирует JSON-контракт `/health/ready`
    - `infra/deploy/backup_restore_drill.sh` поднимает backup/restore drill во временную БД без затрагивания live-данных
    - `infra/deploy/ops_weekly.sh` собирает weekly readiness + restore drill в один сценарий
35. добавлена политика ротации ops-логов:
    - `infra/deploy/rotate_ops_logs.sh` ротирует `/var/log/nexussklad-ops.log` и `/var/log/nexussklad-health.log`
    - cron template теперь включает отдельную log rotation job
36. добавлен security baseline:
    - `apps/api` выставляет базовые security headers
    - auth endpoints ограничены in-memory rate limit'ом
    - `apps/web/nginx.conf` выставляет CSP и базовые browser security headers
    - auth rate limit настраивается через `AUTH_RATE_LIMIT_MAX` и `AUTH_RATE_LIMIT_WINDOW_MS`
37. усилен owner reporting/audit UX:
    - export filenames теперь учитывают текущие report/audit filters
    - reporting screen показывает активный export context перед выгрузкой
    - audit screen показывает summary badges и reset filters
38. усилен inventory/reporting UX в web:
    - inventory day view показывает CTA на запуск первой сессии и summary по draft/completed sessions
    - stock report показывает активный filter context и позволяет быстро сбросить filters
39. усилен team/company owner UX в web:
    - team screen показывает summary по ролям и активным/неактивным пользователям
    - company panel показывает completeness badges и дату создания компании
40. усилен products/movements operator UX в web:
    - products screen показывает summary по low stock и товарам без категории
    - movements screen показывает summary по типам операций
41. усилен modal/forms UX в web:
    - все основные modal forms получили helper texts по действию
    - submit CTA стали точнее для product/movement/company/invite/user/category flows
42. усилен reporting insights UX в web:
    - reporting screen показывает daily summary badges по операциям и инвентаризации
    - export center лучше связывает выгрузки с текущим daily report контекстом
33. legacy cleanup завершен:
    - старый server backup path `/root/skladly` удален
    - активным остается только `/root/nexussklad`
31. добавлен cron-ready ops pack:
    - `infra/deploy/ops_daily.sh`
    - `infra/deploy/ops_crontab.example`
    - daily backup/prune/health цикл можно запускать одной командой
28. backup/restore tooling усилен:
    - backup теперь пишет `.sql.gz` и `.sha256`
    - restore умеет читать `.sql.gz` и проверять checksum
    - добавлен `infra/deploy/verify_backup.sh`
22. в `apps/mobile` начат hybrid transport/domain split:
    - `auth`
    - `products`
    - `movements`
    - `inventory`
    - `team/company`
23. в `apps/mobile` добавлен общий `transport -> domain` mapping layer.
24. в `apps/mobile` реально сгенерирован Dart OpenAPI client, а `auth`, `products/categories`, `movements`, `inventory` и `team/company` уже переведены на first-class generated transport types.
25. в `apps/mobile` удален лишний proxy transport слой:
    - repositories и domain-модели используют generated Dart types напрямую
    - промежуточные `*_transport.dart` файлы удалены
26. в `apps/web` расширен owner inventory/reporting workflow:
    - отдельный view для инвентаризации
    - запуск/открытие/завершение инвентаризации
    - обновление фактических остатков по позициям
    - stock report table и CSV export
27. policy зафиксирована:
    - destructive flows остаются в `apps/web`
    - mobile не берет на себя `delete`-сценарии
28. в `apps/web` добавлены reporting controls:
    - фильтр даты для daily report
    - фильтры stock report по поиску, категории и low stock
    - фильтры audit по пользователю, entity type и action
29. подготовлен staging/deploy контур:
    - `apps/api/Dockerfile`
    - `apps/web/Dockerfile`
    - `apps/web/nginx.conf`
    - `infra/deploy/docker-compose.staging.yml`
    - `infra/deploy/.env.staging.example`
    - `infra/deploy/README.md`
30. staging stack использует один browser origin:
    - `web` отдается через nginx
    - `/v1/*`, `/health` и `/health/ready` проксируются в `api`
    - это убирает необходимость в CORS для staging web shell
31. первый локальный staging run подтвержден:
    - stack поднят через `docker compose ... up -d --build`
    - `http://127.0.0.1:8080` отвечает `200 OK`
    - `http://127.0.0.1:8080/health` отвечает `200 OK`
    - `http://127.0.0.1:8080/health/ready` подтверждает DB readiness
    - demo owner login через staging web origin проходит успешно после seed
32. отдельный reporting/export контур как отдельное приложение не понадобился:
    - вместо этого в `apps/web` добавлен централизованный раздел `Экспорт и отчеты`
    - экспорты сведены в один owner/manager-friendly view
33. внешний staging уже поднят на сервере:
    - путь: `/root/nexussklad`
    - URL: `http://85.239.56.248:8080`
    - внешний health и demo login проверены
34. добавлен production hardening pack:
    - production compose
    - env template
    - deploy script
    - backup/restore scripts
    - smoke check
    - production runbook
35. staging и production-like контуры разведены корректно:
    - staging: `http://85.239.56.248:8080`
    - production-like: `http://85.239.56.248:8081`
    - compose namespaces разделены, оба контура работают параллельно
    - активные контейнеры: `nexussklad-web-staging`, `nexussklad-api-staging`, `nexussklad-postgres-staging`, `nexussklad-web-prod`, `nexussklad-api-prod`, `nexussklad-postgres-prod`
36. после rename проведен финальный UI copy pass:
    - web login shell говорит последовательно про `NexusSklad Control`
    - success state invite переведен на продуктовый русский copy
    - mobile login показывает быстрый demo-вход под новым брендом
37. подготовлен domain/HTTPS groundwork:
    - `infra/deploy/.env.domains.example`
    - `infra/deploy/render_nginx_site.sh`
    - `infra/deploy/nginx/nexussklad-staging.conf.template`
    - `infra/deploy/nginx/nexussklad-production.conf.template`
    - `infra/deploy/DOMAIN_CUTOVER_RUNBOOK.md`
38. после финального copy pass live web-контуры пересобраны и снова подтверждены deploy smoke на `8080/8081`
37. проверено состояние внешнего сервера перед cutover:
    - host `nginx` уже установлен
    - `certbot` пока не установлен
    - текущая рекомендуемая схема: домены -> host nginx -> `8080/8081`
38. в `apps/mobile` добавлен offline-ready read layer:
    - auth session сохраняется локально
    - приложение умеет стартовать из локальной сессии
    - dashboard, categories, products, movements, company и users читаются из cache при недоступном API
39. в `apps/mobile` добавлен первый offline write scope:
    - movement operations ставятся в локальную очередь при network failure
    - экран движений умеет делать retry/sync очереди
    - pending queue видна в UI
40. в `apps/mobile` добавлен inventory offline write scope:
    - изменения фактических остатков ставятся в локальную очередь при network failure
    - экран инвентаризации умеет делать retry/sync очереди
    - завершение инвентаризации блокируется, пока queue не синхронизирована
41. в `apps/mobile` добавлен company offline write scope:
    - update компании ставится в singleton queue при network failure
    - экран команды умеет делать retry/sync queue
    - `companyName` в локальной auth session обновляется сразу
42. в `apps/mobile` добавлен product update offline write scope:
    - update товара ставится в queue по `productId` при network failure
    - pending updates накладываются поверх product list
    - экран товаров умеет делать retry/sync queue
43. в `apps/mobile` добавлен user update offline write scope:
    - update сотрудника ставится в queue по `userId` при network failure
    - pending updates накладываются поверх team list
    - экран команды умеет делать retry/sync queue
44. в `apps/mobile` добавлен conflict-aware offline sync layer:
    - backend `error.code` пробрасывается в `ApiException`
    - mobile умеет различать auth/conflict/validation/server blockers
    - product и user queues продолжают sync остальных элементов, даже если часть операций конфликтует
    - товары и движения показывают conflict-aware sync messages в UI
45. в `apps/mobile` добавлен manual clear/discard flow для offline conflicts:
    - товары, движения и инвентаризация умеют очищать конфликтную очередь
    - экран команды умеет очищать очереди компании и сотрудников
46. в `apps/mobile` добавлен granular retry/discard flow:
    - товары умеют `retry/discard` по отдельному queued update
    - сотрудники умеют `retry/discard` по отдельному queued update
    - conflict UI показывает item-level pending элементы с временем создания
47. в `apps/mobile` добавлен первый reconciliation flow для offline-created entities:
    - создание товара теперь может встать в offline queue
    - pending create виден в каталоге как `queued create`
    - pending create поддерживает `retry/discard`
48. в `apps/mobile` pending queues стали first-class UI-частью:
    - `Товары` всегда показывают pending create/update блок, если есть отложенные операции
    - `Команда` всегда показывает pending user update блок, если есть отложенные операции
49. в `apps/mobile` добавлен offline queue для `inventory start`:
    - старт инвентаризации можно отложить при недоступной сети
    - pending start виден отдельным блоком
    - pending start поддерживает `retry/discard`
50. в `apps/mobile` добавлен offline queue для `category create`:
    - создание категории можно отложить при недоступной сети
    - pending category create виден на экране товаров
    - pending category create поддерживает `retry/discard`
51. в `apps/mobile` добавлен offline queue для `user invite/create`:
    - приглашение сотрудника можно отложить при недоступной сети
    - pending invite виден на экране команды
    - pending invite поддерживает `retry/discard`
52. deploy smoke tooling усилен:
    - `infra/deploy/smoke_check.sh` умеет работать в режиме `skip-login`
    - staging и production-like контуры проверены внешне и на сервере
53. offline invite flow в `apps/mobile` доведен до рабочего контура:
    - pending invite виден на экране команды
    - pending invite поддерживает `retry/discard`
54. в `apps/api` добавлен automated smoke/integration test layer:
    - `npm run test:smoke`
    - покрывает `auth`, `invite`, `products`, `movements`, `inventory`, `reports`, `audit`
55. в `apps/web` и `apps/mobile` усилены empty/error states:
    - admin shell получил глобальный retry и empty states для owner workflows
    - mobile dashboard/movements получили более явные fallback-состояния
56. добавлен `docs/ui_smoke_checklist.md` для IP-only rollout:
    - owner/manager/staff сценарии
    - empty/error states
    - offline visibility checks
    - staging login подтвержден для `owner` и `manager`
57. добавлен `infra/deploy/staging_happy_path_check.sh`:
    - server-side owner/manager API smoke для staging
    - полезен перед ручным UI-прогоном
58. `staging_happy_path_check.sh` расширен до role matrix checks:
    - owner / manager / staff
    - access guards на `reports`, `users`, `audit`, `adjustment`
59. подготовлен staging baseline workflow:
    - `infra/deploy/reset_staging_demo.sh`
    - `docs/ui_smoke_report_template.md`
60. добавлен preflight для ручного UI smoke pass:
    - `infra/deploy/prepare_ui_smoke_pass.sh`
    - `docs/ui_smoke_report_latest.md`
61. добавлен session starter и triage guide:
    - `infra/deploy/start_ui_smoke_session.sh`
    - `docs/ui_gap_triage.md`
62. добавлен fix-pack workflow:
    - `infra/deploy/create_ui_fix_pack.sh`
    - `docs/ui_fix_pack_template.md`
63. добавлен единый QA orchestration workflow:
    - `infra/deploy/run_ui_smoke_workflow.sh`
    - собирает reset/preflight/session report/fix pack в один поток
64. в `apps/web` добавлен render smoke test layer:
    - `npm run test:render`
    - защищает critical empty states от регрессий
65. в `apps/mobile` добавлен shared state-card слой:
    - `lib/core/widgets/state_cards.dart`
    - общие empty/error/sync widgets используются в `products` и `movements`
66. в `apps/mobile` добавлен widget render smoke test layer:
    - `test/widget/render_smoke_test.dart`
    - empty/error/sync состояния валидируются автоматически
67. в `apps/mobile` добавлен shared info/pending widget слой:
    - `lib/core/widgets/info_cards.dart`
    - `dashboard`, `inventory`, `team` используют общие widgets вместо inline-card разметки
68. mobile render smoke suite расширен:
    - теперь автоматически проверяются empty/error/sync/info/pending состояния
    - текущий результат: `6 tests passed`
69. в `apps/mobile` добавлен domain-specific state widget слой:
    - `lib/core/widgets/domain_state_cards.dart`
    - reusable widgets для `dashboard`, `movements`, `inventory`
70. mobile render smoke suite расширен до domain-level coverage:
    - проверяются `DashboardNoActivityCard`
    - проверяется `EmptyMovementsCard`
    - проверяется `PendingInventoryStartCard`
    - текущий результат: `9 tests passed`
71. в `apps/mobile` добавлены reusable domain blocks для pending flows:
    - `ProductPendingOperationsCard`
    - `TeamPendingOperationsCard`
72. `products` и `team` переведены на reusable domain blocks вместо inline pending UI.
73. mobile render smoke suite расширен:
    - покрывает `products` pending operations
    - покрывает `team` pending invites/updates
    - текущий результат: `11 tests passed`
74. в `apps/mobile` добавлен reusable entity-card слой:
    - `CompanyStatusCard`
    - `TeamMemberInfoCard`
    - `ProductStockCard`
75. `products` и `team` переведены на reusable entity cards вместо inline карточек.
76. mobile render smoke suite расширен до coverage entity cards:
    - company pending state
    - team member queued badge
    - product stock badges
    - текущий результат: `14 tests passed`
77. в `apps/web` добавлены reusable owner workflow blocks:
    - `CompanyPanel`
    - `ProductTableRow`
    - `TeamUserRow`
78. `products` и `team` в web переведены на reusable blocks вместо inline разметки.
79. web render smoke suite расширен:
    - company summary block
    - product row block
    - team user row block
    - текущий результат: `8 tests passed`
80. в `apps/web` добавлены reusable blocks для `inventory` и `reporting`:
    - `InventorySessionRow`
    - `StockReportRow`
    - `ExportCard`
81. `InventoryView` переведен на reusable row blocks вместо inline строк.
82. web render smoke suite расширен:
    - inventory session row
    - stock report row
    - export card
    - текущий результат: `11 tests passed`
83. в `apps/web` добавлены reusable row blocks:
    - `MovementTableRow`
    - `AuditLogRow`
84. `movements` и `audit` в web переведены на reusable/testable rows вместо inline строк.
85. web render smoke suite расширен:
    - movement row
    - audit log row
    - текущий результат: `13 tests passed`
86. в `apps/web` modal/forms переведены в first-class testable components:
    - `ProductModal`
    - `MovementModal`
    - `CompanyModal`
    - `InviteModal`
    - `UserModal`
    - `CategoryModal`
87. web render smoke suite расширен:
    - покрывает основные owner/manager modal/forms
    - текущий результат: `19 tests passed`
88. в `infra/deploy` добавлен `web_deploy_smoke_check.sh`:
    - валидирует deployed web shell по root HTML, bundle asset, `/health`, `auth/login`, `auth/me`
    - поддерживает `skip-login` для production-like без demo seed
89. добавлен contract integrity gate:
    - `packages/shared/check_openapi_codegen.sh`
    - `packages/shared/package.json -> npm run codegen:openapi:check`
    - `check_contract_integrity.sh` проверяет spec/codegen drift и компиляцию `apps/api` + `apps/web`
90. в `apps/web` добавлен contract-aware API client:
    - runtime-проверка `module` и envelope shape для `item/list/report`
    - централизованный parsing backend error envelope
91. в `apps/web` добавлен `npm run test:contract`:
    - проверяет error envelope parsing
    - проверяет module/report mismatch detection
    - текущий результат: `6 tests passed`
92. в `apps/mobile` добавлен contract hardening для network слоя:
    - `ApiContractException`
    - централизованный `parseApiError(...)`
93. в `apps/mobile` добавлен `test/network/api_contract_test.dart`:
    - проверяет `item/list/report` guards
    - проверяет `auth/invite` action guards
    - проверяет backend error envelope parsing
    - текущий результат: `7 tests passed`
94. в `apps/api` добавлен `npm run test:contract`:
    - проверяет `health`, `auth`, `item/list/report` envelopes
    - проверяет error envelope для `AppError` и `404`
95. в `apps/api` добавлен стабильный `404 NOT_FOUND` error envelope.
96. `docs/openapi_v1.yaml` усилен shared error response components:
    - `UnauthorizedError`
    - `ForbiddenError`
    - `NotFoundError`
    - `ConflictError`
    - `InternalServerError`
97. OpenAPI теперь явно описывает error responses для core routes, а `packages/shared/src/generated/openapi.ts` regenerated под эти изменения.
98. в `apps/api` добавлен route schema hardening через Fastify `schema.response`.
99. добавлен `apps/api/src/lib/response-schemas.ts` для envelope/error response schemas.
100. API checks после route schema hardening остаются зелеными:
    - `npm run test:contract`
    - `npm run test:smoke`
101. validation errors в API нормализованы в stable `400 VALIDATION_ERROR` envelope.
102. API contract tests расширены validation-сценариями для body/query/params.
103. `apps/web` теперь маппит `VALIDATION_ERROR`, `FORBIDDEN`, `AUTH_*`, `INSUFFICIENT_STOCK`, `INVENTORY_*`, `404` и `409` в стабильные user-facing сообщения.
104. `apps/mobile` получил такой же centralized error mapping с сохранением `backendMessage` для диагностики и тестов.
105. внешний `web` на `8080/8081` пересобран после UI/contract изменений; `production-like` восстановлен без сброса данных после рассинхронизации пароля Postgres.
106. `web` получил session-expiry handler: при `401/AUTH_*` admin shell сбрасывает сессию и возвращает пользователя на экран входа с понятным notice.
107. `mobile` получил такой же flow: ключевые экраны вызывают `AuthController.expireSession(...)` и переводят пользователя обратно на login screen.
108. `web` теперь сначала делает silent refresh через `/v1/auth/refresh` и повторяет действие с новым access token.
109. `mobile` получил `AuthController.recoverSession(...)`: read-heavy экраны пытаются восстановить сессию и перезагрузиться без forced logout.
110. `mobile` write-actions для `movements`, `products`, `team`, `inventory` теперь делают один controlled retry после successful refresh и используют уже введенный payload.
111. `web` показывает notice `Сессия восстановлена. Действие повторено автоматически.` после silent refresh.
112. `mobile` показывает separate notices для `Сессия восстановлена. Продолжаем работу.` и `Сессия завершена. Войди снова.`
113. Обновленный `web` с auth-notice UX выкачен на внешние `8080/8081`; deploy smoke прошел на обоих контурах, live bundle: `/assets/index-DxVwnrtk.js`.
114. В `apps/web` добавлен targeted render-smoke test для `LoginForm` на auth `notice/error` states.
115. В `apps/mobile` `AuthController` теперь работает через `AuthGateway`, а recovery/notices покрыты unit tests.
116. `apps/web` quality gate после этого шага зеленый: `8 contract tests`, `20 render tests`, `build ok`.
117. Generated Dart OpenAPI client для mobile перенесен в `apps/mobile/generated/openapi_client`; это устранило конфликт `flutter test` runtime.
118. `apps/mobile` quality gate снова полностью зеленый: `flutter analyze` — ok, `26 tests passed`.
119. `apps/web` теперь показывает persistent inline session notice в signed-in shell после silent refresh.
120. `apps/mobile` теперь показывает dismissible `AuthNoticeCard` в `AppShell`, а не только краткий `SnackBar`.
121. После этого `apps/web` quality gate: `21 render tests`, `build ok`.
122. После этого `apps/mobile` quality gate: `27 tests passed`.
123. `apps/mobile` получил `offline/conflict UX polish`: более явные тексты для конфликтов, повторной синхронизации и очистки очереди.
124. `TeamScreen` теперь использует общий `ErrorStateCard`, а queued-action блоки точнее объясняют, что произойдет при retry/discard.
125. `apps/web` получил `conflict/error copy polish`: destructive confirm-тексты предупреждают о необратимости и рекомендуют проверить связанные данные.
126. `InviteModal` теперь показывает понятный recovery block `Приглашение готово` вместо сырого `Invite token`.
127. `TeamView` для non-owner теперь использует общий `InlineState`, а не plain notice.
128. После этого `apps/web` quality gate: `22 render tests`, `build ok`.
129. В `apps/mobile` добавлен первый screen-level recovery test для `DashboardScreen`: он фиксирует сценарий `401 -> refresh -> retry` без forced logout.
130. Тест также проверяет recovery-notice и итоговую summary после повторной загрузки.
131. После этого `apps/mobile` quality gate: `flutter analyze` — ok, `28 tests passed`.
132. `ProductsScreen` получил optional repository overrides для screen-level тестов без реального API.
133. Добавлен второй mobile screen-level recovery test: `ProductsScreen` теперь фиксирует сценарий `401 -> refresh -> retry -> updated products list`.
134. После этого `apps/mobile` quality gate: `flutter analyze` — ok, `29 tests passed`.
135. Добавлен третий mobile screen-level recovery test: `MovementsScreen` теперь фиксирует сценарий `401 -> refresh -> retry -> updated movements list`.
136. Screen-level recovery coverage в mobile теперь есть на трех read-heavy экранах: `DashboardScreen`, `ProductsScreen`, `MovementsScreen`.
137. После этого `apps/mobile` quality gate: `flutter analyze` — ok, `30 tests passed`.
138. Добавлен четвертый mobile screen-level recovery test: `InventoryScreen` теперь фиксирует сценарий `401 -> refresh -> retry start inventory`.
139. Screen-level recovery coverage в mobile теперь есть на четырех экранах: `DashboardScreen`, `ProductsScreen`, `MovementsScreen`, `InventoryScreen`.
140. После этого `apps/mobile` quality gate: `flutter analyze` — ok, `31 tests passed`.
141. Добавлен пятый mobile screen-level recovery test: `TeamScreen` теперь фиксирует сценарий `401 -> refresh -> retry company reload`.
142. `TeamScreen` получил optional repository overrides для screen-level тестов без реального API.
143. Screen-level recovery coverage в mobile теперь есть на пяти экранах: `DashboardScreen`, `ProductsScreen`, `MovementsScreen`, `InventoryScreen`, `TeamScreen`.
144. После этого `apps/mobile` quality gate: `flutter analyze` — ok, `32 tests passed`.
145. Добавлен первый mobile write-recovery test: `MovementsScreen` теперь фиксирует сценарий `401 -> refresh -> retry create income`.
146. Этот тест проверяет, что при retry не теряется исходный payload: `productId`, `quantity`, `comment`.
147. После этого `apps/mobile` quality gate: `flutter analyze` — ok, `33 tests passed`.
148. Чтобы стабилизировать write-recovery widget tests, `ProductsScreen` получил `createCategoryNameBuilder`, а `MovementsScreen` — `MovementDialogAction`, `MovementDialogPayload` и `movementPayloadBuilder`.
149. Это убрало flaky зависимость от реальных dialog controllers в тест runtime и сохранило production UX без изменений.
150. Добавлен второй mobile write-recovery test: `ProductsScreen` теперь фиксирует сценарий `401 -> refresh -> retry create category`.
151. Теперь mobile write-recovery покрывает:
    - `MovementsScreen -> create income`
    - `ProductsScreen -> create category`
152. После этого `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `34 tests passed`.
153. `ProductsScreen` получил `createProductPayloadBuilder`, чтобы write-recovery на создание товара тестировался без реального `AlertDialog`.
154. Добавлен третий mobile write-recovery test: `ProductsScreen` теперь фиксирует сценарий `401 -> refresh -> retry create product`.
155. Новый тест проверяет сохранение полного create payload: `name`, `unit`, `categoryId`, `sku`, `barcode`, `description`, `minStock`, `currentStock`.
156. Теперь mobile write-recovery покрывает:
    - `MovementsScreen -> create income`
    - `ProductsScreen -> create category`
    - `ProductsScreen -> create product`
157. После этого `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `35 tests passed`.
158. `InventoryScreen` получил `actualQtyBuilder`, чтобы write-recovery на изменение фактического остатка тестировался без реального quantity dialog.
159. Добавлен четвертый mobile write-recovery test: `InventoryScreen` теперь фиксирует сценарий `401 -> refresh -> retry patch item`.
160. Новый тест проверяет сохранение inventory payload: `inventoryId`, `itemId`, `actualQty`.
161. По ходу найден и исправлен реальный UI дефект: trailing action в `InventoryScreen` overflow'ил на незавершенной сессии; action переведен в compact mode.
162. Теперь mobile write-recovery покрывает:
    - `MovementsScreen -> create income`
    - `ProductsScreen -> create category`
    - `ProductsScreen -> create product`
    - `InventoryScreen -> patch item`
163. После этого `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `36 tests passed`.
164. `TeamScreen` получил `invitePayloadBuilder`, чтобы write-recovery на invite тестировался без реального invite dialog.
165. Добавлен пятый mobile write-recovery test: `TeamScreen` теперь фиксирует сценарий `401 -> refresh -> retry invite user`.
166. Новый тест проверяет сохранение invite payload: `email`, `role`.
167. Теперь mobile write-recovery покрывает:
    - `MovementsScreen -> create income`
    - `ProductsScreen -> create category`
    - `ProductsScreen -> create product`
    - `InventoryScreen -> patch item`
    - `TeamScreen -> invite user`
168. После этого `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `37 tests passed`.
169. Добавлен шестой mobile write-recovery test: `InventoryScreen` теперь фиксирует сценарий `401 -> refresh -> retry finish inventory`.
170. Новый тест проверяет сохранение finish payload: повторно уходит тот же `inventoryId`, а экран после recovery показывает завершенную сессию.
171. Теперь mobile write-recovery покрывает:
    - `MovementsScreen -> create income`
    - `ProductsScreen -> create category`
    - `ProductsScreen -> create product`
    - `InventoryScreen -> patch item`
    - `InventoryScreen -> finish inventory`
    - `TeamScreen -> invite user`
172. После этого `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `38 tests passed`.
173. Добавлен седьмой mobile write-recovery test: `MovementsScreen` теперь фиксирует сценарий `401 -> refresh -> retry create adjustment`.
174. Новый тест проверяет сохранение adjustment payload: повторно уходят те же `productId`, `targetQty`, `comment`, а экран после recovery показывает adjustment в журнале движений.
175. Теперь mobile write-recovery покрывает:
    - `MovementsScreen -> create income`
    - `MovementsScreen -> create adjustment`
    - `ProductsScreen -> create category`
    - `ProductsScreen -> create product`
    - `InventoryScreen -> patch item`
    - `InventoryScreen -> finish inventory`
    - `TeamScreen -> invite user`
176. После этого `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `39 tests passed`.
177. `ProductsScreen` получил `editProductPayloadBuilder`, чтобы write-recovery на редактирование товара тестировался без реального product dialog.
178. Добавлен восьмой mobile write-recovery test: `ProductsScreen` теперь фиксирует сценарий `401 -> refresh -> retry update product`.
179. Новый тест проверяет сохранение update payload: повторно уходят те же `productId`, `name`, `unit`, `categoryId`, `sku`, `barcode`, `description`, `minStock`.
180. Теперь mobile write-recovery покрывает:
    - `MovementsScreen -> create income`
    - `MovementsScreen -> create adjustment`
    - `ProductsScreen -> create category`
    - `ProductsScreen -> create product`
    - `ProductsScreen -> update product`
    - `InventoryScreen -> patch item`
    - `InventoryScreen -> finish inventory`
    - `TeamScreen -> invite user`
181. После этого `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `40 tests passed`.
182. Добавлен девятый mobile write-recovery test: `MovementsScreen` теперь фиксирует сценарий `401 -> refresh -> retry create expense`.
183. Новый тест проверяет сохранение expense payload: повторно уходят те же `productId`, `quantity`, `comment`, а экран после recovery показывает expense в журнале движений.
184. Теперь mobile write-recovery покрывает:
    - `MovementsScreen -> create income`
    - `MovementsScreen -> create expense`
    - `MovementsScreen -> create adjustment`
    - `ProductsScreen -> create category`
    - `ProductsScreen -> create product`
    - `ProductsScreen -> update product`
    - `InventoryScreen -> patch item`
    - `InventoryScreen -> finish inventory`
    - `TeamScreen -> invite user`
185. После этого `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `41 tests passed`.
186. `InventoryScreen._flushPendingUpdates()` получил auth-recovery retry: при `401/AUTH_*` экран сначала делает `refreshToken`, затем повторяет ручную синхронизацию очереди инвентаризации.
187. Добавлен десятый mobile write-recovery test: `InventoryScreen` теперь фиксирует сценарий `401 -> refresh -> retry sync queue`.
188. Новый тест проверяет сохранение sync payload: повторно уходит тот же `inventoryId`, а после recovery экран повторно запрашивает сессию через `getById`.
189. Теперь mobile write-recovery покрывает:
    - `MovementsScreen -> create income`
    - `MovementsScreen -> create expense`
    - `MovementsScreen -> create adjustment`
    - `ProductsScreen -> create category`
    - `ProductsScreen -> create product`
    - `ProductsScreen -> update product`
    - `InventoryScreen -> patch item`
    - `InventoryScreen -> finish inventory`
    - `InventoryScreen -> sync queue`
    - `TeamScreen -> invite user`
190. После этого `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `42 tests passed`.
191. В `apps/web` выделен общий helper `executeSessionAction()` для owner/manager действий с silent refresh и единым retry-path.
192. `App.tsx` переведен на этот helper без изменения UX-контракта: при `401/AUTH_*` web сначала пытается `refreshToken`, затем повторяет исходное действие один раз.
193. Добавлен новый web recovery suite: `npm run test:recovery`.
194. Он покрывает:
    - retry after refresh
    - refresh failure
    - forbidden without retry
    - fallback message for unknown errors
195. После этого `apps/web` quality gate снова зеленый: `npm run check`, `npm run test:contract`, `npm run test:recovery`, `npm run test:render`, `npm run build` — ok.
196. Для destructive owner actions добавлен confirm-aware helper: `executeConfirmedSessionAction()`.
197. `App.tsx` переведен на него для:
    - `delete product`
    - `delete category`
198. Новый helper сначала спрашивает confirm, затем использует общий recovery path через `executeSessionAction()`.
199. `web` recovery suite расширен destructive cases:
    - confirm cancel не запускает delete action
    - delete после `401/AUTH_*` повторяется автоматически после `refreshToken`
200. После этого `apps/web` quality gate снова зеленый: `npm run check`, `npm run test:contract`, `npm run test:recovery`, `npm run test:render`, `npm run build` — ok.

Подробный статус:

- `docs/progress.md`

## Следующий шаг

1. при необходимости прогнать `infra/deploy/run_ui_smoke_workflow.sh --reset`;
2. затем пройти `docs/ui_smoke_checklist.md`;
3. занести находки в созданные session report и fix pack;
4. при изменениях web держать `npm run test:render` зеленым.
5. при изменениях mobile держать `flutter test test/widget/render_smoke_test.dart` зеленым.
6. следующий уровень quality gate:
   - `infra/deploy/web_deploy_smoke_check.sh http://127.0.0.1:8080`
   - `infra/deploy/web_deploy_smoke_check.sh http://127.0.0.1:8081 skip-login`
7. для contract drift использовать:
   - `cd packages/shared && npm run codegen:openapi:check`
   - `./check_contract_integrity.sh`
8. для web transport/client слоя использовать:
   - `cd apps/web && npm run test:contract`
   - `cd apps/web && npm run test:render`
9. для mobile transport/client слоя использовать:
   - `flutter test test/network/api_contract_test.dart`
   - `flutter test test/widget/render_smoke_test.dart`
10. для API error/response слоя использовать:
   - `cd apps/api && npm run test:contract`
   - `cd apps/api && npm run test:smoke`
11. для OpenAPI response/error слоя использовать:
   - `cd packages/shared && npm run codegen:openapi`
   - `cd packages/shared && npm run codegen:openapi:check`
   - `./check_contract_integrity.sh`
12. для API route schema слоя использовать:
   - `cd apps/api && npm run test:contract`
   - `cd apps/api && npm run test:smoke`
13. для API validation слоя использовать:
   - `cd apps/api && npm run test:contract`

201. `apps/web` recovery suite расширен inventory/team-style сценариями: теперь helper отдельно проверяется на сохранение invite payload после `401 -> refreshToken -> retry` и на inventory action chain с follow-up `refresh admin` шагом.
202. Для web recovery path добавлена явная проверка `onSessionRecovered`: восстановленная session действительно уходит дальше в owner/manager action flow.
203. После этого `apps/web` quality gate снова зеленый: `npm run check`, `npm run test:contract`, `npm run test:recovery`, `npm run test:render`, `npm run build` — ok; `test:recovery` теперь дает `8 passed`.
204. `apps/web` recovery suite расширен modal-style сценариями: теперь отдельно проверяются `InviteModal` и `CompanyModal` flow, где `401 -> refreshToken -> retry` не ломает result path и post-success chain.
205. Invite-style test фиксирует сохранение modal result после recovery: retry идет тем же action path, после чего `inviteToken` может быть безопасно установлен в UI.
206. Company-style test фиксирует save-flow после recovery: recovered session продолжает `refresh admin` chain, а modal закрывается только после успешного save.
207. После этого `apps/web` quality gate снова зеленый: `npm run check`, `npm run test:contract`, `npm run test:recovery`, `npm run test:render`, `npm run build` — ok; `test:recovery` теперь дает `10 passed`.
208. `apps/web` recovery suite расширен concrete action-chain сценариями для `team` и `inventory`: теперь helper отдельно проверяется на `update user`-style flow и на `update inventory item`-style flow после `401 -> refreshToken -> retry`.
209. Team-style test фиксирует сохранение update payload после recovery: retry идет тем же action path, а follow-up `refresh admin` использует recovered session.
210. Inventory-style test фиксирует сохранение `inventoryId/itemId/actualQty` после recovery: retry проходит тем же action path и обновляет selected inventory уже с recovered session.
211. После этого `apps/web` quality gate снова зеленый: `npm run check`, `npm run test:contract`, `npm run test:recovery`, `npm run test:render`, `npm run build` — ok; `test:recovery` теперь дает `12 passed`.
212. `apps/web` recovery suite расширен финальными owner action-chain сценариями: теперь отдельно проверяются `update company` и `finish inventory` после `401 -> refreshToken -> retry`.
213. Company-update test фиксирует сохранение update payload после recovery: retry идет тем же action path и post-success refresh/admin path использует recovered session.
214. Finish-inventory test фиксирует сохранение `inventoryId` после recovery: retry проходит тем же action path и завершенная сессия приходит уже с recovered session.
215. После этого `apps/web` quality gate снова зеленый: `npm run check`, `npm run test:contract`, `npm run test:recovery`, `npm run test:render`, `npm run build` — ok; `test:recovery` теперь дает `14 passed`.
216. В `TeamScreen` добавлен стабильный test-only recovery entrypoint через публичный `TeamScreenState.runUserEditForTest(...)`: он нужен, чтобы `update user` сценарий не зависел от flaky tap/dialog path.
217. Добавлен одиннадцатый mobile write-recovery test: `TeamScreen` теперь проверяется на сценарий `401 -> refresh -> retry update user`.
218. Новый тест фиксирует retry payload для сотрудника: повторно уходят те же `userId`, `name`, `email`, `phone`, `role`, `password`, `isActive`.
219. После этого mobile write-recovery покрывает все основные write paths: movements, products, inventory, team invite и team update user.
220. `mobile` quality gate снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `43 passed`.
221. Проведен `mobile UX/copy hardening` pass: `auth/dashboard/products/movements/inventory/team` получили более точные helper texts, clearer CTA и менее техничный продуктовый copy.
222. `ProductsScreen` теперь показывает summary chips по каталогу (`Товаров / Low stock / Без категории`), `MovementsScreen` — summary chips по журналу (`Записей / Приход / Расход / Корректировка`), `InventoryScreen` — summary chips по сессии (`Позиций / Расхождений / В очереди`).
223. `TeamScreen` получил русские role labels в dialogs, новый invite success copy и owner summary chips по команде; `LoginScreen` теперь показывает единый demo-access блок для owner/manager/staff.
224. После этого `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `43 passed`.

225. Закрыт `mobile modal/forms UX hardening`: dialogs `product / movement / inventory / company / invite / user` получили helper texts, role-aware copy и более точные submit CTA.
226. `ProductDialog` теперь объясняет ключевые поля каталога, `MovementDialog` различает flow для прихода/расхода и корректировки, `InventoryScreen` dialog показывает ожидаемый остаток, а team dialogs используют русские role labels и cleaner invite/company/user copy.
227. После этого `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `43 passed`.

228. Закрыт `mobile summary/entity UX hardening`: `CompanyStatusCard`, `TeamMemberInfoCard` и `ProductStockCard` получили product-facing status copy без англицизмов (`Есть изменения в очереди`, `Нужна сверка с сервером`, `низкий остаток`, `создается офлайн`, `в очереди`).
229. `TeamMemberInfoCard` теперь сам отображает role labels как `Менеджер` и `Сотрудник`, а `CompanyStatusCard` показывает явный operational state через chips поверх sync/error сообщений.
230. После этого `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `43 passed`.
231. Добавлен `mobile dialog copy regression` слой: `test/widget/screen_recovery_test.dart` теперь фиксирует product-facing copy для `create category`, `create product`, `movement`, `actual qty` и `invite` dialogs.
232. Это дает отдельный regression-контур именно на тексты и CTA форм, без зависимости только от общих render-smoke карт.
233. После добавления dialog-copy regression `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `48 passed`.
234. Проведен `mobile role/copy consistency` pass: демо-аккаунты, role labels, summary chips и pending labels в `login / dashboard / products / team / entity cards` приведены к единому русскому продуктовый copy.
235. `ProductsScreen` теперь показывает `Низкий остаток`, `TeamScreen` использует `Владелец / Менеджер / Сотрудник` в summary и pending labels, а header роли и пустые состояния больше не смешивают русский UI с `OWNER/MANAGER/STAFF`.
236. После этого `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `48 passed`.
237. Проведен `mobile action feedback hardening` pass: snackbar copy для `products / movements / inventory / team` приведен к единому operational стилю и больше не использует техничные CRUD-формулировки в пользовательском UI.
238. Offline/retry feedback теперь последовательно объясняет состояние действий как `сохранено в очередь на отправку`, `отложенные изменения очищены`, `запуск инвентаризации синхронизирован`, что лучше соответствует реальному workflow склада.
239. После этого `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `48 passed`.
240. Проведен `mobile dashboard insight hardening` pass: `DashboardSummary` теперь хранит breakdown по `INCOME / EXPENSE / ADJUSTMENT / INVENTORY_DIFF`, а экран обзора показывает эти срезы отдельными chips.
241. Это делает mobile dashboard полезнее как operational summary: владелец и менеджер сразу видят, какие именно типы движений формируют день и были ли инвентаризационные сессии.
242. После этого `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `48 passed`.
243. Проведен `mobile operator workflow hardening` pass: `DashboardScreen` получил быстрые действия для перехода в `движения / инвентаризацию / каталог / команду` без лишнего поиска нужной вкладки.
244. `AppShell` теперь умеет открывать целевую вкладку по callback из dashboard и показывает короткий contextual notice о следующем шаге в выбранном рабочем сценарии.
245. В `screen_recovery_test.dart` добавлен отдельный widget-сценарий на dashboard quick actions; после этого `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `49 passed`.
246. Проведен `mobile product filtering hardening` pass: `ProductsScreen` получил быстрые фильтры `Все / Низкий остаток / Без категории / Офлайн-черновики`, чтобы владелец и оператор быстрее выделяли проблемные товарные срезы.
247. Если выбранный фильтр не дает позиций, экран теперь не выглядит пустым: показывается отдельный empty-state `По выбранному фильтру товаров нет` с CTA `Сбросить фильтр`.
248. В `screen_recovery_test.dart` добавлен widget-сценарий на product filters; после этого `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `50 passed`.
249. Проведен `mobile movement filtering hardening` pass: `MovementsScreen` получил быстрые фильтры `Все / Приход / Расход / Корректировка / Сверка`, чтобы журнал операций сразу раскладывался по рабочим типам событий.
250. Если выбранный фильтр не дает записей, экран теперь показывает отдельный empty-state `По выбранному фильтру движений нет` с CTA `Сбросить фильтр`, вместо пустого списка без объяснения.
251. В `screen_recovery_test.dart` добавлен widget-сценарий на movement filters; после этого `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `51 passed`.
252. Проведен `mobile inventory filtering hardening` pass: `InventoryScreen` получил быстрые фильтры `Все / Расхождения / Совпадает`, чтобы сверка остатков не сводилась к ручному просмотру всей сессии.
253. Если выбранный фильтр не дает позиций, экран теперь показывает отдельный empty-state `По выбранному фильтру позиций нет` с CTA `Сбросить фильтр`, вместо пустой инвентаризационной ленты.
254. В `screen_recovery_test.dart` добавлен widget-сценарий на inventory filters; после этого `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `52 passed`.
255. Проведен `mobile team/company workflow hardening` pass: `TeamScreen` получил быстрые owner-facing фильтры `Все / Активные / Менеджеры / Сотрудники / Приглашения`, чтобы владелец мог быстрее раскладывать команду по operational срезам.
256. Для team filters добавлен отдельный empty-state `По выбранному фильтру сотрудников нет` с CTA `Сбросить фильтр`, а copy на pending invite в карточке сотрудника переведен в продуктовую формулировку `Приглашение до ...`.
257. После team/company workflow hardening `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `52 passed`.
258. Проведен `mobile offline movement queue UX` pass: `MovementsScreen` теперь показывает явный pending-action блок `Есть движения в очереди`, когда часть операций сохранена локально и ожидает синхронизации.
259. Оператору даны прямые действия `Отправить сейчас / Очистить очередь`, поэтому offline-состояние журнала движений больше не скрыто за одним chip-счетчиком.
260. В `screen_recovery_test.dart` добавлен widget-сценарий на pending movement queue card; после этого `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `53 passed`.
261. Проведен `mobile offline inventory queue UX` pass: `InventoryScreen` теперь показывает явный pending-action блок `Есть позиции в очереди`, когда изменения по активной сессии инвентаризации сохранены локально и ждут синхронизации.
262. Оператору даны те же прямые действия `Отправить сейчас / Очистить очередь`, поэтому inventory offline workflow теперь консистентен с journal/offline UX в `MovementsScreen`.
263. В `screen_recovery_test.dart` добавлен widget-сценарий на pending inventory queue card; после этого `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `54 passed`.
264. Проведен `mobile products offline queue UX` pass: `ProductPendingOperationsCard` теперь показывает batch-level CTA `Отправить все сейчас / Очистить очередь`, если в каталоге есть локальные category/product операции без конфликта.
265. Это делает offline workflow каталога консистентным с `MovementsScreen` и `InventoryScreen`: владелец и менеджер могут управлять всей очередью товаров одним действием, а не только поэлементно.
266. В `render_smoke_test.dart` добавлен сценарий на batch-actions в `ProductPendingOperationsCard`; после этого `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `55 passed`.
267. Проведен `mobile team offline queue UX` pass: `TeamPendingOperationsCard` теперь показывает batch-level CTA `Отправить все сейчас / Очистить очередь`, если по команде есть локальные invites/updates без конфликта.
268. Это делает offline workflow команды консистентным с products/movements/inventory: владелец может управлять всей очередью сотрудников одним действием, а не только поэлементно.
269. В `render_smoke_test.dart` добавлен сценарий на batch-actions в `TeamPendingOperationsCard`; после этого `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `56 passed`.

- `infra/deploy/bootstrap_owner.sh` создает первого owner через `POST /v1/auth/register` для `staging`, `production` или явного base URL.
- `ALLOW_PUBLIC_REGISTRATION=false` в production-like закрывает публичную регистрацию после bootstrap первого owner.

- `infra/deploy/validate_runtime_env.sh` теперь также требует явный `ALLOW_PUBLIC_REGISTRATION=true|false`, чтобы bootstrap/registration policy была зафиксирована в runtime env.

- Первый `web fix pack` по реальным скриншотам admin-панели начат и закрыт:
  - owner/web copy приведен к одному русскому продуктному тону;
  - `Admin Shell`, `Low stock`, `Stock report`, `Audit trail`, `Parent`, `Entity type`, `Action`, `OWNER/MANAGER/STAFF` убраны из видимого UI;
  - overview получил явный empty-state для дня без операций;
  - demo seed переведен на более нейтральный клиентский сценарий: `Оптовый склад Дербент`, `Мурад И.`, `Менеджер смены`, `Кладовщик 1`.
- Второй `web fix pack` закрывает presentation issues, которые остались по live-скринам:
  - audit rows показывают human-readable действия/сущности и короткую сводку payload;
  - raw JSON в audit теперь вторичен и раскрывается по `Показать JSON`;
  - export cards уменьшают визуальный вес технических имен файлов, оставляя в фокусе смысл выгрузки.

- `apps/web` теперь хранит owner/manager session в `localStorage`, поэтому обычный refresh страницы не выбрасывает пользователя из панели; session очищается только при logout или auth expiry.
- Последний web fix pack также разнес action-toolbar и summary badges по owner-экранам (`products`, `movements`, `inventory`, `reporting`) и устранил auto-open баг create-модалок товаров/категорий.
- Полный локальный quality gate проекта подтвержден в реальном окружении; прежние локальные ошибки `apps/api test:contract` были вызваны sandbox-блокировкой `localhost:5432`, а не регрессией приложения.
- Reporting/export layout дополнительно уплотнен: daily summary chips и filter context больше не тянут лишнюю ширину и не разрывают секции пустым воздухом.
- Следующий `web` spacing pass дополнительно уплотняет `ReportingView`, stock report и `AuditView`: контекстные блоки собираются в компактные `info-strip`, активные фильтры ближе к форме, а summary chips не висят в широких пустых полосах.
- `ProductModal` также усилен визуально: labels полей теперь заметнее placeholders, поэтому создание товара считывается как нормальная форма, а не как набор безымянных инпутов.

- `web` reporting/export and audit layout tightened: context/filter blocks are now compact and left-aligned, and the product modal uses explicit field labels instead of ambiguous numeric placeholders.

- `web` reporting/export sections are now denser and easier to scan, and the product modal uses labeled fields instead of bare numeric/default-looking inputs.

- Web admin получил более плотный reporting/audit layout: summary badges теперь не расползаются, stock-report и audit filters читаются компактнее.
- `apps/web`: compacted header/reporting layout again; `MovementsView` summary no longer mixes stock totals into the action row, and reporting/stock contexts now sit closer to their filters and summaries.
- Web admin spacing refined again: reporting and audit contexts now use compact badge rows, and modal forms expose clearer field affordances.
