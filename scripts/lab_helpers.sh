#!/usr/bin/env bash

set -euo pipefail

# Ensure required CLI tools exist before any lab operation runs.
check_command() {
  local cmd="$1"
  if ! command -v "${cmd}" >/dev/null 2>&1; then
    echo "Missing required command: ${cmd}"
    exit 1
  fi
}

require_env() {
  local name="$1"
  if [[ -z "${!name:-}" ]]; then
    echo "Required environment variable is not set: ${name}"
    exit 1
  fi
}

stack_exists() {
  # Lightweight existence check used by cleanup and dependency guards.
  local stack_name="$1"
  aws cloudformation describe-stacks --stack-name "${stack_name}" >/dev/null 2>&1
}

assert_stack_exists() {
  local stack_name="$1"
  if ! stack_exists "${stack_name}"; then
    echo "CloudFormation stack not found: ${stack_name}"
    exit 1
  fi
}

get_stack_output() {
  # Read a single CloudFormation output by key.
  local stack_name="$1"
  local output_key="$2"
  aws cloudformation describe-stacks \
    --stack-name "${stack_name}" \
    --query "Stacks[0].Outputs[?OutputKey=='${output_key}'].OutputValue | [0]" \
    --output text
}

assert_non_empty() {
  # Defensive guard for missing stack outputs or failed lookups.
  local value="$1"
  local field_name="$2"
  if [[ -z "${value}" || "${value}" == "None" ]]; then
    echo "Expected non-empty value for: ${field_name}"
    exit 1
  fi
}
