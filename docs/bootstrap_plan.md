# NexusSklad Bootstrap Plan

Дата: 4 марта 2026
Статус: активный execution plan

## Цель

Подготовить проект к реальной разработке без хаоса.

## Порядок

1. Зафиксировать PRD.
2. Описать user flows.
3. Зафиксировать database schema.
4. Инициализировать `apps/api`.
5. Инициализировать `apps/mobile`.
6. Подготовить базовые shared contracts.
7. После этого начать реализацию MVP 0.1.

## Прогресс по шагам

0. `completed` — закрыт первый production-hardening пакет:
   - dev auth fallback отключен вне `development`
   - mobile auth session переведена на secure storage
   - offline queueing ограничен только сетевыми ошибками
   - backend contract/smoke checks и mobile test suite снова зеленые
0.1. `completed` — добавлен fail-fast startup guard:
   - API не стартует в non-development окружении с активными `DEFAULT_*` dev fallback переменными
0.2. `completed` — выполнен первый UI smoke workflow:
   - создан session report
   - создан fix pack
   - automated baseline на staging подтвержден
0.3. `completed` — закрыт production-hardening пакет 2:
   - API валидирует non-development JWT secrets
   - staging/prod-like используют отдельные runtime env files вместо example env
   - внешний staging/prod-like повторно проверен после выката
0.4. `completed` — добавлен deploy/runtime env validation слой:
   - `validate_runtime_env.sh` проверяет обязательные runtime переменные
   - deploy/backup/restore scripts отклоняют placeholder и слабые runtime env значения
0.5. `completed` — выполнена ротация server-side Postgres runtime passwords:
   - staging/prod-like env files на сервере обновлены
   - после ротации повторно пройдены happy-path и smoke checks
0.6. `completed` — добавлен безопасный server sync workflow:
   - `sync_server.sh` исключает server-only runtime env files из обычного rsync
   - исключены также серверные backup-файлы
0.7. `completed` — усилен backup/restore слой:
   - backup пишет `.sql.gz` и `.sha256`
   - restore поддерживает checksum verification и `.sql.gz`
   - добавлены `verify_backup.sh` и `prune_backups.sh`
0.8. `completed` — добавлен container log retention:
   - compose-файлы ограничивают рост docker json logs
   - runtime env validation проверяет log retention параметры
0.9. `completed` — добавлен monitoring baseline:
   - `monitor_snapshot.sh` для quick runtime snapshot
   - `monitor_check.sh` для fail-fast health verification
0.10. `completed` — добавлен cron-ready ops pack:
   - `ops_daily.sh` для ежедневного ops-цикла
   - `ops_crontab.example` для планировщика
   - `install_ops_cron.sh` для установки managed cron block
0.11. `completed` — cron jobs установлены на сервере:
   - managed block добавлен в root crontab
   - повторный запуск installer не дублирует block
0.12. `completed` — добавлен единый quality/release gate:
   - `run_quality_gate.sh` для локального полного quality gate
   - `infra/deploy/release_gate.sh` для server-side release verification
0.13. `completed` — усилен owner reporting/audit UX в `apps/web`:
   - export filenames учитывают текущие report/audit filters
   - reporting screen показывает активный export context
   - audit screen показывает summary badges и reset filters
0.14. `completed` — усилен inventory/reporting UX в `apps/web`:
   - `InventoryView` показывает CTA на первую сессию и summary по draft/completed sessions
   - stock report показывает активный filter context и reset filters
0.15. `completed` — усилен team/company owner UX в `apps/web`:
   - `TeamView` показывает summary badges по ролям и активным/неактивным пользователям
   - `CompanyPanel` показывает completeness badges и дату создания компании
0.16. `completed` — усилен products/movements operator UX в `apps/web`:
   - `ProductsView` показывает summary badges по low stock и uncategorized товарам
   - `MovementsView` показывает summary badges по типам операций
0.17. `completed` — усилен modal/forms UX в `apps/web`:
   - modal forms получили helper texts по смыслу действия
   - submit CTA стали точнее для product/movement/company/invite/user/category flows
0.18. `completed` — усилен reporting insights UX в `apps/web`:
   - `ReportingView` показывает daily summary badges по операциям и инвентаризации
   - export center явно связывает выгрузки с daily report контекстом
0.12. `completed` — выполнен legacy cleanup:
   - `/root/skladly` удален с сервера
   - legacy backup path больше не мешает operational контуру
0.10. `completed` — добавлен cron-ready ops pack:
   - `ops_daily.sh` для ежедневного ops-цикла
   - `ops_crontab.example` для планировщика на сервере
0.7. `completed` — усилен backup/restore слой:
   - backup пишет `.sql.gz` и `.sha256`
   - restore поддерживает checksum verification и `.sql.gz`
   - добавлен `verify_backup.sh`

