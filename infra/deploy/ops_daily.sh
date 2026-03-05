#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
TARGET=${1:-production}

case "$TARGET" in
  staging)
    ENV_FILE=${ENV_FILE:-"$SCRIPT_DIR/.env.staging"}
    COMPOSE_FILE="$SCRIPT_DIR/docker-compose.staging.yml"
    MONITOR_TARGET=staging
    PRUNE_COUNT=${PRUNE_COUNT:-7}
    ;;
  production|prod)
    ENV_FILE=${ENV_FILE:-"$SCRIPT_DIR/.env.production"}
    COMPOSE_FILE="$SCRIPT_DIR/docker-compose.production.yml"
    MONITOR_TARGET=production
    PRUNE_COUNT=${PRUNE_COUNT:-14}
    ;;
  *)
    echo "Usage: $0 [staging|production]" >&2
    exit 1
    ;;
esac

export ENV_FILE
export COMPOSE_FILE

"$SCRIPT_DIR/validate_runtime_env.sh" "$ENV_FILE" >/dev/null
"$SCRIPT_DIR/backup_postgres.sh"
KEEP_COUNT="$PRUNE_COUNT" BACKUP_DIR="${BACKUP_DIR:-$SCRIPT_DIR/backups}" "$SCRIPT_DIR/prune_backups.sh"
"$SCRIPT_DIR/monitor_check.sh" "$MONITOR_TARGET"

echo "NexusSklad ops daily completed: $TARGET"
