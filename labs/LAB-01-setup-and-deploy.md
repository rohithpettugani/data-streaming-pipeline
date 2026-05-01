# LAB 01 - Setup and Deploy Core Stack

## Objective

Deploy the base infrastructure with CloudFormation and learn CI-driven deployment via GitHub Actions.

## Files Used

- `infra/streaming-stack.yml`
- `.github/workflows/deploy-streaming-stack.yml`

## Steps

1. Install dependencies:
   ```bash
   python -m venv .venv
   source .venv/bin/activate
   pip install -r requirements.txt
   ```
2. Validate template locally:
   ```bash
   aws cloudformation validate-template --template-body file://infra/streaming-stack.yml
   ```
3. Deploy stack manually once:
   ```bash
   aws cloudformation deploy \
     --template-file infra/streaming-stack.yml \
     --stack-name streaming-pipeline-dev \
     --capabilities CAPABILITY_NAMED_IAM \
     --parameter-overrides ProjectName=dspipeline Environment=dev
   ```
4. Configure GitHub repo secrets:
   - `AWS_ROLE_TO_ASSUME`
   - `AWS_REGION`
5. Trigger GitHub Actions workflow:
   - `Actions -> Deploy Streaming Stack -> Run workflow`

## Verify

Run:

```bash
aws cloudformation describe-stacks \
  --stack-name streaming-pipeline-dev \
  --query "Stacks[0].Outputs" \
  --output table
```

Capture these outputs for later labs:
- `StreamName`
- `FirehoseName`
- `RawBucketName`
- `CdcTableName`
- `ApiInvokeUrl`

## Cleanup Notes

Do not delete the stack yet; later labs depend on these resources.
