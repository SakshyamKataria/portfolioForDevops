#!/usr/bin/env bash
# Uploads a compiled React build and its metadata to AWS S3.
# Usage: ./s3-upload-artifacts.sh <BUILD_NUMBER> <GIT_SHA> <BRANCH>
# Assumes 'npm run build' has already been executed and the 'build/' directory exists.

set -euo pipefail

BUILD_NUMBER="${1:-}"
GIT_SHA="${2:-}"
BRANCH="${3:-main}"

# Load environment variables if present
if [[ -f ".env" ]]; then
  source .env
fi

AWS_REGION="${AWS_REGION:-ap-south-1}"
S3_BUCKET="${S3_BUCKET:-sakshyam-portfolio-artifacts}"

if [[ -z "${BUILD_NUMBER}" || -z "${GIT_SHA}" ]]; then
  echo "Usage: $0 <BUILD_NUMBER> <GIT_SHA> [BRANCH]" >&2
  exit 1
fi

if [[ ! -d "build" ]]; then
  echo "Error: 'build/' directory not found. Please run 'npm run build' first." >&2
  exit 1
fi

PREFIX="releases/${BUILD_NUMBER}"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

echo "==> Creating release.json metadata file..."
cat <<EOF > release.json
{
  "buildNumber": "${BUILD_NUMBER}",
  "gitSha": "${GIT_SHA}",
  "branch": "${BRANCH}",
  "timestamp": "${TIMESTAMP}"
}
EOF

echo "==> Syncing build/ directory to s3://${S3_BUCKET}/${PREFIX}/build/ ..."
aws s3 sync build/ "s3://${S3_BUCKET}/${PREFIX}/build/" \
  --region "${AWS_REGION}" \
  --delete \
  --no-progress

echo "==> Uploading release.json..."
aws s3 cp release.json "s3://${S3_BUCKET}/${PREFIX}/release.json" \
  --region "${AWS_REGION}"

echo "==> Upload complete: s3://${S3_BUCKET}/${PREFIX}/"
