#!/bin/bash
# ============================================================
#  Color Correction Studio - Docker Runner (Unix/Linux/macOS)
#  Automatically pulls, builds, and runs the application
# ============================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Define variables
IMAGE_NAME="color-correction-studio"
CONTAINER_NAME="color-correction-studio"
DOCKER_HUB_USER="collins137"
DOCKER_HUB_REPO="${DOCKER_HUB_USER}/${IMAGE_NAME}"
VERSION="latest"

echo ""
echo "============================================================"
echo "  🎨 Color Correction Studio - Docker Setup"
echo "============================================================"
echo ""

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅${NC} $1"
}

print_error() {
    echo -e "${RED}❌${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️${NC}  $1"
}

print_info() {
    echo -e "${BLUE}ℹ️${NC}  $1"
}

# Check if Docker is installed
echo "[1/6] Checking Docker installation..."
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed or not in PATH"
    echo ""
    echo "Please install Docker from: https://docs.docker.com/get-docker/"
    echo ""
    exit 1
fi
print_status "Docker is installed"
echo ""

# Check if Docker daemon is running
echo "[2/6] Checking Docker daemon..."
if ! docker info &> /dev/null; then
    print_error "Docker daemon is not running"
    echo ""
    echo "Please start Docker and try again"
    echo ""
    exit 1
fi
print_status "Docker daemon is running"
echo ""

# Stop and remove existing container if running
echo "[3/6] Cleaning up existing containers..."
if docker ps -a --filter "name=${CONTAINER_NAME}" --format "{{.ID}}" | grep -q .; then
    docker stop "${CONTAINER_NAME}" &> /dev/null || true
    docker rm "${CONTAINER_NAME}" &> /dev/null || true
    print_status "Removed existing container"
else
    print_status "No existing container found"
fi
echo ""

# Check if image exists locally or pull from Docker Hub
echo "[4/6] Checking for Docker image..."
if docker image inspect "${IMAGE_NAME}:${VERSION}" &> /dev/null; then
    print_status "Image found locally"
else
    print_info "Image not found locally. Attempting to pull from Docker Hub..."
    if docker pull "${DOCKER_HUB_REPO}:${VERSION}" &> /dev/null; then
        print_status "Successfully pulled image from Docker Hub"
        docker tag "${DOCKER_HUB_REPO}:${VERSION}" "${IMAGE_NAME}:${VERSION}"
    else
        print_warning "Image not found on Docker Hub. Building locally..."
        echo ""
        echo "[5/6] Building Docker image locally..."
        echo "This may take several minutes..."
        if docker build -t "${IMAGE_NAME}:${VERSION}" .; then
            print_status "Image built successfully"
        else
            print_error "Failed to build Docker image"
            exit 1
        fi
    fi
fi
echo ""

# Create directories for volumes if they don't exist
echo "[6/6] Starting container..."
mkdir -p uploads results models
mkdir -p backend/uploads backend/results backend/models

# Run container
docker run -d \
    --name "${CONTAINER_NAME}" \
    -p 5000:5000 \
    -p 5173:5173 \
    -v "$(pwd)/uploads:/app/uploads" \
    -v "$(pwd)/results:/app/results" \
    -v "$(pwd)/models:/app/models" \
    -v "$(pwd)/backend/uploads:/app/backend/uploads" \
    -v "$(pwd)/backend/results:/app/backend/results" \
    -v "$(pwd)/backend/models:/app/backend/models" \
    --restart unless-stopped \
    "${IMAGE_NAME}:${VERSION}"

if [ $? -ne 0 ]; then
    print_error "Failed to start container"
    exit 1
fi

print_status "Container started successfully"
echo ""

# Wait for container to be healthy
echo "⏳ Waiting for application to be ready..."
sleep 5

# Check container status
if docker ps --filter "name=${CONTAINER_NAME}" --format "{{.Status}}" | grep -q "Up"; then
    :
else
    print_error "Container failed to start properly"
    echo ""
    echo "📋 Container logs:"
    docker logs "${CONTAINER_NAME}"
    exit 1
fi

echo ""
echo "============================================================"
echo "  ✅ Color Correction Studio is running!"
echo "============================================================"
echo ""
echo "  🌐 Access the application at:"
echo "     http://localhost:5000"
echo ""
echo "  📊 Container status:"
docker ps --filter "name=${CONTAINER_NAME}" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""
echo "  📋 Useful commands:"
echo "     View logs:    docker logs -f ${CONTAINER_NAME}"
echo "     Stop:         docker stop ${CONTAINER_NAME}"
echo "     Start:        docker start ${CONTAINER_NAME}"
echo "     Remove:       docker rm -f ${CONTAINER_NAME}"
echo ""
echo "============================================================"
echo ""

# Open browser (platform-specific)
sleep 3
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    open http://localhost:5000
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    if command -v xdg-open &> /dev/null; then
        xdg-open http://localhost:5000
    fi
fi

echo "Container is running in the background."
echo "Press Ctrl+C to exit this script (container will continue running)."
echo ""

# Keep script running to show logs
docker logs -f "${CONTAINER_NAME}"
