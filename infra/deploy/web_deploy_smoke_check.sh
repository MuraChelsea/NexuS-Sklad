#!/bin/sh
set -eu

BASE_URL=${1:-http://127.0.0.1:8080}
LOGIN_MODE=${2:-with-login}
EMAIL=${NEXUSSKLAD_SMOKE_EMAIL:-owner@nexussklad.local}
PASSWORD=${NEXUSSKLAD_SMOKE_PASSWORD:-demo-owner-123}

HTML_PATH=${TMPDIR:-/tmp}/nexussklad_web_smoke_$$.html
BODY_PATH=${TMPDIR:-/tmp}/nexussklad_web_smoke_body_$$.json
trap 'rm -f "$HTML_PATH" "$BODY_PATH"' EXIT INT TERM

echo "Web deploy smoke: $BASE_URL"

curl -fsS --max-time 10 "$BASE_URL" -o "$HTML_PATH"
grep -q '<title>NexusSklad Control</title>' "$HTML_PATH"
grep -q 'name="description"' "$HTML_PATH"
grep -q '<div id="root"></div>' "$HTML_PATH"
if grep -q '/src/main.tsx' "$HTML_PATH"; then
  echo 'Unexpected dev entrypoint in deployed HTML' >&2
  exit 1
fi
echo ' - root html ok'

HEADER_PATH=${TMPDIR:-/tmp}/nexussklad_web_smoke_headers_$$.txt
trap 'rm -f "$HTML_PATH" "$BODY_PATH" "$HEADER_PATH"' EXIT INT TERM
curl -fsS -I --max-time 10 "$BASE_URL" > "$HEADER_PATH"
grep -qi '^x-content-type-options: nosniff' "$HEADER_PATH"
grep -qi '^x-frame-options: DENY' "$HEADER_PATH"
grep -qi '^referrer-policy: strict-origin-when-cross-origin' "$HEADER_PATH"
grep -qi '^content-security-policy:' "$HEADER_PATH"
echo ' - security headers ok'

ASSET_PATH=$(python3 - "$HTML_PATH" <<'PY2'
import re
import sys
from pathlib import Path
html = Path(sys.argv[1]).read_text()
match = re.search(r"/(assets/[^\"']+\.js)", html)
if not match:
    raise SystemExit(1)
print('/' + match.group(1))
PY2
)

curl -fsS -I --max-time 10 "$BASE_URL$ASSET_PATH" >/dev/null
echo " - asset ok: $ASSET_PATH"

curl -fsS -I --max-time 10 "$BASE_URL/health" >/dev/null
echo ' - health ok'

sh "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/readiness_check.sh" "$BASE_URL" >/dev/null
echo ' - ready ok'

if [ "$LOGIN_MODE" = 'skip-login' ]; then
  echo ' - login skipped'
  echo 'Web deploy smoke passed'
  exit 0
fi

LOGIN_STATUS=$(curl -s -o "$BODY_PATH" -w '%{http_code}' --max-time 10 \
  -X POST "$BASE_URL/v1/auth/login" \
  -H 'Content-Type: application/json' \
  -d "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}")

if [ "$LOGIN_STATUS" != '200' ]; then
  echo "Login failed with status $LOGIN_STATUS" >&2
  cat "$BODY_PATH" >&2
  exit 1
fi

grep -q '"module":"auth"' "$BODY_PATH"
grep -q '"accessToken"' "$BODY_PATH"
ACCESS_TOKEN=$(python3 - "$BODY_PATH" <<'PY2'
import json
import sys
from pathlib import Path
payload = json.loads(Path(sys.argv[1]).read_text())
print(payload['accessToken'])
PY2
)
echo ' - login ok'

ME_STATUS=$(curl -s -o "$BODY_PATH" -w '%{http_code}' --max-time 10 \
  -X GET "$BASE_URL/v1/auth/me" \
  -H "Authorization: Bearer $ACCESS_TOKEN")

if [ "$ME_STATUS" != '200' ]; then
  echo "auth/me failed with status $ME_STATUS" >&2
  cat "$BODY_PATH" >&2
  exit 1
fi

grep -q '"module":"auth"' "$BODY_PATH"
grep -q '"role":"OWNER"' "$BODY_PATH"
echo ' - auth/me ok'

echo 'Web deploy smoke passed'
