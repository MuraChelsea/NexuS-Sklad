#!/bin/sh
set -eu

usage() {
  cat >&2 <<'USAGE'
Usage:
  ./bootstrap_owner.sh <staging|production|http://host:port>

Required env:
  BOOTSTRAP_COMPANY_NAME
  BOOTSTRAP_OWNER_NAME
  BOOTSTRAP_OWNER_EMAIL
  BOOTSTRAP_OWNER_PASSWORD

Optional env:
  BOOTSTRAP_COMPANY_CITY
  BOOTSTRAP_COMPANY_PHONE
  BOOTSTRAP_OWNER_PHONE
USAGE
  exit 1
}

require_env() {
  key=$1
  value=$(printenv "$key" 2>/dev/null || true)

  if [ -z "$value" ]; then
    echo "$key must be set" >&2
    exit 1
  fi

  printf '%s' "$value"
}

json_escape() {
  printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

if [ $# -ne 1 ]; then
  usage
fi

target=$1
case "$target" in
  staging)
    BASE_URL=http://127.0.0.1:8080
    ;;
  production)
    BASE_URL=http://127.0.0.1:8081
    ;;
  http://*|https://*)
    BASE_URL=$target
    ;;
  *)
    usage
    ;;
esac

COMPANY_NAME=$(require_env BOOTSTRAP_COMPANY_NAME)
OWNER_NAME=$(require_env BOOTSTRAP_OWNER_NAME)
OWNER_EMAIL=$(require_env BOOTSTRAP_OWNER_EMAIL)
OWNER_PASSWORD=$(require_env BOOTSTRAP_OWNER_PASSWORD)
COMPANY_CITY=${BOOTSTRAP_COMPANY_CITY:-}
COMPANY_PHONE=${BOOTSTRAP_COMPANY_PHONE:-}
OWNER_PHONE=${BOOTSTRAP_OWNER_PHONE:-}

if [ ${#OWNER_PASSWORD} -lt 6 ]; then
  echo 'BOOTSTRAP_OWNER_PASSWORD must be at least 6 characters' >&2
  exit 1
fi

REQUEST_BODY=$(cat <<JSON
{"companyName":"$(json_escape "$COMPANY_NAME")","companyCity":$( [ -n "$COMPANY_CITY" ] && printf '"%s"' "$(json_escape "$COMPANY_CITY")" || printf 'null' ),"companyPhone":$( [ -n "$COMPANY_PHONE" ] && printf '"%s"' "$(json_escape "$COMPANY_PHONE")" || printf 'null' ),"ownerName":"$(json_escape "$OWNER_NAME")","email":"$(json_escape "$OWNER_EMAIL")","phone":$( [ -n "$OWNER_PHONE" ] && printf '"%s"' "$(json_escape "$OWNER_PHONE")" || printf 'null' ),"password":"$(json_escape "$OWNER_PASSWORD")"}
JSON
)

TMP_RESPONSE=$(mktemp)
HTTP_CODE=$(curl -sS -o "$TMP_RESPONSE" -w '%{http_code}' --max-time 15 \
  -X POST "$BASE_URL/v1/auth/register" \
  -H 'Content-Type: application/json' \
  -d "$REQUEST_BODY")

if [ "$HTTP_CODE" -ne 200 ]; then
  echo "Bootstrap owner failed: HTTP $HTTP_CODE" >&2
  cat "$TMP_RESPONSE" >&2
  rm -f "$TMP_RESPONSE"
  exit 1
fi

if ! grep -q '"module":"auth"' "$TMP_RESPONSE" || ! grep -q '"action":"register"' "$TMP_RESPONSE" || ! grep -q '"accessToken"' "$TMP_RESPONSE"; then
  echo 'Bootstrap owner failed: unexpected response payload' >&2
  cat "$TMP_RESPONSE" >&2
  rm -f "$TMP_RESPONSE"
  exit 1
fi

echo "Bootstrap owner created at $BASE_URL"
echo " - company: $COMPANY_NAME"
echo " - owner:   $OWNER_EMAIL"
echo " - keep these credentials safe"
rm -f "$TMP_RESPONSE"
