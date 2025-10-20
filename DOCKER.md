# 🐳 Docker Deployment Guide

## Quick Start

### For Windows Users
Simply double-click `run-docker.bat` or run in PowerShell:
```powershell
.\run-docker.bat
```

### For Linux/macOS Users
Make the script executable and run:
```bash
chmod +x run-docker.sh
./run-docker.sh
```

The scripts will automatically:
1. ✅ Check if Docker is installed and running
2. 📥 Pull the image from Docker Hub (if available)
3. 🔨 Build the image locally (if not found on Docker Hub)
4. 🚀 Start the container with proper configuration
5. 🌐 Open your browser to http://localhost:5000

---

## Manual Docker Commands

### Build the Image
```bash
docker build -t color-correction-studio:latest .
```

### Run the Container
```bash
docker run -d \
  --name color-correction-studio \
  -p 5000:5000 \
  -p 5173:5173 \
  -v "$(pwd)/uploads:/app/uploads" \
  -v "$(pwd)/results:/app/results" \
  -v "$(pwd)/models:/app/models" \
  --restart unless-stopped \
  color-correction-studio:latest
```

### Using Docker Compose
```bash
# Start services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

---

## Publishing to Docker Hub

### Step 1: Configure Your Username
Edit `docker-push.sh` (Linux/macOS) or `docker-push.bat` (Windows):
```bash
DOCKER_HUB_USER="your-dockerhub-username"  # Change this!
```

### Step 2: Login to Docker Hub
```bash
docker login
```

### Step 3: Build and Push
```bash
# Linux/macOS
chmod +x docker-push.sh
./docker-push.sh

# Windows
docker-push.bat
```

### Step 4: Update Run Scripts
After publishing, update the `DOCKER_HUB_USER` variable in:
- `run-docker.bat`
- `run-docker.sh`

Now others can run your app without building it locally!

---

## Container Management

### View Logs
```bash
docker logs -f color-correction-studio
```

### Stop Container
```bash
docker stop color-correction-studio
```

### Start Container
```bash
docker start color-correction-studio
```

### Restart Container
```bash
docker restart color-correction-studio
```

### Remove Container
```bash
docker rm -f color-correction-studio
```

### Remove Image
```bash
docker rmi color-correction-studio:latest
```

---

## Accessing the Application

Once running, access:
- **Application UI**: http://localhost:5000
- **Backend API**: http://localhost:5000/api/*
- **Health Check**: http://localhost:5000/health

---

## Volume Mounts

The container persists data in these directories:
- `uploads/` - Uploaded images
- `results/` - Processed images
- `models/` - ML models
- `backend/uploads/` - Backend uploads
- `backend/results/` - Backend results
- `backend/models/` - Backend models

These directories are automatically created and mounted to preserve your data.

---

## Resource Limits

Default limits (configurable in `docker-compose.yml`):
- **CPU**: 1-2 cores
- **Memory**: 2-4 GB

Adjust based on your workload:
```yaml
deploy:
  resources:
    limits:
      cpus: '4'
      memory: 8G
```

---

## Troubleshooting

### Container won't start
```bash
# Check logs
docker logs color-correction-studio

# Verify ports are available
netstat -an | grep 5000
```

### Image build fails
```bash
# Clean Docker cache
docker system prune -a

# Rebuild from scratch
docker build --no-cache -t color-correction-studio:latest .
```

### Permission issues (Linux/macOS)
```bash
# Fix directory permissions
chmod -R 755 uploads results models backend
```

### Out of disk space
```bash
# Clean unused Docker resources
docker system prune -a --volumes
```

---

## Development vs Production

### Development (Current Setup)
- Uses Gunicorn with gevent workers
- Hot-reload disabled for stability
- Logs to stdout/stderr
- Health checks enabled

### For Production
Consider adding:
- Reverse proxy (Nginx)
- SSL/TLS certificates
- Environment-specific configs
- Monitoring and alerting
- Backup strategies

---

## Architecture

```
┌─────────────────────────────────────┐
│  Docker Container                   │
│                                     │
│  ┌──────────────┐  ┌─────────────┐ │
│  │   Frontend   │  │   Backend   │ │
│  │  (Built JS)  │  │   (Flask)   │ │
│  │              │  │  Gunicorn   │ │
│  │              │  │   + gevent  │ │
│  └──────────────┘  └─────────────┘ │
│         │                 │         │
│         └────────┬────────┘         │
│                  │                  │
└──────────────────┼──────────────────┘
                   │
            Port 5000 (exposed)
```

---

## Environment Variables

Available environment variables:
- `FLASK_ENV=production` - Flask environment
- `PYTHONUNBUFFERED=1` - Python logging
- `PORT=5000` - Backend port

---

## CI/CD Integration

### GitHub Actions Example
```yaml
name: Build and Push Docker Image

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Login to Docker Hub
        run: echo ${{ secrets.DOCKER_PASSWORD }} | docker login -u ${{ secrets.DOCKER_USERNAME }} --password-stdin
      - name: Build and Push
        run: |
          docker build -t ${{ secrets.DOCKER_USERNAME }}/color-correction-studio:latest .
          docker push ${{ secrets.DOCKER_USERNAME }}/color-correction-studio:latest
```

---

## Security Considerations

1. **Update Dependencies**: Regularly update base images and Python packages
2. **Secrets**: Never commit sensitive data; use environment variables
3. **User Permissions**: Container runs as root by default; consider non-root user for production
4. **Network**: Use Docker networks to isolate services
5. **Scanning**: Run `docker scan color-correction-studio:latest` to check for vulnerabilities

---

## Support

For issues or questions:
1. Check container logs: `docker logs color-correction-studio`
2. Verify Docker installation: `docker --version`
3. Check system resources: `docker stats`

---

## License

Same license as the main application.
