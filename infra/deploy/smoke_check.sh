#!/bin/sh
set -eu

BASE_URL=${1:-http://127.0.0.1:8081}
LOGIN_MODE=${2:-with-login}
EMAIL=${NEXUSSKLAD_SMOKE_EMAIL:-owner@nexussklad.local}
PASSWORD=${NEXUSSKLAD_SMOKE_PASSWORD:-demo-owner-123}

echo "Smoke check: $BASE_URL"

curl -fsS -I --max-time 10 "$BASE_URL" >/dev/null
echo " - root ok"

curl -fsS -I --max-time 10 "$BASE_URL/health" >/dev/null
echo " - health ok"

sh "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/readiness_check.sh" "$BASE_URL" >/dev/null
echo " - ready ok"

if [ "$LOGIN_MODE" = "skip-login" ]; then
  echo " - login skipped"
  echo "Smoke check passed"
  exit 0
fi

LOGIN_JSON=$(curl -fsS --max-time 10 \
  -X POST "$BASE_URL/v1/auth/login" \
  -H 'Content-Type: application/json' \
  -d "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}")

printf '%s' "$LOGIN_JSON" | grep -q '"accessToken"'
printf '%s' "$LOGIN_JSON" | grep -q '"module":"auth"'
echo " - login ok"

echo "Smoke check passed"
