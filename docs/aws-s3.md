# AWS S3 — build artifact archive

## Confirmed settings (do not rename without updating code)

| Setting | Value | Where defined |
|---------|-------|----------------|
| Region | `ap-south-1` | `jenkins/Jenkinsfile`, `config/aws.env.example`, `infra/ec2/deploy.sh` |
| Bucket | `sakshyam-portfolio-artifacts` | Same files |

## Why S3 is in the stack

S3 stores **every Jenkins build** as a recoverable artifact set. If k3s or Docker state is lost, you can redeploy a known static tree without rebuilding from scratch.

## Object layout

```
s3://sakshyam-portfolio-artifacts/
  builds/
    42/
      static/          # CRA output (index.html, static/js, …)
      build-manifest.json
```

- **`static/`** — output of `npm run build` (same as local `/build`).
- **`build-manifest.json`** — build number, short git SHA, archive timestamp.

## Versioning

Enable **S3 bucket versioning** in the AWS console (recommended). Jenkins uses a **new prefix per build** (`builds/<BUILD_NUMBER>/`), so builds do not overwrite each other even without versioning; versioning adds protection against accidental deletes.

## IAM

The EC2 instance role (or Jenkins AWS credentials) needs at minimum:

- `s3:PutObject`, `s3:GetObject`, `s3:ListBucket` on `arn:aws:s3:::sakshyam-portfolio-artifacts` and `arn:aws:s3:::sakshyam-portfolio-artifacts/builds/*`

## List builds

```bash
aws s3 ls s3://sakshyam-portfolio-artifacts/builds/ --region ap-south-1
```
