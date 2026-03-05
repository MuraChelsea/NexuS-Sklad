#!/bin/sh
set -eu

if [ $# -ne 1 ]; then
  echo "Usage: $0 <backup.sql|backup.sql.gz>" >&2
  exit 1
fi

BACKUP_FILE=$1
CHECKSUM_FILE="${BACKUP_FILE}.sha256"

if [ ! -f "$BACKUP_FILE" ]; then
  echo "Backup file not found: $BACKUP_FILE" >&2
  exit 1
fi

if [ ! -f "$CHECKSUM_FILE" ]; then
  echo "Checksum file not found: $CHECKSUM_FILE" >&2
  exit 1
fi

shasum -a 256 -c "$CHECKSUM_FILE"
echo "Backup verified: $BACKUP_FILE"
