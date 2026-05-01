# LAB 05 - Analysis with Athena and Redshift

## Objective

Query curated stream outputs in Athena and (optionally) load aggregate-ready data into Redshift Serverless.

## Steps

1. Create Athena database:
   ```sql
   CREATE DATABASE IF NOT EXISTS streaming_lab;
   ```
2. Create Athena table:
   ```sql
   CREATE EXTERNAL TABLE IF NOT EXISTS streaming_lab.curated_events (
     event_id string,
     source string,
     event_ts string,
     user_id string,
     amount double,
     schema_version int
   )
   PARTITIONED BY (source_partition string)
   STORED AS PARQUET
   LOCATION 's3://<raw-bucket-name>/curated/events/';
   ```
3. Load partitions:
   ```sql
   MSCK REPAIR TABLE streaming_lab.curated_events;
   ```
4. Run validation query:
   ```sql
   SELECT source, COUNT(*) AS total_events
   FROM streaming_lab.curated_events
   GROUP BY source
   ORDER BY total_events DESC;
   ```

## Optional Redshift Path

1. Create table in Redshift Serverless.
2. Run COPY from curated S3 prefix.
3. Run aggregates by source and event time window.

## Verify

- Athena returns rows for at least 2 sources.
- Redshift row counts approximately match Athena counts.
