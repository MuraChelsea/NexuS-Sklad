# NexusSklad UI Gap Triage

Дата: 3 марта 2026

## Severity

### `S1`

Использовать, если:

- ломается основной сценарий роли;
- данные сохраняются неверно;
- пользователь блокируется без обходного пути;
- есть риск неправильных складских остатков или неверного доступа.

### `S2`

Использовать, если:

- сценарий работает, но с заметным UX-сбоем;
- empty/error state сбивает пользователя;
- retry/offline flow существует, но непонятен;
- owner/manager/staff видят не тот affordance, хотя backend guard работает.

### `S3`

Использовать, если:

- проблема косметическая;
- текст/отступ/лейбл/формулировка не мешают завершить задачу;
- есть шероховатость без продуктового риска.

## Triage order

1. Сначала `S1` по:
   - остаткам
   - движениям
   - инвентаризации
   - auth/roles
2. Потом `S2` по:
   - empty/error states
   - retry/offline visibility
   - export/report flows
3. Потом `S3` polish.

## Expected fix pack format

Для каждой пачки фиксов:

1. краткое имя пакета;
2. список экранов/ролей;
3. список root cause;
4. какие проверки должны стать зелеными после фикса.

## Mapping to report

В `docs/ui_smoke_report_latest.md` или session-report фиксировать:

- `Severity`
- `Area`
- `Screen`
- `Summary`
- `Repro`
- `Expected`
- `Actual`

После этого проблемы легко группировать в:

- `Access/Roles`
- `Inventory/Stock`
- `Offline/Retry`
- `UI States`
- `Reports/Exports`
