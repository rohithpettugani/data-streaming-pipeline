# LAB 06 - Observability, Reliability, and Cleanup

## Objective

Add monitoring and reliability checks, then clean up stack resources.

## Steps

1. Create CloudWatch alarms:
   - Lambda errors for API ingest and DDB normalizer
   - Firehose delivery failure indicators
   - Kinesis no-traffic alert during expected active windows
2. Validate reliability patterns:
   - `event_id` exists on every record
   - dedupe behavior from Glue output
   - retry/backoff behavior in producer clients
3. Prepare runbook:
   - replay approach from S3 raw zone
   - troubleshooting flow for Lambda and Firehose errors

## Verify

- Introduce one controlled bad payload and confirm logs/metrics capture it.
- Confirm alarms return to `OK` when traffic normalizes.

## Cleanup

Use `run.sh` for stack cleanup:

```bash
STACK_NAME=streaming-pipeline-dev bash labs/lab-06-observability-and-cleanup/run.sh
```
