#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/../../scripts/lab_helpers.sh"

check_command aws

FOUNDATION_STACK_NAME="${FOUNDATION_STACK_NAME:-streaming-foundation-dev}"
ANALYTICS_STACK_NAME="${ANALYTICS_STACK_NAME:-streaming-analytics-dev}"
PROJECT_NAME="${PROJECT_NAME:-dspipeline}"
ENVIRONMENT="${ENVIRONMENT:-dev}"
TEMPLATE_FILE="${TEMPLATE_FILE:-infra/lab-05-analytics.json}"

assert_stack_exists "${FOUNDATION_STACK_NAME}"
# Analytics stack depends on foundation bucket output.
RAW_BUCKET_NAME="${RAW_BUCKET_NAME:-$(get_stack_output "${FOUNDATION_STACK_NAME}" "RawBucketName")}"
assert_non_empty "${RAW_BUCKET_NAME}" "RawBucketName"

echo "Validating template: ${TEMPLATE_FILE}"
aws cloudformation validate-template --template-body "file://${TEMPLATE_FILE}" >/dev/null

echo "Deploying analytics stack: ${ANALYTICS_STACK_NAME}"
aws cloudformation deploy \
  --template-file "${TEMPLATE_FILE}" \
  --stack-name "${ANALYTICS_STACK_NAME}" \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides \
    "ProjectName=${PROJECT_NAME}" \
    "Environment=${ENVIRONMENT}" \
    "RawBucketName=${RAW_BUCKET_NAME}"

mkdir -p labs/lab-05-athena-and-redshift-analysis/output

# Generate starter Athena SQL so learners can run queries immediately.
cat > labs/lab-05-athena-and-redshift-analysis/output/athena_queries.sql <<EOF
CREATE DATABASE IF NOT EXISTS streaming_lab;

CREATE EXTERNAL TABLE IF NOT EXISTS streaming_lab.curated_events (
  event_id string,
  source string,
  event_ts string,
  user_id string,
  amount double,
  schema_version int
)
STORED AS PARQUET
LOCATION 's3://${RAW_BUCKET_NAME}/curated/events/';

SELECT source, COUNT(*) AS total_events
FROM streaming_lab.curated_events
GROUP BY source
ORDER BY total_events DESC;
EOF

echo "Generated labs/lab-05-athena-and-redshift-analysis/output/athena_queries.sql"
