# Stage 1: CRA build (same as npm run build → /build)
FROM node:18-alpine AS builder

WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm install --legacy-peer-deps

COPY public ./public
COPY src ./src
RUN npm run build

# Stage 2: nginx serves static build
FROM nginx:1.25-alpine

# docker-compose: nginx.conf (proxies /api/status). k3s/Jenkins: nginx.k8s.conf (Ingress routes API).
ARG NGINX_CONF=docker/frontend/nginx.conf
COPY ${NGINX_CONF} /etc/nginx/conf.d/default.conf
COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget -qO- http://127.0.0.1/healthz || exit 1

CMD ["nginx", "-g", "daemon off;"]
