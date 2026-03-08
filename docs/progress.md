# NexusSklad Progress

Дата обновления: 4 марта 2026
Статус: backend MVP, mobile shell and web admin shell in progress

## Завершено

0. Закрыт первый production-hardening пакет:
   - dev auth fallback в API теперь запрещен вне `development`
   - mobile auth session переведена на secure storage
   - offline queues ставят write-операции в очередь только при сетевых ошибках
   - backend contract/smoke checks и mobile analyze/tests снова зеленые после hardening
0.1. Добавлен fail-fast guard для API startup:
   - non-development окружение теперь не запустится, если в env оставлены `DEFAULT_*` переменные dev fallback
0.2. Запущен первый UI smoke workflow на staging:
   - создан session report `docs/ui-smoke-session-20260304-0104.md`
   - создан fix pack `docs/ui-fix-pack-20260304-0104.md`
   - automated staging baseline для owner/manager/staff подтвержден
0.3. Закрыт второй production-hardening пакет:
   - non-development API отвергает placeholder и weak JWT secrets
   - staging/prod-like переведены с example env на реальные server-side `.env.staging` / `.env.production`
   - staging happy-path и production-like smoke повторно подтверждены после выката
0.4. Добавлен deploy/runtime env validation слой:
   - `infra/deploy/validate_runtime_env.sh` проверяет обязательные переменные, длину и placeholder-значения
   - `deploy_staging.sh`, `deploy_production.sh`, `backup_postgres.sh`, `restore_postgres.sh` теперь валидируют runtime env перед выполнением
0.5. Выполнена ротация server-side Postgres runtime passwords для staging/prod-like:
   - `.env.staging` и `.env.production` на сервере обновлены
   - staging happy-path и production-like smoke подтверждены после ротации
0.6. Добавлен безопасный server sync workflow:
   - `infra/deploy/sync_server.sh` синхронизирует проект на сервер
   - sync намеренно сохраняет server-only `.env.staging`, `.env.production` и `infra/deploy/backups/`
0.7. Усилен backup/restore слой:
   - `backup_postgres.sh` пишет сжатый backup и checksum
   - `restore_postgres.sh` умеет читать `.sql.gz` и проверять `.sha256`
   - добавлены `verify_backup.sh` и `prune_backups.sh`
0.8. Добавлен container log retention:
   - staging/prod-like compose используют `json-file` logging с ограничением размера и числа файлов
   - runtime env validation теперь проверяет `NEXUSSKLAD_LOG_MAX_SIZE` и `NEXUSSKLAD_LOG_MAX_FILES`
0.9. Добавлен monitoring baseline:
   - `monitor_snapshot.sh` показывает runtime state контейнеров и endpoint health
   - `monitor_check.sh` дает fail-fast health check для staging/prod-like
0.10. Добавлен cron-ready ops pack:
   - `ops_daily.sh` объединяет backup, prune и health-check
   - `ops_crontab.example` фиксирует базовый cron-профиль
   - `install_ops_cron.sh` ставит managed cron block
0.11. NexusSklad cron jobs установлены на сервере:
   - managed cron block подтвержден
   - installer проверен на idempotency
0.12. Усилен owner reporting/audit UX в `apps/web`:
   - export filenames теперь учитывают текущий report/audit контекст
   - reporting screen показывает активные фильтры для stock/audit export
   - audit screen показывает summary badges и явный reset filters
   - web checks `test:contract`, `test:recovery`, `test:render`, `build` повторно подтверждены
0.13. Усилен inventory/reporting UX в `apps/web`:
   - `InventoryView` теперь явно показывает состояние сессий за день и CTA на запуск первой сессии
   - stock report показывает активный filter context и явный reset filters
   - web render/contract/recovery/build checks повторно подтверждены
0.14. Усилен team/company owner UX в `apps/web`:
   - `TeamView` показывает summary badges по команде, ролям и неактивным пользователям
   - `CompanyPanel` показывает completeness badges и дату создания компании
   - web render/contract/recovery/build checks повторно подтверждены
0.15. Усилен products/movements operator UX в `apps/web`:
   - `ProductsView` показывает summary badges по low stock и товарам без категории
   - `MovementsView` показывает summary badges по типам операций
   - web render/contract/recovery/build checks повторно подтверждены
0.16. Усилен modal/forms UX в `apps/web`:
   - `ProductModal`, `MovementModal`, `CompanyModal`, `InviteModal`, `UserModal`, `CategoryModal` получили явные helper texts
   - submit CTA в modal forms стали точнее и ближе к реальному действию
   - web render/contract/recovery/build checks повторно подтверждены
0.17. Усилен reporting insights UX в `apps/web`:
   - `ReportingView` показывает daily summary badges по операциям и инвентаризации
   - export center теперь лучше связывает выгрузки с daily report контекстом
   - web render/contract/recovery/build checks повторно подтверждены
0.10. Добавлен cron-ready ops pack:
   - `ops_daily.sh` объединяет backup, prune и health-check
   - `ops_crontab.example` фиксирует базовый cron-профиль для staging и production-like
0.7. Усилен backup/restore слой:
   - `backup_postgres.sh` теперь пишет сжатый backup и checksum
   - `restore_postgres.sh` умеет читать `.sql.gz` и проверять `.sha256`
   - добавлен `verify_backup.sh`

1. Зафиксированы продуктовые документы:
   - `prd.md`
   - `user_flows.md`
   - `database_schema.md`
2. Подготовлена архитектура монорепо:
   - `apps/api`
   - `apps/mobile`
   - `apps/web`
   - `packages/shared`
   - `packages/ui`
3. Поднят backend-каркас на `Fastify + TypeScript + Prisma`.
4. Поднят локальный `PostgreSQL` workflow через `docker compose`.
5. Создана первая миграция Prisma и dev seed.
6. Реализована первая рабочая вертикаль:
   - категории: `list/get/create/update/delete`
   - товары: `list/get/create/update/delete`
7. Реализован модуль движений склада:
   - приход
   - расход
   - корректировка остатка
   - защита от отрицательного остатка
   - audit log на операции движения
8. Добавлен `audit log` на create/update/delete категорий и товаров.
9. Реализован базовый `auth`-контур:
   - owner login
   - refresh
   - `me`
   - access token user context
10. Реализован `inventory`-контур:
   - старт сессии
   - обновление фактического количества по позиции
   - завершение с созданием `INVENTORY_DIFF`
   - защита от завершения по устаревшему snapshot остатков
11. Реализован `reports`-контур:
   - daily report
   - stock report
   - фильтры по дате, категории, поиску и low-stock
12. Добавлены `role guards` для `owner / manager / staff`.
13. Реализован `company/users management`:
   - просмотр и обновление компании
   - список пользователей компании
   - создание manager/staff
   - редактирование manager/staff
14. Реализована `refresh/logout policy`:
   - versioned refresh tokens
   - logout invalidates refresh token
   - refresh rejects revoked tokens
15. Реализован `register/invite flow`:
   - регистрация новой компании и owner
   - invite для `manager/staff`
   - accept invite с активацией пользователя
16. Поднят `apps/mobile`:
   - Flutter shell
   - базовая навигация
   - dashboard/products/movements/team screens
   - `NEXUSSKLAD_API_BASE_URL` через `dart-define`
17. Проверен Docker-based Flutter workflow:
   - `flutter pub get`
   - `flutter analyze`
18. Подключен первый реальный mobile flow:
   - login
   - `auth/me`
   - dashboard summary из `/v1/reports/daily`
   - logout
19. Подключены mobile экраны:
   - товары из `/v1/products`
   - движения из `/v1/movements`
21. Подключен mobile inventory flow:
   - старт сессии
   - изменение фактического остатка по позиции
   - завершение сессии
22. Подключены mobile screens для company/team:
   - company из `/v1/company`
   - team list из `/v1/users` для owner
   - invite flow из `/v1/users/invite`
23. Flutter analyze для mobile после интеграции inventory/team screens проходит без ошибок.
24. Smoke-тест API пройден через `Fastify.inject()`.
25. Создан `packages/shared` как единый слой контрактов:
   - common response envelopes
   - auth/company/users/categories/products/movements/inventory/reports DTOs
26. Базовая проверка `packages/shared` через `node --import tsx` проходит.
27. В mobile реализованы операции движений:
   - `income`
   - `expense`
   - `adjustment` для `owner/manager`
28. Flutter analyze после интеграции movement CRUD проходит без ошибок.
29. В mobile реализован product management:
   - создание товара
   - редактирование товара
   - выбор категории
   - стартовый остаток на create
30. Flutter analyze после интеграции product CRUD проходит без ошибок.
31. В mobile реализован company/users management:
   - редактирование компании
   - редактирование сотрудника
   - смена роли
   - активация/деактивация
   - смена пароля сотрудника
32. Flutter analyze после интеграции company/users management проходит без ошибок.
33. Backend `apps/api` привязан к `packages/shared` на уровне route typing:
   - request DTOs
   - response envelopes
   - auth/company/categories/products/movements/inventory/users/reports routes
34. `npm run check` в `nexussklad/apps/api` проходит после интеграции shared contracts.
35. Добавлен `nexussklad/apps/api/src/lib/dto-mappers.ts`:
   - сериализация `Date -> ISO string`
   - сериализация `Decimal -> string`
   - маппинг company/category/product/movement/inventory/user/report DTO
36. Backend routes переведены с raw Prisma payload на явные shared DTO responses.
37. `npm run check` в `nexussklad/apps/api` проходит после DTO mapping.
38. Добавлен `nexussklad/docs/openapi_v1.yaml` с первым repository-tracked OpenAPI export:
   - auth
   - company
   - users
   - categories
   - products
   - movements
   - inventory
   - reports
39. Добавлен `nexussklad/docs/codegen_workflow.md` с планом генерации клиентов.
40. `docs/openapi_v1.yaml` проходит парсинг через `ruby YAML.load_file`.
41. `npm run check` в `nexussklad/apps/api` проходит после добавления OpenAPI groundwork.
42. Инициализирован `apps/web` на `React + Vite + TypeScript`.
43. В `apps/web` реализован первый admin shell:
   - login
   - dashboard
   - products create/update
   - movements create
   - company update
   - users update
   - invite flow
44. `npm run check` в `nexussklad/apps/web` проходит.
45. `npm run build` в `nexussklad/apps/web` проходит.
46. В `apps/web` добавлены owner-heavy workflows:
   - category create/update
   - product delete
   - category delete
   - CSV export для products и movements
47. `npm run check` и `npm run build` в `nexussklad/apps/web` проходят после destructive/admin flows.
48. В `packages/shared` подключен реальный codegen через `openapi-typescript`.
49. Сгенерирован файл `nexussklad/packages/shared/src/generated/openapi.ts` из `docs/openapi_v1.yaml`.
50. `npm run codegen:openapi` и `npm run check` в `nexussklad/packages/shared` проходят.
51. `apps/web` начал использовать generated OpenAPI types:
   - auth
   - dashboard
   - products
   - team
   - movements
52. `npm run check` и `npm run build` в `nexussklad/apps/web` проходят после перевода на generated transport types.
53. `apps/api` переведен с hand-written transport typing на generated OpenAPI schema types:
   - auth
   - company
   - users
   - categories
   - products
   - movements
   - inventory
   - reports
54. `npm run check` в `nexussklad/apps/api` проходит после перевода routes на generated OpenAPI types.
55. В `apps/mobile` добавлен transport contract layer:
   - `core/network/api_contract.dart`
   - `core/network/json_reader.dart`
   - проверка `module/action/report` для response envelopes
   - централизованный парсинг `item/list/report` ответов
56. Mobile repositories и локальные модели переведены с ad-hoc JSON parsing на централизованный contract-driven parsing:
   - auth
   - dashboard
   - categories
   - products
   - movements
   - inventory
   - company
   - users
57. `flutter analyze` в `nexussklad/apps/mobile` проходит после интеграции transport typing.
58. Добавлен backend-модуль `audit`:
   - `GET /v1/audit`
   - фильтры `userId/entityType/action/limit`
   - owner-only доступ
59. OpenAPI и generated types расширены audit-контуром:
   - `docs/openapi_v1.yaml`
   - `packages/shared/src/generated/openapi.ts`
60. В `apps/web` добавлен owner audit workflow:
   - отдельный экран аудита
   - таблица изменений
   - CSV export для audit logs
61. Проверки проходят:
   - `npm run codegen:openapi && npm run check` в `packages/shared`
   - `npm run check` в `apps/api`
   - `npm run check && npm run build` в `apps/web`
   - smoke test `login -> GET /v1/audit` через `Fastify.inject()`
62. Подготовлен Dart codegen strategy и scaffold для `apps/mobile`:
   - `docs/dart_codegen_strategy.md`
   - `apps/mobile/openapi-generator-config.yaml`
   - `apps/mobile/tool/generate_openapi_client.sh`
   - `apps/mobile/lib/generated/openapi/README.md`
63. Скрипт генерации Dart client подготовлен к использованию:
   - помечен как executable
   - проходит `sh -n`
64. Начат hybrid-adoption transport/domain split в mobile auth flow:
   - `features/auth/data/auth_transport.dart`
   - `features/auth/data/auth_session.dart` теперь domain-only
   - repository маппит transport -> domain явно
65. `flutter analyze` в `nexussklad/apps/mobile` проходит после auth transport split.
66. Продолжен hybrid-adoption transport/domain split в mobile products flow:
   - `features/products/data/product_transport.dart`
   - `product_repository.dart` и `category_repository.dart` маппят transport -> domain явно
67. `flutter analyze` в `nexussklad/apps/mobile` проходит после products transport split.
68. Продолжен hybrid-adoption transport/domain split в mobile movements flow:
   - `features/movements/data/movement_transport.dart`
   - `movement_repository.dart` маппит transport -> domain явно
69. `flutter analyze` в `nexussklad/apps/mobile` проходит после movements transport split.
70. Продолжен hybrid-adoption transport/domain split в mobile inventory flow:
   - `features/inventory/data/inventory_transport.dart`
   - `inventory_repository.dart` маппит transport -> domain явно
71. `flutter analyze` в `nexussklad/apps/mobile` проходит после inventory transport split.
72. Продолжен hybrid-adoption transport/domain split в mobile team/company flow:
   - `features/team/data/team_transport.dart`
   - `company_repository.dart` и `user_repository.dart` маппят transport -> domain явно
73. `flutter analyze` в `nexussklad/apps/mobile` проходит после team/company transport split.
74. Добавлен общий mobile mapping helper:
   - `lib/core/network/transport_mapper.dart`
   - единый helper для `transport -> domain`
75. Mobile repositories переведены на общий mapping helper:
   - auth
   - products
   - movements
   - inventory
   - team/company
76. `flutter analyze` в `nexussklad/apps/mobile` проходит после вынесения общего mapping слоя.
77. Запущен реальный Dart OpenAPI generation:
   - `apps/mobile/lib/generated/openapi/` теперь содержит generated package
   - `dart-dio` используется как generator
78. Для generated Dart package добавлен post-process workflow:
   - SDK constraint исправляется на `^3.8.0`
   - из `default_api.dart` убирается лишний import
79. В `apps/mobile` auth flow переведен на first-class generated transport types:
   - `auth_transport.dart` теперь опирается на `nexussklad_openapi_client`
   - `AuthSession` и `MobileUser` маппятся из generated моделей
80. Генерация и сборка проходят:
   - `./tool/generate_openapi_client.sh`
   - `dart run build_runner build --delete-conflicting-outputs` в generated package
   - `flutter analyze` в `nexussklad/apps/mobile`