1. `completed` — PRD зафиксирован.
2. `completed` — user flows описаны.
3. `completed` — database schema описана и переведена в Prisma schema.
4. `completed` — `apps/api` инициализирован, локальная БД поднята, первая миграция и seed готовы.
5. `completed` — `apps/mobile` инициализирован, Docker-based Flutter workflow подготовлен, login/dashboard flow подключен к API.
6. `completed` — `packages/shared` создан с базовыми контрактами и response envelopes.
7. `in_progress` — реализация MVP 0.1 началась с модулями `auth`, `audit`, `company`, `users`, `categories`, `products`, `movements`, `inventory`, `reports`, role guards, refresh/logout policy, register/invite flow, mobile shell, inventory flow, team/company screens, shared contracts, backend route typing, DTO mapping, OpenAPI groundwork, web admin shell, destructive/admin workflows, real codegen, generated OpenAPI typing в `apps/web` и `apps/api`, contract-driven mobile transport parsing, Dart codegen scaffold, реальный generated Dart client, first-class generated auth/products/movements/inventory/team-company transport typing, упрощенный mobile data-слой без proxy transport файлов, inventory/reporting workflows в `apps/web`, reporting filters, centralized export/report view, staging/deploy контур, первый локальный staging run, внешний staging run на сервере, production hardening pack, разведение staging/prod compose namespaces и audit trail для CRUD.
8. `completed` — подготовлен domain/HTTPS groundwork:
   - `.env.domains.example`
   - `render_nginx_site.sh`
   - `nginx/nexussklad-staging.conf.template`
   - `nginx/nexussklad-production.conf.template`
   - `DOMAIN_CUTOVER_RUNBOOK.md`
9. `completed` — проверено текущее server state перед cutover:
   - host `nginx` установлен
   - `certbot` пока отсутствует
   - будущая схема доменов опирается на upstream-порты `8080` и `8081`
10. `completed` — добавлен mobile offline-ready read layer:
   - локальная auth session persistence
   - startup bootstrap из cache
   - cache fallback для dashboard, categories, products, movements, company и users
11. `completed` — добавлен первый mobile write-sync scope:
   - offline queue для movement operations
   - ручной sync/retry через экран движений
   - queue indicator в UI
12. `completed` — добавлен inventory offline write-sync scope:
   - queue для inventory item updates
   - ручной sync/retry через экран инвентаризации
   - finish flow блокируется до синхронизации очереди
13. `completed` — добавлен company offline write-sync scope:
   - singleton queue для company update
   - sync/retry через экран команды
   - локальное обновление company name в auth session
14. `completed` — добавлен product update offline write-sync scope:
   - queue по `productId`
   - overlay pending updates поверх product list
   - sync/retry через экран товаров
15. `completed` — добавлен user update offline write-sync scope:
   - queue по `userId`
   - overlay pending updates поверх team list
   - sync/retry через экран команды
16. `completed` — добавлен базовый conflict handling для queued updates:
   - backend `error.code` теперь пробрасывается в mobile `ApiException`
   - введена общая классификация offline sync blockers
   - `product` и `user` queues не блокируют синхронизацию всех остальных элементов из-за одного конфликта
17. `completed` — добавлен manual clear/discard flow для queued conflicts:
   - clear очереди товаров, движений и инвентаризации
   - discard queue компании
   - clear очереди сотрудников
18. `completed` — добавлен granular retry/discard flow:
   - per-item retry/discard для `product` queued updates
   - per-item retry/discard для `user` queued updates
19. `completed` — добавлен первый reconciliation flow для offline-created entities:
   - `product create` теперь поддерживает offline queue
   - pending create виден в каталоге и поддерживает `retry/discard`
20. `completed` — pending queues стали first-class UI-частью mobile:
   - `products` показывает pending create/update блок всегда, когда есть отложенные операции
   - `team` показывает pending user update блок всегда, когда есть отложенные операции
21. `completed` — добавлен offline queue для `inventory start`:
   - pending start виден на экране инвентаризации
   - pending start поддерживает `retry/discard`
22. `completed` — добавлен offline queue для `category create`:
   - pending category create виден на экране товаров
   - pending category create поддерживает `retry/discard`
23. `completed` — добавлен offline queue для `user invite/create`:
   - pending invite виден на экране команды
   - pending invite поддерживает `retry/discard`
24. `completed` — deploy smoke tooling доведен до production-like сценария:
   - `smoke_check.sh` поддерживает `skip-login`
   - staging и production-like внешне проверены
25. `completed` — offline invite flow доведен до рабочего контура:
   - pending invite виден на экране команды
   - pending invite поддерживает `retry/discard`
26. `completed` — добавлен automated backend smoke/integration слой:
   - `apps/api/src/test/api-smoke.test.ts`
   - `npm run test:smoke` валидирует ключевые MVP-сценарии API
27. `completed` — добавлены web/mobile empty-error states для основных экранов:
   - admin shell получил глобальный retry и пустые состояния
   - mobile dashboard/movements получили более явный UX fallback
28. `completed` — добавлен UI smoke checklist для IP-only rollout:
   - `docs/ui_smoke_checklist.md`
   - staging owner/manager login подтверждены
29. `completed` — добавлен server-side staging happy-path script:
   - `infra/deploy/staging_happy_path_check.sh`
   - закрывает owner/manager API-level path на staging
30. `completed` — server-side staging path расширен до полной role matrix проверки:
   - owner/manager/staff login и access guards валидируются автоматически
31. `completed` — подготовлен staging baseline workflow для ручного UI-прогона:
   - `infra/deploy/reset_staging_demo.sh`
   - `docs/ui_smoke_report_template.md`
32. `completed` — добавлен preflight для ручного UI smoke pass:
   - `infra/deploy/prepare_ui_smoke_pass.sh`
   - `docs/ui_smoke_report_latest.md`
33. `completed` — добавлен session starter и triage guide для ручного UI цикла:
   - `infra/deploy/start_ui_smoke_session.sh`
   - `docs/ui_gap_triage.md`
34. `completed` — добавлен fix-pack workflow для findings:
   - `infra/deploy/create_ui_fix_pack.sh`
   - `docs/ui_fix_pack_template.md`
35. `completed` — собран единый QA orchestration workflow:
   - `infra/deploy/run_ui_smoke_workflow.sh`
   - объединяет reset, preflight, session report и fix pack
