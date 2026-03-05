# NexusSklad Staging Deploy

Минимальный staging-контур поднимает:

- `postgres`
- `api`
- `web`

`apps/web` отдается через `nginx` и проксирует:

- `/v1/*` -> `api:4000`
- `/health` -> `api:4000/health`
- `/health/ready` -> `api:4000/health/ready`

Это убирает CORS-проблему и оставляет один origin для браузера.

## Файлы

- `docker-compose.staging.yml`
- `.env.staging.example`
- `docker-compose.production.yml`
- `.env.production.example`
- `.env.domains.example`
- `deploy_production.sh`
- `deploy_staging.sh`
- `sync_server.sh`
- `backup_postgres.sh`
- `restore_postgres.sh`
- `verify_backup.sh`
- `prune_backups.sh`
- `validate_runtime_env.sh`
- `monitor_snapshot.sh`
- `monitor_check.sh`
- `readiness_check.sh`
- `backup_restore_drill.sh`
- `ops_daily.sh`
- `ops_weekly.sh`
- `rotate_ops_logs.sh`
- `ops_crontab.example`
- `install_ops_cron.sh`
- `release_gate.sh`
- `smoke_check.sh`
- `web_deploy_smoke_check.sh`
- `staging_happy_path_check.sh`
- `reset_staging_demo.sh`
- `prepare_ui_smoke_pass.sh`
- `start_ui_smoke_session.sh`
- `create_ui_fix_pack.sh`
- `run_ui_smoke_workflow.sh`
- `PRODUCTION_RUNBOOK.md`
- `DOMAIN_CUTOVER_RUNBOOK.md`
- `render_nginx_site.sh`
- `nginx/nexussklad-staging.conf.template`
- `nginx/nexussklad-production.conf.template`

## Быстрый старт

```bash
cd infra/deploy
cp .env.staging.example .env.staging
./deploy_staging.sh
```

## Безопасный sync на сервер

Для обычного sync проекта на сервер лучше использовать:

```bash
./sync_server.sh
```

Скрипт намеренно не трогает server-only файлы:

- `.env.staging`
- `.env.production`
- `infra/deploy/backups/`

По умолчанию используется:

- `root@85.239.56.248:/root/nexussklad`

Если нужно, можно переопределить:

```bash
REMOTE_HOST=root@your-host REMOTE_DIR=/root/nexussklad ./sync_server.sh
```

После старта web будет доступен на:

- `http://localhost:8080`

Если нужен другой порт, меняется:

- `NEXUSSKLAD_WEB_PORT`

## Что делает API контейнер

При старте API контейнер автоматически выполняет:

```bash
npx prisma migrate deploy
node dist/apps/api/src/server.js
```

То есть staging-контур не требует отдельного ручного прогона миграций при обычном запуске.

Перед запуском deploy scripts теперь валидируют runtime env:

- обязательные переменные должны быть заполнены;
- `POSTGRES_PASSWORD` не должен быть placeholder и должен быть не короче `16` символов;
- `JWT_*_SECRET` не должны быть placeholder, должны быть не короче `24` символов и не могут совпадать.
- `ALLOW_PUBLIC_REGISTRATION` должен быть явно задан как `true` или `false`;
- `NEXUSSKLAD_LOG_MAX_SIZE` должен выглядеть как `10m` / `50m` / `1g`;
- `NEXUSSKLAD_LOG_MAX_FILES` должен быть числом.

Docker logging policy для всех контейнеров staging/production-like:

- driver: `json-file`
- `max-size`: `NEXUSSKLAD_LOG_MAX_SIZE`
- `max-file`: `NEXUSSKLAD_LOG_MAX_FILES`

## Первичная подготовка данных

Если нужен demo-owner, можно один раз выполнить:

```bash
docker compose --env-file .env.staging -f docker-compose.staging.yml exec api npm run prisma:seed
```

После этого будут доступны demo users:

- `owner@nexussklad.local / demo-owner-123`
- `manager@nexussklad.local / demo-manager-123`
- `staff@nexussklad.local / demo-staff-123`

Для production такой seed не нужен. Вместо него используй bootstrap owner flow. По умолчанию `ALLOW_PUBLIC_REGISTRATION=false`, поэтому после первого владельца публичная регистрация в production-like должна быть закрыта:

```bash
BOOTSTRAP_COMPANY_NAME='NexusSklad Pilot' \
BOOTSTRAP_OWNER_NAME='Pilot Owner' \
BOOTSTRAP_OWNER_EMAIL='owner@example.com' \
BOOTSTRAP_OWNER_PASSWORD='replace-with-strong-password' \
./bootstrap_owner.sh production
```

## Что уже проверено локально

Локально этот staging-контур уже был проверен:

- stack поднялся успешно;
- `http://127.0.0.1:8080` отвечает `200 OK`;
- `http://127.0.0.1:8080/health` отвечает `200 OK`;
- после seed проходит login для `owner@nexussklad.local / demo-owner-123`.

## Что уже проверено на внешнем сервере

Внешний staging уже поднят на сервере и проверен:

- код развернут в `/root/nexussklad`
- URL: `http://85.239.56.248:8080`
- `GET /` отвечает `200 OK`
- `GET /health` отвечает `200 OK`
- `GET /health/ready` подтверждает готовность API и БД
- `smoke_check.sh` и `web_deploy_smoke_check.sh` валидируют и `/health`, и `/health/ready`
- login для `owner@nexussklad.local / demo-owner-123` проходит успешно

