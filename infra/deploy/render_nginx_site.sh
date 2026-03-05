#!/bin/sh

set -eu

if [ "$#" -ne 4 ]; then
  echo "Usage: $0 <staging|production> <domain> <upstream_port> <output_path>" >&2
  exit 1
fi

SITE_KIND=$1
DOMAIN=$2
UPSTREAM_PORT=$3
OUTPUT_PATH=$4

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
TEMPLATE_PATH="$SCRIPT_DIR/nginx/nexussklad-$SITE_KIND.conf.template"

if [ ! -f "$TEMPLATE_PATH" ]; then
  echo "Template not found: $TEMPLATE_PATH" >&2
  exit 1
fi

sed   -e "s/{{SERVER_NAME}}/$DOMAIN/g"   -e "s/{{UPSTREAM_PORT}}/$UPSTREAM_PORT/g"   "$TEMPLATE_PATH" > "$OUTPUT_PATH"

echo "Rendered $OUTPUT_PATH from $TEMPLATE_PATH"
