# GitHub & Docker Hub Setup Guide

This guide walks you through setting up your repository on GitHub and automating Docker image builds.

## Part 1: Initialize Git Repository

### 1. Initialize Git (if not already done)

```bash
cd c:\Users\Collins\Desktop\Color_Correction_UI\UI
git init
```

### 2. Add files to staging

```bash
git add .
```

### 3. Create initial commit

```bash
git commit -m "Initial commit: Color Correction Studio v4.0.0

- React + Vite frontend with TailwindCSS
- Flask + ColorCorrectionPipeline backend
- Docker multi-stage build configuration
- GitHub Actions CI/CD pipeline
- Comprehensive documentation"
```

## Part 2: Create GitHub Repository

### Option A: Using GitHub CLI (Recommended)

```bash
# Install GitHub CLI if not installed
# Windows: winget install GitHub.cli
# Or download from: https://cli.github.com/

# Login to GitHub
gh auth login

# Create repository
gh repo create color-correction-studio --public --source=. --remote=origin --push

# If you want it private
# gh repo create color-correction-studio --private --source=. --remote=origin --push
```

### Option B: Using GitHub Web Interface

1. Go to https://github.com/new
2. Repository name: `color-correction-studio`
3. Description: "Color Correction Studio - ML-based Image Processing"
4. Visibility: Public (or Private)
5. Do NOT initialize with README (we already have one)
6. Click "Create repository"

7. Link your local repo to GitHub:
```bash
git remote add origin https://github.com/collinswakholi/cc_studio.git
git branch -M main
git push -u origin main
```

## Part 3: Configure Docker Hub

### 1. Create Docker Hub Repository

1. Go to https://hub.docker.com/
2. Click "Create Repository"
3. Name: `color-correction-studio`
4. Visibility: Public
5. Description: "Color Correction Studio - ML-based Image Processing with React frontend and Python backend"
6. Click "Create"

### 2. Create Access Token

