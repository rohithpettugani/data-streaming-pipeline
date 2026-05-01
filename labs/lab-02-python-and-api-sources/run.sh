#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${STREAM_NAME:-}" ]]; then
  echo "STREAM_NAME is required"
  exit 1
fi

if [[ -z "${API_ENDPOINT:-}" ]]; then
  echo "API_ENDPOINT is required"
  exit 1
fi

echo "Starting Kinesis producer and API client..."
python src/producers/kinesis_producer.py &
PID_PRODUCER=$!

python src/producers/api_client.py &
PID_API=$!

cleanup() {
  echo "Stopping background producers..."
  kill "${PID_PRODUCER}" "${PID_API}" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

wait
