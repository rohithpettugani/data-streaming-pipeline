#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/../../scripts/lab_helpers.sh"

check_command aws

FOUNDATION_STACK_NAME="${FOUNDATION_STACK_NAME:-streaming-foundation-dev}"
INGESTION_STACK_NAME="${INGESTION_STACK_NAME:-streaming-ingestion-dev}"
ANALYTICS_STACK_NAME="${ANALYTICS_STACK_NAME:-streaming-analytics-dev}"

delete_stack_if_exists() {
  # Delete only when present to keep cleanup idempotent.
  local stack_name="$1"
  if stack_exists "${stack_name}"; then
    echo "Deleting stack ${stack_name}..."
    aws cloudformation delete-stack --stack-name "${stack_name}"
    aws cloudformation wait stack-delete-complete --stack-name "${stack_name}"
    echo "Stack ${stack_name} deleted."
  else
    echo "Stack not found, skipping: ${stack_name}"
  fi
}

delete_stack_if_exists "${ANALYTICS_STACK_NAME}"
delete_stack_if_exists "${INGESTION_STACK_NAME}"
delete_stack_if_exists "${FOUNDATION_STACK_NAME}"
