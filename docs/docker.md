# Docker Configuration

This project uses Docker to create production-ready containers for the frontend and the status API. This ensures parity across environments and simplifies Kubernetes deployment.

## Image Architecture

### Frontend (`portfolio-frontend:<tag>`)
We use a **multi-stage build** for the React frontend:
1. **Stage 1 (Node.js)**: Runs `npm install` and `npm run build` to compile the React application. This stage contains all the build dependencies (like webpack, babel) but is discarded after building.
2. **Stage 2 (Nginx)**: An Alpine Nginx image that takes only the compiled `/build` directory from Stage 1. 

**Why multi-stage?**
It dramatically reduces the final image size and attack surface by excluding Node.js and all development dependencies from the final production container. The final image only contains Nginx and static files.

### Status API (`portfolio-status-api:<tag>`)
A lightweight Node.js API (no external framework like Express, just the native `http` module) providing health and version checks. 

## Local Build & Run

To build and run the images locally without Kubernetes:

### Frontend
```bash
# Build the image from the repository root
docker build -f docker/frontend/Dockerfile -t portfolio-frontend:local .

# Run the image locally
docker run -d -p 8080:80 --name portfolio-frontend portfolio-frontend:local

# Test
curl http://localhost:8080/healthz
```

### Status API
```bash
# Build the status API
docker build -f docker/status-api/Dockerfile -t portfolio-status-api:local docker/status-api

# Run the image locally
docker run -d -p 3001:3001 --name portfolio-status-api portfolio-status-api:local

# Test
curl http://localhost:3001/api/health
curl http://localhost:3001/api/version
```

### Using Docker Compose (Local testing only)
A `docker-compose.yml` file is provided in the repository root for testing the whole stack locally. **This is not used in production (EC2/k3s).**
```bash
docker compose up --build
```

## Relationship to S3

*   **S3** is our immutable build archive. Jenkins syncs the raw `npm run build` output (the `build/` folder) to S3. This provides a permanent backup independent of Docker.
*   **Docker** is the runtime packaging. Jenkins builds the Docker images *after* archiving to S3, using the same build context. The Docker images are then loaded directly into Kubernetes. If the k3s cluster fails, we can rebuild the Docker image cleanly from the S3 static archive.
