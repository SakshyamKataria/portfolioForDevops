#!/usr/bin/env bash
# Deploys images into k3s. Can be used standalone or via Jenkins last stage.
# Usage: ./deploy-k3s.sh <IMAGE_TAG> <GIT_SHA>
set -euo pipefail

IMAGE_TAG="${1:-local}"
GIT_SHA="${2:-unknown}"
BUILD_TIME=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

export KUBECONFIG="/etc/rancher/k3s/k3s.yaml"

# Ensure we run k3s imports as sudo
if [ "$EUID" -ne 0 ]; then
  SUDO="sudo"
else
  SUDO=""
fi

echo "==> Importing images to k3s containerd..."
# Assumes images portfolio-frontend:${IMAGE_TAG} and portfolio-status-api:${IMAGE_TAG} exist locally (via docker pull or docker build)
docker save portfolio-frontend:${IMAGE_TAG} | $SUDO k3s ctr images import -
docker save portfolio-status-api:${IMAGE_TAG} | $SUDO k3s ctr images import -

echo "==> Applying k8s manifests..."
# Assuming we are in the repo root
kubectl apply -f k8s/staging/namespace.yaml
kubectl apply -f k8s/staging/

echo "==> Setting image tags..."
kubectl set image deployment/portfolio-frontend frontend=portfolio-frontend:${IMAGE_TAG} -n staging
kubectl set image deployment/portfolio-status status=portfolio-status-api:${IMAGE_TAG} -n staging

echo "==> Injecting environment variables..."
kubectl set env deployment/portfolio-status -n staging \
  BUILD_NUMBER="${IMAGE_TAG}" GIT_COMMIT="${GIT_SHA}" BUILD_TIME="${BUILD_TIME}"

echo "==> Rolling out..."
kubectl rollout status deployment/portfolio-frontend -n staging --timeout=120s
kubectl rollout status deployment/portfolio-status -n staging --timeout=120s

echo "==> Deploy complete."
