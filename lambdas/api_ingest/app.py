import json
import os
import uuid
from datetime import datetime, timezone

import boto3

kinesis = boto3.client("kinesis")


def lambda_handler(event, context):
    stream_name = os.environ["STREAM_NAME"]
    body = event.get("body") or "{}"
    data = json.loads(body)

    normalized = {
        "event_id": str(uuid.uuid4()),
        "source": "api_gateway",
        "event_ts": datetime.now(timezone.utc).isoformat(),
        "schema_version": 1,
        "payload": data,
    }

    kinesis.put_record(
        StreamName=stream_name,
        Data=json.dumps(normalized).encode("utf-8"),
        PartitionKey="api-source",
    )

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps({"ok": True, "event_id": normalized["event_id"]}),
    }
