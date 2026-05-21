# Project Phases

This document indexes the phased implementation approach for the Portfolio Hosting System.

*   **Phase 1: Architecture & documentation foundation**
    *   Goal: Define and document the full system architecture, technology stack, and cost guidelines before implementation.
*   **Phase 2: Core Infrastructure Preparation**
    *   Goal: Provision EC2, set up S3 buckets, and configure the base Jenkins/Docker/k3s environment.
*   **Phase 3: Dockerization & Local Testing**
    *   Goal: Containerize the React app with Nginx and create the small status API.
*   **Phase 4: Jenkins CI/CD Pipeline Construction**
    *   Goal: Build the Jenkinsfile to automate the build, S3 archival, and container image creation.
*   **Phase 5: Kubernetes (k3s) Manifests**
    *   Goal: Create Deployments, Services, and Ingress rules for the staging namespace.
*   **Phase 6: Integration & Deployment**
    *   Goal: Connect Jenkins to k3s to automatically apply manifests and rollout new images upon build success.
*   **Phase 7: GitHub Actions Deprecation**
    *   Goal: Fully remove `.github/workflows` and finalize the transition to Jenkins.
*   **Phase 8: Polish & Handoff**
    *   Goal: Final testing, README updates, and ensuring the system is ready for faculty demos.
