# LAB 05 - Analysis with Athena and Redshift

## Objective

Deploy analytics infrastructure and query curated stream outputs in Athena, then optionally load data into Redshift Serverless.

## Steps

1. Deploy analytics stack and generate SQL helper:
   ```bash
   bash labs/lab-05-athena-and-redshift-analysis/run.sh
   ```
2. Create Athena database:
   ```sql
   CREATE DATABASE IF NOT EXISTS streaming_lab;
   ```
3. Create external table:
   ```sql
   CREATE EXTERNAL TABLE IF NOT EXISTS streaming_lab.curated_events (
     event_id string,
     source string,
     event_ts string,
     user_id string,
     amount double,
     schema_version int
   )
   STORED AS PARQUET
   LOCATION 's3://<raw-bucket-name>/curated/events/';
   ```
4. Run validation query:
   ```sql
   SELECT source, COUNT(*) AS total_events
   FROM streaming_lab.curated_events
   GROUP BY source
   ORDER BY total_events DESC;
   ```

## Optional Redshift Path

1. Create target table in Redshift Serverless.
2. Load curated S3 data using `COPY`.
3. Run aggregate validation query.

## Verify

- Athena returns events from at least 2 sources.
- Redshift counts are close to Athena counts for same timeframe.

## Quick Run

Use `run.sh` in this folder to:
- check dependencies
- deploy analytics stack (`streaming-analytics-dev`)
- generate Athena SQL template file
