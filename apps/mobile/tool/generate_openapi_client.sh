#!/usr/bin/env sh
set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname "$0")" && pwd)"
MOBILE_DIR="$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)"
REPO_DIR="$(CDPATH= cd -- "$MOBILE_DIR/../.." && pwd)"
SPEC_PATH="$REPO_DIR/docs/openapi_v1.yaml"
OUTPUT_DIR="$MOBILE_DIR/generated/openapi_client"
CONFIG_PATH="$MOBILE_DIR/openapi-generator-config.yaml"

if [ ! -f "$SPEC_PATH" ]; then
  echo "OpenAPI spec not found: $SPEC_PATH" >&2
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

docker run --rm \
  -u "$(id -u):$(id -g)" \
  -v "$REPO_DIR":/local \
  openapitools/openapi-generator-cli generate \
  -i /local/docs/openapi_v1.yaml \
  -g dart-dio \
  -c /local/apps/mobile/openapi-generator-config.yaml \
  -o /local/apps/mobile/generated/openapi_client

perl -0pi -e "s/sdk: '>=3\\.5\\.0 <4\\.0\\.0'/sdk: '^3.8.0'/" "$OUTPUT_DIR/pubspec.yaml"
perl -0pi -e "s/import 'package:nexussklad_openapi_client\\/src\\/deserialize\\.dart';\\n//" "$OUTPUT_DIR/lib/src/api/default_api.dart"

echo "Generated Dart OpenAPI client into $OUTPUT_DIR"
