#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

echo 'Contract integrity check'

(
  cd "$ROOT_DIR/packages/shared"
  npm run codegen:openapi:check
  npm run check
)

(
  cd "$ROOT_DIR/apps/api"
  npm run check
)

(
  cd "$ROOT_DIR/apps/web"
  npm run check
  npm run build
)

echo 'Contract integrity check passed'