81. В `apps/mobile` products flow переведен на first-class generated transport types:
   - `product_transport.dart` теперь опирается на `nexussklad_openapi_client`
   - `ProductRepository` и `CategoryRepository` используют generated `Product`, `Category`, `CreateProductRequest`, `UpdateProductRequest`
82. `flutter analyze` в `nexussklad/apps/mobile` проходит после перевода products/categories на generated transport types.
83. В `apps/mobile` movements flow переведен на first-class generated transport types:
   - `movement_transport.dart` теперь опирается на `nexussklad_openapi_client`
   - `MovementRepository` использует generated `StockMovement`, `CreateMovementRequest`, `CreateAdjustmentRequest`
84. `flutter analyze` в `nexussklad/apps/mobile` проходит после перевода movements на generated transport types.
85. В `apps/mobile` inventory flow переведен на first-class generated transport types:
   - `inventory_transport.dart` теперь опирается на `nexussklad_openapi_client`
   - `InventoryRepository` использует generated `InventorySession`, `InventoryItem`, `StartInventoryRequest`, `UpdateInventoryItemRequest`, `FinishInventoryRequest`
86. `flutter analyze` в `nexussklad/apps/mobile` проходит после перевода inventory на generated transport types.
87. В `apps/mobile` team/company flow переведен на first-class generated transport types:
   - `team_transport.dart` теперь опирается на `nexussklad_openapi_client`
   - `CompanyRepository` и `UserRepository` используют generated `Company`, `CompanyUser`, `InviteUserResponse`, `UpdateCompanyRequest`, `InviteUserRequest`, `UpdateUserRequest`
88. `flutter analyze` в `nexussklad/apps/mobile` проходит после перевода team/company на generated transport types.
89. Убран лишний proxy transport слой в `apps/mobile`:
   - repositories и domain-модели теперь импортируют generated Dart types напрямую
   - удалены `auth_transport.dart`, `product_transport.dart`, `movement_transport.dart`, `inventory_transport.dart`, `team_transport.dart`
90. `flutter analyze` в `nexussklad/apps/mobile` проходит после упрощения mobile data-слоя и удаления transport proxy файлов.
91. Зафиксирована policy проекта:
   - destructive flows (`delete`) остаются в `apps/web`
   - mobile остается рабочим операционным контуром без destructive действий
92. В `apps/web` добавлен inventory/reporting owner workflow:
   - новый view `Инвентаризация`
   - запуск сессии инвентаризации
   - открытие сессии по daily report
   - обновление фактических остатков по позициям
   - завершение сессии
   - stock report table и CSV export
93. `npm run check` и `npm run build` в `nexussklad/apps/web` проходят после расширения admin shell.
94. В `apps/web` добавлены owner reporting controls:
   - date filter для daily report
   - filters для stock report (`search`, `category`, `lowOnly`)
   - filters для audit (`user`, `entityType`, `action`)
95. `npm run check` и `npm run build` в `nexussklad/apps/web` проходят после добавления reporting filters.
96. Подготовлен staging/deploy контур для `nexussklad`:
   - `apps/api/Dockerfile`
   - `apps/web/Dockerfile`
   - `apps/web/nginx.conf`
   - `infra/deploy/docker-compose.staging.yml`
   - `infra/deploy/.env.staging.example`
   - `infra/deploy/README.md`
97. Для staging выбран single-origin подход:
   - `web` отдается через nginx
   - `/v1/*` и `/health` проксируются в `api`
   - staging web shell не зависит от CORS
98. Исправлен runtime start path у API:
   - `npm run start` теперь запускает `dist/apps/api/src/server.js`
99. `docker compose --env-file .env.staging.example -f docker-compose.staging.yml config` проходит в `nexussklad/infra/deploy`.
100. Локальный staging stack впервые поднят успешно:
   - `postgres`
   - `api`
   - `web`
101. Проверки локального staging:
   - `HEAD /` через `http://127.0.0.1:8080` -> `200 OK`
   - `HEAD /health` через nginx -> `200 OK`
   - контейнеры `nexussklad-postgres-staging`, `nexussklad-api-staging`, `nexussklad-web-staging` в статусе `Up`
102. Локальный staging DB засидирован demo users:
   - выполнен `docker compose ... exec -T api npm run prisma:seed`
   - `POST /v1/auth/login` для `owner@nexussklad.local / demo-owner-123` возвращает `200`
103. В `apps/web` добавлен отдельный reporting/export view:
   - новый раздел `Экспорт и отчеты`
   - централизованные экспорты для products, movements, stock report и audit
   - export center без вынесения в отдельное приложение
104. `npm run check` и `npm run build` в `nexussklad/apps/web` проходят после добавления reporting/export view.
105. Внешний staging для `nexussklad` поднят на сервере:
   - код залит в `/root/nexussklad`
   - stack поднят через `infra/deploy/docker-compose.staging.yml`
   - внешний web доступен на `http://85.239.56.248:8080`
106. Проверки внешнего staging:
   - `HEAD /` -> `200 OK`
   - `HEAD /health` -> `200 OK`
   - `POST /v1/auth/login` для `owner@nexussklad.local / demo-owner-123` -> `200`
107. Подготовлен production hardening pack:
   - `infra/deploy/docker-compose.production.yml`
   - `infra/deploy/.env.production.example`
   - `infra/deploy/deploy_production.sh`
   - `infra/deploy/backup_postgres.sh`
   - `infra/deploy/restore_postgres.sh`
   - `infra/deploy/smoke_check.sh`
   - `infra/deploy/PRODUCTION_RUNBOOK.md`
108. Проверки production deploy артефактов:
   - `sh -n` проходит для deploy/backup/restore/smoke scripts
   - `docker compose --env-file .env.production.example -f docker-compose.production.yml config` проходит
109. Исправлен operational issue в deploy:
   - staging и production compose теперь имеют разные `name`
   - это позволяет держать оба контура одновременно без compose namespace conflict
110. На сервере восстановлена параллельная работа двух внешних контуров:
   - staging: `http://85.239.56.248:8080`
   - production-like: `http://85.239.56.248:8081`
111. Проверки после fixes:
   - `HEAD /` и `HEAD /health` проходят на `8080` и `8081`
   - staging login для `owner@nexussklad.local / demo-owner-123` снова проходит на `8080`
112. Подготовлен domain/HTTPS groundwork для `NexusSklad`:
   - добавлены host-nginx templates для staging и production
   - добавлен `render_nginx_site.sh`
   - добавлен `DOMAIN_CUTOVER_RUNBOOK.md`
   - добавлен `.env.domains.example`
113. Проверено состояние сервера для cutover:
   - host `nginx` установлен
   - в `sites-available` уже есть `default` и `optpuls`
   - `certbot` на сервере пока не установлен
114. В `apps/mobile` добавлен базовый offline-ready слой для read flows:
   - сохранение auth session в secure storage
   - bootstrap с восстановлением локальной сессии
   - fallback на локальный cache для dashboard, categories, products, movements, company и users
115. Проверки offline-ready mobile слоя:
   - добавлен secure storage слой для auth session
   - `flutter pub get && flutter analyze` проходят без ошибок
116. В `apps/mobile` добавлена базовая offline write-queue для movements:
   - локальная очередь `income` / `expense` / `adjustment`
   - ручной retry/sync при обновлении экрана движений
   - индикатор pending queue в UI
117. Проверки movement offline queue:
   - `flutter pub get && flutter analyze` проходят после добавления queue store
118. В `apps/mobile` добавлен offline write-sync scope для inventory item updates:
   - локальная очередь изменений фактических остатков
   - ручной sync/retry на экране инвентаризации
   - блокировка завершения инвентаризации, пока queue не синхронизирована
119. Проверки inventory offline queue:
   - `flutter pub get && flutter analyze` проходят после добавления inventory queue store
120. В `apps/mobile` добавлен offline write-sync scope для company update:
   - singleton queue для обновления компании
   - retry/sync через экран команды
   - локальное обновление `companyName` в auth session после queued/update flows
121. Проверки company offline queue:
   - `flutter pub get && flutter analyze` проходят после добавления company queue store
122. В `apps/mobile` добавлен offline write-sync scope для product update:
   - queue по `productId` для offline update операций
   - pending updates накладываются поверх product list при чтении
   - retry/sync идет при обновлении экрана товаров
123. Проверки product update offline queue:
   - `flutter pub get && flutter analyze` проходят после добавления product queue store
124. В `apps/mobile` добавлен offline write-sync scope для user update:
   - queue по `userId` для offline update операций
   - pending updates накладываются поверх team list при чтении
   - retry/sync идет при обновлении экрана команды
125. Проверки user update offline queue:
   - `flutter pub get && flutter analyze` проходят после добавления user queue store
126. В `apps/mobile` добавлен базовый conflict handling для offline sync:
   - `ApiException` теперь знает backend `error.code`
   - добавлен `core/network/offline_sync_issue.dart`
   - sync layers различают auth/conflict/validation/server blockers
   - product и user queues продолжают синхронизацию после конфликтных элементов, не блокируя остальные
127. UI mobile теперь показывает conflict-aware sync state:
   - friendly conflict messages на экранах товаров и движений
   - команда продолжает показывать pending/offline state для company и users
128. Проверки conflict handling:
   - `flutter pub get && flutter analyze` проходят после интеграции conflict policy
129. В `apps/mobile` добавлен manual resolution/clear flow для queued conflicts:
   - можно очистить конфликтную очередь товаров
   - можно очистить конфликтную очередь движений
   - можно очистить конфликтную очередь инвентаризации
   - можно очистить очередь компании и сотрудников из экрана команды
130. Проверки manual clear flow:
   - `flutter pub get && flutter analyze` проходят после добавления clear/discard действий
131. В `apps/mobile` добавлен granular retry/discard flow для queued conflicts:
   - товары умеют `retry/discard` по отдельному pending item
   - сотрудники умеют `retry/discard` по отдельному pending item
   - очереди показывают item-level элементы с меткой времени
132. Проверки granular retry/discard flow:
   - `flutter pub get && flutter analyze` проходят после добавления per-item действий
133. В `apps/mobile` добавлен первый reconciliation flow для offline-created entities:
   - `product create` теперь может уходить в offline queue
   - pending create показывается в каталоге как `queued create`
   - create queue поддерживает `retry/discard`
134. Проверки offline-created product reconciliation:
   - `flutter pub get && flutter analyze` проходят после добавления create queue
135. Улучшен mobile UX для pending queues:
   - `products` показывает pending creates/updates не только при конфликте, а как нормальный рабочий блок
   - `team` показывает pending user updates не только при конфликте, а как нормальный рабочий блок
136. Проверки always-visible pending UX:
   - `flutter pub get && flutter analyze` проходят после обновления экранов `products` и `team`
137. В `apps/mobile` добавлен offline queue для `inventory start`:
   - старт инвентаризации можно отложить при недоступной сети
   - pending start показывается отдельным блоком
   - pending start поддерживает `retry/discard`
138. Проверки inventory start queue:
   - `flutter pub get && flutter analyze` проходят после добавления pending start flow
139. В `apps/mobile` добавлен offline queue для `category create`:
   - создание категории можно отложить при недоступной сети
   - pending category create показывается в экране товаров
   - pending category create поддерживает `retry/discard`
140. Проверки category create queue:
   - `flutter pub get && flutter analyze` проходят после добавления pending category flow
141. В `apps/mobile` добавлен offline queue для `user invite/create`:
   - приглашение сотрудника можно отложить при недоступной сети
   - pending invite показывается на экране команды
   - pending invite поддерживает `retry/discard`
142. Проверки user invite queue:
   - `flutter pub get && flutter analyze` проходят после добавления pending invite flow
143. Усилен deploy smoke tooling:
   - `infra/deploy/smoke_check.sh` теперь поддерживает `skip-login`
   - это позволяет валидировать production-like контур без demo seed
144. Внешние operational проверки пройдены:
   - `http://85.239.56.248:8080` отвечает `200 OK`
   - `http://85.239.56.248:8080/health` отвечает `200 OK`
   - staging login с demo owner проходит
   - `http://85.239.56.248:8081` отвечает `200 OK`
   - `http://85.239.56.248:8081/health` отвечает `200 OK`
   - production-like smoke проходит в режиме `skip-login`
145. В `apps/mobile` offline invite flow доведен до операционного состояния:
   - invite уходит в pending queue при недоступной сети
   - pending invite показывается на экране команды как отдельный блок
   - pending invite поддерживает `retry/discard`
146. Проверки pending invite flow:
   - `flutter pub get && flutter analyze` проходят после доработки `team` data/UI слоя
147. В `apps/api` добавлен automated smoke/integration test layer:
   - `apps/api/src/test/api-smoke.test.ts`
   - сценарии покрывают `auth`, `invite/accept`, `products`, `movements`, `inventory`, `reports`, `audit`
148. В `apps/api/package.json` добавлен `npm run test:smoke`.
149. Backend smoke checks проходят локально:
   - `npm run check`
   - `npm run test:smoke`
   - дополнительно валидируются role guards, refresh/logout invalidation и stock guard
150. В `apps/web` усилены empty/error states:
   - глобальный retry на уровне admin shell
   - явные empty states для `products`, `categories`, `movements`, `stock report`, `team`, `audit`, `export center`
151. В `apps/mobile` усилены UX-состояния:
   - `dashboard` получил pull-to-refresh и пустое daily summary состояние
   - `movements` получил action-oriented empty state с быстрым приходом
152. Проверки UI-hardening проходят:
   - `npm run check && npm run build` в `apps/web`
   - `flutter pub get && flutter analyze` в `apps/mobile`
153. Добавлен UI smoke checklist:
   - `docs/ui_smoke_checklist.md`
   - покрывает `owner`, `manager`, `staff`, empty/error states и offline visibility checks
154. Добавлен server-side staging happy-path script:
   - `infra/deploy/staging_happy_path_check.sh`
   - валидирует `owner` и `manager` login, `auth/me`, `products`, `movements`, `reports`, `users`, `audit`
155. IP-only rollout checks актуализированы:
   - `8080` и `8081` отвечают `200 OK`
   - staging login подтвержден для `owner` и `manager`
156. `staging_happy_path_check.sh` расширен до role matrix checks:
   - `staff` login
   - `staff` запрет на `reports`, `users`, `audit`, `adjustment`
157. Server-side staging role matrix check проходит на сервере:
   - `./staging_happy_path_check.sh http://127.0.0.1:8080`
   - owner/manager/staff access matrix подтверждена
158. Добавлен staging baseline reset script:
   - `infra/deploy/reset_staging_demo.sh`
   - пересоздает staging volume и заново сидирует demo baseline
159. Добавлен шаблон отчета по ручному UI-прогону:
   - `docs/ui_smoke_report_template.md`
   - можно фиксировать найденные UX/logic gaps в одном формате
160. Добавлен preflight script для ручного UI smoke pass:
   - `infra/deploy/prepare_ui_smoke_pass.sh`
   - сначала прогоняет automated staging checks, затем подсказывает manual next steps
161. Добавлен baseline-отчет для текущего UI smoke pass:
   - `docs/ui_smoke_report_latest.md`
   - automated часть уже заполнена и отмечена как green
162. `prepare_ui_smoke_pass.sh` проверен на сервере:
   - `./prepare_ui_smoke_pass.sh http://127.0.0.1:8080`
   - preflight проходит успешно
163. Добавлен reproducible session starter для ручного прогона:
   - `infra/deploy/start_ui_smoke_session.sh`
   - создает timestamped session report из baseline
164. Добавлен triage guide для UI gaps:
   - `docs/ui_gap_triage.md`
   - задает `S1/S2/S3` и порядок фиксов
