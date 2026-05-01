# LAB 04 - PySpark Streaming with AWS Glue

## Objective

Run a Glue streaming ETL job that reads stream data, applies schema + dedupe logic, and writes curated parquet to S3.

## Files Used

- `jobs/glue/streaming_etl.py`

## Steps

1. Ensure Lab 01 foundation stack exists.
2. Upload script:
   ```bash
   bash labs/lab-04-pyspark-glue-streaming/run.sh
   ```
3. Create Glue job with IAM role and script location.
4. Start job with args:
   - `--kafka_bootstrap_servers <msk-bootstrap>`
   - `--kafka_topic events`
   - `--output_path s3://<raw-bucket-name>/curated/events/`
   - `--checkpoint_path s3://<raw-bucket-name>/checkpoints/events/`

## Verify

1. Glue run status and logs.
2. Curated parquet output in S3.
3. Source-based partitions are created.

## Quick Run

Use `run.sh` in this folder to check dependencies, resolve bucket output, upload the script, and print a sample Glue start command.
