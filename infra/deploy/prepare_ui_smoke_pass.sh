#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
BASE_URL=${1:-http://127.0.0.1:8080}

echo "Prepare UI smoke pass for: $BASE_URL"

"$SCRIPT_DIR/staging_happy_path_check.sh" "$BASE_URL"

echo
echo "Next manual steps:"
echo "  1. Open docs/ui_smoke_checklist.md"
echo "  2. Use docs/ui_smoke_report_latest.md as current baseline"
echo "  3. If a clean demo state is needed, run reset_staging_demo.sh intentionally"