1. Go to https://hub.docker.com/settings/security
2. Click "New Access Token"
3. Description: `github-actions-color-correction`
4. Access permissions: **Read, Write, Delete**
5. Click "Generate"
6. **IMPORTANT**: Copy the token immediately (you won't see it again!)

Example token: `dckr_pat_abc123xyz...`

## Part 4: Configure GitHub Secrets

### 1. Add Docker Hub Token to GitHub

1. Go to your GitHub repository
2. Click **Settings** tab
3. In left sidebar: **Secrets and variables** → **Actions**
4. Click **New repository secret**
5. Name: `DOCKER_PASSWORD`
6. Secret: Paste your Docker Hub access token
7. Click **Add secret**

### Verify Setup

You should now have:
- ✅ GitHub repository: `https://github.com/collinswakholi/cc_studio`
- ✅ Docker Hub repository: `https://hub.docker.com/r/collins137/cc_studio`
- ✅ GitHub secret: `DOCKER_PASSWORD` configured

## Part 5: Test CI/CD Pipeline

### 1. Trigger First Build

```bash
# Make a small change (or just push)
git add .
git commit -m "ci: Test GitHub Actions workflow"
git push origin main
```

### 2. Monitor Build Progress

1. Go to your GitHub repository
2. Click **Actions** tab
3. You should see "Build and Push Docker Image" workflow running
4. Click on the workflow to see detailed logs

### 3. Verify on Docker Hub

1. Go to https://hub.docker.com/r/collins137/cc_studio
2. Click **Tags** tab
3. You should see:
   - `latest` tag (from main branch)
   - `main` tag (branch name)
   - SHA tag (commit hash)

## Part 6: Test Docker Image

### Pull and Test Locally

```bash
# Pull the image from Docker Hub
docker pull collins137/cc_studio:latest

# Run the container
docker run -d \
  --name test-color-correction \
  -p 8080:80 \
  -p 5000:5000 \
  collins137/cc_studio:latest

# Wait 30 seconds for startup
timeout 30

# Test backend
curl http://localhost:5000/api/health

# Test frontend (open in browser)
start http://localhost:8080

# View logs
docker logs test-color-correction

# Cleanup
docker stop test-color-correction
docker rm test-color-correction
```

## Part 7: Advanced Workflows

### Create Release with Tags

```bash
# Create and push a version tag
git tag -a v4.0.0 -m "Release v4.0.0: Production-ready Docker deployment"
git push origin v4.0.0

# This triggers:
# - Build with tags: v4.0.0, v4.0, v4, latest
# - GitHub Release creation
```

### Manual Workflow Trigger

1. Go to GitHub **Actions** tab
2. Select "Build and Push Docker Image"
3. Click "Run workflow"
4. Select branch (e.g., `main`)
5. Click "Run workflow"

## Part 8: Local Docker Build and Push

### Build Locally

```bash
# Build the image
docker build -t collins137/cc_studio:local .

# Test locally first
docker run -d -p 8080:80 -p 5000:5000 collins137/cc_studio:local

# If test passes, tag as latest
docker tag collins137/cc_studio:local collins137/cc_studio:latest

# Login to Docker Hub
docker login -u collins137

# Push to Docker Hub
docker push collins137/cc_studio:latest
```

### Multi-Architecture Build

```bash
# Create builder
docker buildx create --name multiarch --use

# Build and push for multiple architectures
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t collins137/cc_studio:latest \
  --push \
  .
```

## Part 9: Maintenance

### Update Docker Hub Description

The GitHub Actions workflow automatically updates the Docker Hub description from README.md on each push.

### Manual Update

```bash
# Install docker-hub-description CLI tool
npm install -g docker-hub-description

# Update description
docker-hub-description \
  --username collins137 \
  --password $DOCKER_PASSWORD \
  --repository collins137/cc_studio \
  --readme README.md
```

### Monitor Image Size

```bash
# Check image size locally
docker images collins137/cc_studio

# View layers
docker history collins137/cc_studio:latest
```

## Troubleshooting

### GitHub Actions Failed

**Check workflow logs:**
1. Go to Actions tab
2. Click failed workflow
3. Expand failed step
4. Read error message

**Common issues:**
- `DOCKER_PASSWORD` secret not set
- Docker Hub repository doesn't exist
- Authentication failed (token expired)

**Fix:**
- Verify secret name is exactly `DOCKER_PASSWORD`
- Create Docker Hub repository first
- Generate new access token

### Docker Push Failed

```bash
# Re-login to Docker Hub
docker logout
docker login -u collins137

# Verify credentials
docker info | grep Username

# Try push again
docker push collins137/cc_studio:latest
```

### Build Context Too Large

```bash
# Check .dockerignore file
cat .dockerignore

# Add more exclusions if needed
echo "node_modules/" >> .dockerignore
echo "v5_backup/" >> .dockerignore

# Verify reduced size
docker build --no-cache -t test .
```

## Next Steps

### Add Badges to README.md

Add these to your README.md:

```markdown
![Docker Image Size](https://img.shields.io/docker/image-size/collins137/cc_studio/latest)
![Docker Pulls](https://img.shields.io/docker/pulls/collins137/cc_studio)
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/collins137/cc_studio/docker-build.yml)
```

### Set Up Automated Security Scans

Already configured in `.github/workflows/security-scan.yml`:
- Runs weekly
- Uses Trivy scanner
- Reports to GitHub Security tab

### Deploy to Production

See [DOCKER_DEPLOYMENT.md](DOCKER_DEPLOYMENT.md) for:
- AWS ECS deployment
- Google Cloud Run
- Kubernetes
- Production configurations

## Summary Checklist

- [ ] Git repository initialized
- [ ] GitHub repository created
- [ ] Docker Hub repository created
- [ ] Docker Hub access token generated
- [ ] GitHub secret `DOCKER_PASSWORD` configured
- [ ] First CI/CD build successful
- [ ] Docker image available on Docker Hub
- [ ] Local test successful
- [ ] Documentation reviewed

## Support

If you encounter issues:
1. Check GitHub Actions logs
2. Review [DOCKER_DEPLOYMENT.md](DOCKER_DEPLOYMENT.md)
3. Open an issue on GitHub
4. Check Docker Hub build status

---

**Your repositories:**
- GitHub: https://github.com/collinswakholi/cc_studio
- Docker Hub: https://hub.docker.com/r/collins137/cc_studio
