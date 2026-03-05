#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
CRON_TEMPLATE="$SCRIPT_DIR/ops_crontab.example"
TMP_CRON=$(mktemp "${TMPDIR:-/tmp}/nexussklad-cron-XXXXXX")
CURRENT_CRON=$(mktemp "${TMPDIR:-/tmp}/nexussklad-cron-current-XXXXXX")

cleanup() {
  rm -f "$TMP_CRON" "$CURRENT_CRON"
}
trap cleanup EXIT INT TERM

if [ ! -f "$CRON_TEMPLATE" ]; then
  echo "Cron template not found: $CRON_TEMPLATE" >&2
  exit 1
fi

START_MARKER="# --- NexusSklad ops begin ---"
END_MARKER="# --- NexusSklad ops end ---"

(crontab -l 2>/dev/null || true) > "$CURRENT_CRON"

awk -v start="$START_MARKER" -v end="$END_MARKER" '
  $0 == start { skip=1; next }
  $0 == end   { skip=0; next }
  !skip       { print }
' "$CURRENT_CRON" > "$TMP_CRON"

{
  cat "$TMP_CRON"
  [ -s "$TMP_CRON" ] && printf '\n'
  printf '%s\n' "$START_MARKER"
  cat "$CRON_TEMPLATE"
  printf '%s\n' "$END_MARKER"
} > "$CURRENT_CRON"

crontab "$CURRENT_CRON"

echo "Installed NexusSklad cron jobs:"
crontab -l
