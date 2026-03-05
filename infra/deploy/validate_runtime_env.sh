#!/bin/sh
set -eu

if [ $# -ne 1 ]; then
  echo "Usage: $0 <env-file>" >&2
  exit 1
fi

ENV_FILE=$1

if [ ! -f "$ENV_FILE" ]; then
  echo "Env file not found: $ENV_FILE" >&2
  exit 1
fi

get_env_value() {
  key=$1
  awk -F= -v key="$key" '
    $1 == key {
      sub(/^[[:space:]]+/, "", $2)
      sub(/[[:space:]]+$/, "", $2)
      print $2
      exit
    }
  ' "$ENV_FILE"
}

require_value() {
  key=$1
  value=$(get_env_value "$key")

  if [ -z "$value" ]; then
    echo "$key must be set in $ENV_FILE" >&2
    exit 1
  fi

  printf '%s' "$value"
}

assert_not_placeholder() {
  key=$1
  value=$2
  normalized=$(printf '%s' "$value" | tr '[:upper:]' '[:lower:]')

  case "$normalized" in
    change-me|replace-me|replace-with-*|example|example-*|changeme)
      echo "$key must not use placeholder values in $ENV_FILE" >&2
      exit 1
      ;;
  esac
}

assert_min_length() {
  key=$1
  value=$2
  min_length=$3
  actual_length=$(printf '%s' "$value" | wc -c | tr -d ' ')

  if [ "$actual_length" -lt "$min_length" ]; then
    echo "$key must be at least $min_length characters in $ENV_FILE" >&2
    exit 1
  fi
}

assert_boolean_flag() {
  key=$1
  value=$2

  case "$value" in
    true|false)
      ;;
    *)
      echo "$key must be either true or false in $ENV_FILE" >&2
      exit 1
      ;;
  esac
}

assert_numeric_port() {
  key=$1
  value=$2

  case "$value" in
    ''|*[!0-9]*)
      echo "$key must be a numeric port in $ENV_FILE" >&2
      exit 1
      ;;
  esac
}

assert_log_size() {
  key=$1
  value=$2

  case "$value" in
    ''|*[!0-9kKmMgG]*)
      echo "$key must look like 10m, 50m or 1g in $ENV_FILE" >&2
      exit 1
      ;;
    *[kKmMgG])
      ;;
    *)
      echo "$key must end with k, m or g in $ENV_FILE" >&2
      exit 1
      ;;
  esac
}

POSTGRES_DB=$(require_value POSTGRES_DB)
POSTGRES_USER=$(require_value POSTGRES_USER)
POSTGRES_PASSWORD=$(require_value POSTGRES_PASSWORD)
JWT_ACCESS_SECRET=$(require_value JWT_ACCESS_SECRET)
JWT_REFRESH_SECRET=$(require_value JWT_REFRESH_SECRET)
ALLOW_PUBLIC_REGISTRATION=$(require_value ALLOW_PUBLIC_REGISTRATION)
NEXUSSKLAD_WEB_PORT=$(require_value NEXUSSKLAD_WEB_PORT)
NEXUSSKLAD_LOG_MAX_SIZE=$(require_value NEXUSSKLAD_LOG_MAX_SIZE)
NEXUSSKLAD_LOG_MAX_FILES=$(require_value NEXUSSKLAD_LOG_MAX_FILES)

assert_not_placeholder POSTGRES_PASSWORD "$POSTGRES_PASSWORD"
assert_not_placeholder JWT_ACCESS_SECRET "$JWT_ACCESS_SECRET"
assert_not_placeholder JWT_REFRESH_SECRET "$JWT_REFRESH_SECRET"

assert_min_length POSTGRES_PASSWORD "$POSTGRES_PASSWORD" 16
assert_min_length JWT_ACCESS_SECRET "$JWT_ACCESS_SECRET" 24
assert_min_length JWT_REFRESH_SECRET "$JWT_REFRESH_SECRET" 24

if [ "$JWT_ACCESS_SECRET" = "$JWT_REFRESH_SECRET" ]; then
  echo "JWT_ACCESS_SECRET and JWT_REFRESH_SECRET must be different in $ENV_FILE" >&2
  exit 1
fi

assert_boolean_flag ALLOW_PUBLIC_REGISTRATION "$ALLOW_PUBLIC_REGISTRATION"
assert_numeric_port NEXUSSKLAD_WEB_PORT "$NEXUSSKLAD_WEB_PORT"
assert_log_size NEXUSSKLAD_LOG_MAX_SIZE "$NEXUSSKLAD_LOG_MAX_SIZE"
assert_numeric_port NEXUSSKLAD_LOG_MAX_FILES "$NEXUSSKLAD_LOG_MAX_FILES"

echo "Runtime env validated: $ENV_FILE"
