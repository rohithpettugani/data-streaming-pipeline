# LAB 01 - Setup and Deploy Core Stack

## Objective

Deploy the foundation infrastructure with CloudFormation and validate dependencies before other labs.

## Files Used

- `infra/lab-01-foundation.json`
- `.github/workflows/deploy-streaming-stack.yml` (GitHub Actions workflows are YAML by design)
- `scripts/check-prerequisites.sh`

## Steps

1. Run prerequisites check:
   ```bash
   bash scripts/check-prerequisites.sh
   ```
2. Create Python environment and install dependencies:
   ```bash
   python -m venv .venv
   source .venv/bin/activate
   pip install -r requirements.txt
   ```
3. Validate template locally:
   ```bash
   aws cloudformation validate-template --template-body file://infra/lab-01-foundation.json
   ```
4. Deploy foundation stack:
   ```bash
   aws cloudformation deploy \
     --template-file infra/lab-01-foundation.json \
     --stack-name streaming-foundation-dev \
     --capabilities CAPABILITY_NAMED_IAM \
     --parameter-overrides ProjectName=dspipeline Environment=dev
   ```
5. Continue to Lab 02 for ingestion infrastructure deployment.

## Verify

```bash
aws cloudformation describe-stacks \
  --stack-name streaming-foundation-dev \
  --query "Stacks[0].Outputs" \
  --output table
```

Capture these outputs for later labs:
- `StreamName`
- `RawBucketName`
- `CdcTableName`
- `CdcTableStreamArn`

## Quick Run

Use `run.sh` in this folder to execute validation and deployment quickly.
