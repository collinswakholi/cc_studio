# Docker Deployment Guide

## Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+
- Git

## Quick Start

### 1. Pull and Run from Docker Hub

```bash
# Pull the latest image
docker pull collins137/cc_studio:latest

# Run the container
docker run -d \
  --name color-correction-studio \
  -p 8080:80 \
  -p 5000:5000 \
  -v color-correction-uploads:/app/backend/uploads \
  -v color-correction-results:/app/backend/results \
  -v color-correction-models:/app/backend/models \
  collins137/cc_studio:latest

# Access the application
# Frontend: http://localhost:8080
# Backend API: http://localhost:5000
```

### 2. Run with Docker Compose

```bash
# Clone the repository
git clone https://github.com/collinswakholi/cc_studio.git
cd color-correction-studio

# Start services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

## Building from Source

### Local Build

```bash
# Clone repository
git clone https://github.com/collinswakholi/cc_studio.git
cd color-correction-studio

# Build image
docker build -t color-correction-studio .

# Run container
docker run -d -p 8080:80 -p 5000:5000 color-correction-studio
```

### Multi-Architecture Build

```bash
# Create buildx builder
docker buildx create --name multiarch --use

# Build for multiple platforms
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t collins137/cc_studio:latest \
  --push \
  .
```

## Configuration

### Environment Variables

Create a `.env` file:

```env
# Backend Configuration
PORT=5000
MAX_WORKERS=4
REQUEST_TIMEOUT=300
PYTHONUNBUFFERED=1

# Volume Paths
UPLOAD_FOLDER=/app/backend/uploads
RESULTS_FOLDER=/app/backend/results
MODELS_FOLDER=/app/backend/models
```

### Custom docker-compose.yml

```yaml
version: '3.8'

services:
  app:
    image: collins137/cc_studio:latest
    ports:
      - "8080:80"
      - "5000:5000"
    environment:
      - MAX_WORKERS=8  # Increase for powerful servers
      - REQUEST_TIMEOUT=600
    volumes:
      - ./data/uploads:/app/backend/uploads
      - ./data/results:/app/backend/results
      - ./data/models:/app/backend/models
    restart: unless-stopped
```

## Testing

### Automated Testing

**Linux/Mac:**
```bash
chmod +x docker-test.sh
./docker-test.sh
```

**Windows PowerShell:**
```powershell
.\docker-test.ps1
```

### Manual Testing

```bash
# Check container health
docker ps
docker inspect --format='{{.State.Health.Status}}' color-correction-studio

# Test backend API
curl http://localhost:5000/api/health

# Test frontend
curl http://localhost:8080

# View logs
docker logs -f color-correction-studio

# Execute shell inside container
docker exec -it color-correction-studio /bin/bash
```

## GitHub Actions Setup

### 1. Create Docker Hub Access Token

1. Go to https://hub.docker.com/settings/security
2. Click "New Access Token"
3. Name: `github-actions`
4. Access permissions: Read, Write, Delete
5. Copy the token

### 2. Configure GitHub Secrets

1. Go to your GitHub repository
2. Settings → Secrets and variables → Actions
3. Click "New repository secret"
4. Name: `DOCKER_PASSWORD`
5. Value: Paste your Docker Hub access token
6. Click "Add secret"

### 3. Trigger Builds

**Automatic builds trigger on:**
- Push to `main` or `master` branch → `latest` tag
- Push tag `v*.*.*` → version tags (e.g., `v4.0.0`)
- Pull requests → test builds

**Manual trigger:**
1. Go to Actions tab
2. Select "Build and Push Docker Image"
3. Click "Run workflow"

## Production Deployment

### Deploy to AWS ECS

```bash
# 1. Create ECR repository
aws ecr create-repository --repository-name color-correction-studio

# 2. Login to ECR
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com

# 3. Tag image
docker tag collins137/cc_studio:latest \
  <account-id>.dkr.ecr.us-east-1.amazonaws.com/color-correction-studio:latest

# 4. Push to ECR
docker push <account-id>.dkr.ecr.us-east-1.amazonaws.com/color-correction-studio:latest

# 5. Create ECS task definition and service
aws ecs create-service --cluster my-cluster --service-name color-correction --task-definition color-correction-task
```

### Deploy to Google Cloud Run

```bash
# 1. Tag for GCR
docker tag collins137/cc_studio:latest \
  gcr.io/PROJECT-ID/color-correction-studio

# 2. Push to GCR
docker push gcr.io/PROJECT-ID/color-correction-studio

# 3. Deploy to Cloud Run
gcloud run deploy color-correction-studio \
  --image gcr.io/PROJECT-ID/color-correction-studio \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated
