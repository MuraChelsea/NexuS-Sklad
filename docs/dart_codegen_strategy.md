# NexusSklad Dart Codegen Strategy

## Цель

Подготовить безопасный путь к генерации Dart transport-контрактов из `docs/openapi_v1.yaml`
без резкого переписывания текущего mobile слоя.

## Что уже есть

- `docs/openapi_v1.yaml` — repository-tracked transport contract
- `packages/shared/src/generated/openapi.ts` — generated TypeScript transport types
- `apps/mobile` — contract-driven parsing через:
  - `lib/core/network/api_contract.dart`
  - `lib/core/network/json_reader.dart`

## Проблема

Сейчас mobile уже строже валидирует envelopes, но все еще держит свои ручные transport/domain
модели в Dart. Это нормально для текущего этапа, но создает дублирование.

## Рекомендуемый путь

1. Не переписывать mobile на full-generated client сразу.
2. Сначала генерировать только transport-layer Dart артефакты.
3. Держать domain-модели UI отдельно от generated transport-моделей.
4. Делать mapping:
   - `generated transport dto -> mobile domain model`

## Почему именно так

- generated модели нестабильнее и зависят от generator output
- UI/domain слой должен оставаться контролируемым вручную
- при таком подходе backend transport drift ловится раньше, а UI не ломается из-за generator churn

## Целевой split

### Generated layer

Папка:

- `apps/mobile/generated/openapi_client/`

Назначение:

- transport models
- enums
- базовые request/response classes
- при необходимости light API client

### Hand-written layer

Папки:

- `apps/mobile/lib/features/**/data`
- `apps/mobile/lib/features/**/presentation`
- `apps/mobile/lib/core/network`

Назначение:

- orchestration
- session handling
- mapping to domain models
- UI-specific computed properties

## Generator choice

Первый рекомендуемый вариант:

- `openapi-generator-cli`
- generator: `dart-dio`

Причина:

- зрелый и широко используемый путь
- генерирует transport client и модели
- хорошо подходит для staged adoption

## Policy

- generated код не редактируется вручную
- generated слой обновляется только командой генерации
- изменения backend transport shape должны обновлять:
  - `docs/openapi_v1.yaml`
  - generated TS types
  - generated Dart types

## Recommended rollout

### Phase 1

Сгенерировать Dart client в отдельную папку и не подключать его в production flow.

Критерий:

- generator workflow стабилен
- output воспроизводим

### Phase 2

Подключить generated enums и request/response models в один read-only flow:

- `auth/login`
- `auth/me`

Статус:

- выполнено частично: `apps/mobile` уже использует generated auth transport types first-class

### Phase 3

Подключить generated transport models для:

- products
- movements
- reports

### Phase 4

Решить, нужен ли full generated API client или только generated models.

## Что не делать

- не смешивать generated transport types с UI-состоянием
- не переписывать все repositories в один проход
- не делать mobile app зависимым от generator runtime

## Практический вывод

Для `NexusSklad` лучший путь сейчас:

- оставить текущий manual/domain слой
- добавить reproducible Dart codegen workflow
- начать adoption с transport models, а не с полного generated client everywhere

## Текущее состояние

Уже сделано:

- generated Dart client реально создается в `apps/mobile/generated/openapi_client`
- генерация требует post-process шага для:
  - SDK constraint (`^3.8.0`)
  - удаления лишнего import в `default_api.dart`
- `auth` mobile flow уже использует generated transport types
