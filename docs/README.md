# Portfolio Hosting System — documentation index

Dev/demo hosting for **opPortfolio** (Create React App → `npm run build` → `/build`). **Not** intended as 24/7 production.

| Document | What it explains |
|----------|------------------|
| [architecture.md](./architecture.md) | End-to-end flow: Git → Jenkins → S3 → Docker → k3s |
| [aws-s3.md](./aws-s3.md) | Region, bucket, versioned artifacts per build |
| [docker.md](./docker.md) | Frontend (nginx + static) and status API images |
| [jenkins.md](./jenkins.md) | Sole CI/CD; job setup; credentials |
| [kubernetes.md](./kubernetes.md) | k3s on EC2; staging namespace; Ingress; probes |
| [ec2-start-stop.md](./ec2-start-stop.md) | Start/stop instance to save credits |
| [file-reference.md](./file-reference.md) | Every repo path and why it exists |

## Mandatory stack roles

| Component | Role in this project |
|-----------|----------------------|
| **EC2** | Hosts Jenkins, Docker engine, and k3s (no EKS) |
| **S3** | Immutable archive per Jenkins build under `builds/<n>/` |
| **Docker** | Packages CRA static build + small status API |
| **Jenkins** | Only CI/CD (GitHub Actions removed) |
| **Kubernetes (k3s)** | Runs Deployments/Services/Ingress in `staging` |

## Quick start (after EC2 is running)

1. `infra/ec2/ec2-setup.sh` on the instance (once).
2. Configure Jenkins per [jenkins.md](./jenkins.md).
3. Push to `master` → pipeline archives to S3 and deploys to k3s.
4. Stop EC2 when finished — [ec2-start-stop.md](./ec2-start-stop.md).
