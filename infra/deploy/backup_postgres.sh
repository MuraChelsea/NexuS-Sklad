#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ENV_FILE=${ENV_FILE:-"$SCRIPT_DIR/.env.production"}
COMPOSE_FILE=${COMPOSE_FILE:-"$SCRIPT_DIR/docker-compose.production.yml"}
BACKUP_DIR=${BACKUP_DIR:-"$SCRIPT_DIR/backups"}
STAMP=$(date +"%Y%m%d-%H%M%S")
COMPRESS_BACKUP=${COMPRESS_BACKUP:-1}

"$SCRIPT_DIR/validate_runtime_env.sh" "$ENV_FILE" >/dev/null

mkdir -p "$BACKUP_DIR"

POSTGRES_DB=$(awk -F= '/^POSTGRES_DB=/{print $2}' "$ENV_FILE")
POSTGRES_USER=$(awk -F= '/^POSTGRES_USER=/{print $2}' "$ENV_FILE")

OUTPUT_FILE="$BACKUP_DIR/nexussklad-${STAMP}.sql"

docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" exec -T postgres \
  pg_dump -U "$POSTGRES_USER" "$POSTGRES_DB" > "$OUTPUT_FILE"

if [ "$COMPRESS_BACKUP" = "1" ]; then
  gzip -f "$OUTPUT_FILE"
  OUTPUT_FILE="${OUTPUT_FILE}.gz"
fi

shasum -a 256 "$OUTPUT_FILE" > "${OUTPUT_FILE}.sha256"

echo "Backup written to $OUTPUT_FILE"
echo "Checksum written to ${OUTPUT_FILE}.sha256"
