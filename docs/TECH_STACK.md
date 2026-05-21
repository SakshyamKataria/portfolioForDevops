# Technology Stack

This document outlines the core technologies used in this project, their roles, and our architectural decisions.

| Technology | Target Version | Role in Project | Why Chosen? |
| :--- | :--- | :--- | :--- |
| **React** | v16.8+ (CRA) | Frontend framework | Provided as the base application. Standard, widely-supported ecosystem. |
| **Node.js / npm** | v18.x | Build tools and Status API | Native environment for React and easy to spin up a tiny Express API. |
| **AWS EC2** | Ubuntu 22.04 LTS | Host Server | Flexible, allows us to run Jenkins, Docker, and k3s together affordably on one machine. |
| **AWS S3** | - | Artifact Storage | Cheap, highly durable storage for versioned backup of our static builds. |
| **Docker** | Latest | Containerization | Standardizes deployment of our frontend Nginx server and API, ensuring 'it works on my machine' applies everywhere. |
| **Jenkins** | LTS | CI/CD Pipeline | Chosen to replace GitHub actions, demonstrating self-hosted CI/CD capabilities and keeping all execution on our EC2 instance. |
| **k3s** | Latest stable | Kubernetes Orchestration | Lightweight Kubernetes that runs exceptionally well on a single EC2 instance with low memory footprint. |
| **Nginx** | 1.25-alpine | Web Server | Robust, highly performant web server to serve the React static build within our Docker container. |

## What we are NOT using (and why)

*   **Amazon EKS (Elastic Kubernetes Service)**: EKS has a significant flat control-plane cost (~$73/month) plus compute costs. Because we have limited AWS credits and this is a dev/demo project, we chose k3s on a single EC2 instance to keep costs minimal.
*   **GitHub Actions**: While convenient, we are explicitly migrating to Jenkins to demonstrate a fully self-managed CI/CD pipeline hosted entirely on our own infrastructure.
*   **24/7 Production Hosting**: This setup is intended for episodic use (faculty demos, development). We intentionally stop the EC2 instance when idle to conserve credits.
