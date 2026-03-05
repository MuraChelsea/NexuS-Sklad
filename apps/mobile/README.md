# NexusSklad Mobile

Flutter mobile shell for `NexusSklad`.

## Цель текущего этапа

- поднять каркас мобильного приложения;
- не зависеть от локальной установки Flutter на macOS 13;
- запускать Flutter-команды через Docker;
- подключить первый реальный flow `login -> me -> daily report`.

## Структура

- `lib/app` — точка входа и shell;
- `lib/core` — конфиг, тема и общие UI-компоненты;
- `lib/features` — экраны и логика по доменным модулям.

## Что уже работает

- login screen
- auth state в памяти
- logout
- dashboard summary из `/v1/reports/daily`
- товары из `/v1/products`
- создание и редактирование товаров из mobile
- движения из `/v1/movements`
- создание движений из mobile:
  - `income`
  - `expense`
  - `adjustment` для `owner/manager`
- инвентаризация:
  - старт сессии
  - обновление фактического остатка
  - завершение сессии
- company screen из `/v1/company`
- team screen из `/v1/users` для owner
- invite flow из `/v1/users/invite`
- редактирование компании из mobile
- редактирование сотрудника из mobile:
  - имя
  - email
  - телефон
  - роль
  - активация/деактивация
  - смена пароля
- contract-driven transport parsing:
  - `lib/core/network/api_contract.dart`
  - `lib/core/network/json_reader.dart`
  - `lib/core/network/transport_mapper.dart`
- generated Dart transport types используются напрямую в repositories для:
  - `auth`
  - `products/categories`
  - `movements`
  - `inventory`
  - `team/company`
- API base url через `dart-define`

## Docker workflow

Все Flutter-команды предполагаются через контейнер:

```bash
docker run --rm \
  -v "$PWD":/workspace \
  -w /workspace \
  ghcr.io/cirruslabs/flutter:stable \
  flutter pub get
```

Примеры:

```bash
docker run --rm -v "$PWD":/workspace -w /workspace ghcr.io/cirruslabs/flutter:stable flutter analyze
docker run --rm -v "$PWD":/workspace -w /workspace ghcr.io/cirruslabs/flutter:stable flutter test
docker run --rm -v "$PWD":/workspace -w /workspace ghcr.io/cirruslabs/flutter:stable flutter build web --dart-define=NEXUSSKLAD_API_BASE_URL=http://localhost:4000
```

## Dart OpenAPI codegen

Подготовлен и уже использован scaffold для генерации Dart transport client:

- `openapi-generator-config.yaml`
- `tool/generate_openapi_client.sh`
- `generated/openapi_client/`

Команда:

```bash
./tool/generate_openapi_client.sh
```

Текущая стратегия:

- generated transport models подключаются постепенно
- domain/UI слой остается hand-written
- `auth` уже переведен на first-class generated transport types
- `products/categories` уже переведены на first-class generated transport types
- `movements` уже переведен на first-class generated transport types
- `inventory` уже переведен на first-class generated transport types
- `team/company` уже переведен на first-class generated transport types
- промежуточные `*_transport.dart` proxy файлы удалены
- repositories и domain-модели импортируют generated Dart types напрямую
- подробности: `../../docs/dart_codegen_strategy.md`

## Dart define

Используется:

- `NEXUSSKLAD_API_BASE_URL`

Пример:

```bash
--dart-define=NEXUSSKLAD_API_BASE_URL=http://localhost:4000
```

## Offline-ready layer

В `apps/mobile` добавлен базовый offline-ready слой:

- auth session сохраняется в secure storage;
- при старте приложение пытается восстановить локальную сессию;
- при недоступном API используются локально сохраненные envelopes для:
  - dashboard
  - categories
  - products
  - movements
  - company
  - users

Текущий scope больше не чисто read-only:

- `income`, `expense`, `adjustment` теперь могут встать в локальную очередь при network failure;
- экран `Движения` умеет показывать pending count и пробовать повторную синхронизацию;
- `inventory item updates` теперь тоже могут встать в локальную очередь при network failure;
- экран `Инвентаризация` умеет синхронизировать очередь и не дает завершить сессию до flush;
- `company update` теперь может встать в singleton queue при network failure;
- экран `Команда` умеет синхронизировать pending update компании;
- `product update` теперь может встать в queue по `productId` при network failure;
- экран `Товары` умеет накладывать pending updates поверх списка и делать retry/sync;
- `user update` теперь может встать в queue по `userId` при network failure;
- экран `Команда` умеет накладывать pending updates поверх списка сотрудников и делать retry/sync;
- offline sync теперь различает типы блокировок:
  - `auth`
  - `conflict`
  - `validation`
  - `server`
