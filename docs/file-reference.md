# File reference — what each path does

## Application (unchanged behavior)

| Path | Why |
|------|-----|
| `src/`, `public/` | Create React App source |
| `package.json` | `npm run build` → `/build` |
| `CNAME` | Legacy GitHub Pages domain hint (`sakshyam.tech`) |

## Docker

| Path | Why |
|------|-----|
| `.dockerignore` | Exclude heavy dirs from build context |
| `docker/frontend/Dockerfile` | Build static + nginx image |
| `docker/frontend/nginx.conf` | docker-compose: SPA + API proxy |
| `docker/frontend/nginx.k8s.conf` | k3s: SPA only |
| `docker/status-api/*` | Minimal JSON status service |
| `docker-compose.yml` | Run frontend + API on EC2 without k8s |

## Kubernetes

| Path | Why |
|------|-----|
| `k8s/*.yaml` | staging namespace, Deployments, Services, Ingress, probes |

## CI/CD

| Path | Why |
|------|-----|
| `jenkins/Jenkinsfile` | Sole automated pipeline |
| ~~`.github/workflows/`~~ | **Removed** — replaced by Jenkins |

## AWS config

| Path | Why |
|------|-----|
| `config/aws.env.example` | Documents region + bucket names (no secrets) |

## EC2 / operations

| Path | Why |
|------|-----|
| `infra/ec2/ec2-setup.sh` | Install Docker, k3s, Jenkins on Ubuntu |
| `infra/ec2/deploy.sh` | Manual rollback: S3 static → image → k3s rollout |

Install on server:

```bash
sudo cp infra/ec2/deploy.sh /home/ubuntu/deploy.sh
sudo chmod +x /home/ubuntu/deploy.sh
```

## Documentation

| Path | Why |
|------|-----|
| `docs/*.md` | Tooling rationale and runbooks |
| `README.md` | Project entry + link to docs |
