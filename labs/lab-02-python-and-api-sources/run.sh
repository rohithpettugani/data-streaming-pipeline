#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/../../scripts/lab_helpers.sh"

check_command aws
check_command python3

FOUNDATION_STACK_NAME="${FOUNDATION_STACK_NAME:-streaming-foundation-dev}"
INGESTION_STACK_NAME="${INGESTION_STACK_NAME:-streaming-ingestion-dev}"
PROJECT_NAME="${PROJECT_NAME:-dspipeline}"
ENVIRONMENT="${ENVIRONMENT:-dev}"
TEMPLATE_FILE="${TEMPLATE_FILE:-infra/lab-02-ingestion.json}"

assert_stack_exists "${FOUNDATION_STACK_NAME}"

# Pull required values from foundation outputs instead of manual exports.
RAW_BUCKET_NAME="$(get_stack_output "${FOUNDATION_STACK_NAME}" "RawBucketName")"
RAW_BUCKET_ARN="$(get_stack_output "${FOUNDATION_STACK_NAME}" "RawBucketArn")"
STREAM_NAME="$(get_stack_output "${FOUNDATION_STACK_NAME}" "StreamName")"
STREAM_ARN="$(get_stack_output "${FOUNDATION_STACK_NAME}" "StreamArn")"
CDC_TABLE_STREAM_ARN="$(get_stack_output "${FOUNDATION_STACK_NAME}" "CdcTableStreamArn")"

assert_non_empty "${RAW_BUCKET_NAME}" "RawBucketName"
assert_non_empty "${RAW_BUCKET_ARN}" "RawBucketArn"
assert_non_empty "${STREAM_NAME}" "StreamName"
assert_non_empty "${STREAM_ARN}" "StreamArn"
assert_non_empty "${CDC_TABLE_STREAM_ARN}" "CdcTableStreamArn"

echo "Validating template: ${TEMPLATE_FILE}"
aws cloudformation validate-template --template-body "file://${TEMPLATE_FILE}" >/dev/null

# Ingestion stack creates API Gateway, Lambda ingest path, and Firehose wiring.
echo "Deploying ingestion stack: ${INGESTION_STACK_NAME}"
aws cloudformation deploy \
  --template-file "${TEMPLATE_FILE}" \
  --stack-name "${INGESTION_STACK_NAME}" \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides \
    "ProjectName=${PROJECT_NAME}" \
    "Environment=${ENVIRONMENT}" \
    "RawBucketName=${RAW_BUCKET_NAME}" \
    "RawBucketArn=${RAW_BUCKET_ARN}" \
    "EventStreamName=${STREAM_NAME}" \
    "EventStreamArn=${STREAM_ARN}" \
    "CdcTableStreamArn=${CDC_TABLE_STREAM_ARN}"

API_ENDPOINT="$(get_stack_output "${INGESTION_STACK_NAME}" "ApiInvokeUrl")"
assert_non_empty "${API_ENDPOINT}" "ApiInvokeUrl"

export STREAM_NAME
export API_ENDPOINT

# Run both event sources together to generate multi-source traffic quickly.
echo "Starting Kinesis producer and API client..."
python src/producers/kinesis_producer.py &
PID_PRODUCER=$!

python src/producers/api_client.py &
PID_API=$!

cleanup() {
  # Ensure background processes are stopped on script exit.
  echo "Stopping background producers..."
  kill "${PID_PRODUCER}" "${PID_API}" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

wait