- friendly conflict messages показываются в UI для товаров и движений;
- `product` и `user` queues не останавливают sync остальных элементов из-за одного conflict item;
- при conflict now доступны manual clear/discard actions:
  - `Товары` — очистить конфликтную очередь обновлений
  - `Движения` — очистить конфликтную очередь операций
  - `Инвентаризация` — очистить конфликтную очередь по текущей сессии
  - `Команда` — очистить очередь компании или сотрудников
- для `Товары` и `Команда` добавлен granular retry/discard:
  - можно повторно отправить один queued update
  - можно удалить один queued update, не очищая всю очередь
- `product create` теперь тоже поддерживает offline queue:
  - pending create появляется в каталоге как `queued create`
  - pending create можно `retry/discard` отдельно
- pending queues теперь видны не только при conflict:
  - `Товары` показывают отложенные `create/update` как рабочий блок
  - `Команда` показывает отложенные `user update` как рабочий блок
- `inventory start` теперь поддерживает offline queue:
  - pending start виден отдельным блоком на экране инвентаризации
  - pending start можно `retry/discard`
- `category create` теперь поддерживает offline queue:
  - pending category create виден на экране товаров
  - pending category create можно `retry/discard`
- `user invite/create` теперь поддерживает offline queue:
  - pending invite виден на экране команды
  - pending invite можно `retry/discard`
- `team` now показывает pending invite как отдельный рабочий блок, не смешивая его с реальным списком пользователей
- write-операции ставятся в offline queue только при сетевых ошибках:
  - `SocketException`
  - `http.ClientException`
  - `TimeoutException`
- contract/runtime ошибки больше не маскируются под offline-case

## UX hardening

- `dashboard` поддерживает pull-to-refresh и явный fallback, когда за день еще нет движений и low-stock;
- `movements` показывает action-oriented empty state с быстрым стартом первого прихода;
- эти состояния работают поверх текущего offline/retry слоя и не ломают queued workflows.

## Shared state cards

Вынесены общие карточки состояний:

- `lib/core/widgets/state_cards.dart`
- `EmptyStateCard`
- `ErrorStateCard`
- `SyncIssueCard`

- `lib/core/widgets/info_cards.dart`
- `InfoMessageCard`
- `PendingActionCard`

- `lib/core/widgets/domain_state_cards.dart`
- `DashboardNoActivityCard`
- `EmptyMovementsCard`
- `PendingInventoryStartCard`
- `ProductPendingOperationsCard`
- `TeamPendingOperationsCard`

## Contract hardening

- `lib/core/network/api_contract.dart` now throws `ApiContractException` on envelope mismatch;
- `lib/core/network/api_exception.dart` contains centralized `parseApiError(...)`;
- `test/network/api_contract_test.dart` validates:
  - `item/list/report` envelope guards
  - `auth` and `invite` action guards
  - backend error envelope parsing

Checks:

```bash
flutter test test/network/api_contract_test.dart
flutter test test/widget/render_smoke_test.dart
```

- `lib/core/widgets/entity_cards.dart`
- `CompanyStatusCard`
- `TeamMemberInfoCard`
- `ProductStockCard`

Сейчас они уже используются в:

- `products`
- `movements`
- `dashboard`
- `inventory`
- `team`
- `dashboard` domain no-activity section
- `movements` empty-state CTA section
- `inventory` pending-start section
- `products` pending operations section
- `team` pending invite/update section
- `company` summary/status card
- `team` member card
- `product` stock card

## Widget smoke tests

Есть lightweight render smoke layer:

- `test/widget/render_smoke_test.dart`

Проверяет:

- empty state
- error state
- sync conflict state
- info state
- pending-action state
- dashboard no-activity state
- movements empty CTA state
- pending inventory start state
- products pending operations state
- team pending operations state
- company status card state
- team member card state
- product stock card state

