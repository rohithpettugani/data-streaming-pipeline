#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/../../scripts/lab_helpers.sh"

STACK_NAME="${STACK_NAME:-streaming-foundation-dev}"
PROJECT_NAME="${PROJECT_NAME:-dspipeline}"
ENVIRONMENT="${ENVIRONMENT:-dev}"
TEMPLATE_FILE="${TEMPLATE_FILE:-infra/lab-01-foundation.json}"

check_command aws

# Validate template before deploy to fail early on syntax issues.
echo "Validating template: ${TEMPLATE_FILE}"
aws cloudformation validate-template --template-body "file://${TEMPLATE_FILE}" >/dev/null

# Foundation stack provides shared outputs consumed by later labs.
echo "Deploying stack: ${STACK_NAME}"
aws cloudformation deploy \
  --template-file "${TEMPLATE_FILE}" \
  --stack-name "${STACK_NAME}" \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides "ProjectName=${PROJECT_NAME}" "Environment=${ENVIRONMENT}"

echo "Stack outputs:"
aws cloudformation describe-stacks \
  --stack-name "${STACK_NAME}" \
  --query "Stacks[0].Outputs" \
  --output table
