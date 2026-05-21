# Cost and Usage Guide

This project is designed as a **dev/demo** environment. It is explicitly architected to conserve AWS credits and minimize costs. 

## Episodic EC2 Usage

The primary cost driver for this project is the AWS EC2 instance hosting Jenkins, Docker, and k3s. 

**CRITICAL RULE: Do NOT leave the EC2 instance running 24/7.**

The system is designed for episodic usage. The typical workflow should be:
1. Start the EC2 instance via the AWS Console or AWS CLI.
2. Push code, trigger Jenkins, or present the demo to faculty.
3. **Stop the EC2 instance immediately when finished.**

### Stop Instance Guidance
*   Ensure Jenkins is not actively running a build.
*   You do not need to cleanly shut down k3s or Docker; stopping the instance from the AWS console safely suspends the machine. Upon restart, k3s and Jenkins will automatically resume.

## Estimated Usage

*   Assuming 10 hours of active development/demo time per month.
*   **EC2 (e.g., t3.medium or t3.large)**: Billed only for the ~10 hours running. Cost is minimal (a few dollars a month depending on instance size).
*   **EBS Volume**: Billed for the provisioned storage size continuously, regardless of whether the instance is stopped. Keep the volume size reasonable (e.g., 20-30 GB).
*   **S3**: Billed for storage used by artifacts. Artifacts are small static files.
*   **Network egress**: Negligible for demos.

## S3 Cost Note
S3 charges are based on the storage footprint of the `sakshyam-portfolio-artifacts` bucket. Because we store compressed static builds, costs will be fractions of a cent per month. A lifecycle rule could be added later to delete builds older than 30 days if storage grows unexpectedly.

## Credits-Friendly Practices
*   **No EKS**: By using k3s on EC2, we avoid the ~$73/month flat fee for an EKS control plane.
*   **No NAT Gateways**: We use a public subnet with a public IP to avoid expensive NAT Gateway hourly charges.
