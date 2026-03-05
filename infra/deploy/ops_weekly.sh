#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
TARGET=${1:-staging}

case "$TARGET" in
  staging)
    ENV_FILE=${ENV_FILE:-"$SCRIPT_DIR/.env.staging"}
    DRILL_TARGET=staging
    ;;
  production|prod)
    ENV_FILE=${ENV_FILE:-"$SCRIPT_DIR/.env.production"}
    DRILL_TARGET=production
    ;;
  *)
    echo "Usage: $0 [staging|production]" >&2
    exit 1
    ;;
esac

"$SCRIPT_DIR/validate_runtime_env.sh" "$ENV_FILE" >/dev/null
sh "$SCRIPT_DIR/readiness_check.sh" "$DRILL_TARGET"
BACKUP_DIR="${BACKUP_DIR:-$SCRIPT_DIR/backups}" sh "$SCRIPT_DIR/backup_restore_drill.sh" "$DRILL_TARGET"

echo "NexusSklad ops weekly completed: $TARGET"
