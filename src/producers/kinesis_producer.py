#!/usr/bin/env python3
import json
import os
import random
import time
import uuid
from datetime import datetime, timezone

import boto3


def build_event() -> dict:
    return {
        "event_id": str(uuid.uuid4()),
        "source": "python_producer",
        "event_ts": datetime.now(timezone.utc).isoformat(),
        "user_id": f"user-{uuid.uuid4().hex[:8]}",
        "amount": round(random.uniform(5.0, 500.0), 2),
        "schema_version": 1,
    }


def main() -> None:
    region = os.getenv("AWS_REGION", "us-east-1")
    stream_name = os.getenv("STREAM_NAME")
    sleep_seconds = float(os.getenv("PRODUCER_INTERVAL_SECONDS", "1"))

    if not stream_name:
        raise ValueError("STREAM_NAME environment variable is required")

    client = boto3.client("kinesis", region_name=region)
    print(f"Writing events to stream={stream_name} region={region}")

    while True:
        event = build_event()
        client.put_record(
            StreamName=stream_name,
            Data=json.dumps(event).encode("utf-8"),
            PartitionKey=event["user_id"],
        )
        print(f"sent {event['event_id']} amount={event['amount']}")
        time.sleep(sleep_seconds)


if __name__ == "__main__":
    main()
