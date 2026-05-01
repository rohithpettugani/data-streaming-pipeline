# LAB 03 - DynamoDB CDC Source

## Objective

Generate CDC events from DynamoDB Streams and route normalized records to Firehose.

## Files Used

- `src/producers/ddb_writer.py`
- `lambdas/ddb_stream_normalizer/app.py`

## Steps

1. Export table name:
   ```bash
   export AWS_REGION=us-east-1
   export DDB_TABLE_NAME="<cdc-table-name>"
   ```
2. Run CDC writer:
   ```bash
   python src/producers/ddb_writer.py
   ```

## Verify

1. Check logs for DDB normalizer Lambda.
2. Confirm objects appear in S3 raw prefix.
3. Confirm Firehose delivery activity.

## Quick Run

Use `run.sh` in this folder to launch CDC writer.
