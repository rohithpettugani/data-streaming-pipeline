# LAB 02 - Python and API Sources

## Objective

Deploy ingestion infrastructure and generate streaming data using:
- direct Python producer to Kinesis
- API client -> API Gateway -> Lambda -> Kinesis

## Files Used

- `src/producers/kinesis_producer.py`
- `src/producers/api_client.py`
- `lambdas/api_ingest/app.py`
- `infra/lab-02-ingestion.json`

## Steps

1. Ensure Lab 01 foundation stack is deployed (`streaming-foundation-dev` by default).
2. Run this lab helper script:
   ```bash
   bash labs/lab-02-python-and-api-sources/run.sh
   ```
3. The script will:
   - verify dependencies
   - deploy ingestion stack (`streaming-ingestion-dev`)
   - fetch `STREAM_NAME` and `API_ENDPOINT` from stack outputs
   - start both producers

## Verify

Check CloudWatch/Kinesis metrics:
- `IncomingRecords`
- `IncomingBytes`
- API Gateway and Lambda logs for ingest path

## Quick Run

Use `run.sh` in this folder to deploy ingestion infra and launch both sources together.
