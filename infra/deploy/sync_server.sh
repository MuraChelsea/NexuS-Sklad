#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PROJECT_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)

REMOTE_HOST=${REMOTE_HOST:-root@85.239.56.248}
REMOTE_DIR=${REMOTE_DIR:-/root/nexussklad}

rsync -az --delete \
  --exclude '.env.staging' \
  --exclude '.env.production' \
  --exclude 'infra/deploy/backups/' \
  "$PROJECT_ROOT"/ "$REMOTE_HOST":"$REMOTE_DIR"/

echo "Synced $PROJECT_ROOT -> $REMOTE_HOST:$REMOTE_DIR"
