#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/lab_helpers.sh"

# This script verifies local tooling and cloud auth before labs start.
echo "Checking required local tooling..."
check_command aws
check_command python3
check_command pip3
check_command git

if command -v gh >/dev/null 2>&1; then
  echo "gh CLI found"
else
  echo "gh CLI not found (optional for PR workflow labs)"
fi

echo "Checking AWS caller identity..."
# Confirms currently configured AWS credentials are valid.
aws sts get-caller-identity --query "Account" --output text >/dev/null

echo "Checking Python package installability..."
# Dry-run avoids changing environment while still validating dependency graph.
python3 -m pip install -r requirements.txt --dry-run >/dev/null

echo "Prerequisites check passed."
