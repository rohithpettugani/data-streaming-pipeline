# LAB 03 - DynamoDB CDC Source

## Objective

Generate change data capture events from DynamoDB Streams and route normalized records to Firehose.

## Files Used

- `src/producers/ddb_writer.py`
- `lambdas/ddb_stream_normalizer/app.py`

## Steps

1. Export table name from stack output:
   ```bash
   export AWS_REGION=us-east-1
   export DDB_TABLE_NAME="<cdc-table-name>"
   ```
2. Run CDC writer:
   ```bash
   python src/producers/ddb_writer.py
   ```
3. Let it run for 2-3 minutes.

## Verify

1. Check Lambda logs for the normalizer function (`ddb-normalizer`).
2. Confirm objects appear in S3 raw prefix:
   ```bash
   aws s3 ls s3://<raw-bucket-name>/raw/ --recursive
   ```
3. Confirm Firehose has delivery activity in CloudWatch.

## Cleanup Notes

Stop writer process with `Ctrl+C`.