```

### Deploy to Kubernetes

Create `k8s-deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: color-correction-studio
spec:
  replicas: 3
  selector:
    matchLabels:
      app: color-correction-studio
  template:
    metadata:
      labels:
        app: color-correction-studio
    spec:
      containers:
      - name: app
        image: collins137/cc_studio:latest
        ports:
        - containerPort: 80
        - containerPort: 5000
        env:
        - name: MAX_WORKERS
          value: "4"
        volumeMounts:
        - name: data
          mountPath: /app/backend/uploads
      volumes:
      - name: data
        persistentVolumeClaim:
          claimName: color-correction-pvc
---
apiVersion: v1
kind: Service
metadata:
  name: color-correction-service
spec:
  selector:
    app: color-correction-studio
  ports:
  - name: http
    port: 80
    targetPort: 80
  - name: api
    port: 5000
    targetPort: 5000
  type: LoadBalancer
```

Deploy:
```bash
kubectl apply -f k8s-deployment.yaml
```

## Monitoring

### View Logs

```bash
# Container logs
docker logs -f color-correction-studio

# Application logs (inside container)
docker exec color-correction-studio tail -f /app/logs/flask-stdout.log
docker exec color-correction-studio tail -f /app/logs/nginx-stdout.log
```

### Health Checks

```bash
# Container health
docker inspect --format='{{.State.Health.Status}}' color-correction-studio

# Backend API health
curl http://localhost:5000/api/health

# Detailed inspection
docker inspect color-correction-studio
```

### Resource Usage

```bash
# Monitor resources
docker stats color-correction-studio

# Disk usage
docker system df

# Volume inspection
docker volume ls
docker volume inspect color-correction-uploads
```

## Troubleshooting

### Container won't start

```bash
# Check logs
docker logs color-correction-studio

# Inspect container
docker inspect color-correction-studio

# Try running interactively
docker run -it --rm -p 8080:80 -p 5000:5000 collins137/cc_studio /bin/bash
```

### Backend not responding

```bash
# Check backend logs
docker exec color-correction-studio tail -100 /app/logs/flask-stdout.log

# Check if Flask is running
docker exec color-correction-studio ps aux | grep python

# Test backend directly
docker exec color-correction-studio curl http://localhost:5000/api/health
```

### Frontend not loading

```bash
# Check Nginx logs
docker exec color-correction-studio tail -100 /app/logs/nginx-stdout.log

# Check Nginx status
docker exec color-correction-studio nginx -t

# Verify static files
docker exec color-correction-studio ls -la /usr/share/nginx/html
```

### High memory usage

```bash
# Check resource usage
docker stats color-correction-studio

# Reduce workers
docker run -e MAX_WORKERS=2 ...

# Increase memory limit
docker run --memory="2g" ...
```

## Backup and Restore

### Backup Volumes

```bash
# Backup uploads
docker run --rm -v color-correction-uploads:/data -v $(pwd):/backup \
  alpine tar czf /backup/uploads-backup.tar.gz -C /data .

# Backup results
docker run --rm -v color-correction-results:/data -v $(pwd):/backup \
  alpine tar czf /backup/results-backup.tar.gz -C /data .

# Backup models
docker run --rm -v color-correction-models:/data -v $(pwd):/backup \
  alpine tar czf /backup/models-backup.tar.gz -C /data .
```

### Restore Volumes

```bash
# Restore uploads
docker run --rm -v color-correction-uploads:/data -v $(pwd):/backup \
  alpine sh -c "cd /data && tar xzf /backup/uploads-backup.tar.gz"
```

## Security

### Update Image Regularly

```bash
# Pull latest version
docker pull collins137/cc_studio:latest

# Restart with new version
docker-compose pull
docker-compose up -d
```

### Scan for Vulnerabilities

```bash
# Using Trivy
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy:latest image collins137/cc_studio:latest
```

### Run as Non-Root (Future Enhancement)

Current implementation runs some services as root. Consider:
- Creating dedicated user in Dockerfile
- Adjusting permissions
- Using rootless Docker

## Performance Tuning

### Optimize for Production

```yaml
services:
  app:
    image: collins137/cc_studio:latest
    deploy:
      resources:
        limits:
          cpus: '4'
          memory: 4G
        reservations:
          cpus: '2'
          memory: 2G
    environment:
      - MAX_WORKERS=8  # Scale with CPU cores
      - REQUEST_TIMEOUT=600
```

### Scale Horizontally

```bash
# Scale with Docker Compose
docker-compose up -d --scale app=3

# Use load balancer (nginx/HAProxy) in front
```

## Support

- Documentation: README.md
- Issues: GitHub Issues
- Docker Hub: https://hub.docker.com/r/collins137/cc_studio
