#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ENV_FILE=${ENV_FILE:-"$SCRIPT_DIR/.env.staging"}
COMPOSE_FILE="$SCRIPT_DIR/docker-compose.staging.yml"

if [ ! -f "$ENV_FILE" ]; then
  echo "Missing env file: $ENV_FILE" >&2
  exit 1
fi

"$SCRIPT_DIR/validate_runtime_env.sh" "$ENV_FILE"

docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" up -d --build