165. `start_ui_smoke_session.sh` проверен на сервере:
   - создает session report в `docs/ui-smoke-session-*.md`
166. Добавлен fix-pack workflow для UI findings:
   - `infra/deploy/create_ui_fix_pack.sh`
   - `docs/ui_fix_pack_template.md`
167. `create_ui_fix_pack.sh` проверен локально:
   - создает `docs/ui-fix-pack-*.md` из текущего session/baseline report
168. Добавлен orchestrated QA workflow script:
   - `infra/deploy/run_ui_smoke_workflow.sh`
   - при необходимости делает reset, затем стартует session report и fix pack
169. В `apps/web` добавлен render smoke test layer:
   - `npm run test:render`
   - покрывает critical empty-state UI для `products`, `movements`, `team`, `audit`, `reporting`
170. Для web node-based tests добавлен `tsx`, а `src/core/config.ts` стал safe вне `vite` runtime.
171. Web quality checks проходят:
   - `npm run check`
   - `npm run test:render`
   - `npm run build`
172. В `apps/mobile` вынесены общие карточки состояний:
   - `lib/core/widgets/state_cards.dart`
   - `EmptyStateCard`, `ErrorStateCard`, `SyncIssueCard`
173. `ProductsScreen` и `MovementsScreen` переведены на shared state cards вместо локальных inline-state реализаций.
174. В `apps/mobile` добавлен widget render smoke test layer:
   - `test/widget/render_smoke_test.dart`
   - покрывает empty, error и sync-conflict состояния
175. Mobile quality checks проходят в Docker на сервере:
   - `flutter analyze`
   - `flutter test test/widget/render_smoke_test.dart`
176. В `apps/mobile` добавлены общие info/pending widgets:
   - `lib/core/widgets/info_cards.dart`
   - `InfoMessageCard`, `PendingActionCard`
177. `DashboardScreen`, `InventoryScreen` и `TeamScreen` переведены на shared info/pending widgets.
178. Mobile widget smoke tests расширены:
   - покрывают `InfoMessageCard`
   - покрывают `PendingActionCard`
   - итоговый render smoke suite: `6 tests passed`
179. В `apps/mobile` добавлены domain-specific state widgets:
   - `lib/core/widgets/domain_state_cards.dart`
   - `DashboardNoActivityCard`, `EmptyMovementsCard`, `PendingInventoryStartCard`
180. `DashboardScreen`, `MovementsScreen` и `InventoryScreen` переведены на domain-specific state widgets.
181. Mobile render smoke suite расширен до domain-level coverage:
   - теперь валидируются dashboard no-activity, movements empty CTA и pending inventory start
   - текущий результат: `9 tests passed`
182. В `apps/mobile` добавлены domain blocks для `products` и `team`:
   - `ProductPendingOperationsCard`
   - `TeamPendingOperationsCard`
183. `ProductsScreen` и `TeamScreen` переведены на reusable domain blocks вместо inline pending-queue разметки.
184. Mobile render smoke suite расширен до coverage для `products` и `team` pending flows:
   - текущий результат: `11 tests passed`
185. В `apps/mobile` добавлен reusable entity-card слой:
   - `lib/core/widgets/entity_cards.dart`
   - `CompanyStatusCard`, `TeamMemberInfoCard`, `ProductStockCard`
186. `ProductsScreen` и `TeamScreen` переведены на reusable entity cards вместо inline карточек.
187. Mobile render smoke suite расширен до entity-card coverage:
   - company pending state
   - team member queued badge
   - product stock badges
   - текущий результат: `14 tests passed`
188. В `apps/web` добавлены reusable owner workflow blocks:
   - `CompanyPanel`
   - `ProductTableRow`
   - `TeamUserRow`
189. `ProductsView` и `TeamView` переведены на reusable web blocks вместо inline row/panel разметки.
190. Web render smoke suite расширен:
   - company summary block
   - product row block
   - team user row block
   - текущий результат: `8 tests passed`
191. Web quality checks остаются зелеными после рефакторинга:
   - `npm run check`
   - `npm run test:render`
   - `npm run build`
192. В `apps/web` добавлены reusable blocks для `inventory` и `reporting`:
   - `InventorySessionRow`
   - `StockReportRow`
   - `ExportCard` переведен в first-class testable block
193. `InventoryView` переведен на reusable row blocks вместо inline row разметки.
194. Web render smoke suite расширен до `11 tests passed`:
   - inventory session row
   - stock report row
   - export card
195. В `apps/web` добавлены reusable row blocks для:
   - `MovementTableRow`
   - `AuditLogRow`
196. `MovementsView` и `AuditView` переведены на reusable/testable rows вместо inline row разметки.
197. Web render smoke suite расширен до `13 tests passed`:
   - movement row
   - audit log row
198. В `apps/web` modal/forms переведены в first-class testable components:
   - `ModalFrame`
   - `ProductModal`
   - `MovementModal`
   - `CompanyModal`
   - `InviteModal`
   - `UserModal`
   - `CategoryModal`
199. Web render smoke suite расширен до `19 tests passed`:
   - покрыты все основные owner/manager modal/forms
200. В `infra/deploy` добавлен `web_deploy_smoke_check.sh`:
   - проверяет root HTML, Vite asset bundle, `/health`, `auth/login`, `auth/me`
   - поддерживает режим `skip-login` для production-like без demo seed
201. Web deploy smoke добавлен в эксплуатационный контур:
   - staging: `web_deploy_smoke_check.sh http://127.0.0.1:8080`
   - production-like: `web_deploy_smoke_check.sh http://127.0.0.1:8081 skip-login`
202. Добавлен contract integrity gate:
   - `packages/shared/check_openapi_codegen.sh` валидирует, что `src/generated/openapi.ts` синхронизирован с `docs/openapi_v1.yaml`
   - корневой `check_contract_integrity.sh` прогоняет:
     - `npm run codegen:openapi:check`
     - `apps/api -> npm run check`
     - `apps/web -> npm run check && npm run build`
203. В `apps/web` добавлен contract-aware API client слой:
   - `readModuleContract`
   - `readItemEnvelope`
   - `readListEnvelope`
   - `readReportEnvelope`
   - `toApiError`
204. `apps/web` переведен на runtime-проверку response envelopes для:
   - `products`
   - `categories`
   - `movements`
   - `inventory`
   - `company`
   - `users`
   - `reports`
   - `audit`
205. В `apps/web` добавлен `npm run test:contract`:
   - валидирует parsing error envelope
   - валидирует module/report mismatch detection
   - текущий результат: `6 tests passed`
206. В `apps/mobile` добавлен contract hardening для network слоя:
   - `ApiContractException` для runtime envelope mismatch
   - `parseApiError(...)` для централизованного parsing backend error envelope
207. В `apps/mobile` добавлен `test/network/api_contract_test.dart`:
   - покрывает `item/list/report` guards
   - покрывает `auth` и `invite` action guards
   - покрывает backend error envelope parsing
   - текущий результат: `7 tests passed`
208. В `apps/api` добавлен `npm run test:contract`:
   - проверяет `health` contract
   - проверяет `item/list/report` envelopes для core модулей
   - проверяет error envelope для `AppError` и `404`
209. В `apps/api` добавлен стабильный not-found contract:
   - `404` теперь возвращает `{ error: { code: "NOT_FOUND", message: "Route not found" } }`
210. API contract checks проходят локально:
   - `npm run check`
   - `npm run test:contract`
   - `npm run test:smoke`
211. `docs/openapi_v1.yaml` усилен shared error response components:
   - `UnauthorizedError`
   - `ForbiddenError`
   - `NotFoundError`
   - `ConflictError`
   - `InternalServerError`
212. OpenAPI now explicitly documents error responses for core routes:
   - `auth`
   - `company/users`
   - `categories/products`
   - `movements`
   - `inventory`
   - `reports`
   - `audit`
213. После обновления OpenAPI regenerated:
   - `packages/shared/src/generated/openapi.ts`
   - `npm run codegen:openapi:check` — ok
   - `./check_contract_integrity.sh` — ok
214. В `apps/api` добавлен route schema hardening на уровне Fastify `schema.response`.
215. Response envelopes теперь сериализационно зафиксированы для:
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
216. Для route-level hardening добавлен `apps/api/src/lib/response-schemas.ts`:
   - `itemEnvelopeSchema`
   - `listEnvelopeSchema`
   - `reportEnvelopeSchema`
   - `authSessionSchema`
   - `authMeSchema`
   - `inviteResponseSchema`
   - shared error response schemas
217. API checks после route schema hardening проходят:
   - `npm run test:contract`
   - `npm run test:smoke`
218. Validation errors в API нормализованы в stable envelope:
   - status: `400`
   - code: `VALIDATION_ERROR`
219. `apps/api/src/test/api-contract.test.ts` расширен validation-сценариями:
   - invalid auth body
   - invalid products query
   - invalid inventory path params
220. API contract checks после validation hardening проходят:
   - `npm run test:contract`
   - `npm run test:smoke`
147. В `apps/api` добавлен automated smoke/integration test layer:
   - `apps/api/src/test/api-smoke.test.ts`
   - сценарии покрывают `auth`, `invite/accept`, `products`, `movements`, `inventory`, `reports`, `audit`
148. В `apps/api/package.json` добавлен `npm run test:smoke`.
149. Backend smoke checks проходят локально:
   - `npm run check`
   - `npm run test:smoke`
   - дополнительно валидируются role guards, refresh/logout invalidation и stock guard

## Текущее состояние API

- `GET /health`
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
- `POST /v1/auth/register`
- `POST /v1/auth/login`
- `POST /v1/auth/refresh`
- `POST /v1/auth/logout`
- `POST /v1/auth/accept-invite`
- `GET /v1/auth/me`
- `GET /v1/company`
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

## Что дальше

