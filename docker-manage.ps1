#!/usr/bin/env pwsh
# ============================================================
#  Docker Management Script for PowerShell Core
#  Works on Windows, Linux, and macOS
# ============================================================

param(
    [Parameter(Position=0)]
    [ValidateSet("run", "stop", "restart", "logs", "clean", "build", "push", "help")]
    [string]$Command = "run",
    
    [Parameter()]
    [switch]$Follow,
    
    [Parameter()]
    [switch]$NoBrowser
)

$IMAGE_NAME = "color-correction-studio"
$CONTAINER_NAME = "color-correction-studio"
$DOCKER_HUB_USER = "collins137"

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Type = "Info"
    )
    
    switch ($Type) {
        "Success" { Write-Host "✅ $Message" -ForegroundColor Green }
        "Error"   { Write-Host "❌ $Message" -ForegroundColor Red }
        "Warning" { Write-Host "⚠️  $Message" -ForegroundColor Yellow }
        "Info"    { Write-Host "ℹ️  $Message" -ForegroundColor Cyan }
        default   { Write-Host $Message }
    }
}

function Test-Docker {
    try {
        $null = docker --version
        $null = docker info
        return $true
    }
    catch {
        return $false
    }
}

function Start-Container {
    Write-ColorOutput "Starting Color Correction Studio..." "Info"
    
    if (-not (Test-Docker)) {
        Write-ColorOutput "Docker is not running. Please start Docker Desktop." "Error"
        exit 1
    }
    
    # Stop existing container if running
    if (docker ps -a --filter "name=$CONTAINER_NAME" --format "{{.ID}}") {
        Write-ColorOutput "Stopping existing container..." "Info"
        docker stop $CONTAINER_NAME 2>$null
        docker rm $CONTAINER_NAME 2>$null
    }
    
    # Check if image exists
    if (-not (docker image inspect "${IMAGE_NAME}:latest" 2>$null)) {
        Write-ColorOutput "Image not found. Building..." "Warning"
        docker build -t "${IMAGE_NAME}:latest" .
    }
    
    # Create directories
    $dirs = @("uploads", "results", "models", "backend\uploads", "backend\results", "backend\models")
    foreach ($dir in $dirs) {
        if (-not (Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }
    }
    
    # Run container
    docker run -d `
        --name $CONTAINER_NAME `
        -p 5000:5000 `
        -p 5173:5173 `
        -v "${PWD}/uploads:/app/uploads" `
        -v "${PWD}/results:/app/results" `
        -v "${PWD}/models:/app/models" `
        -v "${PWD}/backend/uploads:/app/backend/uploads" `
        -v "${PWD}/backend/results:/app/backend/results" `
        -v "${PWD}/backend/models:/app/backend/models" `
        --restart unless-stopped `
        "${IMAGE_NAME}:latest"
    
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput "Container started successfully!" "Success"
        Write-ColorOutput "Application: http://localhost:5000" "Info"
        
        if (-not $NoBrowser) {
            Start-Sleep -Seconds 3
            Start-Process "http://localhost:5000"
        }
    }
    else {
        Write-ColorOutput "Failed to start container" "Error"
        exit 1
    }
}

function Stop-Container {
    Write-ColorOutput "Stopping container..." "Info"
    docker stop $CONTAINER_NAME
    Write-ColorOutput "Container stopped" "Success"
}

function Restart-Container {
    Stop-Container
    Start-Sleep -Seconds 2
    Start-Container
}

function Show-Logs {
    if ($Follow) {
        docker logs -f $CONTAINER_NAME
    }
    else {
        docker logs $CONTAINER_NAME
    }
}

function Remove-All {
    Write-ColorOutput "Cleaning up..." "Warning"
    docker stop $CONTAINER_NAME 2>$null
    docker rm $CONTAINER_NAME 2>$null
    docker rmi "${IMAGE_NAME}:latest" 2>$null
    Write-ColorOutput "Cleanup complete" "Success"
}

function Build-Image {
    Write-ColorOutput "Building Docker image..." "Info"
    docker build -t "${IMAGE_NAME}:latest" .
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput "Build complete!" "Success"
    }
}

function Push-Image {
    if ($DOCKER_HUB_USER -eq "your-dockerhub-username") {
        Write-ColorOutput "Please update DOCKER_HUB_USER in this script" "Error"
        exit 1
    }
    
    Write-ColorOutput "Pushing to Docker Hub..." "Info"
    docker tag "${IMAGE_NAME}:latest" "${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
    docker push "${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
    
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput "Push complete!" "Success"
    }
}

function Show-Help {
    Write-Host @"

Color Correction Studio - Docker Management

USAGE:
    .\docker-manage.ps1 [command] [options]

COMMANDS:
    run         Start the application (default)
    stop        Stop the container
    restart     Restart the container
    logs        Show container logs (use -Follow for live logs)
    clean       Remove container and image
    build       Build Docker image
    push        Push image to Docker Hub
    help        Show this help message

OPTIONS:
    -Follow     Follow logs in real-time (with 'logs' command)
    -NoBrowser  Don't open browser automatically (with 'run' command)

EXAMPLES:
    .\docker-manage.ps1 run
    .\docker-manage.ps1 logs -Follow
    .\docker-manage.ps1 restart
    .\docker-manage.ps1 clean

"@
}

# Main execution
switch ($Command) {
    "run"     { Start-Container }
    "stop"    { Stop-Container }
    "restart" { Restart-Container }
    "logs"    { Show-Logs }
    "clean"   { Remove-All }
    "build"   { Build-Image }
    "push"    { Push-Image }
    "help"    { Show-Help }
}
