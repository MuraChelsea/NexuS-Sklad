#!/bin/sh
set -eu

if [ $# -ne 1 ]; then
  echo "Usage: $0 <backup.sql>" >&2
  exit 1
fi

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ENV_FILE=${ENV_FILE:-"$SCRIPT_DIR/.env.production"}
COMPOSE_FILE=${COMPOSE_FILE:-"$SCRIPT_DIR/docker-compose.production.yml"}
BACKUP_FILE=$1

if [ ! -f "$BACKUP_FILE" ]; then
  echo "Backup file not found: $BACKUP_FILE" >&2
  exit 1
fi

"$SCRIPT_DIR/validate_runtime_env.sh" "$ENV_FILE" >/dev/null

POSTGRES_DB=$(awk -F= '/^POSTGRES_DB=/{print $2}' "$ENV_FILE")
POSTGRES_USER=$(awk -F= '/^POSTGRES_USER=/{print $2}' "$ENV_FILE")

CHECKSUM_FILE="${BACKUP_FILE}.sha256"

if [ -f "$CHECKSUM_FILE" ]; then
  shasum -a 256 -c "$CHECKSUM_FILE"
fi

case "$BACKUP_FILE" in
  *.gz)
    gzip -dc "$BACKUP_FILE" | docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" exec -T postgres \
      psql -U "$POSTGRES_USER" -d "$POSTGRES_DB"
    ;;
  *)
    cat "$BACKUP_FILE" | docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" exec -T postgres \
      psql -U "$POSTGRES_USER" -d "$POSTGRES_DB"
    ;;
esac