1. Следующий технический шаг: выбрать, продолжаем ли продуктовую разработку `web/admin` и backend checks, или фиксируем IP-only rollout checklist.
2. Если rollout важнее — делаем финальный IP-based rollout checklist без домена.
3. Для `web/mobile` уже зафиксированы user-facing сообщения для `VALIDATION_ERROR`, `FORBIDDEN`, `AUTH_*`, `INSUFFICIENT_STOCK`, `INVENTORY_*` и общих `404/409`.
4. Внешние `staging` и `production-like` web-контуры пересобраны; `8081` дополнительно восстановлен после рассинхронизации пароля Postgres в prod-like stack.
5. `web/mobile` теперь переводят пользователя на экран входа при `401/AUTH_*`, а не оставляют его в сломанной сессии.
6. `web` теперь сначала пытается сделать silent refresh по `refreshToken` и повторить действие; forced sign-out остается только если refresh не удался.
7. `mobile` получил recovery flow для read-heavy экранов: при `401/AUTH_*` сначала идет попытка refresh, затем reload экрана, и только потом forced sign-out.
8. `mobile` write-actions теперь тоже делают один controlled retry после успешного refresh и не теряют уже введенный payload.
9. `web/mobile` теперь показывают более явные auth notices: отдельно для `session restored` и для `session expired`.
10. Обновленный `web` с auth-notice flow выкачен на внешние `8080/8081`; deploy smoke прошел на обоих контурах, live asset: `/assets/index-DxVwnrtk.js`.
11. В `apps/web` добавлен targeted render-smoke test для `LoginForm`, который фиксирует `notice/error` auth states.
12. В `apps/mobile` `AuthController` отвязан от concrete `AuthRepository` через `AuthGateway`; добавлен unit-test слой для `tryRefreshSession`, `recoverSession`, `expireSession`.
13. `web` quality gate после этого шага зеленый: `test:contract` — `8 passed`, `test:render` — `20 passed`, `build` — ok.
14. Generated Dart OpenAPI client перенесен из `apps/mobile/lib/generated/openapi` в `apps/mobile/generated/openapi_client`; это убрало конфликт test runtime.
15. `mobile` quality gate снова полностью зеленый: `flutter analyze` — ok, `render_smoke_test + api_contract_test + auth_controller_test` — `26 passed`.
16. `web` получил persistent inline session-notice в signed-in shell; recovery-сообщение теперь видно не только в login/forced-logout flow, но и после silent refresh.
17. `mobile` получил persistent dismissible `AuthNoticeCard` в `AppShell`; recovery notice больше не исчезает сразу после `SnackBar`.
18. После этого `web` quality gate снова зеленый: `test:render` — `21 passed`, `build` — ok.
19. `mobile` quality gate после notice-polish зеленый: `flutter analyze` — ok, `27 tests passed`.
20. `mobile` offline/conflict UX-polish: `SyncIssueCard` получил более явный conflict/offline copy и clearer destructive CTA.
21. `PendingInventoryStartCard`, `ProductPendingOperationsCard`, `TeamPendingOperationsCard` теперь точнее объясняют, что будет с очередью и когда изменения уйдут на сервер.
22. `TeamScreen` переведен на единый `ErrorStateCard` вместо отдельной локальной карточки ошибки.
23. `mobile` quality gate после этого шага остается зеленым: `flutter analyze` — ok, `27 tests passed`.
24. `web` conflict/error copy polish: destructive confirm-диалоги для удаления товара и категории теперь явно предупреждают о необратимости и советуют проверить связанные данные.
25. `InviteModal` теперь показывает не сырой `Invite token`, а понятный recovery block: `Invite готов` + инструкция передать токен сотруднику.
26. `TeamView` для non-owner теперь использует общий `InlineState` вместо plain notice.
27. `web` quality gate после этого шага зеленый: `test:render` — `22 passed`, `build` — ok.
28. Добавлен первый screen-level mobile recovery test: `DashboardScreen` теперь проверяется на сценарий `401 -> refresh -> retry summary reload` без forced logout.
29. Новый тест фиксирует и runtime-состояние recovery notice: после refresh экран показывает актуальную summary, а `AuthController` сохраняет `Сессия восстановлена. Продолжаем работу.`.
30. `mobile` quality gate после этого шага зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `28 passed`.
31. Добавлен второй screen-level mobile recovery test: `ProductsScreen` теперь проверяется на сценарий `401 -> refresh -> retry products reload`.
32. Для этого `ProductsScreen` получил безопасные optional repository overrides, чтобы screen-level recovery можно было тестировать без реального API.
33. `mobile` quality gate после этого шага зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `29 passed`.
34. Добавлен третий screen-level mobile recovery test: `MovementsScreen` теперь проверяется на сценарий `401 -> refresh -> retry movements reload`.
35. `mobile` screen-level recovery теперь покрывает уже три read-heavy экрана: `DashboardScreen`, `ProductsScreen`, `MovementsScreen`.
36. `mobile` quality gate после этого шага зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `30 passed`.
37. Добавлен четвертый screen-level mobile recovery test: `InventoryScreen` теперь проверяется на сценарий `401 -> refresh -> retry start inventory`.
38. `mobile` screen-level recovery теперь покрывает уже четыре экрана: `DashboardScreen`, `ProductsScreen`, `MovementsScreen`, `InventoryScreen`.
39. `mobile` quality gate после этого шага зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `31 passed`.
40. Добавлен пятый screen-level mobile recovery test: `TeamScreen` теперь проверяется на сценарий `401 -> refresh -> retry company reload`.
41. Для этого `TeamScreen` получил optional repository overrides (`companyRepository`, `userRepository`) для тестирования без реального API.
42. `mobile` screen-level recovery теперь покрывает пять экранов: `DashboardScreen`, `ProductsScreen`, `MovementsScreen`, `InventoryScreen`, `TeamScreen`.
43. `mobile` quality gate после этого шага зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `32 passed`.
44. Добавлен первый mobile write-recovery test: `MovementsScreen` теперь проверяется на сценарий `401 -> refresh -> retry create income`.
45. Новый тест фиксирует, что write payload не теряется: после refresh повторно уходит тот же `productId`, `quantity`, `comment`.
46. `mobile` quality gate после этого шага зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `33 passed`.
47. `ProductsScreen` получил test hook `createCategoryNameBuilder`, а `MovementsScreen` — public `MovementDialogAction`/`MovementDialogPayload` и `movementPayloadBuilder`; это убрало flaky dialog-runtime из write-recovery тестов.
48. Добавлен второй mobile write-recovery test: `ProductsScreen` теперь проверяется на сценарий `401 -> refresh -> retry create category`.
49. Теперь mobile write-recovery покрывает два сценария с сохранением payload: `MovementsScreen -> create income` и `ProductsScreen -> create category`.
50. `mobile` quality gate после этого шага снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `34 passed`.
51. `ProductsScreen` получил второй test hook: `createProductPayloadBuilder`. Он нужен для write-recovery теста `create product` без реального `AlertDialog`.
52. Добавлен третий mobile write-recovery test: `ProductsScreen` теперь проверяется на сценарий `401 -> refresh -> retry create product`.
53. Новый тест фиксирует полный payload retry для создания товара: `name`, `unit`, `categoryId`, `sku`, `barcode`, `description`, `minStock`, `currentStock`.
54. Теперь mobile write-recovery покрывает три сценария: `MovementsScreen -> create income`, `ProductsScreen -> create category`, `ProductsScreen -> create product`.
55. `mobile` quality gate после этого шага снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `35 passed`.
56. `InventoryScreen` получил test hook `actualQtyBuilder`, чтобы сценарий изменения фактического остатка можно было тестировать без реального quantity dialog.
57. Добавлен четвертый mobile write-recovery test: `InventoryScreen` теперь проверяется на сценарий `401 -> refresh -> retry patch item`.
58. Новый тест фиксирует retry payload для инвентаризации: повторно уходят те же `inventoryId`, `itemId`, `actualQty`.
59. Во время этого шага обнаружен реальный UI дефект: trailing action в `InventoryScreen` overflow'ил в незавершенной сессии. Исправлено через compact style для `TextButton`.
60. Теперь mobile write-recovery покрывает четыре сценария: `MovementsScreen -> create income`, `ProductsScreen -> create category`, `ProductsScreen -> create product`, `InventoryScreen -> patch item`.
61. `mobile` quality gate после этого шага снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `36 passed`.
62. `TeamScreen` получил test hook `invitePayloadBuilder`, чтобы сценарий invite recovery тестировался без реального invite dialog.
63. Добавлен пятый mobile write-recovery test: `TeamScreen` теперь проверяется на сценарий `401 -> refresh -> retry invite user`.
64. Новый тест фиксирует retry payload для invite flow: повторно уходят те же `email` и `role`.
65. Теперь mobile write-recovery покрывает пять сценариев: `MovementsScreen -> create income`, `ProductsScreen -> create category`, `ProductsScreen -> create product`, `InventoryScreen -> patch item`, `TeamScreen -> invite user`.
66. `mobile` quality gate после этого шага снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `37 passed`.
67. Добавлен шестой mobile write-recovery test: `InventoryScreen` теперь проверяется на сценарий `401 -> refresh -> retry finish inventory`.
68. Новый тест фиксирует retry payload для завершения инвентаризации: повторно уходят тот же `inventoryId`, а после recovery UI переходит в состояние `Сессия завершена.`.
69. `mobile` quality gate после этого шага снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `38 passed`.
70. Добавлен седьмой mobile write-recovery test: `MovementsScreen` теперь проверяется на сценарий `401 -> refresh -> retry create adjustment`.
71. Новый тест фиксирует retry payload для корректировки остатков: повторно уходят те же `productId`, `targetQty`, `comment`, а экран после recovery показывает новую adjustment-запись.
72. `mobile` quality gate после этого шага снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `39 passed`.
73. `ProductsScreen` получил test hook `editProductPayloadBuilder`, чтобы сценарий редактирования товара можно было тестировать без реального product dialog.
74. Добавлен восьмой mobile write-recovery test: `ProductsScreen` теперь проверяется на сценарий `401 -> refresh -> retry update product`.
75. Новый тест фиксирует retry payload для редактирования товара: повторно уходят те же `productId`, `name`, `unit`, `categoryId`, `sku`, `barcode`, `description`, `minStock`; `mobile` quality gate после этого шага снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `40 passed`.
76. Добавлен девятый mobile write-recovery test: `MovementsScreen` теперь проверяется на сценарий `401 -> refresh -> retry create expense`.
77. Новый тест фиксирует retry payload для расхода: повторно уходят те же `productId`, `quantity`, `comment`, а экран после recovery показывает новую expense-запись.
78. `mobile` quality gate после этого шага снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `41 passed`.
79. `InventoryScreen._flushPendingUpdates()` получил auth-recovery retry: при `401/AUTH_*` screen сначала делает `refreshToken`, затем повторяет sync queue один раз и только после неудачи показывает ошибку.
80. Добавлен десятый mobile write-recovery test: `InventoryScreen` теперь проверяется на сценарий `401 -> refresh -> retry sync queue`.
81. Новый тест фиксирует retry payload для ручной синхронизации очереди инвентаризации: повторно уходят тот же `inventoryId`, затем экран запрашивает свежую сессию через `getById`.
82. `mobile` quality gate после этого шага снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `42 passed`.
83. В `apps/web` выделен общий helper `executeSessionAction()` для owner/manager действий с silent refresh и единым retry-path.
84. `App.tsx` переведен на новый helper без изменения UX: при `401/AUTH_*` web по-прежнему сначала пытается `refreshToken`, затем повторяет исходное действие один раз.
85. Добавлен отдельный web recovery suite: `npm run test:recovery` покрывает retry after refresh, refresh failure, forbidden no-retry и fallback message для unknown errors.
86. `web` quality gate после этого шага снова зеленый: `npm run check`, `test:contract`, `test:recovery`, `test:render`, `build` — ok.
87. Для destructive owner actions добавлен отдельный helper `executeConfirmedSessionAction()`: он сначала запрашивает confirm, затем использует общий recovery path через `executeSessionAction()`.
88. `App.tsx` переведен на новый helper для `delete product` и `delete category`, без изменения текущего UX copy и confirm-текстов.
89. `web` recovery suite расширен destructive-сценариями: cancel не запускает удаление, auth-expired delete после refresh повторяется автоматически.
90. `web` quality gate после этого шага снова зеленый: `npm run check`, `test:contract`, `test:recovery`, `test:render`, `build` — ok.
91. Бренд проекта полностью переименован из `Skladly` в `NexusSklad`: обновлены app titles, package names, env vars, demo emails, generated OpenAPI client, deploy templates и пути проекта `skladly/ -> nexussklad/`.
92. После rename прогнаны ключевые проверки:
   - `./check_contract_integrity.sh` — ok
   - `flutter analyze` + `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `42 passed`
93. После rename перегенерирован Dart OpenAPI client `nexussklad_openapi_client`, а post-process script очищен от warning-импортов, чтобы mobile quality gate снова был полностью зеленым.
94. Серверный deploy переведен на новый путь `/root/nexussklad`: старые контейнеры `skladly-*` остановлены, новые `nexussklad-*` подняты для staging и production-like.
95. Внешние контуры после rename снова доступны:
   - staging: `http://85.239.56.248:8080`
   - production-like: `http://85.239.56.248:8081`
96. После серверной миграции deploy smoke снова зеленый:
   - `web_deploy_smoke_check.sh http://127.0.0.1:8080` — ok
   - `web_deploy_smoke_check.sh http://127.0.0.1:8081 skip-login` — ok
97. Верхнеуровневые продуктовые документы тоже приведены к новому бренду по именам файлов:
   - `/Users/muradidrisov/NEXUSSKLAD_PROJECT.md`
   - `/Users/muradidrisov/NEXUSSKLAD_BRANDING.md`
   - `/Users/muradidrisov/NEXUSSKLAD_WIREFRAMES.md`
98. Проведен финальный UI copy pass под `NexusSklad`: полированы web login hero, invite success state, web page title/meta и mobile login copy.
99. После UI copy pass проверки снова зеленые:
   - `apps/web`: `npm run check`, `npm run test:render`, `npm run build` — ok
   - `apps/mobile`: `flutter analyze` — ok
100. После финального copy pass внешний `web` пересобран и снова выкачен на оба контура:
   - staging asset: `/assets/index-UzRcfvw8.js`
   - production-like asset: `/assets/index-UzRcfvw8.js`
101. Повторный deploy smoke после live rebuild снова зеленый:
   - `http://127.0.0.1:8080` — ok
   - `http://127.0.0.1:8081` — ok
102. Добавлен readiness baseline для API: `GET /health/ready` теперь отдельно проверяет доступность БД и отдает `200`/`503` в стабильном контракте.
103. `monitor_check.sh` и `monitor_snapshot.sh` переведены на readiness-aware режим: operational checks теперь валидируют не только root и `/health`, но и `/health/ready`.
104. `smoke_check.sh` и `web_deploy_smoke_check.sh` тоже переведены на readiness-aware режим: deploy smoke теперь валидирует и liveness, и readiness endpoint'ы.
105. Добавлен `readiness_check.sh`: он валидирует не только HTTP `200`, но и JSON-контракт `/health/ready` (`status=ok`, `checks.database=ok`).
106. Добавлен `backup_restore_drill.sh`: он делает backup и восстанавливает его во временную БД внутри postgres-контейнера, не трогая live-данные.
107. Исправлен `web nginx`: `/health/ready` теперь реально проксируется в API, а не падает в SPA shell; deploy smoke переведен на вызов `readiness_check.sh`, чтобы ловить такие ошибки автоматически.
108. Добавлен `ops_weekly.sh`: weekly ops-пакет теперь отдельно запускает readiness contract check и backup/restore drill, без смешивания этого с ежедневным циклом.
109. Добавлен `rotate_ops_logs.sh`: ops/log health файлы теперь ротируются и gzip'ятся отдельным shell-скриптом, без зависимости от system logrotate.
110. Добавлен security baseline: API теперь отдает `X-Content-Type-Options`, `X-Frame-Options`, `Referrer-Policy`, `Cache-Control`, а web nginx — CSP и browser security headers.
111. Для auth endpoints добавлен базовый in-memory rate limit; `api-contract` тесты теперь отдельно покрывают `429 AUTH_RATE_LIMITED`.
112. OpenAPI и env templates синхронизированы с security baseline: добавлены `/health/ready`, `TooManyRequestsError`, `429` для auth routes и `AUTH_RATE_LIMIT_*` переменные.


113. Проведен `mobile UX/copy hardening` pass: login, dashboard, products, movements, inventory и team получили более точные helper texts, action labels и менее техничный продуктовый copy.
114. `ProductsScreen` теперь показывает короткую operational summary по каталогу (`Товаров / Low stock / Без категории`), а пустой каталог дает role-aware CTA на создание первой позиции.
115. `MovementsScreen` теперь показывает краткую сводку по журналу (`Записей / Приход / Расход / Корректировка`) и более явный copy в movement dialog для каждой операции.
116. `InventoryScreen` теперь показывает summary chips по текущей сессии (`Позиций / Расхождений / В очереди`), clearer start CTA `Открыть сессию` и более точный copy для фиксации фактического остатка.
117. `TeamScreen` получил cleaner owner/staff copy, русские role labels в invite/edit dialogs, более понятный invite success state и summary chips по команде (`Сотрудников / Активных / Менеджеров / Staff`).
118. После mobile UX/copy hardening quality gate снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `43 passed`.

