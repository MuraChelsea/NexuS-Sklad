#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ROOT_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)
BASE_URL=${1:-http://127.0.0.1:8080}
STAMP=$(date '+%Y%m%d-%H%M')
REPORT_PATH="$ROOT_DIR/docs/ui-smoke-session-$STAMP.md"

"$SCRIPT_DIR/prepare_ui_smoke_pass.sh" "$BASE_URL"
cp "$ROOT_DIR/docs/ui_smoke_report_latest.md" "$REPORT_PATH"

echo
echo "Session report created:"
echo "  $REPORT_PATH"
echo
echo "Recommended workflow:"
echo "  1. Open $REPORT_PATH"
echo "  2. Walk through docs/ui_smoke_checklist.md"
echo "  3. Record findings in the session report"
