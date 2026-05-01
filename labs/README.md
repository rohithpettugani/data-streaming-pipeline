# Structured Labs Index

Follow these labs in order. Each lab is a folder with:
- `README.md` for instructions
- `run.sh` for a runnable helper script

1. [lab-01-setup-and-deploy/](lab-01-setup-and-deploy/)
2. [lab-02-python-and-api-sources/](lab-02-python-and-api-sources/)
3. [lab-03-dynamodb-cdc-source/](lab-03-dynamodb-cdc-source/)
4. [lab-04-pyspark-glue-streaming/](lab-04-pyspark-glue-streaming/)
5. [lab-05-athena-and-redshift-analysis/](lab-05-athena-and-redshift-analysis/)
6. [lab-06-observability-and-cleanup/](lab-06-observability-and-cleanup/)

## How To Execute

From repository root, run for any lab:

```bash
bash labs/<lab-folder>/run.sh
```

Example:

```bash
bash labs/lab-01-setup-and-deploy/run.sh
```

## Lab Completion Outcome

At the end of LAB-06, you should have:
- A deployed stack managed by CloudFormation + GitHub Actions.
- Ingestion running from Python app, API Gateway, DynamoDB streams, and MSK.
- Curated outputs in S3 and queryable analytics in Athena/Redshift.
