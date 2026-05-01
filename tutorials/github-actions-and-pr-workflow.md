# GitHub Actions and PR Workflow Tutorial

This guide shows how to collaborate using pull requests and deploy CloudFormation stacks with GitHub Actions.

## 1) Branch and PR Workflow

1. Create feature branch:

```bash
git checkout -b feature/update-streaming-stack
```

2. Make changes and commit:

```bash
git add infra/streaming-stack.yml
git commit -m "feat: add API Gateway resources to stack"
```

3. Push branch:

```bash
git push -u origin feature/update-streaming-stack
```

4. Open PR:

```bash
gh pr create --fill
```

5. Address review comments and push follow-up commits.
6. Merge after CI passes.

## 2) GitHub Actions CI for CloudFormation

Use this workflow to validate and deploy stack changes.

```yaml
name: Deploy Streaming Stack

on:
  workflow_dispatch:
  push:
    branches: [ "main" ]
    paths:
      - "infra/**"

permissions:
  id-token: write
  contents: read

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ secrets.AWS_ROLE_TO_ASSUME }}
          aws-region: ${{ secrets.AWS_REGION }}
      - name: Validate template
        run: aws cloudformation validate-template --template-body file://infra/streaming-stack.yml
      - name: Deploy stack
        run: |
          aws cloudformation deploy \
            --template-file infra/streaming-stack.yml \
            --stack-name streaming-pipeline-dev \
            --capabilities CAPABILITY_NAMED_IAM
```

## 3) Required Repository Secrets

Add these in GitHub repository settings:
- `AWS_ROLE_TO_ASSUME`
- `AWS_REGION`

Recommended approach:
- Use GitHub OIDC trust with AWS IAM role.
- Avoid static long-lived access keys in secrets.

## 4) What to Check in CI Logs

- Template validation succeeded.
- Stack update finished with `UPDATE_COMPLETE` or `CREATE_COMPLETE`.
- Outputs include expected resource names/ARNs.

## 5) Rollback and Troubleshooting

- If deployment fails:
  - Open CloudFormation events and inspect failing resource.
  - Fix template/IAM issue in branch.
  - Re-run workflow from GitHub Actions.

- If AWS auth fails:
  - Validate OIDC trust policy on IAM role.
  - Confirm secret names and values are correct.

## 6) Suggested Team Rules

- Protect `main` branch.
- Require pull request reviews.
- Require status checks to pass before merge.
- Keep PRs small and focused.

This workflow gives learners a production-style CI path for the streaming pipeline project.
