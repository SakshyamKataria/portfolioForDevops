# EC2 Environment Setup

This project uses a single AWS EC2 instance to run our entire pipeline (Jenkins, Docker, and Kubernetes).

## Instance Type Recommendation
A **t3.small** or **t3.medium** running **Ubuntu 22.04 LTS** is highly recommended. K3s and Jenkins can struggle on micro instances due to memory limits (Jenkins alone likes 1GB of RAM). Since this is episodic, a slightly larger instance is cheap because it is turned off most of the time.

## Start/Stop Instance
To save AWS credits, **stop** the instance from the AWS Console or AWS CLI when you are not actively developing or demoing. 
```bash
# Example AWS CLI stop/start
aws ec2 stop-instances --instance-ids i-0abcd1234efgh5678
aws ec2 start-instances --instance-ids i-0abcd1234efgh5678
```

## SSH Access
You will connect to the instance using your private key pair and the default `ubuntu` user:
```bash
ssh -i /path/to/key.pem ubuntu@<EC2_PUBLIC_IP>
```

## Kubernetes Configuration (kubeconfig)
K3s stores its kubeconfig at `/etc/rancher/k3s/k3s.yaml` by default. 
The `infra/ec2/bootstrap.sh` script automatically copies this into `/home/ubuntu/.kube/config` and fixes permissions so the `ubuntu` user can run `kubectl` commands natively.

## How Jenkins Connects to k3s
Jenkins (whether run natively or via docker-compose) relies on the same `/etc/rancher/k3s/k3s.yaml` file to authenticate its `kubectl` commands against the local cluster. Because it runs on the exact same host as the k3s control plane, no remote cluster authentication or networking setup is required.
