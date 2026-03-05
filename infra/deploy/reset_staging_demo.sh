#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ENV_FILE=${1:-"$SCRIPT_DIR/.env.staging.example"}

echo "Reset staging demo data using: $ENV_FILE"
echo "This recreates the staging database volume and reseeds demo accounts."

docker compose --env-file "$ENV_FILE" -f "$SCRIPT_DIR/docker-compose.staging.yml" down -v
docker compose --env-file "$ENV_FILE" -f "$SCRIPT_DIR/docker-compose.staging.yml" up -d --build
docker compose --env-file "$ENV_FILE" -f "$SCRIPT_DIR/docker-compose.staging.yml" exec -T api npm run prisma:seed

echo "Staging demo reset complete"