36. `completed` — добавлен web render smoke test layer:
   - `npm run test:render`
   - критичные empty-state regressions теперь валидируются автоматически
37. `completed` — в `apps/mobile` добавлен shared state-card слой:
   - `lib/core/widgets/state_cards.dart`
   - `ProductsScreen` и `MovementsScreen` используют общие empty/error/sync widgets
38. `completed` — в `apps/mobile` добавлен widget render smoke test layer:
   - `test/widget/render_smoke_test.dart`
   - Dockerized `flutter analyze` и `flutter test` проходят на сервере
39. `completed` — в `apps/mobile` добавлен shared info/pending widget слой:
   - `lib/core/widgets/info_cards.dart`
   - `DashboardScreen`, `InventoryScreen`, `TeamScreen` используют общие info/pending widgets
40. `completed` — mobile render smoke suite расширен до 6 widget tests:
   - empty/error/sync/info/pending states валидируются автоматически
41. `completed` — в `apps/mobile` добавлен domain-specific state widget слой:
   - `lib/core/widgets/domain_state_cards.dart`
   - `dashboard`, `movements`, `inventory` используют reusable domain-state widgets
42. `completed` — mobile render smoke suite расширен до 9 widget tests:
   - покрыты dashboard no-activity, movements empty CTA и pending inventory start
43. `completed` — в `apps/mobile` добавлены reusable domain blocks для `products` и `team` pending flows:
   - `ProductPendingOperationsCard`
   - `TeamPendingOperationsCard`
44. `completed` — mobile render smoke suite расширен до 11 widget tests:
   - покрыты `products` pending operations
   - покрыты `team` pending invite/update operations
45. `completed` — в `apps/mobile` добавлен reusable entity-card слой:
   - `lib/core/widgets/entity_cards.dart`
   - `CompanyStatusCard`, `TeamMemberInfoCard`, `ProductStockCard`
46. `completed` — mobile render smoke suite расширен до 14 widget tests:
   - покрыты company/team/product cards
47. `completed` — в `apps/web` добавлены reusable owner workflow blocks:
   - `CompanyPanel`
   - `ProductTableRow`
   - `TeamUserRow`
48. `completed` — web render smoke suite расширен до 8 tests:
   - покрыты company summary, product row и team user row
49. `completed` — web checks остаются зелеными после рефакторинга:
   - `npm run check`
   - `npm run test:render`
   - `npm run build`
50. `completed` — в `apps/web` добавлены reusable blocks для `inventory` и `reporting`:
   - `InventorySessionRow`
   - `StockReportRow`
   - `ExportCard`
51. `completed` — web render smoke suite расширен до 11 tests:
   - покрыты inventory/reporting reusable blocks
52. `completed` — в `apps/web` добавлены reusable row blocks для `movements` и `audit`:
   - `MovementTableRow`
   - `AuditLogRow`
53. `completed` — web render smoke suite расширен до 13 tests:
   - покрыты reusable rows для `movements` и `audit`
54. `completed` — web modal/forms переведены в first-class testable components:
   - `ProductModal`
   - `MovementModal`
   - `CompanyModal`
   - `InviteModal`
   - `UserModal`
   - `CategoryModal`
55. `completed` — web render smoke suite расширен до 19 tests:
   - покрыты owner/manager modal/forms
56. `completed` — добавлен `infra/deploy/web_deploy_smoke_check.sh`:
   - валидирует deployed root HTML, bundle asset, `/health`, `auth/login`, `auth/me`
   - поддерживает `skip-login` для production-like контура
57. `completed` — добавлен contract integrity gate:
   - `packages/shared/check_openapi_codegen.sh`
   - `packages/shared -> npm run codegen:openapi:check`
   - `./check_contract_integrity.sh`
58. `completed` — в `apps/web` добавлен contract-aware API client:
   - runtime-проверка `module` и envelope shape для `item/list/report`
   - централизованный parsing backend error envelope
59. `completed` — в `apps/web` добавлен `npm run test:contract`:
   - проверяет error envelope parsing
   - проверяет module/report mismatch guards
60. `completed` — в `apps/mobile` добавлен contract hardening для network слоя:
   - `ApiContractException`
   - `parseApiError(...)`
61. `completed` — в `apps/mobile` добавлен `test/network/api_contract_test.dart`:
   - валидирует runtime envelope guards
   - валидирует backend error envelope parsing
62. `completed` — в `apps/api` добавлен `npm run test:contract`:
   - валидирует `health`, `auth`, `item/list/report` envelopes
   - валидирует error envelope для `AppError` и `404`
63. `completed` — в `apps/api` добавлен стабильный `NOT_FOUND` error envelope.
64. `completed` — `docs/openapi_v1.yaml` усилен shared error response components:
   - `UnauthorizedError`
   - `ForbiddenError`
   - `NotFoundError`
   - `ConflictError`
   - `InternalServerError`
65. `completed` — OpenAPI error responses явно описаны для core routes и regenerated в `packages/shared/src/generated/openapi.ts`.
66. `completed` — в `apps/api` добавлен route schema hardening на уровне Fastify `schema.response`.
67. `completed` — добавлен `apps/api/src/lib/response-schemas.ts` для envelope/error response schemas.
68. `completed` — API checks после route schema hardening остаются зелеными:
   - `npm run test:contract`
   - `npm run test:smoke`
69. `completed` — validation errors нормализованы в stable `400 VALIDATION_ERROR` envelope.
70. `completed` — `apps/api/src/test/api-contract.test.ts` расширен validation-сценариями.

## MVP 0.1

Входит:

