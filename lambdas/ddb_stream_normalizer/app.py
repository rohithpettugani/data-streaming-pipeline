import base64
import json
import os
import uuid
from datetime import datetime, timezone
from decimal import Decimal

import boto3

firehose = boto3.client("firehose")


def _to_primitive(value):
    if isinstance(value, Decimal):
        return float(value)
    return value


def lambda_handler(event, context):
    stream_name = os.environ["FIREHOSE_STREAM_NAME"]
    records = []

    for record in event.get("Records", []):
        ddb = record.get("dynamodb", {})
        new_image = ddb.get("NewImage", {})
        event_name = record.get("eventName", "UNKNOWN")

        normalized = {
            "event_id": str(uuid.uuid4()),
            "source": "dynamodb_stream",
            "event_ts": datetime.now(timezone.utc).isoformat(),
            "schema_version": 1,
            "event_name": event_name,
            "payload": new_image,
        }
        serialized = (json.dumps(normalized, default=_to_primitive) + "\n").encode("utf-8")
        records.append({"Data": serialized})

    if records:
        firehose.put_record_batch(DeliveryStreamName=stream_name, Records=records)

    return {"statusCode": 200, "processed": len(records)}
