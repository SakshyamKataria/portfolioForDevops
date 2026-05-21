# MASTER Deployment Runbook

This guide is the single source of truth for standing up and running the entire Portfolio Hosting System.

## Prerequisites Checklist
- [ ] AWS Account with billing active.
- [ ] S3 Bucket created (`sakshyam-portfolio-artifacts` in `ap-south-1`).
- [ ] EC2 Instance provisioned (t3.small/medium, Ubuntu 22.04).
- [ ] EC2 Key Pair downloaded for SSH access.
- [ ] IAM Instance Profile attached to the EC2 instance with S3 permissions (see `S3.md`).
- [ ] Security Group configured (Ports: 22, 80, 8080).

## First-time Setup (Bootstrap Once)
Once your EC2 instance is running, SSH into it and run:
```bash
git clone https://github.com/Hrishi1999/opPortfolio.git portfolio
cd portfolio
sudo bash infra/ec2/bootstrap.sh
docker compose -f docker-compose.jenkins.yml up -d
```
Then follow `JENKINS.md` to unlock Jenkins, install plugins, and set up the `opPortfolio` pipeline job.

## Every Dev Session
When you sit down to write code or test the pipeline:
1. Start the EC2 instance from AWS.
2. Ensure Jenkins is running (`docker start jenkins-server` if using compose, or `sudo systemctl start jenkins` if native).
3. Push your code to GitHub to trigger Jenkins, or manually click "Build Now" in the Jenkins UI.
4. Verify the URLs (`http://<EC2_IP>` and `http://<EC2_IP>/api/version`).

## Faculty Demo Script (10 minutes)
1. **Show Jenkins**: Open `http://<EC2_IP>:8080`, click into the `opPortfolio` job, and show the visual Pipeline stages passing cleanly.
2. **Show S3 Archive**: Open the AWS S3 Console, navigate to `releases/<BUILD_NUMBER>/build/`, and show the timestamped `release.json`.
3. **Show k3s Pods**: SSH into EC2 and run `kubectl get pods -n staging` to prove the containers are running inside Kubernetes.
4. **Show Live Site**: Open `http://<EC2_IP>` in the browser.
5. **Show Status API**: Open `http://<EC2_IP>/api/version` to prove the git commit hash and build number matched what Jenkins just injected.

## Teardown
When the demo or dev session is over:
**Stop the EC2 instance.** Do *not* Terminate it unless you are permanently deleting the project. 

## Troubleshooting

| Issue | Cause | Fix |
| :--- | :--- | :--- |
| **ImagePullBackOff** | Kubernetes can't find the Docker image locally. | Ensure `k3s ctr images import` ran successfully in Jenkins, and `imagePullPolicy` is `IfNotPresent`. |
| **Jenkins docker.sock denied** | Jenkins container user isn't root, or native jenkins user isn't in `docker` group. | `sudo usermod -aG docker jenkins` and restart Jenkins. |
| **S3 Access Denied** | The EC2 instance doesn't have the correct IAM profile attached. | See `S3.md` and attach the IAM policy via the AWS console. |
| **kubectl connection refused** | k3s isn't running or kubeconfig is missing. | Run `sudo systemctl restart k3s`. Verify `KUBECONFIG` env var in Jenkins. |