- auth;
- товары;
- категории;
- остатки;
- приход;
- расход;
- история движений.

## MVP 0.2

- роли;
- аудит;
- инвентаризация;
- базовые отчеты.

## Следующий шаг

1. при необходимости прогнать `infra/deploy/run_ui_smoke_workflow.sh --reset`;
2. затем пройти `docs/ui_smoke_checklist.md`;
3. занести находки в созданный session report и fix pack;
4. при изменениях web держать `npm run test:render` зеленым.
5. при изменениях mobile держать `flutter test test/widget/render_smoke_test.dart` зеленым.
6. при изменениях web держать deploy smoke зеленым:
   - `infra/deploy/web_deploy_smoke_check.sh http://127.0.0.1:8080`
   - `infra/deploy/web_deploy_smoke_check.sh http://127.0.0.1:8081 skip-login`
7. при изменениях OpenAPI/spec-driven слоев держать зеленым:
   - `packages/shared -> npm run codegen:openapi:check`
   - `./check_contract_integrity.sh`
8. при изменениях web transport/client слоя держать зеленым:
   - `apps/web -> npm run test:contract`
   - `apps/web -> npm run test:render`
9. при изменениях mobile transport/client слоя держать зеленым:
   - `flutter test test/network/api_contract_test.dart`
   - `flutter test test/widget/render_smoke_test.dart`
10. при изменениях API error/response слоя держать зеленым:
   - `apps/api -> npm run test:contract`
   - `apps/api -> npm run test:smoke`
11. при изменениях OpenAPI response/error схем держать зеленым:
   - `packages/shared -> npm run codegen:openapi`
   - `packages/shared -> npm run codegen:openapi:check`
   - `./check_contract_integrity.sh`
12. при изменениях API route schema слоя держать зеленым:
   - `apps/api -> npm run test:contract`
   - `apps/api -> npm run test:smoke`
13. при изменениях API validation слоя держать зеленым:
   - `apps/api -> npm run test:contract`
14. при изменениях UX-обработки API ошибок держать зеленым:
   - `apps/web -> npm run test:contract`
   - `flutter test test/network/api_contract_test.dart`
15. при пересборке внешних web-контуров после UI/contract изменений держать зеленым:
   - `infra/deploy/web_deploy_smoke_check.sh http://127.0.0.1:8080`
   - `infra/deploy/web_deploy_smoke_check.sh http://127.0.0.1:8081 skip-login`
16. при изменениях auth/session-expiry UX держать зеленым:
   - `apps/web -> npm run test:contract`
   - `apps/web -> npm run test:render`
   - `flutter test test/network/api_contract_test.dart`
   - `flutter test test/widget/render_smoke_test.dart`
17. при изменениях silent refresh / session recovery flow держать зеленым:
   - `apps/web -> npm run build`
   - `infra/deploy/web_deploy_smoke_check.sh http://127.0.0.1:8080`
   - `infra/deploy/web_deploy_smoke_check.sh http://127.0.0.1:8081 skip-login`
18. при изменениях mobile write-recovery flow держать зеленым:
   - `flutter test test/widget/render_smoke_test.dart`
   - `flutter test test/network/api_contract_test.dart`
19. при изменениях auth-notice UX держать зеленым:
   - `apps/web -> npm run build`
   - `infra/deploy/web_deploy_smoke_check.sh http://127.0.0.1:8080`
   - `infra/deploy/web_deploy_smoke_check.sh http://127.0.0.1:8081 skip-login`
   - `apps/web -> npm run build`
   - `flutter analyze`
   - `flutter test test/widget/render_smoke_test.dart`
20. targeted coverage для session recovery / notices:
   - `apps/web -> LoginForm` render smoke на `notice/error` states
   - `apps/mobile -> AuthController` unit tests на `tryRefreshSession`, `recoverSession`, `expireSession`
21. generated Dart client для mobile должен жить вне `apps/mobile/lib/`:
   - текущее рабочее расположение: `apps/mobile/generated/openapi_client`
   - это нужно для стабильного `flutter test` runtime
22. auth recovery UX держим persistent:
   - `apps/web` показывает inline session notice в signed-in shell до явного dismiss
   - `apps/mobile` показывает dismissible `AuthNoticeCard` в `AppShell`
23. при изменениях auth recovery notices держать зеленым:
   - `apps/web -> npm run test:render`
   - `apps/web -> npm run build`
   - `flutter analyze`
   - `flutter test test/widget/render_smoke_test.dart test/network/api_contract_test.dart test/auth/auth_controller_test.dart`
24. при изменениях offline/conflict UX держать единый стиль:
   - `SyncIssueCard` отвечает за conflict/offline copy
   - `TeamScreen` использует общий `ErrorStateCard`
   - queued-action блоки объясняют последствия retry/discard понятным текстом
25. для `apps/web` owner flows:
   - destructive confirms должны явно предупреждать о необратимости
   - invite flow должен давать понятную инструкцию, что делать с токеном дальше
   - non-owner ограничения показывать через общий `InlineState`
26. для mobile auth/session recovery держать screen-level покрытие хотя бы на одном read-heavy экране:
   - текущее покрытие: `DashboardScreen`
   - сценарий: `401 -> refreshToken -> retry -> updated summary without forced logout`
   - прогонять: `flutter test test/widget/screen_recovery_test.dart`
27. screen-level recovery в mobile расширять через optional repository injection, а не через real API:
   - текущее покрытие: `DashboardScreen`, `ProductsScreen`
   - второй сценарий: `401 -> refreshToken -> retry -> updated products list`
