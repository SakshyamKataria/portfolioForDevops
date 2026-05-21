# Kubernetes Architecture (k3s)

This project uses Kubernetes to orchestrate the frontend and status API containers. We use **k3s**, a highly available, certified Kubernetes distribution designed for production workloads in unattended, resource-constrained, remote locations or inside IoT appliances.

## Why k3s on EC2 vs. Amazon EKS?

Amazon EKS (Elastic Kubernetes Service) is a powerful managed Kubernetes service, but it comes with a flat cost of ~$73/month just for the control plane, *before* paying for any worker nodes. Because this is a dev/demo portfolio project intended to minimize AWS credit burn, we run k3s directly on our single EC2 instance. It provides the full Kubernetes API experience at zero additional cost beyond the raw EC2 compute.

## Manifests Overview

All manifests are located in `k8s/staging/` and deploy to the `staging` namespace.

*   `namespace.yaml`: Creates the `staging` namespace to isolate our demo environment.
*   `frontend-deployment.yaml`: Deploys the Nginx container serving the compiled React build. Configured with liveness (`/healthz`) and readiness (`/readyz`) probes, plus basic resource limits.
*   `frontend-service.yaml`: Creates a `ClusterIP` service to expose the frontend pods internally on port 80.
*   `status-deployment.yaml`: Deploys the Node.js status API. Uses environment variables for `BUILD_NUMBER` and `GIT_COMMIT` (injected by Jenkins during deployment). Includes probes on `/api/health`.
*   `status-service.yaml`: Creates a `ClusterIP` service to expose the status pods internally on port 3001.
*   `ingress.yaml`: Uses Traefik (k3s's default ingress controller) to route traffic based on the path:
    *   `/api` routes to `portfolio-status:3001`
    *   `/` routes to `portfolio-frontend:80`

### Image Pull Policy

In `frontend-deployment.yaml` and `status-deployment.yaml`, the `imagePullPolicy` is set to `IfNotPresent`. This is crucial because our CI/CD pipeline builds the images locally on the EC2 instance and imports them directly into k3s's container runtime, rather than pushing to a remote registry like Docker Hub or ECR (which costs money/time).

## How Images Get Into k3s

Because we aren't using a remote Docker registry, Jenkins uses the following process to move newly built Docker images into k3s:

```bash
docker save portfolio-frontend:local | sudo k3s ctr images import -
docker save portfolio-status-api:local | sudo k3s ctr images import -
```
Once imported, Kubernetes can schedule pods using these images because of the `IfNotPresent` pull policy.

## Apply Order

To deploy manually or via Jenkins, apply the manifests in this order:

```bash
kubectl apply -f k8s/staging/namespace.yaml
kubectl apply -f k8s/staging/
```

## Local Testing (Kind / Minikube)

You can test these manifests locally on your laptop using `kind` or `minikube`. 

1. Build images locally: `docker build -f docker/frontend/Dockerfile -t portfolio-frontend:local .`
2. Load images into your local cluster:
   *   **Kind**: `kind load docker-image portfolio-frontend:local`
   *   **Minikube**: `minikube image load portfolio-frontend:local`
3. Apply manifests: `kubectl apply -f k8s/staging/`
4. Access: Since the Ingress is configured for `portfolio.local`, you will need to add an entry to your `/etc/hosts` file pointing `portfolio.local` to your minikube IP or localhost (depending on your ingress setup).

## Useful Commands

*   **Get Pods**: `kubectl get pods -n staging`
*   **Describe Pod (for debugging crashes/probes)**: `kubectl describe pod <pod-name> -n staging`
*   **View Logs**: `kubectl logs -f deployment/portfolio-frontend -n staging`
*   **Check Rollout Status**: `kubectl rollout status deployment/portfolio-frontend -n staging`
*   **Rollback to Previous Version**: `kubectl rollout undo deployment/portfolio-frontend -n staging`
