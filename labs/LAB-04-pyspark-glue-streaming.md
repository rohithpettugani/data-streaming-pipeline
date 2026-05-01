# LAB 04 - PySpark Streaming with AWS Glue

## Objective

Run a Glue streaming ETL job that reads stream data, applies schema + dedupe logic, and writes curated parquet files to S3.

## Files Used

- `jobs/glue/streaming_etl.py`

## Steps

1. Upload Glue job script:
   ```bash
   aws s3 cp jobs/glue/streaming_etl.py s3://<raw-bucket-name>/glue/scripts/streaming_etl.py
   ```
2. Create Glue job (once):
   - Runtime: Glue 4.0+
   - IAM role: role with S3 + MSK/Kinesis access
   - Script location: uploaded S3 URI
3. Start Glue job with arguments:
   - `--kafka_bootstrap_servers <msk-bootstrap>`
   - `--kafka_topic events`
   - `--output_path s3://<raw-bucket-name>/curated/events/`
   - `--checkpoint_path s3://<raw-bucket-name>/checkpoints/events/`

## Verify

1. Confirm Glue job run is `RUNNING` then writing output.
2. Validate parquet output:
   ```bash
   aws s3 ls s3://<raw-bucket-name>/curated/events/ --recursive
   ```
3. Confirm partition folders by `source`.

## Cleanup Notes

Stop Glue run after validation if you are cost-sensitive.