Дополнительно:

- production-like контур поднят на `http://85.239.56.248:8081`
- staging и production-like compose namespaces разведены и работают параллельно

## Domain / HTTPS groundwork

Сейчас в репозитории уже подготовлены domain-ready артефакты:

- `.env.domains.example`
- `render_nginx_site.sh`
- `nginx/nexussklad-staging.conf.template`
- `nginx/nexussklad-production.conf.template`
- `DOMAIN_CUTOVER_RUNBOOK.md`

Текущее рекомендуемое соответствие:

- `staging.<your-domain>` -> host nginx -> `127.0.0.1:8080`
- `app.<your-domain>` -> host nginx -> `127.0.0.1:8081`

Проверено на сервере:

- `nginx` установлен
- `certbot` пока не установлен

## Полезные команды

Проверить логи:

```bash
docker compose --env-file .env.staging -f docker-compose.staging.yml logs -f
```

Остановить стек:

```bash
docker compose --env-file .env.staging -f docker-compose.staging.yml down
```

Остановить стек и удалить БД:

```bash
docker compose --env-file .env.staging -f docker-compose.staging.yml down -v
```

Если нужно только проверить env без deploy:

```bash
./validate_runtime_env.sh ./.env.staging
```

Создать первого owner без demo seed:

```bash
BOOTSTRAP_COMPANY_NAME='NexusSklad Pilot' \
BOOTSTRAP_OWNER_NAME='Pilot Owner' \
BOOTSTRAP_OWNER_EMAIL='owner@example.com' \
BOOTSTRAP_OWNER_PASSWORD='replace-with-strong-password' \
./bootstrap_owner.sh production
```

Backup-файлы по умолчанию теперь:

- сжимаются в `.sql.gz`
- получают checksum-файл `.sha256`

Проверить checksum backup:

```bash
./verify_backup.sh ./backups/nexussklad-YYYYMMDD-HHMMSS.sql.gz
```

Оставить только последние `10` backup-файлов:

```bash
./prune_backups.sh
```

Изменить retention:

```bash
KEEP_COUNT=20 ./prune_backups.sh
```

Быстрый runtime snapshot:

```bash
./monitor_snapshot.sh staging
./monitor_snapshot.sh production
```

Жесткая проверка контейнеров и endpoint health:

```bash
./monitor_check.sh staging
./monitor_check.sh production
```

Проверка readiness JSON-контракта:

```bash
./readiness_check.sh staging
./readiness_check.sh production
```

Безопасный backup/restore drill во временную БД:

```bash
./backup_restore_drill.sh staging
```

Готовый daily ops runner:

```bash
./ops_daily.sh production
./ops_daily.sh staging
```

Он делает:

- env validation
- backup
- prune старых backup'ов
- monitor health check

Weekly restore drill:

```bash
./ops_weekly.sh staging
```

Он делает:

- readiness contract check
- backup restore drill во временную БД

Ротация ops/log health файлов:

```bash
./rotate_ops_logs.sh
```

По умолчанию:

- ротирует `nexussklad-ops.log` и `nexussklad-health.log` от `10 MiB`
- gzip'ит архивы
- оставляет последние `7` архивов на каждый лог

Шаблон для cron:

```bash
cat ops_crontab.example
```

Установить cron jobs:

```bash
./install_ops_cron.sh
```

## Smoke modes

Полный smoke c login:

```bash
./smoke_check.sh http://localhost:8080
```

Web deploy smoke для web-shell и asset bundle:

```bash
./web_deploy_smoke_check.sh http://localhost:8080
```

Owner/manager staging happy-path:

```bash
./staging_happy_path_check.sh http://localhost:8080
```

Сейчас script уже проверяет не только `owner/manager`, но и `staff` role guards:

- `reports` -> `403` для `staff`
- `users` -> `403` для `manager/staff`
- `audit` -> `403` для `manager/staff`
- `movements/adjustment` -> `403` для `staff`

Полный reset staging demo baseline:

```bash
./reset_staging_demo.sh
```

Важно:

- script разрушает staging volume через `docker compose down -v`;
- использовать только для demo/staging baseline, не для production.

Preflight перед ручным UI smoke pass:

```bash
./prepare_ui_smoke_pass.sh http://localhost:8080
```

Полный старт новой ручной UI smoke session:

```bash
./start_ui_smoke_session.sh http://localhost:8080
```

Script:

- прогоняет preflight;
- создает `docs/ui-smoke-session-YYYYMMDD-HHMM.md`;
- оставляет baseline untouched.

Сборка fix pack из findings:

```bash
./create_ui_fix_pack.sh ../../docs/ui_smoke_report_latest.md
```

Полный orchestration workflow:

```bash
./run_ui_smoke_workflow.sh http://localhost:8080
```

С reset staging baseline:

```bash
./run_ui_smoke_workflow.sh http://localhost:8080 --reset
```

Health-only smoke без demo login:

```bash
./smoke_check.sh http://localhost:8081 skip-login
```

Для production-like web shell без demo seed:

```bash
./web_deploy_smoke_check.sh http://localhost:8081 skip-login
```
