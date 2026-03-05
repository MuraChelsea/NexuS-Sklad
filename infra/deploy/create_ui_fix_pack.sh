#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ROOT_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)
SOURCE_REPORT=${1:-"$ROOT_DIR/docs/ui_smoke_report_latest.md"}
STAMP=$(date '+%Y%m%d-%H%M')
TARGET_PATH="$ROOT_DIR/docs/ui-fix-pack-$STAMP.md"

if [ ! -f "$SOURCE_REPORT" ]; then
  echo "Source report not found: $SOURCE_REPORT" >&2
  exit 1
fi

cp "$ROOT_DIR/docs/ui_fix_pack_template.md" "$TARGET_PATH"

SOURCE_BASENAME=$(basename "$SOURCE_REPORT")

python3 - "$TARGET_PATH" "$SOURCE_BASENAME" <<'PY'
from pathlib import Path
import sys

target = Path(sys.argv[1])
source_name = sys.argv[2]
content = target.read_text()
content = content.replace("{{SOURCE_REPORT}}", source_name)
target.write_text(content)
PY

echo "UI fix pack created:"
echo "  $TARGET_PATH"
echo
echo "Next steps:"
echo "  1. Copy findings from $SOURCE_REPORT"
echo "  2. Group by S1/S2/S3 and by area"
echo "  3. Implement one fix pack at a time"