28. следующий минимальный набор mobile recovery coverage для read-heavy flow:
   - `DashboardScreen`
   - `ProductsScreen`
   - `MovementsScreen`
   - прогонять: `flutter test test/widget/screen_recovery_test.dart`
29. для `InventoryScreen` recovery пока фиксируем start-flow:
   - сценарий: `401 -> refreshToken -> retry start inventory -> session visible`
   - completed session в тесте допустима, если это снимает layout noise и не меняет сам recovery contract
30. `TeamScreen` recovery тестировать через repository overrides, а не через реальные queue stores:
   - сценарий: `401 -> refreshToken -> retry company reload`
   - минимальный assert: session жива, companyName в auth session обновлен, screen header обновлен
31. следующий слой mobile auth coverage:
   - write-recovery на `MovementsScreen`
   - сценарий: `401 -> refreshToken -> retry create income`
   - обязательный assert: payload не меняется между первым и повторным вызовом
32. write-recovery tests в mobile не должны опираться на реальные dialog controllers:
   - для `ProductsScreen` использовать `createCategoryNameBuilder`
   - для `MovementsScreen` использовать `movementPayloadBuilder`
   - это нужно, чтобы widget tests не ломались на disposed `TextEditingController`/focus runtime
33. текущий mobile write-recovery coverage:
   - `MovementsScreen: 401 -> refreshToken -> retry create income`
   - `ProductsScreen: 401 -> refreshToken -> retry create category`
   - обязательный прогон: `flutter test test/widget/screen_recovery_test.dart`
34. для `ProductsScreen` write-recovery на создание товара использовать `createProductPayloadBuilder`, а не реальный product dialog.
35. текущий расширенный mobile write-recovery coverage:
   - `MovementsScreen: 401 -> refreshToken -> retry create income`
   - `ProductsScreen: 401 -> refreshToken -> retry create category`
   - `ProductsScreen: 401 -> refreshToken -> retry create product`
   - обязательный прогон: `flutter test test/widget/screen_recovery_test.dart`
36. для `InventoryScreen` write-recovery на изменение фактического остатка использовать `actualQtyBuilder`, а не реальный qty dialog.
37. текущий полный mobile write-recovery coverage:
   - `MovementsScreen: 401 -> refreshToken -> retry create income`
   - `ProductsScreen: 401 -> refreshToken -> retry create category`
   - `ProductsScreen: 401 -> refreshToken -> retry create product`
   - `InventoryScreen: 401 -> refreshToken -> retry patch item`
   - обязательный прогон: `flutter test test/widget/screen_recovery_test.dart`
38. для `TeamScreen` write-recovery на invite использовать `invitePayloadBuilder`, а не реальный invite dialog.
39. текущий полный mobile write-recovery coverage:
   - `MovementsScreen: 401 -> refreshToken -> retry create income`
   - `ProductsScreen: 401 -> refreshToken -> retry create category`
   - `ProductsScreen: 401 -> refreshToken -> retry create product`
   - `InventoryScreen: 401 -> refreshToken -> retry patch item`
   - `TeamScreen: 401 -> refreshToken -> retry invite user`
   - обязательный прогон: `flutter test test/widget/screen_recovery_test.dart`
40. следующий расширенный mobile write-recovery coverage:
   - `MovementsScreen: 401 -> refreshToken -> retry create income`
   - `MovementsScreen: 401 -> refreshToken -> retry create expense`
   - `MovementsScreen: 401 -> refreshToken -> retry create adjustment`
   - `ProductsScreen: 401 -> refreshToken -> retry create category`
   - `ProductsScreen: 401 -> refreshToken -> retry create product`
   - `ProductsScreen: 401 -> refreshToken -> retry update product`
   - `InventoryScreen: 401 -> refreshToken -> retry patch item`
   - `InventoryScreen: 401 -> refreshToken -> retry finish inventory`
   - `InventoryScreen: 401 -> refreshToken -> retry sync queue`
   - `TeamScreen: 401 -> refreshToken -> retry invite user`
   - обязательный прогон: `flutter test test/widget/screen_recovery_test.dart`
41. для web owner/manager action recovery держать единый helper:
   - `src/core/session-actions.ts`
   - retry только один раз после успешного `refreshToken`
42. web quality gate для recovery слоя:
   - `cd apps/web && npm run test:recovery`
   - helper должен покрывать:
     - retry after refresh
     - refresh failure
     - forbidden without retry
     - fallback message for unknown errors
43. destructive owner actions в `apps/web` проводить только через confirm-aware helper:
   - `executeConfirmedSessionAction()`
   - confirm cancel не должен запускать delete operation
44. web recovery suite должен отдельно держать destructive cases:
   - delete cancelled
   - delete retried after refresh
45. текущий бренд зафиксирован как `NexusSklad`; новые изменения, генерация клиента и deploy-конфиги должны использовать только префиксы `NEXUSSKLAD_*`, `nexussklad_*`, `nexussklad-`.
46. после любого rename-level изменения обязательно перепроверять:
   - `./check_contract_integrity.sh`
   - `flutter analyze`
   - `flutter test test/widget/render_smoke_test.dart test/widget/screen_recovery_test.dart test/network/api_contract_test.dart test/auth/auth_controller_test.dart`
47. после server-side rename/migration staging и production-like должны работать уже из `/root/nexussklad`, а не из legacy-пути `/root/skladly`.
48. после такой миграции обязательные deploy проверки:
   - `infra/deploy/web_deploy_smoke_check.sh http://127.0.0.1:8080`
   - `infra/deploy/web_deploy_smoke_check.sh http://127.0.0.1:8081 skip-login`
