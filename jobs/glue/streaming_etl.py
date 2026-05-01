import sys

from awsglue.utils import getResolvedOptions
from pyspark.sql import SparkSession
from pyspark.sql import functions as F
from pyspark.sql.types import DoubleType, IntegerType, StringType, StructField, StructType

args = getResolvedOptions(
    sys.argv,
    [
        "kafka_bootstrap_servers",
        "kafka_topic",
        "output_path",
        "checkpoint_path",
    ],
)

spark = SparkSession.builder.appName("streaming-etl").getOrCreate()
spark.conf.set("spark.sql.shuffle.partitions", "4")

schema = StructType(
    [
        StructField("event_id", StringType(), True),
        StructField("source", StringType(), True),
        StructField("event_ts", StringType(), True),
        StructField("user_id", StringType(), True),
        StructField("amount", DoubleType(), True),
        StructField("schema_version", IntegerType(), True),
    ]
)

raw = (
    spark.readStream.format("kafka")
    .option("kafka.bootstrap.servers", args["kafka_bootstrap_servers"])
    .option("subscribe", args["kafka_topic"])
    .option("startingOffsets", "latest")
    .load()
)

parsed = (
    raw.select(F.from_json(F.col("value").cast("string"), schema).alias("r"))
    .select("r.*")
    .withColumn("event_time", F.to_timestamp("event_ts"))
    .dropna(subset=["event_id", "event_time"])
)

clean = parsed.withWatermark("event_time", "10 minutes").dropDuplicates(["event_id"])

(
    clean.writeStream.format("parquet")
    .outputMode("append")
    .option("path", args["output_path"])
    .option("checkpointLocation", args["checkpoint_path"])
    .partitionBy("source")
    .trigger(processingTime="30 seconds")
    .start()
    .awaitTermination()
)