Команда:

```bash
flutter test test/widget/render_smoke_test.dart
```

## API error UX

`lib/core/network/api_exception.dart` держит centralized user-facing mapping для:

- `VALIDATION_ERROR`
- `FORBIDDEN`
- `AUTH_*`
- `INSUFFICIENT_STOCK`
- `INVENTORY_*`
- общих `404/409`

При этом raw backend message сохраняется в `backendMessage` для диагностики и contract tests.

## Session expiry UX

`AuthController.expireSession(...)` теперь используется ключевыми экранами:

- `dashboard`
- `products`
- `movements`
- `inventory`
- `team`

Если backend возвращает `401` или `AUTH_*`, приложение очищает локальную сессию и возвращает пользователя на экран входа.

Для read-heavy сценариев есть более мягкий путь:

- `AuthController.recoverSession(...)`
- сначала пробует `refreshToken`
- если refresh успешен, экран перезагружается
- forced logout остается только если refresh не удался

Для write-action сценариев recovery тоже есть:

- `movements`
- `products`
- `team`
- `inventory`

После успешного refresh экран делает один controlled retry и использует уже введенный payload, не открывая форму заново.

Notice UX:

- `Сессия восстановлена. Продолжаем работу.`
- `Сессия завершена. Войди снова.`

Targeted coverage:

- `test/auth/auth_controller_test.dart`
- покрыты:
  - `tryRefreshSession`
  - `recoverSession`
  - `expireSession`
- `test/widget/screen_recovery_test.dart`
- покрыт:
  - `DashboardScreen: 401 -> refresh -> retry -> updated summary`
- `ProductsScreen: 401 -> refresh -> retry -> updated products list`
- `MovementsScreen: 401 -> refresh -> retry -> updated movements list`
- `MovementsScreen: 401 -> refresh -> retry create income with preserved payload`
- `ProductsScreen: 401 -> refresh -> retry create category`
- `ProductsScreen: 401 -> refresh -> retry create product`
- `InventoryScreen: 401 -> refresh -> retry start inventory -> visible session`
- `InventoryScreen: 401 -> refresh -> retry patch item`
- `TeamScreen: 401 -> refresh -> retry company reload`
- `TeamScreen: 401 -> refresh -> retry invite user`

Важно:

- generated Dart client живет вне `lib/`:
  - `generated/openapi_client/`
- это нужно, чтобы `flutter test` корректно работал с path dependency и generated `part` файлами

Auth recovery UX:

- `AppShell` теперь показывает persistent `AuthNoticeCard`
- notice можно скрыть вручную
- `SnackBar` остался как краткий transient сигнал, но больше не является единственным каналом
- `DashboardScreen` имеет screen-level regression test на session recovery без forced logout
- `ProductsScreen` имеет screen-level regression test на session recovery при повторной загрузке каталога
- `ProductsScreen` имеет отдельный write-recovery test на повторный `create category` после refresh
- `ProductsScreen` имеет отдельный write-recovery test на повторный `create product` после refresh
- `ProductsScreen` имеет отдельный write-recovery test на повторный `update product` после refresh
- `MovementsScreen` имеет screen-level regression test на session recovery при повторной загрузке журнала движений
- `MovementsScreen` имеет отдельный write-recovery test на повторный `create income` после refresh
- `MovementsScreen` имеет отдельный write-recovery test на повторный `create expense` после refresh
- `MovementsScreen` имеет отдельный write-recovery test на повторный `create adjustment` после refresh
- `InventoryScreen` имеет screen-level regression test на session recovery при повторном старте инвентаризации
- `InventoryScreen` имеет отдельный write-recovery test на повторный `patch item` после refresh
- `InventoryScreen` имеет отдельный write-recovery test на повторный `finish inventory` после refresh
- `InventoryScreen` имеет отдельный write-recovery test на повторный `sync queue` после refresh
- `TeamScreen` имеет screen-level regression test на session recovery при повторной загрузке company data
- `TeamScreen` имеет отдельный write-recovery test на повторный `invite user` после refresh

Для write-recovery screen tests:

- `ProductsScreen` использует `createCategoryNameBuilder`
- `ProductsScreen` использует `createProductPayloadBuilder`
- `ProductsScreen` использует `editProductPayloadBuilder`
- `MovementsScreen` использует `movementPayloadBuilder`
- `InventoryScreen` использует `actualQtyBuilder`
- `TeamScreen` использует `invitePayloadBuilder`

