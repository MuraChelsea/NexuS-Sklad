#!/bin/sh
set -eu

OPS_LOG=${OPS_LOG:-/var/log/nexussklad-ops.log}
HEALTH_LOG=${HEALTH_LOG:-/var/log/nexussklad-health.log}
MAX_SIZE_BYTES=${MAX_SIZE_BYTES:-10485760}
KEEP_COUNT=${KEEP_COUNT:-7}
STAMP=$(date +"%Y%m%d-%H%M%S")

rotate_one() {
  log_file=$1

  if [ ! -f "$log_file" ]; then
    return 0
  fi

  size=$(wc -c < "$log_file" | tr -d ' ')
  if [ "$size" -lt "$MAX_SIZE_BYTES" ]; then
    return 0
  fi

  rotated="${log_file}.${STAMP}"
  mv "$log_file" "$rotated"
  : > "$log_file"
  gzip -f "$rotated"

  base_name=$(basename "$log_file")
  log_dir=$(dirname "$log_file")

  find "$log_dir" -maxdepth 1 -type f -name "${base_name}.*.gz" | sort -r | awk "NR > ${KEEP_COUNT}" | while IFS= read -r old_file; do
    rm -f "$old_file"
  done

  echo "Rotated $log_file -> ${rotated}.gz"
}

rotate_one "$OPS_LOG"
rotate_one "$HEALTH_LOG"

echo "NexusSklad log rotation completed"