49. верхнеуровневые продуктовые документы вне репозитория должны поддерживаться в naming-consistent виде:
   - `NEXUSSKLAD_PROJECT.md`
   - `NEXUSSKLAD_BRANDING.md`
   - `NEXUSSKLAD_WIREFRAMES.md`
50. после brand/copy-polish изменений в UI обязательно перепроверять минимум:
   - `cd apps/web && npm run check && npm run test:render && npm run build`
   - `flutter analyze`
51. readiness baseline обязателен для deploy-ready состояния:
   - `GET /health` отвечает за liveness
   - `GET /health/ready` отвечает за readiness и доступность БД
   - `monitor_check.sh` и `monitor_snapshot.sh` должны проверять оба endpoint'а
52. deploy smoke scripts тоже должны проверять оба endpoint'а:
   - `smoke_check.sh`
   - `web_deploy_smoke_check.sh`
53. DB hardening baseline должен включать:
   - `readiness_check.sh` для валидации JSON-контракта `/health/ready`
   - `backup_restore_drill.sh` для безопасного restore-drill во временную БД staging
54. ops policy должна быть разделена:
   - `ops_daily.sh` для ежедневного backup/prune/monitor цикла
   - `ops_weekly.sh` для отдельного readiness + restore drill
55. ops log files тоже должны иметь отдельную policy:
   - `rotate_ops_logs.sh`
   - отдельная cron job на ротацию `/var/log/nexussklad-ops.log` и `/var/log/nexussklad-health.log`
56. security baseline должен включать:
   - browser security headers в `apps/web/nginx.conf`
   - security headers в `apps/api`
   - базовый auth rate limit на `login/register/accept-invite`
57. после security hardening нужно держать spec/env consistency:
   - `openapi_v1.yaml` описывает `429` для auth routes и `/health/ready`
   - env examples содержат `AUTH_RATE_LIMIT_MAX` и `AUTH_RATE_LIMIT_WINDOW_MS`
58. `mobile UX/copy hardening` закрыт: core mobile screens получили product-facing copy, summary chips и clearer CTA; обязательный прогон: `flutter analyze` + `flutter test test/widget/render_smoke_test.dart test/widget/screen_recovery_test.dart test/network/api_contract_test.dart test/auth/auth_controller_test.dart`.
59. следующий шаг по продукту: `mobile modal/forms UX hardening` — привести dialogs `product/movement/company/invite/user/inventory` к тому же уровню helper texts и submit CTA, что уже есть в `apps/web`.

60. `mobile modal/forms UX hardening` закрыт: dialogs `product / movement / inventory / company / invite / user` приведены к product-facing copy, helper texts и submit CTA уже согласованы с `apps/web`; обязательный прогон: `flutter analyze` + `flutter test test/widget/render_smoke_test.dart test/widget/screen_recovery_test.dart test/network/api_contract_test.dart test/auth/auth_controller_test.dart`.
61. следующий шаг по продукту: `manual UI smoke findings -> fix pack` либо, если идем дальше без ручного QA, `mobile summary/entity UX hardening` для карточек компании, товара и инвентаризации.

