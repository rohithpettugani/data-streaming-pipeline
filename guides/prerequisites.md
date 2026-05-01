# Prerequisites Guide

Use this guide before starting any lab.

## Required Tools

- AWS CLI v2
- Python 3.10+
- pip3
- git
- (Optional) GitHub CLI `gh`

## Required Access

- AWS credentials configured and active (`aws sts get-caller-identity` works)
- Permissions for CloudFormation, IAM, S3, Kinesis, Firehose, Lambda, API Gateway, DynamoDB, Glue, Athena, CloudWatch
- GitHub repository admin access for configuring Actions secrets

## Python Setup

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Quick Validation Script

Run:

```bash
bash scripts/check-prerequisites.sh
```

This validates local tools, AWS auth, and Python dependency installability.

## GitHub Actions Secrets

Set in repository settings:
- `AWS_ROLE_TO_ASSUME`
- `AWS_REGION`

## Suggested Environment Defaults

```bash
export AWS_REGION=us-east-1
export PROJECT_NAME=dspipeline
export ENVIRONMENT=dev
```