119. Закрыт `mobile modal/forms UX hardening`: dialogs `product / movement / inventory / company / invite / user` получили helper texts, более точные submit CTA и менее техничный copy.
120. `ProductDialog` теперь объясняет ключевые поля (`категория / единица / SKU / штрихкод / min stock / стартовый остаток / описание`), `MovementDialog` — различает flow для прихода/расхода и корректировки, а team dialogs используют русские role labels и clearer invite/company/user copy.
121. После form-polish `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `43 passed`.

122. Проведен `mobile summary/entity UX hardening` pass: `CompanyStatusCard`, `TeamMemberInfoCard` и `ProductStockCard` получили более продуктовые статусные метки без англицизмов (`Есть изменения в очереди`, `Нужна сверка с сервером`, `низкий остаток`, `создается офлайн`, `в очереди`).
123. `TeamMemberInfoCard` теперь сам переводит системные роли в UI labels (`Менеджер`, `Сотрудник`), а `CompanyStatusCard` показывает не только sync/error text, но и явный operational status через chips.
124. После entity/status polish `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `43 passed`.
125. Добавлен `mobile dialog copy regression` слой в `test/widget/screen_recovery_test.dart`: отдельные widget-сценарии теперь фиксируют product-facing copy для `ProductsScreen`, `MovementsScreen`, `InventoryScreen` и `TeamScreen`.
126. Новые dialog tests проверяют не recovery-механику, а сам UI-контракт форм: заголовки, helper texts и submit CTA для `create category`, `create product`, `movement`, `actual qty` и `invite`.
127. После добавления dialog copy regression suite `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `48 passed`.
128. Проведен `mobile role/copy consistency` pass: остаточные англоязычные метки в `login / dashboard / products / team / entity cards` переведены в единый продуктовый русский copy.
129. `ProductsScreen` теперь показывает `Низкий остаток`, `TeamScreen` использует `Владелец / Менеджер / Сотрудник` в summary, pending labels и company header, а demo-access copy на login экране больше не смешивает `owner/manager/staff` с русским текстом.
130. После role/copy consistency pass `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `48 passed`.
131. Проведен `mobile action feedback hardening` pass: snackbar-сообщения для `products / movements / inventory / team` приведены к единому operational copy без техничных формулировок и неточных статусов.
132. Offline/retry feedback теперь последовательно использует формулировки уровня продукта: `сохранено в очередь на отправку`, `отложенные изменения очищены`, `запуск инвентаризации синхронизирован`, `изменения по сотруднику сохранены...`, без смешения CRUD-технических терминов с UI copy.
133. После action-feedback hardening `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `48 passed`.
134. Проведен `mobile dashboard insight hardening` pass: daily summary теперь хранит и показывает разрез по `приходам / расходам / корректировкам / сверкам / сессиям`, а не только aggregate total.
135. `DashboardScreen` теперь дает владельцу и менеджеру более полезный срез дня без перехода в web/admin: видно, какой именно тип движения формирует нагрузку и есть ли в дне инвентаризационные сессии.
136. После dashboard insight hardening `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `48 passed`.
137. Проведен `mobile operator workflow hardening` pass: `DashboardScreen` получил быстрые действия для `движений / инвентаризации / каталога / команды`, чтобы оператор и владелец могли переходить к рабочим сценариям прямо из обзора смены.
138. `AppShell` теперь умеет открывать нужную вкладку по callback из dashboard и показывает контекстный notice о следующем шаге (`Открыл движения...`, `Открыл инвентаризацию...` и т.д.), что убирает лишний навигационный поиск по нижнему меню.
139. В `screen_recovery_test.dart` добавлен отдельный widget-сценарий на dashboard quick actions; после operator workflow hardening `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `49 passed`.
140. Проведен `mobile product filtering hardening` pass: `ProductsScreen` получил быстрые product-facing фильтры `Все / Низкий остаток / Без категории / Офлайн-черновики`, чтобы оператору не приходилось искать проблемные позиции только через строку поиска.
141. Для фильтров добавлен отдельный empty-state: если каталог не пуст, но выбранный срез не содержит позиций, экран показывает `По выбранному фильтру товаров нет` и дает явный CTA `Сбросить фильтр`.
142. В `screen_recovery_test.dart` добавлен widget-сценарий на product filters; после product filtering hardening `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `50 passed`.
143. Проведен `mobile movement filtering hardening` pass: `MovementsScreen` получил быстрые фильтры `Все / Приход / Расход / Корректировка / Сверка`, чтобы оператор мог быстро отделять типы операций внутри журнала без ручного просмотра списка.
144. Для movement filters добавлен отдельный empty-state: если журнал за день не пуст, но выбранный тип операций не содержит записей, экран показывает `По выбранному фильтру движений нет` и дает CTA `Сбросить фильтр`.
145. В `screen_recovery_test.dart` добавлен widget-сценарий на movement filters; после movement filtering hardening `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `51 passed`.
146. Проведен `mobile inventory filtering hardening` pass: `InventoryScreen` получил быстрые фильтры `Все / Расхождения / Совпадает`, чтобы при сверке можно было отдельно смотреть проблемные и уже подтвержденные позиции.
147. Для inventory filters добавлен отдельный empty-state: если сессия открыта, но выбранный фильтр не дает позиций, экран показывает `По выбранному фильтру позиций нет` и дает CTA `Сбросить фильтр`.
148. В `screen_recovery_test.dart` добавлен widget-сценарий на inventory filters; после inventory filtering hardening `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `52 passed`.
149. Проведен `mobile team/company workflow hardening` pass: `TeamScreen` получил быстрые owner-facing фильтры `Все / Активные / Менеджеры / Сотрудники / Приглашения`, чтобы владелец мог быстро разложить команду по operational срезам без ручного просмотра списка.
150. Если выбранный team filter не дает сотрудников, экран теперь показывает отдельный empty-state `По выбранному фильтру сотрудников нет` с CTA `Сбросить фильтр`; pending-invite copy на карточках сотрудников также переведен в продуктовый русский (`Приглашение до ...`).
151. После team/company workflow hardening `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `52 passed`.
152. Проведен `mobile offline movement queue UX` pass: `MovementsScreen` теперь показывает не только chip со счетчиком очереди, но и явный pending-action блок `Есть движения в очереди` с CTA `Отправить сейчас / Очистить очередь`.
153. Это убирает скрытую offline-семантику: оператору больше не нужно догадываться, что означает счетчик `Очередь: N` — экран прямо объясняет, что часть операций сохранена локально и ждет синхронизации.
154. В `screen_recovery_test.dart` добавлен widget-сценарий на pending queue action card; после offline movement queue hardening `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `53 passed`.
155. Проведен `mobile offline inventory queue UX` pass: `InventoryScreen` теперь показывает отдельный pending-action блок `Есть позиции в очереди`, когда по активной сессии есть локальные item updates, ожидающие синхронизации.
156. Это выравнивает inventory offline UX с movement queue: оператор видит не только chip `В очереди: N`, но и прямые действия `Отправить сейчас / Очистить очередь`, плюс краткое объяснение, что изменения пока локальные.
157. В `screen_recovery_test.dart` добавлен widget-сценарий на pending inventory queue card; после offline inventory queue hardening `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `54 passed`.
158. Проведен `mobile products offline queue UX` pass: `ProductPendingOperationsCard` теперь умеет показывать общие CTA `Отправить все сейчас / Очистить очередь`, если есть локальные category/product операции без конфликта.
159. Это выравнивает products offline UX с movements/inventory: отложенные изменения по каталогу больше не выглядят только как список отдельных retry/discard строк — у владельца и менеджера есть явный batch-level control.
160. В `render_smoke_test.dart` добавлен отдельный сценарий на batch-actions в `ProductPendingOperationsCard`; после products offline queue hardening `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `55 passed`.
161. Проведен `mobile team offline queue UX` pass: `TeamPendingOperationsCard` теперь показывает batch-level CTA `Отправить все сейчас / Очистить очередь`, если есть локальные invites/updates по команде без конфликта.
162. Это выравнивает team offline UX с products/movements/inventory: owner больше не управляет pending командой только поэлементно, а получает явный общий control для всей очереди сотрудников.
163. В `render_smoke_test.dart` добавлен сценарий на batch-actions в `TeamPendingOperationsCard`; после team offline queue hardening `apps/mobile` quality gate снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `56 passed`.

164. Добавлен `bootstrap_owner.sh` в `infra/deploy`: теперь первый owner для production-like/production создается отдельным явным flow через `POST /v1/auth/register`, а не только через demo seed.
165. Deploy/docs policy обновлена: demo seed остается только для тестовых контуров, а реальный production bootstrap описан как отдельная операция с `BOOTSTRAP_*` env и target `staging|production|<url>`.
166. Добавлена `ALLOW_PUBLIC_REGISTRATION` policy: в production-like по умолчанию `false`, а `POST /v1/auth/register` после появления первой компании возвращает `403 AUTH_REGISTRATION_DISABLED`.
167. `validate_runtime_env.sh` теперь требует явный `ALLOW_PUBLIC_REGISTRATION=true|false`, чтобы registration policy не зависела от неявных defaults в staging/production-like.
168. Проведен `mobile team search hardening` pass: `TeamScreen` получил поиск по имени, email и телефону, чтобы owner мог быстро находить сотрудников внутри текущего фильтра.
169. Для team search добавлен отдельный empty-state `Поиск не дал сотрудников по текущему фильтру.` и CTA `Очистить поиск`; после изменения mobile quality gate снова зеленый: `flutter analyze` — ok, `render_smoke_test + screen_recovery_test + api_contract_test + auth_controller_test` — `56 passed`.
170. Запущен первый `web fix pack` по реальным скриншотам admin-панели: убрана смесь русского и английского в ключевых owner-экранах (`login`, `overview`, `products`, `inventory`, `team`, `reports`, `audit`).
171. `apps/web` приведен к более продуктовому copy: `Admin Shell`, `owner/manager`, `Low stock`, `Stock report`, `Audit trail`, `Parent`, `Entity type`, `Action` и `OWNER/MANAGER/STAFF` заменены на управленческие русские формулировки.
172. В `DashboardView` добавлен явный empty-state для дня без операций, а строки `InventorySessionRow`, `MovementTableRow` и `AuditLogRow` теперь показывают статусы, типы движений и audit-действия в читаемом UI-формате.
173. Demo seed обновлен под менее техничный клиентский показ: компания теперь `Оптовый склад Дербент`, owner — `Мурад И.`, manager — `Менеджер смены`, staff — `Кладовщик 1`.
174. Проведен второй `web fix pack` по новым скриншотам: audit presentation больше не держится только на raw technical labels — action/entity formatting понимает `inventory.*`, `movement.*`, snake_case entity types и human-readable payload summary.
175. `ExportCard` облегчен визуально: имя файла стало вторичным метаданным с отдельной подписью `Имя файла`, а не главным блоком карточки; это снижает ощущение внутреннего инструмента и делает смысл выгрузки первичным.
176. Перед выкладкой второго fix pack прогнан полный `apps/web` gate (`npm run check`, `test:contract`, `test:recovery`, `test:render`, `build`); после sync на сервер нужно повторно прогнать `prisma:seed` в staging/prod-like, чтобы live-данные точно совпали с обновленным клиентским seed-copy.
177. Проведен третий `web fix pack` по UI-замечаниям со скриншотов: системно увеличены интервалы между title-блоками и action-кнопками через `toolbar-title`, больший `gap` у `toolbar`/`toolbar-actions`, выровнены карточки разделов и action rows, чтобы текст и кнопки больше не "липли" друг к другу.
178. Из owner-facing `AuditView` полностью убран raw JSON affordance `Показать JSON`: для обычного пользователя важна краткая управленческая сводка изменений, а не отладочный payload. В audit строках теперь остаются только human-readable badges (`Позиции: ...`, `До: ...`, `После: ...` и т.п.).
179. После повторного просмотра live-скриншотов доточен spacing layer `apps/web`: `audit-insights`, `toolbar-filters` и `ActiveFilterChips` больше не используют right-pushed layout, поэтому badges и фильтры собираются плотными левыми группами без больших пустых дыр между текстом и кнопками.
180. В `AuditView` human-readable payload labels расширены для movement/update полей: `quantity` -> `Количество`, `beforeQty` -> `Остаток до`, `afterQty` -> `Остаток после`; nested `before/after` объекты теперь сводятся к кратким русским подписям вместо технического `объект`.

181. Проведен четвертый `web fix pack` по реальным скриншотам owner-панели: `ProductsView` больше не держит `Категорий: N` в верхней action-зоне, а `MovementsView` перенес `Товаров: N` из верхнего toolbar в нижний summary-ряд, чтобы кнопки и смысловые метрики больше не спорили за одно и то же место.
182. В `InventoryView` badge `Низкий остаток` убран из верхнего action-toolbar отчета по остаткам и переведен в отдельную compact-сводку рядом с контекстом фильтров; в `ReportingView` daily insight chips также переведены в compact-режим, чтобы `Низкий остаток` не отваливался на отдельную строку на wide-layout.
183. В `apps/web` добавлена browser-side session persistence через `localStorage`: normal page refresh больше не выбрасывает пользователя из owner/manager панели, а logout/session expiry по-прежнему очищают persisted session.
184. Исправлен modal-state bug в `App.tsx`: create-модалки товаров и категорий больше не открываются самопроизвольно при входе в админ-панель; закрытое состояние унифицировано как `false`, create-flow — `null`, edit-flow — объект сущности.
185. После четвертого fix pack `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `30 passed`, `npm run build` — ok.
186. Полный локальный `run_quality_gate.sh` повторно прогнан с реальным доступом к локальному Postgres и полностью зеленый: `shared`, `api`, `web`, `mobile` — все passed.
187. Причина прошлых локальных падений `apps/api test:contract` не в коде, а в sandbox-блокировке доступа к `localhost:5432`; при реальном TCP-доступе suite подтверждает стабильность `health/ready`, auth, envelopes, validation и registration policy.
188. `release_gate.sh` на сервере повторно прогнан и зеленый для `staging` и `production-like`.
189. В `ReportingView` daily summary и export/filter chips дополнительно уплотнены: labels сокращены до `Приход / Расход / Корректировка / Сверка / Сессии`, чтобы блок `Сводка за день` не разваливался визуально и не вытеснял `Низкий остаток` на отдельную визуально чужую строку.
190. Следующий `web` spacing pass перевел `ReportingView` и stock report на двухуровневый компактный layout: `Контекст отчета / Контекст журнала` теперь собираются в общий `info-strip`, а `Сводка дня` и `Сводка отчета` больше не оставляют широких пустых полос между заголовком, бейджами и фильтрами.
191. `AuditView` дополнительно уплотнен: блок `Активные фильтры` переведен в compact-режим, `filter-panel` и `ActiveFilterChips` больше не разрывают секцию большими вертикальными отступами, а owner-facing фильтры и инсайты собираются плотнее под заголовком.
192. `ProductModal` получил более заметные подписи полей (`field-label` теперь темнее и визуально сильнее), чтобы создание товара не выглядело набором безымянных полей и числовых инпутов.
193. После этого spacing/layout pass `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `30 passed`, `npm run build` — ok.

- tightened `web` reporting/audit spacing: grouped context chips, moved audit filters into a compact left-aligned panel, and removed excess whitespace between report sections.
- improved `ProductModal` usability with explicit field labels and clearer placeholders for category, minimum stock, starting stock, and description.

- tightened `web` reporting hierarchy again: shortened low-stock labels in summary chips, renamed context blocks to shorter titles, and reduced whitespace in reporting/export sections.
- refined `ProductModal` UX with explicit field labels and descriptive placeholders so numeric and category inputs are no longer ambiguous.

