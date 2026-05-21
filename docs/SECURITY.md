# Security Policies

Since this is a development and demonstration environment, we favor simplicity over enterprise-grade lockdown, but we still strictly adhere to baseline security practices:

1. **No Secrets in Git**: There are absolutely no AWS Access Keys, secret tokens, or passwords hardcoded in this repository. 
2. **IAM Roles over Keys**: The EC2 instance utilizes an AWS IAM Instance Profile. This delegates temporary credentials securely to the instance metadata service, meaning Jenkins never stores AWS keys.
3. **Security Groups**: 
   - Ensure your Security Group restricts Port 22 (SSH) to your specific home IP address where possible.
   - Ports 80 (HTTP) and 8080 (Jenkins) are open to the world (0.0.0.0/0) *only* for the purpose of the demonstration.
   - Close the security group ports or stop the instance entirely when not actively demoing.
4. **Jenkins Security**: The `docker.sock` mount in the Jenkins compose file is a known security tradeoff. It gives the Jenkins container root access to the EC2 host to facilitate building Docker images easily. In a strict production environment, this would be isolated using Docker-in-Docker or Kaniko inside Kubernetes pods.
