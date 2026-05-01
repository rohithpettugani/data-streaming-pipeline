# LAB 06 - Observability, Reliability, and Cleanup

## Objective

Harden the pipeline with monitoring and reliability checks, then clean up resources.

## Steps

1. Create CloudWatch alarms:
   - Lambda Errors > 0 for API ingest and DDB normalizer
   - Firehose DeliveryToS3.Success < expected baseline
   - Kinesis IncomingRecords = 0 during expected active windows
2. Add reliability checks:
   - Verify all events contain `event_id`
   - Confirm dedupe behavior in Glue output
   - Validate retries/backoff in producer clients
3. Document runbook notes:
   - how to replay from S3 raw zone
   - how to inspect DLQ/error prefixes

## Verify

- Trigger a synthetic failure (invalid API payload) and confirm logs capture it.
- Confirm alarms move to `OK` after system recovers.

## Cleanup

```bash
aws cloudformation delete-stack --stack-name streaming-pipeline-dev
```

Confirm stack deletion:

```bash
aws cloudformation wait stack-delete-complete --stack-name streaming-pipeline-dev
```
