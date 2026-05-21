#!/usr/bin/env bash
# Lists all releases stored in the configured S3 bucket.
# Usage: ./s3-list-releases.sh

set -euo pipefail

# Load environment variables if present
if [[ -f ".env" ]]; then
  source .env
fi

AWS_REGION="${AWS_REGION:-ap-south-1}"
S3_BUCKET="${S3_BUCKET:-sakshyam-portfolio-artifacts}"

echo "==> Fetching releases from s3://${S3_BUCKET}/releases/ ..."
aws s3 ls "s3://${S3_BUCKET}/releases/" \
  --region "${AWS_REGION}"