62. `mobile summary/entity UX hardening` закрыт: entity/status cards переведены на продуктовые русские метки, без англицизмов и с более явным operational state; обязательный прогон: `flutter analyze` + `flutter test test/widget/render_smoke_test.dart test/widget/screen_recovery_test.dart test/network/api_contract_test.dart test/auth/auth_controller_test.dart`.
63. следующий шаг: либо `manual UI smoke findings -> fix pack`, либо deeper mobile polish для inventory/team/product detail cards уже по ручным находкам, а не вслепую.
64. `mobile dialog copy regression` закрыт: в `test/widget/screen_recovery_test.dart` добавлены отдельные widget-сценарии, которые фиксируют copy-контракт для `create category`, `create product`, `movement`, `actual qty` и `invite` dialogs.
65. обязательный прогон после dialog-copy изменений: `flutter analyze` + `flutter test test/widget/render_smoke_test.dart test/widget/screen_recovery_test.dart test/network/api_contract_test.dart test/auth/auth_controller_test.dart`; текущий результат — `48 passed`.
66. следующий шаг: либо `manual UI smoke findings -> fix pack`, либо следующий прикладной product block уже по реальным ручным находкам, а не по общему polish pass.
67. `mobile role/copy consistency` закрыт: остаточные англоязычные метки в `login / dashboard / products / team / entity cards` переведены в единый русский продуктовый copy, включая роли, summary chips и pending labels.
68. обязательный прогон после role/copy consistency pass: `flutter analyze` + `flutter test test/widget/render_smoke_test.dart test/widget/screen_recovery_test.dart test/network/api_contract_test.dart test/auth/auth_controller_test.dart`; текущий результат — `48 passed`.
69. следующий шаг: либо `manual UI smoke findings -> fix pack`, либо следующий продуктовый блок уже от реальных ручных находок, а не от остаточного copy polish.
70. `mobile action feedback hardening` закрыт: snackbar-сообщения для `products / movements / inventory / team` приведены к единому operational copy, без технических CRUD-формулировок и смешения online/offline терминов.
71. обязательный прогон после action-feedback pass: `flutter analyze` + `flutter test test/widget/render_smoke_test.dart test/widget/screen_recovery_test.dart test/network/api_contract_test.dart test/auth/auth_controller_test.dart`; текущий результат — `48 passed`.
72. следующий шаг: либо `manual UI smoke findings -> fix pack`, либо следующий продуктовый блок по мобильному приложению уже от реальных ручных находок.
73. `mobile dashboard insight hardening` закрыт: daily summary теперь содержит breakdown по `приходам / расходам / корректировкам / сверкам / сессиям`, а `DashboardScreen` показывает этот срез в chips рядом с основными summary cards.
74. обязательный прогон после dashboard insight pass: `flutter analyze` + `flutter test test/widget/render_smoke_test.dart test/widget/screen_recovery_test.dart test/network/api_contract_test.dart test/auth/auth_controller_test.dart`; текущий результат — `48 passed`.
75. следующий шаг: либо `manual UI smoke findings -> fix pack`, либо уже следующий прикладной mobile block, если есть конкретная функциональная гипотеза, а не общий polish.
76. `mobile operator workflow hardening` закрыт: `DashboardScreen` получил быстрые действия для `движений / инвентаризации / каталога / команды`, а `AppShell` — tab-opening callbacks с контекстными notice-сообщениями.
77. обязательный прогон после operator workflow pass: `flutter analyze` + `flutter test test/widget/render_smoke_test.dart test/widget/screen_recovery_test.dart test/network/api_contract_test.dart test/auth/auth_controller_test.dart`; текущий результат — `49 passed`.
78. следующий шаг: либо `manual UI smoke findings -> fix pack`, либо уже следующий функциональный product block, а не очередной общий mobile polish pass.
79. `mobile product filtering hardening` закрыт: `ProductsScreen` получил быстрые фильтры `Все / Низкий остаток / Без категории / Офлайн-черновики` и отдельный empty-state для выбранного среза каталога.
80. обязательный прогон после product filtering pass: `flutter analyze` + `flutter test test/widget/render_smoke_test.dart test/widget/screen_recovery_test.dart test/network/api_contract_test.dart test/auth/auth_controller_test.dart`; текущий результат — `50 passed`.
81. следующий шаг: либо `manual UI smoke findings -> fix pack`, либо новый прикладной mobile block уже вокруг конкретных сценариев оператора, а не общего UX polish.
82. `mobile movement filtering hardening` закрыт: `MovementsScreen` получил быстрые фильтры `Все / Приход / Расход / Корректировка / Сверка` и отдельный empty-state для выбранного типа операций.
83. обязательный прогон после movement filtering pass: `flutter analyze` + `flutter test test/widget/render_smoke_test.dart test/widget/screen_recovery_test.dart test/network/api_contract_test.dart test/auth/auth_controller_test.dart`; текущий результат — `51 passed`.
84. следующий шаг: либо `manual UI smoke findings -> fix pack`, либо новый прикладной mobile block уже по inventory/team workflows, а не следующий общий polish pass.
85. `mobile inventory filtering hardening` закрыт: `InventoryScreen` получил быстрые фильтры `Все / Расхождения / Совпадает` и отдельный empty-state для выбранного среза внутри активной сессии.
86. обязательный прогон после inventory filtering pass: `flutter analyze` + `flutter test test/widget/render_smoke_test.dart test/widget/screen_recovery_test.dart test/network/api_contract_test.dart test/auth/auth_controller_test.dart`; текущий результат — `52 passed`.
87. следующий шаг: либо `manual UI smoke findings -> fix pack`, либо следующий прикладной mobile block уже вокруг `team/company` workflows, а не общего UX polish.
88. `mobile team/company workflow hardening` закрыт: `TeamScreen` получил быстрые owner-facing фильтры `Все / Активные / Менеджеры / Сотрудники / Приглашения` и отдельный empty-state для пустого team-среза.
89. pending invite copy в `TeamScreen` приведен к продуктовой формулировке `Приглашение до ...`, чтобы карточки сотрудников и фильтры были консистентны с остальным mobile UX.
90. обязательный прогон после team/company workflow hardening: `flutter analyze` + `flutter test test/widget/render_smoke_test.dart test/widget/screen_recovery_test.dart test/network/api_contract_test.dart test/auth/auth_controller_test.dart`; текущий результат — `52 passed`.
91. `mobile offline movement queue UX` закрыт: `MovementsScreen` теперь показывает явный pending-action блок для локальной очереди движений, а не только счетчик `Очередь: N`.
92. operator-facing CTA для очереди движений зафиксированы как `Отправить сейчас / Очистить очередь`, чтобы offline workflow был понятным без чтения технических сообщений.
93. обязательный прогон после movement queue UX pass: `flutter analyze` + `flutter test test/widget/render_smoke_test.dart test/widget/screen_recovery_test.dart test/network/api_contract_test.dart test/auth/auth_controller_test.dart`; текущий результат — `53 passed`.
94. `mobile offline inventory queue UX` закрыт: `InventoryScreen` теперь показывает явный pending-action блок для локальной очереди item updates, а не только chip `В очереди: N`.
95. inventory offline CTA выровнены с movements: `Отправить сейчас / Очистить очередь`, чтобы состояние локальных изменений было читаемо без входа в technical retry flow.
96. обязательный прогон после inventory queue UX pass: `flutter analyze` + `flutter test test/widget/render_smoke_test.dart test/widget/screen_recovery_test.dart test/network/api_contract_test.dart test/auth/auth_controller_test.dart`; текущий результат — `54 passed`.
97. `mobile products offline queue UX` закрыт: `ProductPendingOperationsCard` теперь показывает batch-level CTA `Отправить все сейчас / Очистить очередь`, если локальные category/product операции не конфликтуют с сервером.
98. products offline UX выровнен с movements/inventory: владелец и менеджер теперь видят не только список pending действий, но и явный общий control для всей очереди каталога.
99. обязательный прогон после products queue UX pass: `flutter analyze` + `flutter test test/widget/render_smoke_test.dart test/widget/screen_recovery_test.dart test/network/api_contract_test.dart test/auth/auth_controller_test.dart`; текущий результат — `55 passed`.
100. `mobile team offline queue UX` закрыт: `TeamPendingOperationsCard` теперь показывает batch-level CTA `Отправить все сейчас / Очистить очередь`, если локальные invites/updates не конфликтуют с сервером.
101. team offline UX выровнен с остальными mobile контурами: владелец получает явный общий control для всей очереди команды, а не только item-level retry/discard.
102. обязательный прогон после team queue UX pass: `flutter analyze` + `flutter test test/widget/render_smoke_test.dart test/widget/screen_recovery_test.dart test/network/api_contract_test.dart test/auth/auth_controller_test.dart`; текущий результат — `56 passed`.

