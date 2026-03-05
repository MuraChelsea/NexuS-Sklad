#!/bin/sh
set -eu

TARGET=${1:-staging}

case "$TARGET" in
  staging)
    BASE_URL=${BASE_URL:-http://127.0.0.1:8080}
    ;;
  production|prod)
    BASE_URL=${BASE_URL:-http://127.0.0.1:8081}
    ;;
  http://*|https://*)
    BASE_URL=$TARGET
    TARGET=custom
    ;;
  *)
    echo "Usage: $0 [staging|production|http://host:port]" >&2
    exit 1
    ;;
esac

BODY_PATH=${TMPDIR:-/tmp}/nexussklad_readiness_$$.json
trap 'rm -f "$BODY_PATH"' EXIT INT TERM

STATUS=$(curl -s -o "$BODY_PATH" -w '%{http_code}' --max-time 10 "$BASE_URL/health/ready")

if [ "$STATUS" != "200" ]; then
  echo "Readiness check failed with status $STATUS for $BASE_URL/health/ready" >&2
  cat "$BODY_PATH" >&2
  exit 1
fi

python3 - "$BODY_PATH" <<'PY'
import json
import sys
from pathlib import Path

payload = json.loads(Path(sys.argv[1]).read_text())
assert payload["status"] == "ok", payload
assert payload["service"] == "nexussklad-api", payload
assert payload["checks"]["database"] == "ok", payload
assert isinstance(payload["timestamp"], str) and payload["timestamp"], payload
PY

echo "NexusSklad readiness check passed: $TARGET"
