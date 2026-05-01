#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${RAW_BUCKET_NAME:-}" ]]; then
  echo "RAW_BUCKET_NAME is required"
  exit 1
fi

mkdir -p labs/lab-05-athena-and-redshift-analysis/output

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