Это нужно, чтобы не гонять реальные `AlertDialog` controllers в widget test runtime и не ловить disposed/focus race.

Дополнительно:

- trailing action в `InventoryScreen` переведен в compact mode, чтобы не было overflow в незавершенной сессии

Offline/conflict UX:

- `SyncIssueCard` теперь разделяет:
  - conflict state
  - waiting-to-sync state
- queued-action блоки объясняют, когда изменения уйдут на сервер
- destructive CTA сформулированы явно:
  - `Очистить и принять серверное состояние`

Team recovery hooks:

- `TeamScreenState.runUserEditForTest(...)` дает стабильный entrypoint для screen-level recovery test на `update user` без зависимости от реального tap/dialog path.
- `screen_recovery_test.dart` теперь покрывает:
  - `TeamScreen -> invite user`
  - `TeamScreen -> update user`

Mobile UX/copy hardening:

- `LoginScreen` теперь показывает единый demo-access блок для owner / manager / staff и менее техничный copy на входе.
- `DashboardScreen` использует более продуктовый hero copy и уточненный owner-report текст.
- `ProductsScreen` показывает summary chips по каталогу и clearer empty-state CTA для owner/manager.
- `MovementsScreen` показывает summary chips по журналу и action-specific submit CTA в movement dialog.
- `InventoryScreen` показывает summary chips по текущей сессии и clearer action labels (`Открыть сессию`, `Зафиксировать`).
- `TeamScreen` использует русские role labels в dialogs, summary chips по команде и новый invite success copy.


Modal/forms UX hardening:

- `ProductDialog` теперь объясняет поля каталога: категория, единица, SKU, штрихкод, минимальный и стартовый остаток, описание.
- `MovementDialog` использует action-specific helper texts и submit CTA для прихода, расхода и корректировки.
- `InventoryScreen` dialog показывает ожидаемый остаток и clearer CTA `Зафиксировать`.
- `TeamScreen` dialogs используют русские role labels, cleaner invite success state и helper texts для company/user management.


Entity/status UX hardening:

- `CompanyStatusCard` теперь показывает operational chips: `Есть изменения в очереди`, `Нужна сверка с сервером`, `Данные актуальны`.
- `TeamMemberInfoCard` использует product-facing role labels: `Менеджер`, `Сотрудник`, а queued badge переведен в `в очереди`.
- `ProductStockCard` использует более понятные складские статусы: `низкий остаток` и `создается офлайн`.


Dialog copy regression:

- `test/widget/screen_recovery_test.dart` теперь включает отдельные widget-сценарии на copy-контракт dialogs:
  - `create category`
  - `create product`
  - `movement`
  - `actual qty`
  - `invite`
- Эти тесты фиксируют заголовки, helper texts и submit CTA, чтобы mobile form copy не деградировал при следующих UX-проходах.
- Текущий mobile gate:
  - `flutter analyze`
  - `flutter test test/widget/render_smoke_test.dart test/widget/screen_recovery_test.dart test/network/api_contract_test.dart test/auth/auth_controller_test.dart`
  - результат: `48 passed`


Role/copy consistency:

- `LoginScreen` теперь показывает demo-access блок как `Владелец / Менеджер / Сотрудник`, без смешения английских ролей с русским интерфейсом.
- `DashboardScreen` и `TeamScreen` переводят системные роли в продуктовые labels: `Владелец`, `Менеджер`, `Сотрудник`.
- `ProductsScreen` использует русскую summary-метку `Низкий остаток`, а `TeamScreen` переводит pending labels и owner summary chips в единый product-facing copy.
- Текущий mobile gate:
  - `flutter analyze`
  - `flutter test test/widget/render_smoke_test.dart test/widget/screen_recovery_test.dart test/network/api_contract_test.dart test/auth/auth_controller_test.dart`
  - результат: `48 passed`


Action feedback hardening:

- Snackbar copy для `products`, `movements`, `inventory` и `team` приведен к единому operational стилю.
- Offline/retry формулировки теперь говорят не о техническом CRUD-событии, а о рабочем результате:
  - `сохранено в очередь на отправку`
  - `отложенные изменения очищены`
  - `запуск инвентаризации синхронизирован`
