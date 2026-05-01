# LAB 03 - DynamoDB CDC Source

## Objective

Generate CDC events from DynamoDB Streams and route normalized records to Firehose.

## Files Used

- `src/producers/ddb_writer.py`
- `lambdas/ddb_stream_normalizer/app.py`

## Steps

1. Ensure Lab 01 and Lab 02 completed (foundation + ingestion stacks exist).
2. Run CDC writer:
   ```bash
   bash labs/lab-03-dynamodb-cdc-source/run.sh
   ```

The script performs dependency checks and auto-resolves `DDB_TABLE_NAME` from foundation stack outputs.

## Verify

1. Check logs for DDB normalizer Lambda.
2. Confirm objects appear in S3 raw prefix.
3. Confirm Firehose delivery activity.

## Quick Run

Use `run.sh` in this folder to launch CDC writer.
