# Jenkins CI/CD Documentation

This project uses **Jenkins** as the sole CI/CD orchestrator, completely replacing GitHub Actions.

## Why Jenkins vs GitHub Actions?
While GitHub Actions is highly convenient for SaaS-hosted pipelines, managing Jenkins on our own EC2 instance provides a deeper learning experience for infrastructure-as-code and self-hosted CI/CD. It forces us to handle our own compute resources, security, Docker socket integrations, and Kubernetes deployments. Additionally, running Jenkins on the same EC2 instance as k3s saves money by consolidating workloads onto one machine for this dev/demo project.

## Required Jenkins Plugins
To run the `Jenkinsfile` in this repository, ensure your Jenkins server has the following plugins installed:
*   **workflow-aggregator** (Pipeline)
*   **docker-workflow** (Docker Pipeline)
*   **git** (Git Plugin)
*   **credentials-binding** (Credentials Binding)

## How to Install/Start Jenkins on EC2

### Option A: Native Install (Recommended for Phase 6 setup)
If you run `sudo apt-get install jenkins`, it runs as a systemd service. 
You must add the `jenkins` user to the `docker` group (`sudo usermod -aG docker jenkins`) and give it read access to the k3s kubeconfig.

### Option B: Dockerized Jenkins (docker-compose.jenkins.yml)
You can run Jenkins inside Docker using the `docker-compose.jenkins.yml` provided in the root directory.
**Security Note:** This compose file mounts `/var/run/docker.sock` into the Jenkins container. This is a known security tradeoff (it effectively grants root access to the host), but is acceptable for a student/dev project to avoid complex Docker-in-Docker configurations.

## Required Credentials
Since our EC2 instance uses an **IAM Instance Profile**, Jenkins does *not* need AWS Access Keys stored in its credential manager. It inherits permissions automatically.
You only need to ensure:
1. `git` is installed and Jenkins has SSH/HTTPS access to pull your repository.
2. The `KUBECONFIG` environment variable is pointing to the valid k3s config (usually `/etc/rancher/k3s/k3s.yaml`).

## How to Create the Job
1. Log into Jenkins.
2. Click **New Item** -> Name it "opPortfolio" -> Select **Multibranch Pipeline** or **Pipeline**.
3. Under the **Pipeline** section, choose **Pipeline script from SCM**.
4. Select **Git**, provide your repository URL.
5. Ensure the Script Path is `jenkins/Jenkinsfile`.
6. Save and build.

## First Pipeline Run Checklist
- [ ] Did Jenkins successfully pull the repository?
- [ ] Did `npm install` and `npm run build` succeed?
- [ ] Did the S3 upload script correctly push artifacts to the bucket without permission errors?
- [ ] Were the Docker images successfully built and tagged?
- [ ] Did `k3s ctr images import` execute correctly without sudo/permission denied errors?
- [ ] Did the Kubernetes pods successfully spin up and pass their `/healthz` probes?