- Текущий mobile gate:
  - `flutter analyze`
  - `flutter test test/widget/render_smoke_test.dart test/widget/screen_recovery_test.dart test/network/api_contract_test.dart test/auth/auth_controller_test.dart`
  - результат: `48 passed`


Dashboard insight hardening:

- `DashboardSummary` теперь хранит не только общий `totalMovementCount`, но и breakdown по:
  - `incomeCount`
  - `expenseCount`
  - `adjustmentCount`
  - `inventoryDiffCount`
  - `inventorySessionsCount`
- `DashboardScreen` показывает этот срез рядом с основными summary cards, чтобы owner/manager видели структуру дня без перехода в web/admin.
- Текущий mobile gate:
  - `flutter analyze`
  - `flutter test test/widget/render_smoke_test.dart test/widget/screen_recovery_test.dart test/network/api_contract_test.dart test/auth/auth_controller_test.dart`
  - результат: `48 passed`


Operator workflow hardening:

- `DashboardScreen` теперь показывает быстрые действия:
  - `Приход товара`
  - `Расход товара`
  - `Инвентаризация`
  - `Каталог и остатки`
  - `Команда и доступ`
- `AppShell` принимает callbacks от dashboard и открывает нужную вкладку с контекстным notice о следующем шаге.
- `screen_recovery_test.dart` теперь отдельно проверяет, что quick actions действительно открывают target workflows.
- Текущий mobile gate:
  - `flutter analyze`
  - `flutter test test/widget/render_smoke_test.dart test/widget/screen_recovery_test.dart test/network/api_contract_test.dart test/auth/auth_controller_test.dart`
  - результат: `49 passed`


Product filtering hardening:

- `ProductsScreen` теперь показывает быстрые фильтры:
  - `Все`
  - `Низкий остаток`
  - `Без категории`
  - `Офлайн-черновики`
- summary chips и filters разделены: верхняя строка отвечает за обзор каталога, а вторая — за быстрый переход к нужному срезу.
- если выбранный фильтр не дает позиций, экран показывает отдельный empty-state `По выбранному фильтру товаров нет` с CTA `Сбросить фильтр`.
- `screen_recovery_test.dart` теперь отдельно проверяет, что product filters действительно переключают каталог между `low stock` и `offline drafts`.
- Текущий mobile gate:
  - `flutter analyze`
  - `flutter test test/widget/render_smoke_test.dart test/widget/screen_recovery_test.dart test/network/api_contract_test.dart test/auth/auth_controller_test.dart`
  - результат: `50 passed`


Movement filtering hardening:

- `MovementsScreen` теперь показывает быстрые фильтры:
  - `Все`
  - `Приход`
  - `Расход`
  - `Корректировка`
  - `Сверка`
- summary chips и filters разделены: верхняя строка дает обзор журнала, а вторая — быстрый переход к нужному типу операций.
- если выбранный фильтр не дает записей, экран показывает отдельный empty-state `По выбранному фильтру движений нет` с CTA `Сбросить фильтр`.
- `screen_recovery_test.dart` теперь отдельно проверяет, что movement filters действительно переключают журнал между `приходом` и `сверкой`.
- Текущий mobile gate:
  - `flutter analyze`
  - `flutter test test/widget/render_smoke_test.dart test/widget/screen_recovery_test.dart test/network/api_contract_test.dart test/auth/auth_controller_test.dart`
  - результат: `51 passed`


Inventory filtering hardening:

- `InventoryScreen` теперь показывает быстрые фильтры:
  - `Все`
  - `Расхождения`
  - `Совпадает`
- overview chips и filters разделены: верхняя строка показывает состояние сессии, а вторая — помогает быстро перейти к проблемным или уже совпадающим позициям.
- если выбранный фильтр не дает позиций, экран показывает отдельный empty-state `По выбранному фильтру позиций нет` с CTA `Сбросить фильтр`.
- `screen_recovery_test.dart` теперь отдельно проверяет, что inventory filters действительно переключают сессию между `расхождениями` и `совпадающими` позициями.
- Текущий mobile gate:
  - `flutter analyze`
  - `flutter test test/widget/render_smoke_test.dart test/widget/screen_recovery_test.dart test/network/api_contract_test.dart test/auth/auth_controller_test.dart`
  - результат: `52 passed`


