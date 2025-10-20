# 🚀 Quick Start Guide - Color Correction Studio

## Prerequisites
- **Docker Desktop** installed ([Download](https://www.docker.com/products/docker-desktop))
- Internet connection (first run only)

---

## 🎯 Option 1: Run with Scripts (Recommended)

### Windows
```powershell
# Simply double-click run-docker.bat
# OR run in PowerShell:
.\run-docker.bat
```

### Linux/macOS
```bash
# Make executable and run:
chmod +x run-docker.sh
./run-docker.sh
```

**That's it!** The script will:
1. Check Docker installation
2. Pull/build the image automatically
3. Start the container
4. Open your browser to http://localhost:5000

---

## 🐳 Option 2: Docker Compose

```bash
# Start
docker-compose up -d

# View logs
docker-compose logs -f

# Stop
docker-compose down
```

---

## 📦 Option 3: Manual Docker Commands

### Pull from Docker Hub (if published)
```bash
docker pull your-dockerhub-username/color-correction-studio:latest
```

### Build Locally
```bash
docker build -t color-correction-studio:latest .
```

### Run
```bash
docker run -d \
  --name color-correction-studio \
  -p 5000:5000 \
  -v "$(pwd)/uploads:/app/uploads" \
  -v "$(pwd)/results:/app/results" \
  --restart unless-stopped \
  color-correction-studio:latest
```

---

## 🔧 Development Mode (Without Docker)

### 1. Install Dependencies
```bash
# Frontend
npm install

# Backend
cd backend
pip install -r requirements.txt
```

### 2. Start Both Servers
```bash
# Cross-platform (recommended)
npm start

# OR platform-specific:
npm run start:win    # Windows
npm run start:unix   # Linux/macOS
```

---

## 📤 Publishing to Docker Hub

### 1. Edit Push Scripts
Update your Docker Hub username in:
- `docker-push.bat` (Windows)
- `docker-push.sh` (Linux/macOS)

```bash
DOCKER_HUB_USER="your-actual-username"  # Change this!
```

### 2. Login to Docker Hub
```bash
docker login
```

### 3. Build and Push
```bash
# Windows
docker-push.bat

# Linux/macOS
chmod +x docker-push.sh
./docker-push.sh
```

### 4. Share with Others
Others can now run:
```bash
docker pull your-dockerhub-username/color-correction-studio:latest
```

And use the same `run-docker.bat` or `run-docker.sh` scripts after updating the username.

---

## 🌐 Access the Application

Once running:
- **Main App**: http://localhost:5000
- **Health Check**: http://localhost:5000/health
- **API Endpoint**: http://localhost:5000/api/*

---

## 🛠️ Useful Commands

### View Logs
```bash
docker logs -f color-correction-studio
```

### Stop/Start
```bash
docker stop color-correction-studio
docker start color-correction-studio
```

### Restart
```bash
docker restart color-correction-studio
```

### Remove Container
```bash
docker rm -f color-correction-studio
```

### Check Status
```bash
docker ps | grep color-correction
```

---

## 🐛 Troubleshooting

### Port Already in Use
```bash
# Check what's using port 5000
netstat -an | findstr :5000    # Windows
lsof -i :5000                   # Linux/macOS

# Use different port
docker run -p 8080:5000 ...
```

### Container Fails to Start
```bash
# View detailed logs
docker logs color-correction-studio

# Check container status
docker ps -a | grep color-correction
```

### Docker Not Running
1. Open Docker Desktop
2. Wait for it to fully start
3. Try again

### Build Fails
```bash
# Clean Docker cache
docker system prune -a

# Rebuild
docker build --no-cache -t color-correction-studio:latest .
```

---

## 📊 System Requirements

**Minimum:**
- 2 CPU cores
- 4 GB RAM
- 5 GB disk space

**Recommended:**
- 4 CPU cores
- 8 GB RAM
- 10 GB disk space
- GPU (optional, for faster processing)

---

## 📚 Additional Documentation

- [DOCKER.md](DOCKER.md) - Comprehensive Docker guide
- [UI_ARCHITECTURE.md](UI_ARCHITECTURE.md) - Architecture details
- [CHANGELOG.md](CHANGELOG.md) - Version history

---

## 💡 Tips

1. **First run takes longer** - Docker downloads and builds everything
2. **Subsequent runs are fast** - Uses cached images
3. **Data persists** - uploads/ and results/ folders are mounted
4. **Auto-restart** - Container restarts if it crashes or system reboots
5. **Clean up** - Run `docker system prune` periodically to free space

---

## 🆘 Support

1. Check logs: `docker logs color-correction-studio`
2. Verify Docker: `docker --version`
3. Check resources: `docker stats`
4. Review [DOCKER.md](DOCKER.md) for advanced topics

---

## 📄 License

See main application license.
