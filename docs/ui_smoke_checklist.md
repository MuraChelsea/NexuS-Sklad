# NexusSklad UI Smoke Checklist

Дата: 3 марта 2026
Режим rollout: `IP-only`

## Контуры

- staging web: `http://85.239.56.248:8080`
- staging api health: `http://85.239.56.248:8080/health`
- production-like web: `http://85.239.56.248:8081`
- production-like api health: `http://85.239.56.248:8081/health`

## Staging accounts

- `owner@nexussklad.local / demo-owner-123`
- `manager@nexussklad.local / demo-manager-123`
- `staff@nexussklad.local / demo-staff-123`

## Owner happy-path

1. Открыть `http://85.239.56.248:8080`.
2. Войти как `owner`.
3. Убедиться, что открывается `Обзор` без fatal error.
4. Проверить `Товары`:
   - список открывается;
   - `Новый товар` работает;
   - `Новая категория` работает;
   - `Удалить` виден для owner.
5. Проверить `Движения`:
   - `Приход` работает;
   - `Расход` работает;
   - `Корректировка` доступна owner.
6. Проверить `Инвентаризация`:
   - `Запустить сессию` работает;
   - `Открыть` сессию можно;
   - позицию можно сохранить;
   - сессию можно завершить.
7. Проверить `Компания и команда`:
   - редактирование компании работает;
   - invite работает;
   - список сотрудников открывается.
8. Проверить `Экспорт и отчеты`:
   - export buttons скачивают CSV;
   - пустые состояния выглядят корректно, если фильтры дают пустой отчет.
9. Проверить `Аудит`:
   - owner видит экран;
   - фильтры применяются;
   - пустой фильтрованный результат показывает empty state.

## Manager happy-path

1. Войти как `manager`.
2. Убедиться, что `Аудит` отсутствует.
3. Проверить `Товары`:
   - create/update доступны;
   - delete недоступен.
4. Проверить `Движения`:
   - `Приход` и `Расход` доступны;
   - `Корректировка` доступна.
5. Проверить `Инвентаризация`:
   - старт сессии доступен;
   - finish доступен.
6. Проверить `Компания и команда`:
   - owner-only управление сотрудниками не доступно;
   - поясняющий state отображается.
7. Проверить `Экспорт и отчеты`:
   - stock/daily exports доступны;
   - audit export отсутствует.

## Staff happy-path

1. Войти как `staff` в mobile.
2. Проверить, что доступны:
   - `Обзор`
   - `Товары`
   - `Движения`
   - `Инвентаризация`
3. Убедиться, что `adjustment` не доступен.
4. Убедиться, что owner-only team actions не доступны.

## Empty/error states

1. В web на `Аудит` применить фильтры, которые гарантированно дадут пустой результат.
2. В web на `Stock report` применить фильтры, которые дадут пустой результат.
3. В web на `Товары` проверить empty state на новой компании без каталога.
4. В mobile на `Движения` проверить empty state на новой компании.
5. В mobile на `Dashboard` проверить fallback на новой компании без движений.
6. При отключенном API проверить, что web показывает retry/error block, а не пустой экран.

## Offline visibility checks

1. В mobile залогиниться.
2. Отключить сеть.
3. Создать pending:
   - `product create`
   - `product update`
   - `category create`
   - `movement`
   - `inventory start`
   - `inventory item update`
   - `company update`
   - `user update`
   - `user invite`
4. Проверить, что соответствующие pending-блоки видны в UI.
5. Включить сеть.
6. Проверить `retry/sync`.
7. Если сервер отклоняет операцию:
   - убедиться, что conflict message понятный;
   - доступны `retry/discard` или clear actions.

## Automated checks around UI rollout

- `curl -I http://85.239.56.248:8080`
- `curl -I http://85.239.56.248:8080/health`
- `curl -I http://85.239.56.248:8081`
- `curl -I http://85.239.56.248:8081/health`
- `POST /v1/auth/login` на staging для `owner`
- `POST /v1/auth/login` на staging для `manager`

## Ограничение текущего этапа

- production-like контур на `8081` сейчас валидируется без demo login;
- полный UI happy-path там проверять рано, пока не будет production seed/real account bootstrap.
