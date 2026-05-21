#!/usr/bin/env bash
# One-time bootstrap on Ubuntu EC2: Docker, k3s, Jenkins prerequisites, AWS CLI.
set -euo pipefail

DEPLOY_USER="${DEPLOY_USER:-ubuntu}"

echo "==> Installing base packages..."
apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
  ca-certificates curl gnupg unzip git jq

echo "==> Installing Docker CE..."
if ! command -v docker &>/dev/null; then
  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  chmod a+r /etc/apt/keyrings/docker.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
  apt-get update -qq
  apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-compose-plugin
fi
usermod -aG docker "${DEPLOY_USER}" || true

echo "==> Installing AWS CLI v2..."
if ! command -v aws &>/dev/null; then
  curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip -q awscliv2.zip
  ./aws/install
  rm -rf aws awscliv2.zip
fi

echo "==> Installing k3s..."
if ! command -v k3s &>/dev/null; then
  curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--write-kubeconfig-mode 644" sh -
fi

echo "==> Configuring kubectl for ${DEPLOY_USER}..."
mkdir -p "/home/${DEPLOY_USER}/.kube"
cp /etc/rancher/k3s/k3s.yaml "/home/${DEPLOY_USER}/.kube/config"
chown -R "${DEPLOY_USER}:${DEPLOY_USER}" "/home/${DEPLOY_USER}/.kube"

echo "==> Firewall / Security Notes:"
echo "    Ensure your EC2 Security Group allows:"
echo "    - Port 22 (SSH) from your IP"
echo "    - Port 80 (HTTP) for Traefik Ingress"
echo "    - Port 443 (HTTPS) if setting up SSL later"
echo "    - Port 8080 for Jenkins dashboard"
echo "    - Port 6443 (k3s API) only if connecting remotely"

echo "==> Done. To install Jenkins, you can use docker-compose.jenkins.yml or run 'sudo apt-get install jenkins'."
