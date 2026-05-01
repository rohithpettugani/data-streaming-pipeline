#!/usr/bin/env python3
import os
import random
import time
import uuid
from datetime import datetime, timezone

import boto3


def main() -> None:
    # Table name is sourced from foundation stack outputs in lab scripts.
    region = os.getenv("AWS_REGION", "us-east-1")
    table_name = os.getenv("DDB_TABLE_NAME")
    sleep_seconds = float(os.getenv("DDB_WRITE_INTERVAL_SECONDS", "2"))

    if not table_name:
        raise ValueError("DDB_TABLE_NAME environment variable is required")

    ddb = boto3.resource("dynamodb", region_name=region)
    table = ddb.Table(table_name)
    print(f"Writing CDC records to table={table_name} region={region}")

    while True:
        # Inserts trigger DynamoDB Streams and exercise the CDC path.
        item = {
            "pk": f"order#{uuid.uuid4()}",
            "created_at": datetime.now(timezone.utc).isoformat(),
            "amount": str(round(random.uniform(20.0, 900.0), 2)),
            "status": random.choice(["CREATED", "APPROVED", "CANCELLED"]),
        }
        table.put_item(Item=item)
        print(f"put {item['pk']} status={item['status']}")
        time.sleep(sleep_seconds)


if __name__ == "__main__":
    main()
