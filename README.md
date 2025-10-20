# 🎨 Color Correction Studio

A professional image color correction tool with ML-based algorithms, packaged as a Docker container for easy deployment.

![Version](https://img.shields.io/badge/version-4.0.0-blue)
![Docker](https://img.shields.io/badge/docker-ready-brightgreen)
![License](https://img.shields.io/badge/license-MIT-green)

## 🚀 Quick Start

### Run with Docker (Easiest)

**Windows:**
```powershell
.\run-docker.bat
```

**Linux/macOS:**
```bash
chmod +x run-docker.sh
./run-docker.sh
```

The script will automatically:
- Pull the image from Docker Hub (or build locally)
- Start the container
- Open http://localhost:5000 in your browser

### Pull from Docker Hub

```bash
docker pull collins137/color-correction-studio:latest
docker run -d -p 5000:5000 --name color-correction collins137/color-correction-studio:latest
```

## 📋 Features

- ✅ Advanced color correction algorithms
- ✅ ML-based image processing
- ✅ Batch processing support
- ✅ Real-time preview
- ✅ Multiple correction methods (FFC, GC, WB, CC)
- ✅ GPU acceleration support
- ✅ Docker containerized
- ✅ Production-ready with Gunicorn

## 🏗️ Architecture

- **Frontend**: React + Vite + TailwindCSS
- **Backend**: Flask + OpenCV + ML models
- **Server**: Gunicorn with gevent workers
- **Containerization**: Multi-stage Docker build

## 📦 Installation

### Option 1: Docker (Recommended)

See [Quick Start](#-quick-start) above.

### Option 2: Local Development

#### Prerequisites
- Node.js 18+
- Python 3.11+
- Git

#### Setup
```bash
# Install frontend dependencies
npm install

# Install backend dependencies
cd backend
pip install -r requirements.txt
cd ..

# Start application
npm start
```

Access at: http://localhost:5173 (frontend) and http://localhost:5000 (backend)

## 🐳 Docker Documentation

- [QUICKSTART.md](QUICKSTART.md) - Quick start guide
- [DOCKER.md](DOCKER.md) - Comprehensive Docker documentation
- [DOCKER_SETUP.md](DOCKER_SETUP.md) - Deployment summary
- [DOCKER_CHEATSHEET.txt](DOCKER_CHEATSHEET.txt) - Command reference

## 🔧 Configuration

### Environment Variables

```bash
PORT=5000                    # Backend port
MAX_WORKERS=4               # Worker processes
REQUEST_TIMEOUT=300         # Request timeout (seconds)
UPLOAD_FOLDER=uploads       # Upload directory
RESULTS_FOLDER=results      # Results directory
```

### Docker Compose

```bash
# Start services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

## 📖 API Documentation

### Health Check
```bash
GET /health
GET /api/health
```

### Upload Images
```bash
POST /api/upload
Content-Type: multipart/form-data
```

### Process Images
```bash
POST /api/process
Content-Type: application/json
```

## 🛠️ Development

### Project Structure
```
├── backend/              # Flask backend
│   ├── server_enhanced.py
│   └── requirements.txt
├── src/                  # React frontend
│   ├── ColorCorrectionUI.jsx
│   └── main.jsx
├── Dockerfile           # Docker configuration
├── docker-compose.yml   # Docker Compose
└── package.json         # Node dependencies
```

### Build Frontend
```bash
npm run build
```

### Run Tests
```bash
npm test
```

## 🚢 Deployment

### Deploy to Cloud

The Docker image can be deployed to:
- AWS ECS/Fargate
- Google Cloud Run
- Azure Container Instances
- DigitalOcean App Platform
- Any Docker-compatible platform

### CI/CD

GitHub Actions workflow is included for automatic Docker builds on push.

## 📊 Performance

- Multi-threaded processing
- GPU acceleration (when available)
- Efficient memory management
- Optimized Docker image (~1.2GB)

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- ColorCorrectionPipeline library
- OpenCV community
- React and Vite teams

## 📧 Contact

Collins - [@collins137](https://github.com/collins137)

Project Link: [https://github.com/collins137/color-correction-studio](https://github.com/collins137/color-correction-studio)

## 🔗 Links

- [Docker Hub](https://hub.docker.com/r/collins137/color-correction-studio)
- [Documentation](DOCKER.md)
- [Issues](https://github.com/collins137/color-correction-studio/issues)

---

Made with ❤️ by Collins + Copilot AI
