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

assert_status() {
  container=$1
  expected=$2
  actual=$(docker inspect --format '{{.State.Status}}' "$container")
  if [ "$actual" != "$expected" ]; then
    echo "$container status mismatch: expected $expected, got $actual" >&2
    exit 1
  fi
}

assert_health() {
  container=$1
  expected=$2
  actual=$(docker inspect --format '{{if .State.Health}}{{.State.Health.Status}}{{else}}n/a{{end}}' "$container")
  if [ "$actual" != "$expected" ]; then
    echo "$container health mismatch: expected $expected, got $actual" >&2
    exit 1
  fi
}

assert_status "$WEB_CONTAINER" running
assert_status "$API_CONTAINER" running
assert_status "$POSTGRES_CONTAINER" running

assert_health "$API_CONTAINER" healthy
assert_health "$POSTGRES_CONTAINER" healthy

curl -fsS -I --max-time 10 "$BASE_URL" >/dev/null
curl -fsS -I --max-time 10 "$BASE_URL/health" >/dev/null
curl -fsS --max-time 10 "$BASE_URL/health/ready" >/dev/null

echo "NexusSklad monitor check passed: $TARGET"
