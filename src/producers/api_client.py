#!/usr/bin/env python3
import json
import os
import random
import time
import uuid
from datetime import datetime, timezone

import requests


def main() -> None:
    endpoint = os.getenv("API_ENDPOINT")
    sleep_seconds = float(os.getenv("API_CALL_INTERVAL_SECONDS", "1"))

    if not endpoint:
        raise ValueError("API_ENDPOINT environment variable is required")

    print(f"Posting events to {endpoint}")
    while True:
        payload = {
            "client_event_id": str(uuid.uuid4()),
            "event_ts": datetime.now(timezone.utc).isoformat(),
            "customer_id": f"cust-{uuid.uuid4().hex[:8]}",
            "amount": round(random.uniform(10.0, 1500.0), 2),
        }
        response = requests.post(endpoint, json=payload, timeout=10)
        response.raise_for_status()
        print(json.dumps({"status": response.status_code, "payload": payload}))
        time.sleep(sleep_seconds)


if __name__ == "__main__":
    main()
