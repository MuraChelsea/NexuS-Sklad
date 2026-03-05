#!/bin/sh
set -eu

BASE_URL=${1:-http://85.239.56.248:8080}

OWNER_EMAIL=${NEXUSSKLAD_OWNER_EMAIL:-owner@nexussklad.local}
OWNER_PASSWORD=${NEXUSSKLAD_OWNER_PASSWORD:-demo-owner-123}
MANAGER_EMAIL=${NEXUSSKLAD_MANAGER_EMAIL:-manager@nexussklad.local}
MANAGER_PASSWORD=${NEXUSSKLAD_MANAGER_PASSWORD:-demo-manager-123}
STAFF_EMAIL=${NEXUSSKLAD_STAFF_EMAIL:-staff@nexussklad.local}
STAFF_PASSWORD=${NEXUSSKLAD_STAFF_PASSWORD:-demo-staff-123}

echo "Staging happy-path check: $BASE_URL"

curl -fsS -I --max-time 10 "$BASE_URL" >/dev/null
echo " - root ok"

curl -fsS -I --max-time 10 "$BASE_URL/health" >/dev/null
echo " - health ok"

login() {
  email=$1
  password=$2

  curl -fsS --max-time 10 \
    -X POST "$BASE_URL/v1/auth/login" \
    -H 'Content-Type: application/json' \
    -d "{\"email\":\"$email\",\"password\":\"$password\"}"
}

json_field() {
  json_input=$1
  field_path=$2

  JSON_INPUT="$json_input" python3 - "$field_path" <<'PY'
import json
import os
import sys

payload = json.loads(os.environ["JSON_INPUT"])
current = payload
for part in sys.argv[1].split("."):
    if isinstance(current, list):
        current = current[int(part)]
    else:
        current = current[part]
print(current)
PY
}

json_count() {
  json_input=$1
  field_path=$2

  JSON_INPUT="$json_input" python3 - "$field_path" <<'PY'
import json
import os
import sys

payload = json.loads(os.environ["JSON_INPUT"])
current = payload
for part in sys.argv[1].split("."):
    if isinstance(current, list):
        current = current[int(part)]
    else:
        current = current[part]
print(len(current))
PY
}

expect_status() {
  method=$1
  url=$2
  token=$3
  expected=$4
  payload=${5:-}

  if [ -n "$payload" ]; then
    status=$(curl -s -o /tmp/nexussklad_check_body.$$ -w "%{http_code}" --max-time 10 \
      -X "$method" "$BASE_URL$url" \
      -H 'Content-Type: application/json' \
      -H "Authorization: Bearer $token" \
      -d "$payload")
  else
    status=$(curl -s -o /tmp/nexussklad_check_body.$$ -w "%{http_code}" --max-time 10 \
      -X "$method" "$BASE_URL$url" \
      -H "Authorization: Bearer $token")
  fi

  if [ "$status" != "$expected" ]; then
    echo "Unexpected status for $method $url: got $status expected $expected"
    cat /tmp/nexussklad_check_body.$$
    rm -f /tmp/nexussklad_check_body.$$
    exit 1
  fi

  rm -f /tmp/nexussklad_check_body.$$
}

OWNER_JSON=$(login "$OWNER_EMAIL" "$OWNER_PASSWORD")
OWNER_TOKEN=$(json_field "$OWNER_JSON" "accessToken")
OWNER_ROLE=$(json_field "$OWNER_JSON" "user.role")
[ "$OWNER_ROLE" = "OWNER" ]
echo " - owner login ok"

MANAGER_JSON=$(login "$MANAGER_EMAIL" "$MANAGER_PASSWORD")
MANAGER_TOKEN=$(json_field "$MANAGER_JSON" "accessToken")
MANAGER_ROLE=$(json_field "$MANAGER_JSON" "user.role")
[ "$MANAGER_ROLE" = "MANAGER" ]
echo " - manager login ok"

STAFF_JSON=$(login "$STAFF_EMAIL" "$STAFF_PASSWORD")
STAFF_TOKEN=$(json_field "$STAFF_JSON" "accessToken")
STAFF_ROLE=$(json_field "$STAFF_JSON" "user.role")
[ "$STAFF_ROLE" = "STAFF" ]
echo " - staff login ok"

expect_status GET /v1/auth/me "$OWNER_TOKEN" 200
expect_status GET /v1/auth/me "$MANAGER_TOKEN" 200
expect_status GET /v1/auth/me "$STAFF_TOKEN" 200
echo " - auth/me ok"

expect_status GET /v1/products "$OWNER_TOKEN" 200
expect_status GET /v1/products "$MANAGER_TOKEN" 200
expect_status GET /v1/products "$STAFF_TOKEN" 200
expect_status GET /v1/movements "$OWNER_TOKEN" 200
expect_status GET /v1/movements "$MANAGER_TOKEN" 200
expect_status GET /v1/movements "$STAFF_TOKEN" 200
echo " - catalog and movements ok"

expect_status GET /v1/reports/daily "$OWNER_TOKEN" 200
expect_status GET /v1/reports/daily "$MANAGER_TOKEN" 200
expect_status GET /v1/reports/daily "$STAFF_TOKEN" 403
echo " - reports access ok"

expect_status GET /v1/users "$OWNER_TOKEN" 200
expect_status GET /v1/users "$MANAGER_TOKEN" 403
expect_status GET /v1/users "$STAFF_TOKEN" 403
echo " - users role guards ok"

expect_status GET /v1/audit "$OWNER_TOKEN" 200
expect_status GET /v1/audit "$MANAGER_TOKEN" 403
expect_status GET /v1/audit "$STAFF_TOKEN" 403
echo " - audit role guards ok"

PRODUCTS_JSON=$(curl -fsS --max-time 10 \
  -X GET "$BASE_URL/v1/products" \
  -H "Authorization: Bearer $OWNER_TOKEN")

PRODUCT_COUNT=$(json_count "$PRODUCTS_JSON" "items")
if [ "$PRODUCT_COUNT" -gt 0 ]; then
  FIRST_PRODUCT_ID=$(json_field "$PRODUCTS_JSON" "items.0.id")
  expect_status POST /v1/movements/adjustment "$STAFF_TOKEN" 403 \
    "{\"productId\":\"$FIRST_PRODUCT_ID\",\"targetQty\":1,\"comment\":\"staff-guard-check\"}"
  echo " - staff adjustment guard ok"
fi

echo "Staging happy-path check passed"
