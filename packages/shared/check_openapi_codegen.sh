#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SPEC_PATH="$SCRIPT_DIR/../../docs/openapi_v1.yaml"
TARGET_PATH="$SCRIPT_DIR/src/generated/openapi.ts"
TMP_PATH=$(mktemp "${TMPDIR:-/tmp}/nexussklad-openapi-check-XXXXXX.ts")
trap 'rm -f "$TMP_PATH"' EXIT INT TERM

"$SCRIPT_DIR/node_modules/.bin/openapi-typescript" "$SPEC_PATH" -o "$TMP_PATH" >/dev/null

if ! cmp -s "$TMP_PATH" "$TARGET_PATH"; then
  echo 'Generated TypeScript OpenAPI types are out of date.' >&2
  echo 'Run: npm run codegen:openapi' >&2
  exit 1
fi

echo 'OpenAPI TypeScript artifacts are up to date.'
