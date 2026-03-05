#!/bin/sh
set -eu

TARGET=${1:-staging}

case "$TARGET" in
  staging)
    ENV_FILE=${ENV_FILE:-"$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/.env.staging"}
    COMPOSE_FILE=${COMPOSE_FILE:-"$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/docker-compose.staging.yml"}
    POSTGRES_CONTAINER=nexussklad-postgres-staging
    ;;
  production|prod)
    ENV_FILE=${ENV_FILE:-"$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/.env.production"}
    COMPOSE_FILE=${COMPOSE_FILE:-"$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/docker-compose.production.yml"}
    POSTGRES_CONTAINER=nexussklad-postgres-prod
    ;;
  *)
    echo "Usage: $0 [staging|production]" >&2
    exit 1
    ;;
esac

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
BACKUP_DIR=${BACKUP_DIR:-${TMPDIR:-/tmp}/nexussklad-drill-backups}
STAMP=$(date +"%Y%m%d_%H%M%S")
TMP_DB="nexussklad_restore_drill_${STAMP}"

"$SCRIPT_DIR/validate_runtime_env.sh" "$ENV_FILE" >/dev/null

mkdir -p "$BACKUP_DIR"

POSTGRES_USER=$(awk -F= '/^POSTGRES_USER=/{print $2}' "$ENV_FILE")
BACKUP_OUTPUT=$(BACKUP_DIR="$BACKUP_DIR" "$SCRIPT_DIR/backup_postgres.sh" 2>/dev/null | awk '/Backup written to /{print $4}')

if [ -z "$BACKUP_OUTPUT" ] || [ ! -f "$BACKUP_OUTPUT" ]; then
  echo "Backup drill failed: backup file was not created" >&2
  exit 1
fi

cleanup() {
  docker exec "$POSTGRES_CONTAINER" psql -U "$POSTGRES_USER" -d postgres -c "DROP DATABASE IF EXISTS ${TMP_DB};" >/dev/null 2>&1 || true
}

trap cleanup EXIT INT TERM

docker exec "$POSTGRES_CONTAINER" psql -U "$POSTGRES_USER" -d postgres -c "CREATE DATABASE ${TMP_DB};" >/dev/null

case "$BACKUP_OUTPUT" in
  *.gz)
    gzip -dc "$BACKUP_OUTPUT" | docker exec -i "$POSTGRES_CONTAINER" psql -U "$POSTGRES_USER" -d "$TMP_DB" >/dev/null
    ;;
  *)
    cat "$BACKUP_OUTPUT" | docker exec -i "$POSTGRES_CONTAINER" psql -U "$POSTGRES_USER" -d "$TMP_DB" >/dev/null
    ;;
esac

TABLE_COUNT=$(docker exec "$POSTGRES_CONTAINER" psql -U "$POSTGRES_USER" -d "$TMP_DB" -tAc "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';")

if [ "${TABLE_COUNT:-0}" -le 0 ]; then
  echo "Backup drill failed: restored database has no public tables" >&2
  exit 1
fi

echo "NexusSklad backup restore drill passed: $TARGET"
echo " - backup: $BACKUP_OUTPUT"
echo " - temp db: $TMP_DB"
echo " - public tables: $TABLE_COUNT"
