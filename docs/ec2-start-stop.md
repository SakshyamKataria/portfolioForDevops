# EC2 start / stop (save credits)

This system is for **dev/demo only**, not 24/7 production.

## When to stop

Stop the instance when you are not:

- Running Jenkins builds
- Demoing the portfolio on k3s/Docker
- Grading or testing the pipeline

Stopped instances avoid compute charges (you may still pay for EBS and S3).

## Stop (AWS Console)

1. EC2 → Instances → select your Ubuntu instance.
2. **Instance state** → **Stop instance**.
3. Wait until state is `stopped`.

## Stop (CLI)

```bash
aws ec2 stop-instances --instance-ids i-xxxxxxxx --region ap-south-1
```

## Start before a demo

1. **Start instance** (Console or `aws ec2 start-instances ...`).
2. Note the new **public IP** (may change unless Elastic IP is attached).
3. SSH: `ssh -i your-key.pem ubuntu@<PUBLIC_IP>`
4. Start services if they are not enabled on boot:

```bash
sudo systemctl start docker
sudo systemctl start k3s
sudo systemctl start jenkins
```

5. Verify:

```bash
sudo kubectl get pods -n staging
docker ps
sudo systemctl status jenkins
```

## After start

- Update DNS or bookmarks if the public IP changed.
- Run Jenkins job or push to `master` to deploy latest code.
- Jenkins: `http://<PUBLIC_IP>:8080`

## deploy user

If you use a `deploy` user instead of `ubuntu`, adjust paths in `infra/ec2/ec2-setup.sh` (`DEPLOY_USER`) and Jenkins docs accordingly. Existing `deploy.sh` on the server should be updated from `infra/ec2/deploy.sh` in this repo—not deleted without a replacement.
