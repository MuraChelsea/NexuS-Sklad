#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ROOT_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)

BASE_URL=http://127.0.0.1:8080
RESET_MODE=no

for arg in "$@"; do
  case "$arg" in
    --reset)
      RESET_MODE=yes
      ;;
    http://*|https://*)
      BASE_URL=$arg
      ;;
    *)
      echo "Unknown argument: $arg" >&2
      echo "Usage: $0 [http://host:port] [--reset]" >&2
      exit 1
      ;;
  esac
done

if [ "$RESET_MODE" = "yes" ]; then
  "$SCRIPT_DIR/reset_staging_demo.sh"
fi

"$SCRIPT_DIR/start_ui_smoke_session.sh" "$BASE_URL"

LATEST_REPORT=$(ls -1 "$ROOT_DIR"/docs/ui-smoke-session-*.md | tail -n 1)
"$SCRIPT_DIR/create_ui_fix_pack.sh" "$LATEST_REPORT"

LATEST_FIX_PACK=$(ls -1 "$ROOT_DIR"/docs/ui-fix-pack-*.md | tail -n 1)

echo
echo "Workflow ready:"
echo "  session report: $LATEST_REPORT"
echo "  fix pack:       $LATEST_FIX_PACK"
