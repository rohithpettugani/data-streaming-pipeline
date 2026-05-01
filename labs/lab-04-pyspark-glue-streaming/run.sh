#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/../../scripts/lab_helpers.sh"

check_command aws

FOUNDATION_STACK_NAME="${FOUNDATION_STACK_NAME:-streaming-foundation-dev}"
assert_stack_exists "${FOUNDATION_STACK_NAME}"

# Upload Glue job script into S3 so Glue can execute it.
RAW_BUCKET_NAME="${RAW_BUCKET_NAME:-$(get_stack_output "${FOUNDATION_STACK_NAME}" "RawBucketName")}"
assert_non_empty "${RAW_BUCKET_NAME}" "RawBucketName"

SCRIPT_S3_URI="s3://${RAW_BUCKET_NAME}/glue/scripts/streaming_etl.py"

echo "Uploading Glue script to ${SCRIPT_S3_URI}"
aws s3 cp jobs/glue/streaming_etl.py "${SCRIPT_S3_URI}"

cat <<EOF
Glue script uploaded.

Sample command to start Glue job:
aws glue start-job-run \\
  --job-name <your-glue-job-name> \\
  --arguments '{
    "--kafka_bootstrap_servers":"<msk-bootstrap>",
    "--kafka_topic":"events",
    "--output_path":"s3://${RAW_BUCKET_NAME}/curated/events/",
    "--checkpoint_path":"s3://${RAW_BUCKET_NAME}/checkpoints/events/"
  }'
EOF
