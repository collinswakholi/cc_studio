@echo off
REM ============================================================
REM  Color Correction Studio - Docker Runner (Windows)
REM  Automatically pulls, builds, and runs the application
REM ============================================================

setlocal enabledelayedexpansion

echo.
echo ============================================================
echo   🎨 Color Correction Studio - Docker Setup
echo ============================================================
echo.

REM Define variables
set IMAGE_NAME=color-correction-studio
set CONTAINER_NAME=color-correction-studio
set DOCKER_HUB_USER=collins137
set DOCKER_HUB_REPO=%DOCKER_HUB_USER%/%IMAGE_NAME%
set VERSION=latest

REM Check if Docker is installed
echo [1/6] Checking Docker installation...
docker --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker is not installed or not in PATH
    echo.
    echo Please install Docker Desktop from: https://www.docker.com/products/docker-desktop
    echo.
    pause
    exit /b 1
)
echo ✅ Docker is installed
echo.

REM Check if Docker daemon is running
echo [2/6] Checking Docker daemon...
docker info >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker daemon is not running
    echo.
    echo Please start Docker Desktop and try again
    echo.
    pause
    exit /b 1
)
echo ✅ Docker daemon is running
echo.

REM Stop and remove existing container if running
echo [3/6] Cleaning up existing containers...
docker ps -a --filter "name=%CONTAINER_NAME%" --format "{{.ID}}" >nul 2>&1
if not errorlevel 1 (
    docker stop %CONTAINER_NAME% >nul 2>&1
    docker rm %CONTAINER_NAME% >nul 2>&1
    echo ✅ Removed existing container
) else (
    echo ✅ No existing container found
)
echo.

REM Check if image exists locally or pull from Docker Hub
echo [4/6] Checking for Docker image...
docker image inspect %IMAGE_NAME%:%VERSION% >nul 2>&1
if errorlevel 1 (
    echo 📥 Image not found locally. Attempting to pull from Docker Hub...
    docker pull %DOCKER_HUB_REPO%:%VERSION% 2>nul
    if errorlevel 1 (
        echo ⚠️  Image not found on Docker Hub. Building locally...
        goto BUILD_LOCAL
    ) else (
        echo ✅ Successfully pulled image from Docker Hub
        docker tag %DOCKER_HUB_REPO%:%VERSION% %IMAGE_NAME%:%VERSION%
        goto RUN_CONTAINER
    )
) else (
    echo ✅ Image found locally
    goto RUN_CONTAINER
)

:BUILD_LOCAL
echo [5/6] Building Docker image locally...
echo This may take several minutes...
docker build -t %IMAGE_NAME%:%VERSION% .
if errorlevel 1 (
    echo ❌ Failed to build Docker image
    pause
    exit /b 1
)
echo ✅ Image built successfully
echo.
goto RUN_CONTAINER

:RUN_CONTAINER
echo [6/6] Starting container...
REM Create directories for volumes if they don't exist
if not exist "uploads" mkdir uploads
if not exist "results" mkdir results
if not exist "models" mkdir models
if not exist "backend\uploads" mkdir backend\uploads
if not exist "backend\results" mkdir backend\results
if not exist "backend\models" mkdir backend\models

docker run -d ^
    --name %CONTAINER_NAME% ^
    -p 5000:5000 ^
    -p 5173:5173 ^
    -v "%cd%\uploads:/app/uploads" ^
    -v "%cd%\results:/app/results" ^
    -v "%cd%\models:/app/models" ^
    -v "%cd%\backend\uploads:/app/backend/uploads" ^
    -v "%cd%\backend\results:/app/backend/results" ^
    -v "%cd%\backend\models:/app/backend/models" ^
    --restart unless-stopped ^
    %IMAGE_NAME%:%VERSION%

if errorlevel 1 (
    echo ❌ Failed to start container
    pause
    exit /b 1
)

echo ✅ Container started successfully
echo.

REM Wait for container to be healthy
echo ⏳ Waiting for application to be ready...
timeout /t 5 /nobreak >nul

REM Check container status
docker ps --filter "name=%CONTAINER_NAME%" --format "{{.Status}}" | findstr /C:"Up" >nul
if errorlevel 1 (
    echo ❌ Container failed to start properly
    echo.
    echo 📋 Container logs:
    docker logs %CONTAINER_NAME%
    pause
    exit /b 1
)

echo.
echo ============================================================
echo   ✅ Color Correction Studio is running!
echo ============================================================
echo.
echo   🌐 Access the application at:
echo      http://localhost:5000
echo.
echo   📊 Container status:
docker ps --filter "name=%CONTAINER_NAME%" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo.
echo   📋 Useful commands:
echo      View logs:    docker logs -f %CONTAINER_NAME%
echo      Stop:         docker stop %CONTAINER_NAME%
echo      Start:        docker start %CONTAINER_NAME%
echo      Remove:       docker rm -f %CONTAINER_NAME%
echo.
echo ============================================================
echo.

REM Open browser after a short delay
timeout /t 3 /nobreak >nul
start http://localhost:5000

echo Press any key to exit (container will continue running)...
pause >nul
