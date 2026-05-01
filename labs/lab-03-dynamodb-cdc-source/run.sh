#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/../../scripts/lab_helpers.sh"

check_command aws
check_command python3

FOUNDATION_STACK_NAME="${FOUNDATION_STACK_NAME:-streaming-foundation-dev}"
assert_stack_exists "${FOUNDATION_STACK_NAME}"

# Resolve table output so users do not have to set DDB_TABLE_NAME manually.
DDB_TABLE_NAME="${DDB_TABLE_NAME:-$(get_stack_output "${FOUNDATION_STACK_NAME}" "CdcTableName")}"
assert_non_empty "${DDB_TABLE_NAME}" "CdcTableName"

export DDB_TABLE_NAME

python src/producers/ddb_writer.py