103. `production data policy` усилена: для первого владельца добавлен отдельный `infra/deploy/bootstrap_owner.sh`, чтобы production bootstrap не зависел от demo seed.
104. Публичная регистрация после bootstrap регулируется через `ALLOW_PUBLIC_REGISTRATION`: для production-like/production целевое значение — `false`.
105. runtime env policy ужесточена: `ALLOW_PUBLIC_REGISTRATION` должен быть явно задан в deploy env, чтобы bootstrap/registration режим не оставался неявным.
106. `TeamScreen` получил owner-facing поиск по команде; следующий логичный шаг — прекращать blind polish и переходить к manual UI smoke / fix pack.
107. `web fix pack` начат по реальным скриншотам admin-панели: в первую очередь чистим смешение русского и английского, технические термины и слабые empty-state блоки.
108. текущий пакет закрывает продуктовый copy для `login`, `overview`, `products`, `inventory`, `team`, `reports`, `audit`, а также переводит роли, типы движений и статусы инвентаризации в читаемый русский UI.
109. после фикса этого пакета обязательный прогон: `apps/web -> npm run check && npm run test:contract && npm run test:recovery && npm run test:render && npm run build`, затем sync/rebuild staging и production-like.
110. второй `web fix pack` должен закрывать то, что осталось по live-скринам после первой локализации: human-readable audit rows, менее навязчивые filename blocks в export cards и гарантированное совпадение seed-copy с live staging/prod-like.
111. для audit presentation выбран pragmatic path: summary badges + collapsible `Показать JSON`, а не попытка полностью скрыть payload; это сохраняет управленческую читаемость и не ломает диагностическую ценность журнала.
112. после второго fix pack обязательно: `apps/web` quality gate локально, затем sync на сервер, `npm run prisma:seed` внутри staging/prod-like API и `release_gate.sh`, чтобы live UI и live demo data не расходились.
113. после ручного просмотра новых скринов третий `web fix pack` должен убрать визуальную скученность header/action зон: ключевой критерий — title-блоки, бейджи и CTA не должны визуально прилипать друг к другу ни в `products`, ни в `movements`, ни в `inventory`, ни в `team`, ни в `reports`.
114. `AuditView` для owner больше не должен показывать raw JSON как часть стандартного UI; для pilot-ready режима это отладочная деталь, а не пользовательская ценность. В интерфейсе оставляем только human-readable сводку payload.
115. после следующего live-pass нужно держать принцип: любые summary badges, filter chips и toolbar actions должны собираться в левые логические группы, а не растягиваться `space-between` по всей ширине секции.
116. human-readable audit payload layer больше не должен пропускать технические ключи вроде `beforeQty/afterQty/quantity`; все ключевые поля изменений обязаны отображаться на русском и в управленческом, а не разработческом тоне.
117. Следующий spacing/layout pass по `apps/web` должен убрать остаточные широкие пустоты в `ReportingView`, stock report и `AuditView`: контекстные блоки собираем в компактные полосы (`info-strip`), активные фильтры держим ближе к форме, а summary-бейджи перестаем растягивать на визуально пустые зоны.
118. `ProductModal` в `web` должен быть не только функциональным, но и читаемым с первого взгляда: labels полей делаем заметными, placeholders — вторичными, чтобы создание товара не выглядело как безымянный набор инпутов.
119. После этого пакета обязательный прогон не меняется: `npm run check && npm run test:contract && npm run test:recovery && npm run test:render && npm run build`, затем sync/rebuild `web` на `8080/8081` и `release_gate.sh`.

- Закрыть текущий `web fix pack`: session persistence, modal-state fix и окончательное разведение summary badges и action-toolbar по `products / movements / inventory / reporting`.
- После локального green gate пересобрать live `web` на `8080/8081` и повторно прогнать `release_gate.sh`, чтобы новые owner fixes стали доступны на staging и production-like.
- Локальный full quality gate уже подтвержден вне sandbox-ограничений; следующий шаг по `web` — выкатить compact reporting fixes на live и еще раз проверить `release_gate.sh`.

- latest `web` fix pack focuses on spacing discipline in `ReportingView`/`AuditView` and labeled fields in `ProductModal`; next step is to redeploy and visually verify on staging.

- latest `web` polish removes lingering whitespace in reporting and clarifies product creation fields; live web rebuild and release gate rerun follow this fix pack.

- Web admin: reporting/audit spacing tightened; stock-report и audit filters переведены в более компактный layout.
120. После визуального аудита live-скринов очередной `web` spacing pass должен еще раз сократить пустоты в `ReportingView` и `stock report`, убрать второстепенные метрики из верхних action-зон (`MovementsView`) и поджать header card, чтобы верхний hero-блок не съедал полезную высоту экрана.
- Web fix pack continues to compress reporting/audit context sections and remove ambiguous modal inputs before moving to the next functional block.
