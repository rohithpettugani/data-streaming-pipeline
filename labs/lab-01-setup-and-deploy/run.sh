#!/usr/bin/env bash
set -euo pipefail

STACK_NAME="${STACK_NAME:-streaming-pipeline-dev}"
PROJECT_NAME="${PROJECT_NAME:-dspipeline}"
ENVIRONMENT="${ENVIRONMENT:-dev}"
TEMPLATE_FILE="${TEMPLATE_FILE:-infra/streaming-stack.yml}"

echo "Validating template: ${TEMPLATE_FILE}"
aws cloudformation validate-template --template-body "file://${TEMPLATE_FILE}" >/dev/null

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
