# LAB 02 - Python and API Sources

## Objective

Generate streaming data using:
- direct Python producer to Kinesis
- API client -> API Gateway -> Lambda -> Kinesis

## Files Used

- `src/producers/kinesis_producer.py`
- `src/producers/api_client.py`
- `lambdas/api_ingest/app.py`

## Steps

1. Export values from stack outputs:
   ```bash
   export AWS_REGION=us-east-1
   export STREAM_NAME="<stream-name>"
   export API_ENDPOINT="<api-invoke-url>"
   ```
2. Run producer:
   ```bash
   python src/producers/kinesis_producer.py
   ```
3. Run API client in another terminal:
   ```bash
   python src/producers/api_client.py
   ```

## Verify

Check CloudWatch/Kinesis metrics:
- `IncomingRecords`
- `IncomingBytes`

## Quick Run

Use `run.sh` in this folder to launch both sources together.
