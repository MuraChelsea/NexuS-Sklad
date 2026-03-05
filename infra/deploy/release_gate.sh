#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

echo "[1/6] staging monitor"
"$SCRIPT_DIR/monitor_check.sh" staging

echo "[1.1/6] staging readiness contract"
sh "$SCRIPT_DIR/readiness_check.sh" staging

echo "[2/6] production-like monitor"
"$SCRIPT_DIR/monitor_check.sh" production

echo "[2.1/6] production-like readiness contract"
sh "$SCRIPT_DIR/readiness_check.sh" production

echo "[3/6] staging app smoke"
"$SCRIPT_DIR/staging_happy_path_check.sh" http://127.0.0.1:8080

echo "[4/6] production-like smoke"
"$SCRIPT_DIR/smoke_check.sh" http://127.0.0.1:8081 skip-login

echo "[5/6] staging web smoke"
"$SCRIPT_DIR/web_deploy_smoke_check.sh" http://127.0.0.1:8080

echo "[6/6] production-like web smoke"
"$SCRIPT_DIR/web_deploy_smoke_check.sh" http://127.0.0.1:8081 skip-login

echo "NexusSklad release gate passed"
