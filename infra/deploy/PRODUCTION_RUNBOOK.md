# NexusSklad Production Runbook

Этот runbook нужен для перехода от staging к production-ready запуску.

## Что уже есть

- production compose:
  - `docker-compose.production.yml`
- env template:
  - `.env.production.example`
- deploy script:
  - `deploy_production.sh`
- backup script:
  - `backup_postgres.sh`
- restore script:
  - `restore_postgres.sh`
- backup verify script:
  - `verify_backup.sh`
- backup prune script:
  - `prune_backups.sh`
- runtime snapshot script:
  - `monitor_snapshot.sh`
- runtime health check script:
  - `monitor_check.sh`
- readiness contract check:
  - `readiness_check.sh`
- backup restore drill:
  - `backup_restore_drill.sh`
- daily ops script:
  - `ops_daily.sh`
- weekly ops script:
  - `ops_weekly.sh`
- log rotation script:
  - `rotate_ops_logs.sh`
- cron template:
  - `ops_crontab.example`
- cron installer:
  - `install_ops_cron.sh`
- release gate:
  - `release_gate.sh`
- smoke script:
  - `smoke_check.sh`
- bootstrap owner script:
  - `bootstrap_owner.sh`

## Минимальный порядок запуска

1. Подготовить env:

```bash
cp .env.production.example .env.production
```

2. Задать сильные секреты:

- `POSTGRES_PASSWORD`
- `JWT_ACCESS_SECRET`
- `JWT_REFRESH_SECRET`

Минимальные требования:

- `POSTGRES_PASSWORD` — не placeholder и не короче `16` символов;
- `JWT_ACCESS_SECRET` и `JWT_REFRESH_SECRET` — не placeholder, не короче `24` символов и разные.
- `ALLOW_PUBLIC_REGISTRATION` — явно `true` или `false`; для production-like/production рекомендуем `false`.
- `NEXUSSKLAD_LOG_MAX_SIZE` — значение вида `10m` / `50m` / `1g`;
- `NEXUSSKLAD_LOG_MAX_FILES` — число.

3. Поднять production stack:

```bash
./deploy_production.sh
```

При необходимости можно отдельно проверить env до deploy:

```bash
./validate_runtime_env.sh ./.env.production
```

4. Для реального первого владельца используй bootstrap flow вместо demo seed:

```bash
BOOTSTRAP_COMPANY_NAME='NexusSklad Pilot' \
BOOTSTRAP_OWNER_NAME='Pilot Owner' \
BOOTSTRAP_OWNER_EMAIL='owner@example.com' \
BOOTSTRAP_OWNER_PASSWORD='replace-with-strong-password' \
./bootstrap_owner.sh production
```

Для тестового production-like контура demo seed по-прежнему возможен, но в реальном production его лучше не использовать:

```bash
docker compose --env-file .env.production -f docker-compose.production.yml exec -T api npm run prisma:seed
```

5. Прогнать smoke check:

```bash
./smoke_check.sh http://your-host:8081
```

Если в production-like/production контуре нет demo seed, использовать health-only режим:

```bash
./smoke_check.sh http://your-host:8081 skip-login
```

## Что нужно до реального production

1. Домен
2. Reverse proxy / ingress
3. HTTPS
4. Ротация секретов
5. Регулярные backup'ы
6. Хранение backup'ов вне сервера
7. Ограничение доступа к staging/demo пользователям
8. Отключение demo seed в боевом процессе
9. Smoke checklist после каждого deploy
10. Базовый мониторинг логов и health
11. Настроенный log retention для docker-контейнеров
12. Регулярный health-check контейнеров и endpoint'ов

## Backup

Сделать backup:

```bash
./backup_postgres.sh
```

По умолчанию backup сохраняется как:

- `.sql.gz`
- `.sha256`

Восстановить backup:

```bash
./restore_postgres.sh ./backups/nexussklad-YYYYMMDD-HHMMSS.sql.gz
```

Проверить checksum backup:

```bash
./verify_backup.sh ./backups/nexussklad-YYYYMMDD-HHMMSS.sql.gz
```

Оставить только последние `10` backup-файлов:

```bash
./prune_backups.sh
```

Сделать runtime snapshot:

```bash
./monitor_snapshot.sh production
```

Проверить, что контур жив:

```bash
./monitor_check.sh production
```

Проверить readiness JSON-контракт:

```bash
./readiness_check.sh production
```

Периодически прогонять backup/restore drill:

```bash
./backup_restore_drill.sh staging
```

Сделать ежедневный ops cycle вручную:

```bash
./ops_daily.sh production
```

Сделать weekly restore drill вручную:

```bash
./ops_weekly.sh staging
```

Сделать ops log rotation вручную:

```bash
./rotate_ops_logs.sh
```

Шаблон cron:

```bash
cat ops_crontab.example
```

Установить cron jobs:

```bash
./install_ops_cron.sh
```

## Замечание

Сейчас production compose по умолчанию публикует web на:

- `8081`

Это осознанно, чтобы не конфликтовать с другими сервисами на сервере.
