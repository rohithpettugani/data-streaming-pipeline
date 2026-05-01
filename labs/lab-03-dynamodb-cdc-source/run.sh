#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${DDB_TABLE_NAME:-}" ]]; then
  echo "DDB_TABLE_NAME is required"
  exit 1
fi

python src/producers/ddb_writer.py
