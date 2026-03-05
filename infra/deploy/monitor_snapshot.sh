#!/bin/sh
set -eu

TARGET=${1:-staging}

case "$TARGET" in
  staging)
    WEB_CONTAINER=nexussklad-web-staging
    API_CONTAINER=nexussklad-api-staging
    POSTGRES_CONTAINER=nexussklad-postgres-staging
    BASE_URL=${BASE_URL:-http://127.0.0.1:8080}
    ;;
  production|prod)
    WEB_CONTAINER=nexussklad-web-prod
    API_CONTAINER=nexussklad-api-prod
    POSTGRES_CONTAINER=nexussklad-postgres-prod
    BASE_URL=${BASE_URL:-http://127.0.0.1:8081}
    ;;
  *)
    echo "Usage: $0 [staging|production]" >&2
    exit 1
    ;;
esac

inspect_field() {
  container=$1
  format=$2
  docker inspect --format "$format" "$container"
}

print_container_status() {
  container=$1
  status=$(inspect_field "$container" '{{.State.Status}}')
  health=$(inspect_field "$container" '{{if .State.Health}}{{.State.Health.Status}}{{else}}n/a{{end}}')
  restarts=$(inspect_field "$container" '{{.RestartCount}}')
  started_at=$(inspect_field "$container" '{{.State.StartedAt}}')

  echo "$container"
  echo "  status:   $status"
  echo "  health:   $health"
  echo "  restarts: $restarts"
  echo "  started:  $started_at"
}

echo "NexusSklad monitor snapshot"
echo "target: $TARGET"
echo "time:   $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
echo

print_container_status "$WEB_CONTAINER"
print_container_status "$API_CONTAINER"
print_container_status "$POSTGRES_CONTAINER"

echo
if curl -fsS -I --max-time 10 "$BASE_URL" >/dev/null; then
  echo "root:   ok ($BASE_URL)"
else
  echo "root:   failed ($BASE_URL)"
fi

if curl -fsS -I --max-time 10 "$BASE_URL/health" >/dev/null; then
  echo "health: ok ($BASE_URL/health)"
else
  echo "health: failed ($BASE_URL/health)"
fi

if curl -fsS --max-time 10 "$BASE_URL/health/ready" >/dev/null; then
  echo "ready:  ok ($BASE_URL/health/ready)"
else
  echo "ready:  failed ($BASE_URL/health/ready)"
fi
