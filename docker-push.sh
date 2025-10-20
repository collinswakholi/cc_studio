#!/bin/bash
# ============================================================
#  Build and Push to Docker Hub
# ============================================================

set -e

# Configuration - UPDATE THESE VALUES
DOCKER_HUB_USER="collins137"
IMAGE_NAME="color-correction-studio"
VERSION="latest"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() { echo -e "${GREEN}✅${NC} $1"; }
print_error() { echo -e "${RED}❌${NC} $1"; }
print_info() { echo -e "${BLUE}ℹ️${NC}  $1"; }

echo ""
echo "============================================================"
echo "  🐳 Docker Build and Push Script"
echo "============================================================"
echo ""

# Check if user has configured their Docker Hub username
if [ "$DOCKER_HUB_USER" == "your-dockerhub-username" ]; then
    print_error "Please edit this script and set your Docker Hub username"
    echo ""
    echo "  1. Open: docker-push.sh"
    echo "  2. Change: DOCKER_HUB_USER=\"your-dockerhub-username\""
    echo "  3. To your actual Docker Hub username"
    echo ""
    exit 1
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed"
    exit 1
fi

# Check if logged in to Docker Hub
if ! docker info | grep -q "Username"; then
    print_info "Not logged in to Docker Hub. Please login:"
    docker login
    if [ $? -ne 0 ]; then
        print_error "Docker login failed"
        exit 1
    fi
fi

print_status "Logged in to Docker Hub"
echo ""

# Build image
echo "[1/3] Building Docker image..."
print_info "This may take several minutes..."
docker build -t "${IMAGE_NAME}:${VERSION}" .
if [ $? -ne 0 ]; then
    print_error "Build failed"
    exit 1
fi
print_status "Image built successfully"
echo ""

# Tag image
echo "[2/3] Tagging image for Docker Hub..."
docker tag "${IMAGE_NAME}:${VERSION}" "${DOCKER_HUB_USER}/${IMAGE_NAME}:${VERSION}"
docker tag "${IMAGE_NAME}:${VERSION}" "${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
print_status "Image tagged"
echo ""

# Push to Docker Hub
echo "[3/3] Pushing to Docker Hub..."
print_info "Pushing ${DOCKER_HUB_USER}/${IMAGE_NAME}:${VERSION}"
docker push "${DOCKER_HUB_USER}/${IMAGE_NAME}:${VERSION}"
docker push "${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
if [ $? -ne 0 ]; then
    print_error "Push failed"
    exit 1
fi
print_status "Successfully pushed to Docker Hub"
echo ""

echo "============================================================"
echo "  ✅ Build and Push Complete!"
echo "============================================================"
echo ""
echo "  📦 Image: ${DOCKER_HUB_USER}/${IMAGE_NAME}:${VERSION}"
echo "  🔗 URL: https://hub.docker.com/r/${DOCKER_HUB_USER}/${IMAGE_NAME}"
echo ""
echo "  Others can now pull your image with:"
echo "  docker pull ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
echo ""
echo "============================================================"
