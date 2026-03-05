#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
BACKUP_DIR=${BACKUP_DIR:-"$SCRIPT_DIR/backups"}
KEEP_COUNT=${KEEP_COUNT:-10}

case "$KEEP_COUNT" in
  ''|*[!0-9]*)
    echo "KEEP_COUNT must be a non-negative integer" >&2
    exit 1
    ;;
esac

if [ ! -d "$BACKUP_DIR" ]; then
  echo "Backup directory not found: $BACKUP_DIR" >&2
  exit 1
fi

list_backups() {
  find "$BACKUP_DIR" -maxdepth 1 -type f \( -name 'nexussklad-*.sql' -o -name 'nexussklad-*.sql.gz' \) \
    | sed 's#^\./##' \
    | sort
}

BACKUPS=$(list_backups)

if [ -z "$BACKUPS" ]; then
  echo "No backups to prune in $BACKUP_DIR"
  exit 0
fi

COUNT=$(printf '%s\n' "$BACKUPS" | sed '/^$/d' | wc -l | tr -d ' ')

if [ "$COUNT" -le "$KEEP_COUNT" ]; then
  echo "Nothing to prune: found $COUNT backups, keep-count is $KEEP_COUNT"
  exit 0
fi

TO_DELETE_COUNT=$((COUNT - KEEP_COUNT))
printf '%s\n' "$BACKUPS" | sed '/^$/d' | head -n "$TO_DELETE_COUNT" | while IFS= read -r backup_file; do
  rm -f "$backup_file" "${backup_file}.sha256"
  echo "Pruned $backup_file"
done