- Сжал web reporting/audit layout: компактные группы сводок, более плотные контекстные блоки и левое выравнивание audit-фильтров.
194. Следующий `web` low-noise layout pass убрал остаточные визуальные перекосы: `MovementsView` больше не показывает `Товаров: N` в action-row, header-card сделан компактнее, а `ReportingView`/stock-report получили более собранные context blocks без широких пустых полос между заголовками, сводками и фильтрами.
- Tightened web reporting/audit spacing again, switched report context blocks to compact badge rows, and cleaned modal field affordances for company/invite/user/product forms.
195. Проведен `web movements filtering hardening` pass: `MovementsView` получил быстрые фильтры `Все / Приход / Расход / Корректировка / Сверка`, чтобы owner/manager могли разбирать журнал операций по типам без ручного просмотра всей таблицы.
196. Для movement filters в `apps/web` добавлен отдельный empty-state: если журнал за день не пуст, но выбранный тип операций не содержит записей, экран показывает `По выбранному фильтру движений нет` и дает CTA `Сбросить фильтр`.
197. После movement filtering hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `32 passed`, `npm run build` — ok.
198. Проведен `web team filtering/search hardening` pass: `TeamView` получил owner-facing фильтры `Все / Активные / Менеджеры / Сотрудники / Приглашения`, чтобы владелец быстрее выделял нужный operational срез команды.
199. В `TeamView` добавлен поиск по имени/email/телефону и два отдельных empty-state сценария: `По выбранному фильтру сотрудников нет` (с CTA `Сбросить фильтр`) и `Поиск не дал сотрудников по текущему фильтру.` (с CTA `Очистить поиск`).
200. После team filtering/search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `35 passed`, `npm run build` — ok.
201. Проведен `web team invite visibility hardening` pass: `TeamUserRow` теперь показывает invite-aware статус `Ожидает активации` и отдельный badge `Приглашение до ...`, чтобы owner видел не только общий статус активности, но и срок pending-invite прямо в таблице.
202. Исправлен markup bug в `CompanyModal`: удален вложенный `label` у поля `Телефон`, из-за которого форма содержала дублирующуюся разметку и потенциально ломала доступность поля для screen-reader/navigation сценариев.
203. После team invite visibility + modal markup fix `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `35 passed`, `npm run build` — ok.
204. Проведен `web inventory session filtering hardening` pass: `InventoryView` получил быстрые фильтры `Все / Черновики / Завершенные`, чтобы owner/manager могли разбирать дневные сессии инвентаризации по статусам без ручного просмотра всей таблицы.
205. Для inventory session filters добавлен отдельный empty-state: если за день сессии есть, но выбранный статус не содержит записей, экран показывает `По выбранному фильтру сессий нет` и дает CTA `Сбросить фильтр`.
206. После inventory session filtering hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `37 passed`, `npm run build` — ok.
207. Проведен `web products filtering hardening` pass: `ProductsView` получил быстрые фильтры `Все / Низкий остаток / Без категории`, чтобы owner/manager могли сразу выделять риск-зоны каталога без ручного просмотра всей таблицы.
208. Для product filters в `apps/web` добавлен отдельный empty-state: если каталог не пуст, но выбранный срез не содержит позиций, экран показывает `По выбранному фильтру товаров нет` и дает CTA `Сбросить фильтр`.
209. После products filtering hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `39 passed`, `npm run build` — ok.
210. Проведен `web products search hardening` pass: `ProductsView` теперь поддерживает поиск по `названию / SKU / штрихкоду` поверх текущего фильтра, чтобы owner/manager могли быстро находить конкретные позиции внутри выбранного среза каталога.
211. Для product search добавлен отдельный empty-state `Поиск не дал товаров по текущему фильтру.` с CTA `Очистить поиск`; также исправлен markup bug в `LoginForm` (удален вложенный `label`, добавлена явная подпись поля `Пароль`).
212. После products search + login markup fix `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `40 passed`, `npm run build` — ok.
213. Проведен `web movements search hardening` pass: `MovementsView` теперь поддерживает поиск по `товару / сотруднику` поверх фильтра типа операции, чтобы owner/manager могли быстрее находить нужные записи в журнале без ручного просмотра всей таблицы.
214. Для movement search добавлен отдельный empty-state `Поиск не дал движений по текущему фильтру.` с CTA `Очистить поиск`; параллельно добавлен общий reset-контрол `Сбросить всё` для комбинации фильтра и поиска.
215. После movements search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `41 passed`, `npm run build` — ok.
216. Проведен `web inventory session search hardening` pass: `InventoryView` теперь поддерживает поиск по `ID сессии / сотруднику` поверх фильтра статуса (`Все / Черновики / Завершенные`), чтобы owner/manager могли быстрее находить нужные инвентаризации за день.
217. Для inventory session search добавлен отдельный empty-state `Поиск не дал сессий по текущему фильтру.` с CTA `Очистить поиск`; также добавлен общий reset-контрол `Сбросить всё` для комбинации статусного фильтра и поиска.
218. После inventory session search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `42 passed`, `npm run build` — ok.
219. Проведен `web audit search hardening` pass: `AuditView` получил локальный поиск по загруженному журналу (`действие / сущность / сотрудник`) поверх server-side фильтров, чтобы owner быстрее находил нужные записи без ручного просмотра всей таблицы.
220. Для audit search добавлен отдельный empty-state `Поиск не дал записей по текущим фильтрам` с CTA `Очистить поиск`; в toolbar теперь показывается `Записей: N` по текущему поисковому срезу и `Всего в выборке: M` при активном поиске.
221. После audit search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `43 passed`, `npm run build` — ok.
222. Проведен `web modal form accessibility hardening` pass: `MovementModal` получил явные field labels для `Товар / Количество(или Целевой остаток) / Комментарий`, чтобы форма операций не зависела только от placeholder-подсказок.
223. `InviteModal` и `UserModal` теперь показывают явную подпись `Роль сотрудника`, а `UserModal` также получил labeled-поле `Новый пароль`; это выравнивает role/password affordances с уже усиленными product/company/login формами.
224. После modal form accessibility hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `43 passed`, `npm run build` — ok.
225. Проведен `web audit preset filtering hardening` pass: `AuditView` получил быстрые preset-фильтры по сущностям (`Товары / Категории / Движения / Сессии инвентаризации / Сотрудники`) и по частым действиям (`Приглашения / Завершение инвентаризации / Обновления`), чтобы owner мог фильтровать журнал без ручного ввода technical token-строк.
226. Preset-layer реализован как non-breaking обертка над текущими полями фильтра: кнопки заполняют существующие `entityType/action` значения, сохраняют совместимость server-side фильтров и работают вместе с локальным audit search/reset controls.
227. После audit preset filtering hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `43 passed`, `npm run build` — ok.
228. Проведен `web categories search hardening` pass: в блоке `Категории` внутри `ProductsView` добавлен поиск по `названию категории / родительской категории`, чтобы owner/manager могли быстрее находить нужный узел структуры каталога.
229. Для category search добавлен отдельный empty-state `Поиск не дал категорий` с CTA `Очистить поиск`; search-панель отображается и в таблице категорий, и в пустом поисковом срезе без потери action-кнопок.
230. После categories search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `45 passed`, `npm run build` — ok.
231. Проведен `web dashboard session filtering/search hardening` pass: `DashboardView` получил быстрые фильтры `Все / Черновики / Завершенные` и поиск по `ID сессии / сотруднику`, чтобы обзор дня не требовал перехода в отдельный inventory-экран для базовой сортировки сессий.
232. Для dashboard session controls добавлены отдельные empty-state сценарии: `По выбранному фильтру сессий нет` (с CTA `Сбросить фильтр`) и `Поиск не дал сессий в сводке дня` (с CTA `Очистить поиск`), плюс общий reset-контрол `Сбросить всё`.
233. После dashboard session filtering/search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `48 passed`, `npm run build` — ok.
234. Проведен `web dashboard movement visibility hardening` pass: `DashboardView` получил отдельный блок `Движения по складу` с быстрыми фильтрами `Все / Приход / Расход / Корректировка / Сверка` и поиском по `товару / сотруднику`, чтобы обзор дня закрывал не только инвентаризацию, но и оперативную ленту движений.
235. Для dashboard movement controls добавлены отдельные empty-state сценарии: `По выбранному фильтру движений нет` (с CTA `Сбросить фильтр`) и `Поиск не дал движений в сводке дня` (с CTA `Очистить поиск`), плюс общий reset-контрол `Сбросить всё`.
236. После dashboard movement visibility hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `51 passed`, `npm run build` — ok.
237. Проведен `web movement timeline hardening` pass: в `MovementsView` и в dashboard-блоке `Движения по складу` добавлена колонка `Когда`, чтобы записи были читаемы как журнал по времени, а не только как агрегированный список действий.
238. Для movement tables добавлено явное ordering правило `newest-first`: записи движений теперь сортируются по `createdAt` по убыванию, чтобы вверху всегда были последние операции смены.
239. После movement timeline hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `51 passed`, `npm run build` — ok.
240. Проведен `web inventory session timeline hardening` pass: в таблицах сессий `DashboardView` и `InventoryView` добавлена колонка `Когда`, чтобы inventory-история в daily overview и в профильном экране читалась как timeline, а не только как список ID/статусов.
241. Для inventory session tables добавлено явное ordering правило `newest-first`: сессии теперь сортируются по `startedAt` по убыванию в обоих экранах (`dashboard` и `inventory`), чтобы свежие сверки всегда были наверху.
242. После inventory session timeline hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `51 passed`, `npm run build` — ok.
243. Проведен `web audit entity id visibility hardening` pass: локальный поиск `AuditView` теперь учитывает `entityId`, а в `AuditLogRow` добавлен явный badge `ID: ...`, чтобы связь записи с конкретной сущностью не терялась даже при минимальном payload.
244. Проведен `web audit search depth hardening` pass: audit-поиск расширен на raw technical токены (`action`, `entityType`, `role`) и human-readable payload summary (`Позиции`, `Изменено`, `Остаток до/после`), чтобы owner мог находить записи как по бизнес-формулировкам, так и по системным кодам событий.
245. После audit entity-id + search-depth hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `53 passed`, `npm run build` — ok.
246. Проведен `web audit timeline sorting hardening` pass: в `AuditView` добавлен явный переключатель порядка журнала `Сначала новые / Сначала старые`, чтобы owner мог читать события как в оперативном режиме (latest-first), так и в ретроспективе (oldest-first).
247. Для нового sorting-layer добавлено smoke-покрытие порядка строк: `AuditView` теперь тестируется на режим `defaultSort: 'OLDEST'`, который подтверждает корректный вывод timeline в хронологическом порядке.
248. После audit timeline sorting hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `54 passed`, `npm run build` — ok.
249. Проведен `web movements search depth hardening` pass: в `MovementsView` и dashboard-блоке `Движения по складу` поиск расширен с `товар/сотрудник` до `товар + сотрудник + тип операции + комментарий + role/ID`, чтобы журнал находился и по бизнес-формулировкам (`Приход`), и по operational пометкам смены.
250. Обновлены movement-search affordances: placeholder синхронизирован как `Поиск по товару, сотруднику, типу или комментарию`, а для нового поведения добавлены smoke-кейсы на поиск по label типа операции (`приход`) и по тексту комментария (`поставка`).
251. После movements search depth hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `56 passed`, `npm run build` — ok.
252. Проведен `web inventory session search depth hardening` pass: в `DashboardView` и `InventoryView` сессионный поиск переведен на единый helper и расширен до `ID (полный/короткий) + сотрудник (id/name) + статус (raw token + human label) + дата/время старта + число позиций`, чтобы сессии находились и по operational-коду (`DRAFT`), и по пользовательским формулировкам.
253. Обновлены session-search affordances: placeholder синхронизирован как `Поиск по ID, сотруднику, статусу, дате или позициям`; добавлены smoke-кейсы для поиска по technical status token (`draft`) и по summary label (`Позиции: 12`).
254. После inventory session search depth hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `58 passed`, `npm run build` — ok.
255. Проведен `web team search depth hardening` pass: `TeamView` переведен на единый `team-user` search helper и теперь ищет не только по `name/email/phone`, но и по `id`, `role` (raw + human label), `status` (`Активен / Неактивен / Ожидает активации`) и invite-label (`Приглашение до ...`), чтобы owner быстрее находил нужный кадровый срез.
256. Обновлены team-search affordances: placeholder синхронизирован как `Поиск по имени, email, телефону, роли или статусу`; добавлены smoke-кейсы на поиск по role-label (`менеджер`) и по invite-status (`ожидает`).
257. После team search depth hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `60 passed`, `npm run build` — ok.
258. Проведен `web stock report sorting hardening` pass: в `InventoryView` добавлен локальный переключатель сортировки отчета остатков `Риск сначала / По названию`, чтобы команда могла быстро видеть риск-позиции вверху и при необходимости переключаться на алфавитный просмотр без изменения серверных фильтров.
259. В `LOW_FIRST` режиме сортировка учитывает сначала `isLowStock`, затем величину дефицита (`minStock - currentStock`) и только потом название; это делает приоритет отчета более операционным, чем простой alphabetical list.
260. После stock report sorting hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `61 passed`, `npm run build` — ok.
261. Проведен `web team sorting hardening` pass: в `TeamView` добавлен локальный переключатель сортировки `Активные сначала / По имени`, чтобы owner мог быстро фокусироваться на текущей рабочей команде и при необходимости переходить к алфавитному просмотру без изменения фильтра.
262. Для `ACTIVE_FIRST` режима сортировка учитывает статусный приоритет (`Активен` -> `Ожидает активации` -> `Неактивен`) и затем имя; это сохраняет operational-фокус и одновременно делает список стабильным внутри статусов.
263. После team sorting hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `62 passed`, `npm run build` — ok.
264. Проведен `web products sorting hardening` pass: в `ProductsView` добавлен локальный переключатель сортировки `Риск сначала / По названию`, чтобы оператор мог держать риск-позиции вверху каталога и при необходимости переключаться на алфавитный просмотр без потери текущего фильтра/поиска.
265. Для `LOW_FIRST` режима сортировка каталога учитывает сначала low-stock статус, затем величину дефицита (`minStock - currentStock`) и после этого название; это делает рабочий порядок товаров более полезным для смены, чем plain alphabetical list.
266. После products sorting hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `63 passed`, `npm run build` — ok.
267. Проведен `web categories sorting hardening` pass: в `ProductsView` для блока `Категории` добавлен локальный переключатель `Корневые сначала / По названию`, чтобы быстрее читать структуру каталога по уровням и переключаться на алфавитный обзор без изменения поиска.
268. Для режима `ROOT_FIRST` категории сортируются по приоритету уровня (`корневые` выше дочерних), затем по имени родителя и имени категории; это снижает "перемешивание" веток и делает иерархию заметно читаемее в таблице.
269. После categories sorting hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `64 passed`, `npm run build` — ok.
270. Проведен `web movement sorting controls hardening` pass: в `DashboardView` и `MovementsView` добавлен локальный переключатель порядка `Сначала новые / Сначала старые`, чтобы журнал движений можно было читать как оперативную ленту и как ретроспективный timeline без смены даты/фильтров.
271. Для движения внедрен единый сортировочный helper `sortMovementsByCreatedAt` с режимами `NEWEST` и `OLDEST`; это убирает разнобой между dashboard и профильным экраном движений и делает порядок строк предсказуемым в обеих таблицах.
272. После movement sorting controls hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `66 passed`, `npm run build` — ok.
273. Проведен `web inventory session sorting controls hardening` pass: в `DashboardView` и `InventoryView` добавлен локальный переключатель порядка сессий `Сначала новые / Сначала старые`, чтобы инвентаризационный timeline можно было читать как в оперативном, так и в ретроспективном режиме.
274. Для сессий внедрен единый helper `sortInventorySessionsByStartedAt` с режимами `NEWEST` и `OLDEST`; это синхронизирует порядок строк между daily dashboard и профильным экраном инвентаризации и убирает несогласованность отображения.
275. После inventory session sorting controls hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `68 passed`, `npm run build` — ok.
276. Проведен `web stock status quick-filter hardening` pass: в `InventoryView` добавлен локальный статус-фильтр позиций `Все позиции / Низкий остаток / В норме`, который работает поверх уже загруженного отчета и помогает оператору быстро переключать operational-срез без перезагрузки данных.
277. Для stock status filters добавлен отдельный empty-state `По выбранному статусу позиций нет` с action `Сбросить статус`, чтобы при пустом срезе команда явно понимала, что данные есть, но не в выбранном статусе.
278. После stock status quick-filter hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `69 passed`, `npm run build` — ok.
279. Проведен `web products search depth hardening` pass: в `ProductsView` локальный поиск расширен с `название / SKU / штрихкод` до `название / SKU / штрихкод / категория / единица`, чтобы товар находился не только по идентификаторам позиции, но и по контексту каталога.
280. Обновлены product-search affordances: placeholder синхронизирован как `Поиск по названию, SKU, штрихкоду или категории`; добавлен smoke-кейс на поиск по category-label (`напитки`) поверх текущего среза каталога.
281. После products search depth hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `70 passed`, `npm run build` — ok.
282. Проведен `web products search unit-awareness hardening` pass: product-search в `ProductsView` теперь явно коммуницирует поиск по единице измерения (`unit`) и сохраняет покрытие на category/unit lookup, чтобы оператор мог находить позиции по operational-обозначениям товара (`кг`, `л`, `шт`).
283. Product-search placeholder обновлен до `Поиск по названию, SKU, штрихкоду, категории или единице`; добавлен отдельный smoke-кейс на unit-based lookup (`кг`) поверх текущего каталога.
284. После products unit-aware search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `71 passed`, `npm run build` — ok.
285. Проведен `web movement search affordance alignment` pass: placeholder поиска движений в `DashboardView` и `MovementsView` синхронизирован с реальным search-охватом (`товар + ID + сотрудник + роль + тип + комментарий`), чтобы UI-подсказка не отставала от фактической логики.
286. Добавлены smoke-кейсы на role-based lookup (`владелец`) для dashboard-блока движений и для standalone `MovementsView`; это закрепляет поддержку поиска по human-readable роли, а не только по товару/типу/комментарию.
287. После movement search affordance alignment `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `73 passed`, `npm run build` — ok.
288. Проведен `web movement quantity-search alignment` pass: movement-search placeholder в `DashboardView` и `MovementsView` расширен до `... типу, количеству или комментарию`, чтобы текстовый affordance прямо отражал поддержку поиска по `quantity/beforeQty/afterQty`.
289. Добавлены smoke-кейсы на quantity-based lookup (`5`) для dashboard-движений и standalone `MovementsView`; это фиксирует, что числовой поиск остается рабочим и не конфликтует с фильтрами/сортировкой.
290. После movement quantity-search alignment `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `75 passed`, `npm run build` — ok.
291. Проведен `web audit search affordance alignment` pass: placeholder `AuditView` синхронизирован с фактическим поиском и теперь явно указывает role-aware coverage (`...сотруднику, роли или деталям`), чтобы owner понимал, что журнал ищется и по роли пользователя.
292. Добавлен smoke-кейс на role-based audit lookup (`владелец`), который закрепляет поддержку поиска по human-readable роли в owner-facing журнале действий.
293. После audit role-search alignment `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `76 passed`, `npm run build` — ok.
294. Проведен `web team search affordance alignment` pass: placeholder поиска в `TeamView` синхронизирован с реальным охватом (`имя/email/телефон/роль/статус/ID/приглашение`), чтобы подсказка не занижала фактические возможности фильтрации команды.
295. Добавлен отдельный smoke-кейс на invite-label lookup (`приглашение до`), который закрепляет поиск не только по статусу `ожидает`, но и по текстовому блоку приглашения.
296. После team search affordance alignment `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `77 passed`, `npm run build` — ok.
297. Проведен `web movement id-search hardening` pass: `buildMovementSearchText` расширен токенами `movement.id` и `createdBy.id`, чтобы lookup по явным идентификаторам движений/сотрудников работал в dashboard и в профильном журнале движений.
298. Добавлены smoke-кейсы на movement-id lookup (`movement-1`) для `DashboardView` и `MovementsView`; это закрепляет, что ID-поиск не ломается при активных фильтрах, сортировке и прочих search-токенах.
299. После movement id-search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `79 passed`, `npm run build` — ok.
300. Проведен `web audit user-id search hardening` pass: audit-search в `AuditView` расширен токеном `log.user.id`, чтобы owner мог находить записи журнала по явному идентификатору пользователя, а не только по имени/роли.
301. Добавлен smoke-кейс на user-id lookup для `AuditView`; тест использует реальный `auditLog.user.id` (`owner-1`) и подтверждает, что поисковый срез не проваливается в empty-state.
302. После audit user-id search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `80 passed`, `npm run build` — ok.
303. Проведен `web team invite-date search hardening` pass: `buildTeamUserSearchText` расширен raw-значением `inviteExpiresAt`, чтобы поиск команды работал не только по invite-label, но и по фактической дате/году приглашения.
304. Team-search placeholder синхронизирован как `...ID или дате приглашения`; добавлен smoke-кейс на invite-date lookup (`2026`) для pending-invite пользователя.
305. После team invite-date search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `81 passed`, `npm run build` — ok.
306. Проведен `web movement date-search hardening` pass: `buildMovementSearchText` расширен токенами `createdAt` (raw ISO + локализованная дата/время), чтобы движение можно было находить по дате операции без ручного перебора таблицы.
307. Movement-search placeholder в `DashboardView` и `MovementsView` синхронизирован как `...количеству, дате или комментарию`; добавлены smoke-кейсы на date-based lookup (`2026`) для обоих экранов.
308. После movement date-search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `83 passed`, `npm run build` — ok.
309. Проведен `web inventory session ISO date-search hardening` pass: `buildInventorySessionSearchText` расширен raw-токенами `startedAt` и `finishedAt` (в дополнение к локализованным датам), чтобы поиск сессий стабильно работал по ISO-формату даты.
310. Добавлены smoke-кейсы на session ISO date lookup (`2026-03-03`) для `DashboardView` и `InventoryView`; это закрепляет поиск по техническому формату даты без зависимости от локали браузера.
311. После inventory session ISO date-search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `85 passed`, `npm run build` — ok.
312. Проведен `web audit date-search hardening` pass: в `AuditView` search-контур расширен токенами `createdAt` (raw ISO + локализованная дата/время), чтобы владелец мог находить записи журнала по дате события.
313. Audit-search placeholder синхронизирован как `...сотруднику, роли, дате или деталям`; добавлен smoke-кейс на date-based lookup (`2026-03-03`) для `AuditView`.
314. После audit date-search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `86 passed`, `npm run build` — ok.
315. Проведен `web stock-report search affordance alignment` pass: placeholder поиска в блоке отчета по остаткам (`InventoryView`) синхронизирован с backend-поиском и теперь явно отражает coverage `товар / SKU / штрихкод`.
316. Добавлена smoke-проверка placeholder в `InventoryView`, чтобы UI-подсказка для stock-search не регрессировала и продолжала соответствовать фактическому search-контракту `/v1/reports/stock`.
317. После stock-report search affordance alignment `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `86 passed`, `npm run build` — ok.
318. Проведен `web movement SKU/unit search hardening` pass: `buildMovementSearchText` расширен токенами `movement.product.sku` и `movement.product.unit`, чтобы движения находились не только по названию товара, но и по операционным идентификаторам позиции.
319. Movement-search placeholder в `DashboardView` и `MovementsView` синхронизирован как `...товару, SKU, единице...`; добавлены smoke-кейсы на SKU-based lookup (`sku-1`) для обоих экранов движений.
320. После movement SKU/unit search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `88 passed`, `npm run build` — ok.
321. Проведен `web inventory session comment-search hardening` pass: `buildInventorySessionSearchText` расширен токеном `session.comment`, чтобы сессии инвентаризации находились по тексту комментария без смены даты/статуса.
322. Session-search placeholder в `DashboardView` и `InventoryView` синхронизирован как `...дате, комментарию или позициям`; добавлены smoke-кейсы на comment-based lookup (`сверка`) для обоих экранов.
323. После inventory session comment-search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `90 passed`, `npm run build` — ok.
324. Проведен `web audit log-id search hardening` pass: audit-search в `AuditView` расширен токеном `log.id`, чтобы owner мог находить конкретную запись журнала по ее прямому идентификатору, а не только по `entityId`.
325. Добавлен smoke-кейс на log-id lookup (`audit-1`) для `AuditView`; это закрепляет owner-facing сценарий точечного поиска по идентификатору записи аудита.
326. После audit log-id search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `91 passed`, `npm run build` — ok.
327. Проведен `web audit separator-free search hardening` pass: в `AuditView` добавлен fallback-поиск по compact-токенам без разделителей (`.`, `_`, `-`, пробелы), чтобы технические запросы вроде `inventoryfinished` находили запись так же, как `inventory.finished`.
328. `normalizeAuditToken` расширен до удаления всех небуквенно-цифровых разделителей; добавлен smoke-кейс `AuditView supports separator-free technical search token` для запроса `inventoryfinished`.
329. После audit separator-free search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `92 passed`, `npm run build` — ok.
330. Проведен `web team compact-phone search hardening` pass: `buildTeamUserSearchText` расширен digits-only токеном телефона, чтобы поиск сотрудников работал и по компактному номеру без `+`, пробелов и дефисов.
331. Добавлен smoke-кейс `TeamView supports search by compact phone digits` с запросом `79001111111`; это закрепляет phone-search сценарий для owner/manager без зависимости от форматирования номера в карточке сотрудника.
332. После team compact-phone search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `93 passed`, `npm run build` — ok.
333. Проведен `web movement unit-search test hardening` pass: закреплено отдельное smoke-покрытие unit-aware поиска движений (`unit` токен из `buildMovementSearchText`) для dashboard-сводки и standalone журнала движений.
334. Добавлены тесты `DashboardView supports movement search by product unit` и `MovementsView supports search by product unit` с запросом `шт`, чтобы исключить регресс unit-based lookup после будущих refactor поискового контура.
335. После movement unit-search test hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `95 passed`, `npm run build` — ok.
336. Проведен `web inventory finishedAt search coverage hardening` pass: добавлено отдельное smoke-покрытие поиска сессий по дате завершения (`finishedAt`) для dashboard-сводки и standalone `InventoryView`.
337. Добавлены тесты `DashboardView supports session search by finished date value` и `InventoryView supports session search by finished date value` с запросом `2026-03-04`, чтобы зафиксировать owner/manager-сценарий поиска закрытых сессий.
338. После inventory finishedAt search coverage hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `97 passed`, `npm run build` — ok.
339. Проведен `web movement separator-free type-search hardening` pass: `buildMovementSearchText` расширен compact-токеном `movementType` без `_`, чтобы технические запросы вроде `inventorydiff` находили операции типа `INVENTORY_DIFF`.
340. Добавлены smoke-кейсы `DashboardView supports movement search by separator-free operation token` и `MovementsView supports search by separator-free operation token`, закрепляющие поиск по type-token без разделителей.
341. После movement separator-free type-search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `99 passed`, `npm run build` — ok.
342. Проведен `web product compact-barcode search hardening` pass: в `ProductsView` search-контур расширен digits-only токеном штрихкода, чтобы товар находился по номеру без дефисов и пробелов.
343. Добавлен smoke-кейс `ProductsView supports search by compact barcode digits` с запросом `46012345`; это закрепляет barcode lookup в формате, удобном для ручного ввода и сканеров.
344. После product compact-barcode search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `100 passed`, `npm run build` — ok.
345. Проведен `web product separator-free SKU search hardening` pass: в `ProductsView` search-контур расширен compact-токеном SKU без разделителей, чтобы запросы вроде `sku1` находили позиции c `SKU-1`.
346. Добавлен smoke-кейс `ProductsView supports search by separator-free sku token`, который закрепляет SKU lookup без дефиса и предотвращает регресс после будущих refactor поисковой логики.
347. После product separator-free SKU search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `101 passed`, `npm run build` — ok.
348. Проведен `web movement compact-id search hardening` pass: `buildMovementSearchText` расширен compact-токенами `movement.id`, `product.id` и `createdBy.id`, чтобы поиск по идентификаторам работал и без дефисов.
349. Добавлены smoke-кейсы `DashboardView supports movement search by compact movement id` и `MovementsView supports search by compact movement id` с запросом `movement1`, фиксирующие поддержку ID lookup в compact-формате.
350. После movement compact-id search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `103 passed`, `npm run build` — ok.
351. Проведен `web inventory session compact-id search hardening` pass: `buildInventorySessionSearchText` расширен compact-токенами `session.id` и `startedBy.id`, чтобы поиск сессий работал по ID без дефисов.
352. Добавлены smoke-кейсы `DashboardView supports session search by compact session id` и `InventoryView supports session search by compact session id` с запросом `inv2026030301`, закрепляющие compact-ID lookup для инвентаризационных сессий.
353. После inventory session compact-id search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `105 passed`, `npm run build` — ok.
354. Проведен `web team compact-id search hardening` pass: `buildTeamUserSearchText` расширен compact-токеном `user.id`, чтобы поиск сотрудников по ID работал и без дефисов.
355. Добавлен smoke-кейс `TeamView supports search by compact user id` с запросом `77777777777777777777777777777777`, закрепляющий owner/manager-сценарий поиска сотрудника по идентификатору в компактном формате.
356. После team compact-id search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `106 passed`, `npm run build` — ok.
357. Проведен `web movement compact-SKU search hardening` pass: `buildMovementSearchText` расширен compact-токеном SKU без разделителей, чтобы запросы `sku1` находили движения с `SKU-1`.
358. Добавлены smoke-кейсы `DashboardView supports movement search by separator-free product sku token` и `MovementsView supports search by separator-free product sku token`, закрепляющие compact SKU lookup в обоих журналах движений.
359. После movement compact-SKU search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `108 passed`, `npm run build` — ok.
360. Проведен `web movement compact-actor-id search coverage` pass: добавлены smoke-кейсы на поиск движений по `createdBy.id` в compact-формате (`owner1`) для dashboard-сводки и standalone журнала движений.
361. Тесты `DashboardView supports movement search by compact actor id` и `MovementsView supports search by compact actor id` закрепляют существующую поддержку compact user-id lookup и защищают от регрессий после рефакторинга search-токенов.
362. После movement compact-actor-id coverage pass `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `110 passed`, `npm run build` — ok.
363. Проведен `web inventory compact-actor-id search coverage` pass: добавлены smoke-кейсы на поиск инвентаризационных сессий по `startedBy.id` в compact-формате (`owner1`) для dashboard-сводки и standalone `InventoryView`.
364. Тесты `DashboardView supports session search by compact actor id` и `InventoryView supports session search by compact actor id` закрепляют поддержку compact user-id lookup в поиске сессий.
365. После inventory compact-actor-id coverage pass `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `112 passed`, `npm run build` — ok.
366. Проведен `web team compact-email search hardening` pass: `buildTeamUserSearchText` расширен compact-токеном email без `@`/`.` и прочих разделителей, чтобы поиск сотрудников работал по строке вида `alinexusskladlocal`.
367. Добавлен smoke-кейс `TeamView supports search by compact email token`; он закрепляет owner/manager-сценарий поиска по email в compact-формате.
368. После team compact-email search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `113 passed`, `npm run build` — ok.
369. Проведен `web products ID-search hardening` pass: `ProductsView` search-контур расширен токенами `product.id` и compact `product.id` (без дефисов), чтобы карточки находились по техническому идентификатору.
370. Products-search placeholder синхронизирован как `Поиск по ID, названию, SKU, штрихкоду, категории или единице`; добавлены smoke-кейсы `ProductsView supports search by product id` и `ProductsView supports search by compact product id`.
371. После products ID-search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `115 passed`, `npm run build` — ok.
372. Проведен `web movement compact-date search hardening` pass: `buildMovementSearchText` расширен digits-only токеном `createdAt`, чтобы даты движений находились и в compact-формате (`20260303`).
373. Добавлены smoke-кейсы `DashboardView supports movement search by compact date value` и `MovementsView supports search by compact date value`, закрепляющие compact date lookup в обоих представлениях движения.
374. После movement compact-date search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `117 passed`, `npm run build` — ok.
375. Проведен `web inventory compact-finished-date search hardening` pass: `buildInventorySessionSearchText` расширен digits-only токенами `startedAt/finishedAt`, чтобы поиск сессий работал по compact-формату даты (`YYYYMMDD`).
376. Добавлены smoke-кейсы `DashboardView supports session search by compact finished date value` и `InventoryView supports session search by compact finished date value` с запросом `20260304`; это закрепляет lookup закрытых сессий без разделителей даты.
377. После inventory compact-finished-date search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `119 passed`, `npm run build` — ok.
378. Проведен `web team compact-invite-date search hardening` pass: `buildTeamUserSearchText` расширен digits-only токеном `inviteExpiresAt`, чтобы поиск по дате приглашения работал и в compact-формате (`YYYYMMDD`).
379. Добавлен smoke-кейс `TeamView supports search by compact invite date value` с запросом `20260309`; это закрепляет owner/manager-сценарий поиска pending-invite сотрудников без разделителей даты.
380. После team compact-invite-date search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `120 passed`, `npm run build` — ok.
381. Проведен `web audit entity-id search coverage` pass: добавлены smoke-кейсы на поиск аудита по `entityId` в raw и compact формате (`inventory-1` и `inventory1`), чтобы owner мог точечно находить изменения конкретной сущности.
382. Тесты `AuditView supports search by entity id` и `AuditView supports search by compact entity id` закрепляют поиск по `entityId` независимо от разделителей.
383. После audit entity-id search coverage pass `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `122 passed`, `npm run build` — ok.
384. Проведен `web audit compact-id coverage` pass: добавлены smoke-кейсы на поиск аудита по compact `user.id` (`owner1`) и compact `log.id` (`audit1`), чтобы технический lookup работал без дефисов.
385. Тесты `AuditView supports search by compact user id` и `AuditView supports search by compact log id` закрепляют fallback-поиск по compact token-формату в owner-facing журнале действий.
386. После audit compact-id coverage pass `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `124 passed`, `npm run build` — ok.
387. Проведен `web audit compact-entity-token/date search coverage` pass: добавлены smoke-кейсы на поиск аудита по compact entity type token (`inventorysession`) и compact date token (`20260303`), чтобы owner lookup оставался устойчивым к формату запроса.
388. Тесты `AuditView supports search by compact entity type token` и `AuditView supports search by compact date value` закрепляют поддержку separator-free поиска по типу сущности и дате события.
389. После audit compact entity-token/date coverage pass `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `126 passed`, `npm run build` — ok.
390. Проведен `web category ID-search hardening` pass: в `ProductsView` category-search расширен токенами `category.id`, `parentId` и их compact-формами, чтобы техпоиск категорий работал как с дефисами, так и без.
391. Category-search placeholder обновлен до `Поиск по ID, категории или родителю`; добавлены smoke-кейсы `ProductsView supports category search by category id` и `ProductsView supports category search by compact category id`.
392. После category ID-search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `128 passed`, `npm run build` — ok.
393. Проведен `web category parent-id search coverage` pass: добавлены smoke-кейсы на поиск категорий по `parentId` в raw и compact формате (`root-9` и `root9`), чтобы закрепить lookup дочерних категорий по техническому идентификатору родителя.
394. Тесты `ProductsView supports category search by parent id` и `ProductsView supports category search by compact parent id` фиксируют, что category-search не теряет записи с совпадением по `parentId`.
395. После category parent-id search coverage pass `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `130 passed`, `npm run build` — ok.
396. Проведен `web category compact-name search hardening` pass: category-search в `ProductsView` расширен compact-токенами названия категории и названия родителя, чтобы separator-free запросы (без пробелов/дефисов) продолжали находить нужные записи.
397. Добавлены smoke-кейсы `ProductsView supports category search by separator-free category name token` и `ProductsView supports category search by separator-free parent name token`, закрепляющие поиск по compact name token-формату.
398. После category compact-name search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `132 passed`, `npm run build` — ok.
399. Проведен `web category separator-variant search hardening` pass: в category-search добавлен compact fallback для запроса (`compactCategorySearch`), чтобы запросы с отличающимися разделителями (`-`, пробелы, пунктуация) стабильно совпадали с category/parent name token-ами.
400. Добавлены smoke-кейсы `ProductsView supports category search by separator-variant category name token` и `ProductsView supports category search by separator-variant parent name token`, закрепляющие поиск по hyphenated запросам.
401. После category separator-variant search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `134 passed`, `npm run build` — ok.
402. Проведен `web product separator-variant search hardening` pass: в product-search добавлен compact fallback для запроса (`compactProductSearch`), чтобы поиск товаров оставался устойчивым к разным разделителям в SKU и product ID.
403. Добавлены smoke-кейсы `ProductsView supports search by separator-variant sku token` и `ProductsView supports search by separator-variant product id token`, закрепляющие поиск по запросам вида `sku 1` и `UUID` со space-разделителями.
404. После product separator-variant search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `136 passed`, `npm run build` — ok.
405. Проведен `web movement separator-variant search hardening` pass: в `DashboardView` и `MovementsView` добавлен compact fallback для movement-search запроса, чтобы технические токены (`INVENTORY_DIFF`, IDs и пр.) стабильно находились при отличающихся разделителях.
406. Добавлены smoke-кейсы `DashboardView supports movement search by separator-variant operation token` и `MovementsView supports search by separator-variant operation token` с запросом `inventory diff`.
407. После movement separator-variant search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `138 passed`, `npm run build` — ok.
408. Проведен `web inventory session separator-variant search hardening` pass: в поиске сессий `DashboardView` и `InventoryView` добавлен compact fallback для query-строки, чтобы lookup по `session.id` и смежным токенам работал независимо от разделителей.
409. Добавлены smoke-кейсы `DashboardView supports session search by separator-variant session id token` и `InventoryView supports session search by separator-variant session id token` с запросом `inv 20260303 01`.
410. После inventory session separator-variant search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:contract` — `8 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `140 passed`, `npm run build` — ok.
411. Проведен `movement journal/day-slice integrity` pass: `/v1/movements` расширен query-параметрами `offset`, `dateFrom`, `dateTo`, а `apps/web` разделил полный журнал движений и date-scoped dashboard-срез, чтобы сводка дня больше не подмешивала чужие даты и не работала на усеченных `limit=30`.
412. В `apps/web` добавлены client-side tests `fetchAllMovements paginates through the full movement history` и `fetchAllMovements forwards date filters for dashboard day slices`; в `apps/api` smoke-suite расширен проверками offset/date-range фильтрации для `GET /v1/movements`.
413. После movement journal/day-slice integrity pass доступны локально подтверждены: `packages/shared npm run check` — ok, `apps/api npm run check` — ok, `apps/web npm run check` — ok, `npm run test:contract` — `10 passed`, `npm run test:recovery` — `14 passed`, `npm run test:render` — `140 passed`, `npm run build` — ok.
414. Проведен `audit trail pagination integrity` pass: `/v1/audit` расширен query-параметром `offset`, а `apps/web` переведен на `fetchAllAuditLogs`, чтобы audit view и CSV-экспорт не обрезались первой страницей при росте журнала.
415. Добавлены проверки `fetchAllAuditLogs paginates through the full audit trail`, `fetchAllAuditLogs forwards active audit filters across pages` и smoke-кейс на `GET /v1/audit?limit=1&offset=1`, фиксирующие полную выгрузку и корректный carry-over фильтров.
416. После audit trail pagination integrity pass локально подтверждены: `packages/shared npm run codegen:openapi:check` — ok, `npm run check` — ok; `apps/api npm run check` — ok, `npm run test:smoke` — `2 passed`, `npm run test:contract` — `9 passed`; `apps/web npm run check` — ok, `npm run test:contract` — `12 passed`, `npm run build` — ok.
417. Проведен `stock report completeness integrity` pass: `apps/web` перестал форсировать `limit=100` в `/v1/reports/stock`, а `apps/api` больше не применяет default `take: 100`, чтобы остатки, low-stock summary и CSV-экспорт считались по полному набору товаров.
418. Добавлены проверки `fetchStockReport does not force a default limit for full stock exports`, `fetchStockReport forwards explicit limit when requested` и smoke-кейс с 101 seeded товарами, фиксирующий отсутствие silent truncation и корректную low-only выборку после сотого товара.
419. После stock report completeness integrity pass локально подтверждены: `apps/api npm run check` — ok, `npm run test:smoke` — `2 passed`, `npm run test:contract` — `9 passed`; `apps/web npm run check` — ok, `npm run test:contract` — `14 passed`, `npm run build` — ok.
420. Проведен `web export parity` pass: экспорт из `ProductsView`, `MovementsView`, `InventoryView` и `AuditView` переведен на текущий видимый срез, чтобы CSV учитывал локальные quick-filters, поиск и sort-mode, а не исходный необработанный массив из `App`.
421. В `apps/web/src/app/App.tsx` вынесены selector-helper'ы `selectVisibleProducts`, `selectVisibleMovements`, `selectVisibleInventorySessions`, `selectVisibleStockReportItems`, `selectVisibleAuditLogs`, что убрало дублирование filter/search/sort логики между таблицей и export callback.
422. После web export parity pass локально подтверждены: `apps/web npm run check` — ok, `npm run test:render` — `144 passed`, `npm run build` — ok.
423. Проведен `web team separator-variant search hardening` pass: в `TeamView` добавлен compact fallback для query-строки, чтобы поиск сотрудников стабильно находил `user.id` и email при разных разделителях, а не только при уже нормализованных токенах.
424. Добавлены smoke-кейсы `TeamView supports search by separator-variant user id token` и `TeamView supports search by separator-variant email token`, закрепляющие запросы вида `7777 7777 ...` и `ali nexussklad local`.
425. После team separator-variant search hardening `apps/web` quality gate снова зеленый: `npm run check` — ok, `npm run test:render` — `146 passed`, `npm run build` — ok.
426. Проведен `reporting export preview parity` pass: `ReportingView` теперь строит preview filename для audit export с теми же `users`, что и реальный download callback, чтобы карточка выгрузки не показывала одно имя файла, а скачивание не выдавало другое при active `auditFilters.userId`.
427. Добавлен smoke-кейс на audit export card в `ReportingView renders active export context`, фиксирующий preview имени файла с user-based token вместо анонимного `userId`.
428. После reporting export preview parity pass локально подтверждены: `apps/web npm run check` — ok, `npm run test:render` — `146 passed`, `npm run build` — ok.
429. Проведен `reporting audit context badge parity` pass: `ReportingView` теперь прокидывает `users` и в `collectAuditFilterBadges`, чтобы блок "Контекст журнала" показывал фактическое имя выбранного сотрудника, а не generic placeholder `Пользователь: выбран вручную`.
430. Smoke-кейс `ReportingView renders active export context` расширен проверкой badge `Пользователь: Мурад И.` рядом с audit export preview, чтобы контекст карточки и download metadata больше не расходились.
431. После reporting audit context badge parity pass локально подтверждены: `apps/web npm run check` — ok, `npm run test:render` — `146 passed`, `npm run build` — ok.
432. Проведен `inventory day-scoped copy alignment` pass: `InventoryView` больше не маркирует date-scoped экран как "сегодня" и переведен на нейтральные формулировки `Сессии за день`, `Дата: ...`, `За выбранный день ...`, чтобы подписи не врали при просмотре архива за прошлые даты.
433. Smoke-кейс `InventoryView renders empty session CTA and stock filters context` обновлен проверками `Сессии за день`, `Дата: 2026-03-03` и `За выбранный день сессий инвентаризации нет`, фиксирующими копирайт вокруг date picker.
434. После inventory day-scoped copy alignment pass локально подтверждены: `apps/web npm run check` — ok, `npm run test:render` — `146 passed`, `npm run build` — ok.
435. Проведен `dashboard mixed-scope metric copy alignment` pass: в `DashboardView` метрики переименованы в `Текущий низкий остаток`, `Движения за день`, `Товаров в каталоге`, чтобы top-cards не выглядели как единый day-scoped блок при фактически смешанных текущих и дневных данных.
436. Smoke-кейс `DashboardView renders session filter controls and summary badges` расширен проверками новых metric labels, фиксирующими различие между текущим состоянием каталога и операциями выбранного дня.
437. После dashboard mixed-scope metric copy alignment pass локально подтверждены: `apps/web npm run check` — ok, `npm run test:render` — `146 passed`, `npm run build` — ok.
438. Проведен `reporting mixed-scope daily badge alignment` pass: в `ReportingView` badge `Низкий остаток` переименован в `Текущий низкий остаток`, потому что `daily report` получает это число из текущего stock snapshot каталога, а не из исторического состояния на выбранную дату.
439. Smoke-кейс `ReportingView renders active export context` расширен проверкой `Текущий низкий остаток: 0`, чтобы сводка дня больше не маскировала current-state метрику под day-scoped показатель и использовала фактический `report.stock.lowStockCount`.
440. После reporting mixed-scope daily badge alignment pass локально подтверждены: `apps/web npm run check` — ok, `npm run test:render` — `146 passed`, `npm run build` — ok; smoke-кейс использует фактическое значение `report.stock.lowStockCount`, поэтому проверка зафиксирована на `Текущий низкий остаток: 0`.
441. Проведен `reporting stock-export scope parity` pass: `ReportingView` и реальный `onExportStock` переведены на отдельные stock-report helper'ы без `date`, потому что `/v1/reports/stock` не принимает дату и date-token в badges/filename вводил в заблуждение.
442. `InventoryView` переведен на тот же `collectStockReportFilterBadges`, чтобы stock-report контекст в разных экранах опирался на одну и ту же date-agnostic семантику.
443. После reporting stock-export scope parity pass локально подтверждены: `apps/web npm run check` — ok, `npm run test:render` — `146 passed`, `npm run build` — ok; smoke-кейс фиксирует `Дата сводки: 2026-03-03` отдельно от stock export filename `nexussklad-stock-report-cola-напитки-low-only.csv`.
444. Проведен `stock report metric scope copy alignment` pass: metric card `Низкий остаток` в `ReportingView` и `InventoryView` переименован в `Низкий остаток в отчете`, потому что он показывает не глобальный low-stock count компании, а `stockReport.summary.lowStockItems` для текущего фильтрованного stock-report среза.
445. Smoke-кейсы `ReportingView renders active export context` и `InventoryView renders empty session CTA and stock filters context` расширены проверкой label `Низкий остаток в отчете`, чтобы карточки summary не маскировали report-scoped счетчик под абсолютную метрику каталога.
446. После stock report metric scope copy alignment pass локально подтверждены: `apps/web npm run check` — ok, `npm run test:render` — `146 passed`, `npm run build` — ok.
447. Проведен `reporting audit-only empty-state integrity` pass: `ReportingView` больше не показывает `Экспортировать пока нечего`, если у owner есть доступный `auditLogs` export при пустых товарах, движениях и stock report.
448. Добавлен smoke-кейс `ReportingView does not show empty state when only audit export has data`, фиксирующий owner-only сценарий с единственным доступным export source из журнала изменений.
449. После reporting audit-only empty-state integrity pass локально подтверждены: `apps/web npm run check` — ok, `npm run test:render` — `147 passed`, `npm run build` — ok.
450. Проведен `audit empty-state semantics` pass: `AuditView` теперь различает полностью пустой журнал и пустой результат из-за active server-side filters, чтобы экран без фильтров не маркировался как filtered state.
451. Добавлены smoke-кейсы `AuditView renders empty filtered state` и `AuditView renders filtered empty state when server-side filters remove all logs`, фиксирующие обе ветки no-data semantics вместе с badge-контекстом активных фильтров.
452. После audit empty-state semantics pass локально подтверждены: `apps/web npm run check` — ok, `npm run test:render` — `148 passed`, `npm run build` — ok.
453. Проведен `inventory stock-summary copy parity` pass: в `InventoryView` badge `Сводка отчета` переведен на `Низкий остаток в отчете`, чтобы summary block не расходился с metric card и не маскировал report-scoped low-stock count под абсолютный показатель каталога.
454. После inventory stock-summary copy parity pass локально подтверждены: `apps/web npm run check` — ok, `npm run test:render` — `148 passed`, `npm run build` — ok.
455. Проведен `team owner-only empty-state integrity` pass: `TeamView` переведен на managed-users semantics без owner, потому что `/v1/users` включает владельца и прежнее условие `users.length === 0` делало empty-state `кроме владельца` недостижимым в реальном потоке.
456. Добавлен smoke-кейс `TeamView renders owner-only company as empty team state`, фиксирующий сценарий, где в company user list есть только владелец, а экран все равно должен показывать CTA на приглашение сотрудников вместо таблицы с owner row.
457. После team owner-only empty-state integrity pass локально подтверждены: `apps/web npm run check` — ok, `npm run test:render` — `149 passed`, `npm run build` — ok.
458. Проведен `product uncategorized integrity` pass: `ProductsView` переведен на единый predicate `isProductUncategorized`, потому что row UI уже показывает `Без категории` по `category === null`, а summary/filter раньше опирались только на `categoryId` и расходились при dangling relation.
459. Добавлен smoke-кейс `ProductsView treats missing category relation as uncategorized`, фиксирующий сценарий с `categoryId` при `category: null`, чтобы summary badge и quick-filter `Без категории` совпадали с тем, что реально видит пользователь в таблице.
460. После product uncategorized integrity pass локально подтверждены: `apps/web npm run check` — ok, `npm run test:render` — `150 passed`, `npm run build` — ok.
461. Проведен `audit filter normalization` pass: `entityType` и `action` в audit/reporting теперь нормализуются к API-совместимому виду (`PRODUCT` -> `product`, `PRODUCT_UPDATED` -> `product.updated`), чтобы case/separator variants не ломали server-side выборку и export metadata.
462. После audit filter normalization pass локально подтверждены: `apps/web npm run check` — ok, `npm run test:render` — `150 passed`, `npm run build` — ok; smoke-кейс `ReportingView renders active export context` фиксирует normalized badges `Сущность: товар` и `Действие: Обновление: товар`.
