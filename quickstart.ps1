# Quick Start - Color Correction Studio Deployment
# =================================================
# This script helps you deploy the application step-by-step

param(
    [switch]$BuildLocal,
    [switch]$TestLocal,
    [switch]$PushGitHub,
    [switch]$BuildDocker,
    [switch]$All
)

$ErrorActionPreference = "Stop"

function Write-Step {
    param($Message)
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host $Message -ForegroundColor Cyan
    Write-Host "========================================`n" -ForegroundColor Cyan
}

function Write-Success {
    param($Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-ErrorMessage {
    param($Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

function Write-Info {
    param($Message)
    Write-Host "ℹ $Message" -ForegroundColor Yellow
}

# Check prerequisites
function Test-Prerequisites {
    Write-Step "Checking Prerequisites"
    
    $missing = @()
    
    # Check Git
    if (!(Get-Command git -ErrorAction SilentlyContinue)) {
        $missing += "Git"
    } else {
        Write-Success "Git installed"
    }
    
    # Check Node.js
    if (!(Get-Command node -ErrorAction SilentlyContinue)) {
        $missing += "Node.js"
    } else {
        $nodeVersion = node --version
        Write-Success "Node.js $nodeVersion installed"
    }
    
    # Check Python
    if (!(Get-Command python -ErrorAction SilentlyContinue)) {
        $missing += "Python"
    } else {
        $pythonVersion = python --version
        Write-Success "$pythonVersion installed"
    }
    
    # Check Docker
    if (!(Get-Command docker -ErrorAction SilentlyContinue)) {
        $missing += "Docker"
    } else {
        $dockerVersion = docker --version
        Write-Success "$dockerVersion installed"
    }
    
    if ($missing.Count -gt 0) {
        Write-ErrorMessage "Missing prerequisites: $($missing -join ', ')"
        Write-Info "Please install missing tools and try again"
        exit 1
    }
}

# Build frontend locally
function Build-Frontend {
    Write-Step "Building Frontend"
    
    if (!(Test-Path "node_modules")) {
        Write-Info "Installing npm dependencies..."
        npm install
    }
    
    Write-Info "Building frontend with Vite..."
    npm run build
    
    if (Test-Path "dist") {
        Write-Success "Frontend built successfully"
    } else {
        Write-ErrorMessage "Frontend build failed"
        exit 1
    }
}

# Test backend
function Test-Backend {
    Write-Step "Testing Backend"
    
    Write-Info "Checking Python dependencies..."
    python -c "import flask; import cv2; import numpy; print('Backend dependencies OK')"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Backend dependencies satisfied"
    } else {
        Write-ErrorMessage "Backend dependencies missing"
        Write-Info "Install with: cd backend && pip install -r requirements.txt"
        exit 1
    }
}

# Initialize Git repository
function Initialize-Git {
    Write-Step "Initializing Git Repository"
    
    if (Test-Path ".git") {
        Write-Info "Git repository already initialized"
        return
    }
    
    git init
    Write-Success "Git repository initialized"
    
    # Check if remote exists
    $remote = git remote get-url origin 2>$null
    if (!$remote) {
        Write-Info "Don't forget to add remote:"
        Write-Host "  git remote add origin https://github.com/collins137/color-correction-studio.git" -ForegroundColor Yellow
    } else {
        Write-Success "Remote origin: $remote"
    }
}

# Commit changes
function Commit-Changes {
    Write-Step "Committing Changes"
    
    # Check for changes
    $status = git status --porcelain
    if (!$status) {
        Write-Info "No changes to commit"
        return
    }
    
    Write-Info "Staging all changes..."
    git add .
    
    Write-Info "Creating commit..."
    git commit -m "chore: Docker deployment configuration

- Multi-stage Dockerfile with Nginx + Flask
- Docker Compose configuration
- GitHub Actions CI/CD pipeline
- Automated testing scripts
- Comprehensive documentation"
    
    Write-Success "Changes committed"
}

# Build Docker image
function Build-DockerImage {
    Write-Step "Building Docker Image"
    
    Write-Info "Building collins137/color-correction-studio:local..."
    docker build -t collins137/color-correction-studio:local .
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Docker image built successfully"
        
        # Show image info
        $imageInfo = docker images collins137/color-correction-studio:local --format "Size: {{.Size}}"
        Write-Info $imageInfo
    } else {
        Write-ErrorMessage "Docker build failed"
        exit 1
    }
}

# Test Docker image
function Test-DockerImage {
    Write-Step "Testing Docker Image"
    
    $containerName = "color-correction-test"
    
    # Stop existing container
    docker stop $containerName 2>$null
    docker rm $containerName 2>$null
    
    Write-Info "Starting test container..."
    docker run -d `
        --name $containerName `
        -p 8080:80 `
        -p 5000:5000 `
        collins137/color-correction-studio:local
    
    Write-Info "Waiting for services to start (20 seconds)..."
    Start-Sleep -Seconds 20
    
    # Test backend
    Write-Info "Testing backend API..."
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:5000/api/health" -UseBasicParsing -TimeoutSec 5
        if ($response.StatusCode -eq 200) {
            Write-Success "Backend API responding"
        }
    } catch {
        Write-ErrorMessage "Backend test failed"
        docker logs $containerName
        docker stop $containerName
        docker rm $containerName
        exit 1
    }
    
    # Test frontend
    Write-Info "Testing frontend..."
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8080" -UseBasicParsing -TimeoutSec 5
        if ($response.StatusCode -eq 200) {
            Write-Success "Frontend responding"
        }
    } catch {
        Write-ErrorMessage "Frontend test failed"
        docker logs $containerName
        docker stop $containerName
        docker rm $containerName
        exit 1
    }
    
    Write-Success "All tests passed!"
    Write-Info "Container running at:"
    Write-Host "  Frontend: http://localhost:8080" -ForegroundColor Cyan
    Write-Host "  Backend:  http://localhost:5000" -ForegroundColor Cyan
    Write-Host "`nTo stop: docker stop $containerName" -ForegroundColor Yellow
}

