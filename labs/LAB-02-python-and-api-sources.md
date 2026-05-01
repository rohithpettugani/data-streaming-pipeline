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

1. Export values from CloudFormation outputs:
   ```bash
   export AWS_REGION=us-east-1
   export STREAM_NAME="<stream-name>"
   export API_ENDPOINT="<api-invoke-url>"
   ```
2. Start Python producer in one terminal:
   ```bash
   python src/producers/kinesis_producer.py
   ```
3. Start API client in a second terminal:
   ```bash
   python src/producers/api_client.py
   ```

## Verify

Check Kinesis metrics in CloudWatch:
- IncomingRecords
- IncomingBytes

Optional CLI check:

```bash
aws cloudwatch get-metric-statistics \
  --namespace AWS/Kinesis \
  --metric-name IncomingRecords \
  --dimensions Name=StreamName,Value="${STREAM_NAME}" \
  --start-time "$(date -u -v-10M +%Y-%m-%dT%H:%M:%SZ)" \
  --end-time "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  --period 60 \
  --statistics Sum
```

## Cleanup Notes

Stop both scripts with `Ctrl+C` after validation.
