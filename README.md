# Color Correction Studio

![Version](https://img.shields.io/badge/version-4.0.0-blue.svg)
![Docker](https://img.shields.io/docker/automated/collins137/cc_studio)
![License](https://img.shields.io/badge/license-MIT-green.svg)

A professional image color correction tool powered by ML algorithms, featuring a modern React frontend and Python Flask backend.

## 🎨 Features

- **Advanced Color Correction**: ML-based color correction using multiple algorithms
- **Flat Field Correction (FFC)**: Remove vignetting and lens artifacts
- **Gamma Correction (GC)**: Adjust image brightness and contrast
- **White Balance (WB)**: Automatic and manual white balance correction
- **Color Chart Detection**: Automatic detection and analysis of color charts
- **Batch Processing**: Process multiple images with parallel computing
- **Real-time Preview**: Interactive image preview with before/after comparison
- **Delta E Metrics**: Quantify color correction accuracy
- **Model Management**: Save and reuse trained color correction models

## 🚀 Quick Start with Docker

### Pull from Docker Hub

```bash
docker pull collins137/cc_studio:latest
```

### Run with Docker

```bash
docker run -d \
  --name color-correction-studio \
  -p 8080:80 \
  -p 5000:5000 \
  -v color-correction-data:/app/backend/uploads \
  collins137/cc_studio:latest
```

Access the application at: http://localhost:8080

### Run with Docker Compose

```bash
docker-compose up -d
```

## 📦 Installation (Development)

### Prerequisites

- Node.js 18+ 
- Python 3.11+
- npm or yarn

### Frontend Setup

```bash
npm install
npm run dev
```

### Backend Setup

```bash
cd backend
pip install -r requirements.txt
python server_enhanced.py
```

## 🏗️ Architecture

```
┌─────────────────────────────────────────────┐
│           Nginx (Port 80)                   │
│     Static Frontend (React + Vite)          │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│      Flask Backend (Port 5000)              │
│   ColorCorrectionPipeline (ML Engine)       │
│   • OpenCV • NumPy • scikit-learn           │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│        Data Persistence (Volumes)           │
│  • Uploads • Results • Models • Logs        │
└─────────────────────────────────────────────┘
```

## 🔧 Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PORT` | 5000 | Backend API port |
| `MAX_WORKERS` | 4 | Parallel processing workers |
| `REQUEST_TIMEOUT` | 300 | Request timeout (seconds) |

### Docker Volumes

- `/app/backend/uploads` - Uploaded images
- `/app/backend/results` - Processed images
- `/app/backend/models` - Trained models
- `/app/logs` - Application logs

## 🐳 Building Docker Image Locally

```bash
docker build -t color-correction-studio .
docker run -p 8080:80 -p 5000:5000 color-correction-studio
```

## 🔐 GitHub Actions CI/CD

This project uses GitHub Actions for automated Docker image builds:

1. **Create Docker Hub Access Token**:
   - Go to https://hub.docker.com/settings/security
   - Generate new access token

2. **Configure GitHub Secrets**:
   - Go to your repository → Settings → Secrets
   - Add secret: `DOCKER_PASSWORD` (your Docker Hub token)

3. **Automatic Builds**:
   - Push to `main` branch → Builds `latest` tag
   - Push tag `v*.*.*` → Builds version tag
   - Pull requests → Test builds only

## 📊 Usage

### Basic Workflow

1. **Load Images**: Upload images for color correction
2. **Detect Chart**: Automatically detect color reference charts
3. **Configure Pipeline**: Enable/disable correction steps (FFC, GC, WB, CC)
4. **Run Correction**: Process single image or batch
5. **Review Results**: View before/after, Delta E metrics, RGB scatter plots
6. **Save Results**: Export corrected images and trained models

### Batch Operations

- **Apply to Others**: Apply trained model to multiple images
- **Process All**: Train individual models for each image with color chart

## 🔍 API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/health` | GET | Health check |
| `/api/upload-images` | POST | Upload images |
| `/api/detect-chart` | POST | Detect color chart |
| `/api/run-cc` | POST | Run color correction |
| `/api/apply-cc` | POST | Apply trained model |
| `/api/save-images` | POST | Save results |
| `/api/save-model` | POST | Save trained model |

## 🧪 Testing Docker Image

```bash
# Build
docker build -t test-color-correction .

# Run with health check
docker run --rm -d --name test-app -p 8080:80 -p 5000:5000 test-color-correction

# Check health
docker inspect --format='{{.State.Health.Status}}' test-app

# View logs
docker logs test-app

# Test API
curl http://localhost:5000/api/health

# Test Frontend
curl http://localhost:8080

# Cleanup
docker stop test-app
```

## 🤝 Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 📝 License

MIT License - see LICENSE file for details

## 👨‍💻 Author

**Collins**
- GitHub: [@collins137](https://github.com/collins137)
- Docker Hub: [collins137](https://hub.docker.com/u/collins137)

## 🙏 Acknowledgments

- ColorCorrectionPipeline library
- React & Vite for frontend framework
- Flask for backend API
- OpenCV for image processing
- Docker for containerization

## 📚 Documentation

For detailed documentation, see:
- [Architecture Guide](./UI_ARCHITECTURE.md)
- [Changelog](./CHANGELOG.md)
- [Agent Guidelines](./Agents.MD)

## 🐛 Issues & Support

Found a bug? Have a question?
- Open an issue: [GitHub Issues](https://github.com/collinswakholi/cc_studio/issues)
- Check existing issues before creating new ones

## 🔄 Updates

Stay updated:
- Watch this repository for releases
- Star ⭐ if you find it useful
- Follow [@collins137](https://github.com/collins137)
