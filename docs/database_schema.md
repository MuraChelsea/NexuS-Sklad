# NexusSklad Database Schema

Дата: 1 марта 2026
Статус: draft

## 1. Принцип схемы

Схема должна быть:

- простой;
- прозрачной;
- подходящей для MVP;
- готовой к расширению;
- безопасной для операций с остатками.

## 2. Таблицы

### companies

| Поле | Тип | Описание |
|---|---|---|
| id | uuid | первичный ключ |
| name | text | название компании |
| city | text | город |
| phone | text | телефон компании |
| created_at | timestamp | дата создания |

### users

| Поле | Тип | Описание |
|---|---|---|
| id | uuid | первичный ключ |
| company_id | uuid | ссылка на компанию |
| name | text | имя пользователя |
| phone | text | телефон |
| email | text | email |
| password_hash | text | хэш пароля |
| role | text | owner / manager / staff |
| is_active | boolean | активен ли пользователь |
| created_at | timestamp | дата создания |

### categories

| Поле | Тип | Описание |
|---|---|---|
| id | uuid | первичный ключ |
| company_id | uuid | ссылка на компанию |
| parent_id | uuid nullable | родительская категория |
| name | text | название категории |
| created_at | timestamp | дата создания |

### products

| Поле | Тип | Описание |
|---|---|---|
| id | uuid | первичный ключ |
| company_id | uuid | ссылка на компанию |
| category_id | uuid nullable | ссылка на категорию |
| name | text | название товара |
| sku | text | артикул |
| barcode | text nullable | штрихкод |
| unit | text | единица измерения |
| description | text nullable | описание |
| min_stock | numeric | минимальный остаток |
| current_stock | numeric | текущий остаток |
| created_at | timestamp | дата создания |
| updated_at | timestamp | дата обновления |

### stock_movements

| Поле | Тип | Описание |
|---|---|---|
| id | uuid | первичный ключ |
| company_id | uuid | ссылка на компанию |
| product_id | uuid | ссылка на товар |
| created_by | uuid | пользователь |
| movement_type | text | income / expense / adjustment / inventory_diff |
| quantity | numeric | количество |
| before_qty | numeric | остаток до операции |
| after_qty | numeric | остаток после операции |
| comment | text nullable | комментарий |
| created_at | timestamp | дата создания |

### inventory_sessions

| Поле | Тип | Описание |
|---|---|---|
| id | uuid | первичный ключ |
| company_id | uuid | ссылка на компанию |
| started_by | uuid | кто начал |
| status | text | draft / in_progress / completed |
| comment | text nullable | комментарий |
| started_at | timestamp | старт |
| finished_at | timestamp nullable | завершение |

### inventory_items

| Поле | Тип | Описание |
|---|---|---|
| id | uuid | первичный ключ |
| session_id | uuid | ссылка на инвентаризацию |
| product_id | uuid | ссылка на товар |
| expected_qty | numeric | ожидаемое количество |
| actual_qty | numeric | фактическое количество |
| difference | numeric | расхождение |
| comment | text nullable | комментарий |

### audit_logs

| Поле | Тип | Описание |
|---|---|---|
| id | uuid | первичный ключ |
| company_id | uuid | ссылка на компанию |
| user_id | uuid | пользователь |
| action | text | действие |
| entity_type | text | сущность |
| entity_id | uuid | ID сущности |
| payload | jsonb | полезная нагрузка |
| created_at | timestamp | дата создания |

## 3. Связи

- `companies 1:N users`
- `companies 1:N categories`
- `companies 1:N products`
- `companies 1:N stock_movements`
- `companies 1:N inventory_sessions`
- `products 1:N stock_movements`
- `inventory_sessions 1:N inventory_items`
- `products 1:N inventory_items`

## 4. Индексы

Рекомендуемые индексы:

- `users(company_id)`
- `categories(company_id)`
- `products(company_id)`
- `products(company_id, category_id)`
- `products(company_id, name)`
- `products(company_id, sku)`
- `stock_movements(company_id, created_at desc)`
- `stock_movements(product_id, created_at desc)`
- `audit_logs(company_id, created_at desc)`

## 5. Ограничения

1. У `users.role` только:
   - `owner`
   - `manager`
   - `staff`
2. У `stock_movements.movement_type` только:
   - `income`
   - `expense`
   - `adjustment`
   - `inventory_diff`
3. У товара не должно быть отрицательного остатка без специального сценария.
4. `before_qty` и `after_qty` обязательны для каждого движения.
5. Инвентаризация должна хранить и ожидаемое, и фактическое количество.

## 6. Принцип обновления остатка

При создании операции:

1. API читает `current_stock`.
2. Валидирует действие.
3. Считает `before_qty`.
4. Считает `after_qty`.
5. Создает запись в `stock_movements`.
6. Обновляет `products.current_stock`.
7. Создает запись в `audit_logs`.

Это должно выполняться в транзакции.

## 7. Будущее расширение схемы

Позже можно добавить:

- suppliers;
- warehouses;
- warehouse_zones;
- attachments;
- notifications;
- api_tokens;
- import_jobs.
