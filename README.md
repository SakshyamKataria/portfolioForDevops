# opPortfolio

[![Netlify Status](https://api.netlify.com/api/v1/badges/afea2508-00ca-464f-8f63-a4283928fc0f/deploy-status)](https://app.netlify.com/sites/hriship/deploys)
![Hits](https://hitcounter.pythonanywhere.com/count/tag.svg?url=https%3A%2F%2Fgithub.com%2FHrishi1999%2FopPortfolio)

![opPortfolio](/images/portfolio.gif)

Personal portfolio (Create React App). Customize content in `src/portfolio.js` and colors in `src/theme.js`.

## Portfolio Hosting System

This repository contains our dev/demo deployment pipeline.

- CI/CD is handled entirely by **Jenkins** (GitHub Actions has been completely removed).
- See the **[docs/](docs/)** folder for complete system design. Specifically, start with **[docs/JENKINS.md](docs/JENKINS.md)** for CI/CD setup, or **[ARCHITECTURE.md](docs/ARCHITECTURE.md)** to understand the overall system.

### Local development

```bash
npm install --legacy-peer-deps
npm start
npm run build    # output in /build
```

### Docker (optional, on EC2 or laptop)

```bash
docker compose up --build
# http://localhost:8080  —  status API: http://localhost:3001/api/status
```

### Deploy flow (summary)

1. Start EC2 → run/bootstrap per [docs/ec2-start-stop.md](docs/ec2-start-stop.md).
2. Jenkins pipeline (`jenkins/Jenkinsfile`) on push to `master`.
3. Artifacts: `s3://sakshyam-portfolio-artifacts/builds/<BUILD_NUMBER>/`.
4. k3s `staging` namespace serves the site; stop EC2 when done.

Manual deployment / rollback: `sudo bash infra/ec2/deploy-k3s.sh <BUILD_NUMBER> <GIT_SHA>`

## Sections

- Home
- Education and Certificates
- Experience
- Projects
- Contact and Resume

## Customize

- `homepage` in `package.json` — domain or `https://<username>.github.io`
- `src/portfolio.js` — your details
- `src/theme.js` — light/dark theme
