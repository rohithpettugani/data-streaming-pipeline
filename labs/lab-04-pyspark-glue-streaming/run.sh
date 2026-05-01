#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${RAW_BUCKET_NAME:-}" ]]; then
  echo "RAW_BUCKET_NAME is required"
  exit 1
fi

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
