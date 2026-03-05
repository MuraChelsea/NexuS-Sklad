#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

echo "[1/4] shared"
cd "$SCRIPT_DIR/packages/shared"
npm run codegen:openapi:check
npm run check

echo "[2/4] api"
cd "$SCRIPT_DIR/apps/api"
npm run check
npm run test:contract
npm run test:smoke

echo "[3/4] web"
cd "$SCRIPT_DIR/apps/web"
npm run check
npm run test:contract
npm run test:recovery
npm run test:render
npm run build

echo "[4/4] mobile"
cd "$SCRIPT_DIR/apps/mobile"
docker run --rm \
  -v "$PWD":/workspace \
  -w /workspace \
  ghcr.io/cirruslabs/flutter:stable \
  sh -lc 'flutter pub get && flutter analyze && flutter test test/widget/render_smoke_test.dart test/widget/screen_recovery_test.dart test/network/api_contract_test.dart test/auth/auth_controller_test.dart'

echo "NexusSklad quality gate passed"
