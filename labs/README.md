# Structured Labs Index

Follow these labs in order. Each lab includes objective, steps, verification, and cleanup notes.

1. [LAB-01-setup-and-deploy.md](LAB-01-setup-and-deploy.md)
2. [LAB-02-python-and-api-sources.md](LAB-02-python-and-api-sources.md)
3. [LAB-03-dynamodb-cdc-source.md](LAB-03-dynamodb-cdc-source.md)
4. [LAB-04-pyspark-glue-streaming.md](LAB-04-pyspark-glue-streaming.md)
5. [LAB-05-athena-and-redshift-analysis.md](LAB-05-athena-and-redshift-analysis.md)
6. [LAB-06-observability-and-cleanup.md](LAB-06-observability-and-cleanup.md)

## Lab Completion Outcome

At the end of LAB-06, you should have:
- A deployed stack managed by CloudFormation + GitHub Actions.
- Ingestion running from Python app, API Gateway, DynamoDB streams, and MSK.
- Curated outputs in S3 and queryable analytics in Athena/Redshift.
