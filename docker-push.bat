@echo off
REM ============================================================
REM  Build and Push to Docker Hub (Windows)
REM ============================================================

setlocal enabledelayedexpansion

REM Configuration - UPDATE THESE VALUES
set DOCKER_HUB_USER=collins137
set IMAGE_NAME=color-correction-studio
set VERSION=latest

echo.
echo ============================================================
echo   🐳 Docker Build and Push Script
echo ============================================================
echo.

REM Check if user has configured their Docker Hub username
if "%DOCKER_HUB_USER%"=="your-dockerhub-username" (
    echo ❌ Please edit this script and set your Docker Hub username
    echo.
    echo   1. Open: docker-push.bat
    echo   2. Change: set DOCKER_HUB_USER=your-dockerhub-username
    echo   3. To your actual Docker Hub username
    echo.
    pause
    exit /b 1
)

REM Check if Docker is installed
docker --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker is not installed
    pause
    exit /b 1
)

REM Check if logged in to Docker Hub
docker info | findstr /C:"Username" >nul 2>&1
if errorlevel 1 (
    echo ℹ️  Not logged in to Docker Hub. Please login:
    docker login
    if errorlevel 1 (
        echo ❌ Docker login failed
        pause
        exit /b 1
    )
)

echo ✅ Logged in to Docker Hub
echo.

REM Build image
echo [1/3] Building Docker image...
echo ℹ️  This may take several minutes...
docker build -t %IMAGE_NAME%:%VERSION% .
if errorlevel 1 (
    echo ❌ Build failed
    pause
    exit /b 1
)
echo ✅ Image built successfully
echo.

REM Tag image
echo [2/3] Tagging image for Docker Hub...
docker tag %IMAGE_NAME%:%VERSION% %DOCKER_HUB_USER%/%IMAGE_NAME%:%VERSION%
docker tag %IMAGE_NAME%:%VERSION% %DOCKER_HUB_USER%/%IMAGE_NAME%:latest
echo ✅ Image tagged
echo.

REM Push to Docker Hub
echo [3/3] Pushing to Docker Hub...
echo ℹ️  Pushing %DOCKER_HUB_USER%/%IMAGE_NAME%:%VERSION%
docker push %DOCKER_HUB_USER%/%IMAGE_NAME%:%VERSION%
docker push %DOCKER_HUB_USER%/%IMAGE_NAME%:latest
if errorlevel 1 (
    echo ❌ Push failed
    pause
    exit /b 1
)
echo ✅ Successfully pushed to Docker Hub
echo.

echo ============================================================
echo   ✅ Build and Push Complete!
echo ============================================================
echo.
echo   📦 Image: %DOCKER_HUB_USER%/%IMAGE_NAME%:%VERSION%
echo   🔗 URL: https://hub.docker.com/r/%DOCKER_HUB_USER%/%IMAGE_NAME%
echo.
echo   Others can now pull your image with:
echo   docker pull %DOCKER_HUB_USER%/%IMAGE_NAME%:latest
echo.
echo ============================================================
echo.
pause
