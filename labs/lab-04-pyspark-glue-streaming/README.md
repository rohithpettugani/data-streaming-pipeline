# LAB 04 - PySpark Streaming with AWS Glue

## Objective

Run a Glue streaming ETL job that reads stream data, applies schema + dedupe logic, and writes curated parquet to S3.

## Files Used

- `jobs/glue/streaming_etl.py`

## Steps

1. Upload script:
   ```bash
   aws s3 cp jobs/glue/streaming_etl.py s3://<raw-bucket-name>/glue/scripts/streaming_etl.py
   ```
2. Create Glue job with IAM role and script location.
3. Start job with args:
   - `--kafka_bootstrap_servers <msk-bootstrap>`
   - `--kafka_topic events`
   - `--output_path s3://<raw-bucket-name>/curated/events/`
   - `--checkpoint_path s3://<raw-bucket-name>/checkpoints/events/`

## Verify

1. Glue run status and logs.
2. Curated parquet output in S3.
3. Source-based partitions are created.

## Quick Run

Use `run.sh` in this folder to upload the script and print sample Glue start command.