# Main execution
Write-Host @"

╔════════════════════════════════════════════════════════════╗
║                                                            ║
║     COLOR CORRECTION STUDIO - DEPLOYMENT WIZARD           ║
║                    Version 4.0.0                           ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Magenta

if ($All) {
    $BuildLocal = $true
    $TestLocal = $true
    $BuildDocker = $true
    $PushGitHub = $true
}

if (!$BuildLocal -and !$TestLocal -and !$PushGitHub -and !$BuildDocker) {
    Write-Host "Usage:" -ForegroundColor Yellow
    Write-Host "  .\quickstart.ps1 -All              # Run all steps"
    Write-Host "  .\quickstart.ps1 -BuildLocal       # Build frontend locally"
    Write-Host "  .\quickstart.ps1 -TestLocal        # Test backend dependencies"
    Write-Host "  .\quickstart.ps1 -BuildDocker      # Build Docker image"
    Write-Host "  .\quickstart.ps1 -PushGitHub       # Initialize Git and commit"
    Write-Host ""
    Write-Host "Example full workflow:" -ForegroundColor Cyan
    Write-Host "  .\quickstart.ps1 -All"
    exit 0
}

try {
    Test-Prerequisites
    
    if ($BuildLocal) {
        Build-Frontend
    }
    
    if ($TestLocal) {
        Test-Backend
    }
    
    if ($PushGitHub) {
        Initialize-Git
        Commit-Changes
    }
    
    if ($BuildDocker) {
        Build-DockerImage
        
        $test = Read-Host "`nTest Docker image? (y/n)"
        if ($test -eq 'y') {
            Test-DockerImage
        }
    }
    
    Write-Step "Deployment Summary"
    Write-Success "All requested operations completed successfully!"
    
    Write-Host "`nNext Steps:" -ForegroundColor Yellow
    Write-Host "1. Review GITHUB_SETUP.md for GitHub/Docker Hub configuration"
    Write-Host "2. Push to GitHub: git push origin main"
    Write-Host "3. Configure GitHub secret DOCKER_PASSWORD"
    Write-Host "4. Monitor GitHub Actions for automated builds"
    Write-Host "5. Pull from Docker Hub: docker pull collins137/color-correction-studio:latest"
    
    Write-Host "`nDocumentation:" -ForegroundColor Cyan
    Write-Host "  • README.md - Project overview"
    Write-Host "  • GITHUB_SETUP.md - GitHub & Docker Hub setup"
    Write-Host "  • DOCKER_DEPLOYMENT.md - Production deployment"
    
} catch {
    Write-ErrorMessage "An error occurred: $_"
    exit 1
}