Team/company workflow hardening:

- `TeamScreen` теперь показывает быстрые owner-facing фильтры:
  - `Все`
  - `Активные`
  - `Менеджеры`
  - `Сотрудники`
  - `Приглашения`
- если выбранный фильтр не дает сотрудников, экран показывает отдельный empty-state `По выбранному фильтру сотрудников нет` с CTA `Сбросить фильтр`.
- карточки сотрудников используют более точный pending invite copy:
  - `Приглашение до ...`
- Текущий mobile gate:
  - `flutter analyze`
  - `flutter test test/widget/render_smoke_test.dart test/widget/screen_recovery_test.dart test/network/api_contract_test.dart test/auth/auth_controller_test.dart`
  - результат: `52 passed`


Offline movement queue UX:

- `MovementsScreen` теперь показывает не только chip `Очередь: N`, но и явный pending-action блок `Есть движения в очереди`.
- оператор может сразу:
  - `Отправить сейчас`
  - `Очистить очередь`
- экран прямо объясняет offline-состояние:
  - `Часть операций сохранена локально и будет отправлена при следующей синхронизации.`
- `screen_recovery_test.dart` теперь отдельно проверяет, что pending queue card рендерится при наличии локальной очереди.
- Текущий mobile gate:
  - `flutter analyze`
  - `flutter test test/widget/render_smoke_test.dart test/widget/screen_recovery_test.dart test/network/api_contract_test.dart test/auth/auth_controller_test.dart`
  - результат: `53 passed`


Offline inventory queue UX:

- `InventoryScreen` теперь показывает явный pending-action блок `Есть позиции в очереди`, когда по активной сессии есть локальные item updates.
- оператор может сразу:
  - `Отправить сейчас`
  - `Очистить очередь`
- экран явно объясняет offline-состояние:
  - `Часть изменений по инвентаризации сохранена локально и ждет синхронизации с сервером.`
- `screen_recovery_test.dart` теперь отдельно проверяет, что pending inventory queue card рендерится при наличии локальной очереди.
- Текущий mobile gate:
  - `flutter analyze`
  - `flutter test test/widget/render_smoke_test.dart test/widget/screen_recovery_test.dart test/network/api_contract_test.dart test/auth/auth_controller_test.dart`
  - результат: `54 passed`


Products offline queue UX:

- `ProductPendingOperationsCard` теперь показывает batch-level CTA:
  - `Отправить все сейчас`
  - `Очистить очередь`
- эти действия доступны, когда есть локальные category/product операции и нет conflict-состояния.
- это выравнивает offline workflow каталога с `MovementsScreen` и `InventoryScreen`: владелец и менеджер могут управлять всей очередью товаров одним действием.
- `render_smoke_test.dart` теперь отдельно проверяет, что batch-actions рендерятся для `ProductPendingOperationsCard`.
- Текущий mobile gate:
  - `flutter analyze`
  - `flutter test test/widget/render_smoke_test.dart test/widget/screen_recovery_test.dart test/network/api_contract_test.dart test/auth/auth_controller_test.dart`
  - результат: `55 passed`


Team offline queue UX:

- `TeamPendingOperationsCard` теперь показывает batch-level CTA:
  - `Отправить все сейчас`
  - `Очистить очередь`
- эти действия доступны, когда по команде есть локальные invites/updates и нет conflict-состояния.
- это выравнивает offline workflow команды с `ProductsScreen`, `MovementsScreen` и `InventoryScreen`: владелец получает общий control для всей очереди сотрудников.
- `render_smoke_test.dart` теперь отдельно проверяет, что batch-actions рендерятся для `TeamPendingOperationsCard`.
- Текущий mobile gate:
  - `flutter analyze`
  - `flutter test test/widget/render_smoke_test.dart test/widget/screen_recovery_test.dart test/network/api_contract_test.dart test/auth/auth_controller_test.dart`
  - результат: `56 passed`

## Team search hardening

- `TeamScreen` теперь поддерживает поиск по имени, email и телефону поверх owner-фильтров.
- Если по текущему фильтру и поиску нет сотрудников, экран показывает отдельный empty-state и CTA `Очистить поиск`.
