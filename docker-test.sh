#!/bin/bash

# Color Correction Studio - Docker Build and Test Script
# ========================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
IMAGE_NAME="collins137/color-correction-studio"
CONTAINER_NAME="color-correction-test"
FRONTEND_PORT=8080
BACKEND_PORT=5000

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Color Correction Studio - Build & Test${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Step 1: Build Docker image
echo -e "${YELLOW}[1/6]${NC} Building Docker image..."
docker build -t ${IMAGE_NAME}:test . || {
    echo -e "${RED}✗ Build failed!${NC}"
    exit 1
}
echo -e "${GREEN}✓ Build successful!${NC}\n"

# Step 2: Stop and remove existing container
echo -e "${YELLOW}[2/6]${NC} Cleaning up existing containers..."
docker stop ${CONTAINER_NAME} 2>/dev/null || true
docker rm ${CONTAINER_NAME} 2>/dev/null || true
echo -e "${GREEN}✓ Cleanup complete!${NC}\n"

# Step 3: Run container
echo -e "${YELLOW}[3/6]${NC} Starting container..."
docker run -d \
    --name ${CONTAINER_NAME} \
    -p ${FRONTEND_PORT}:80 \
    -p ${BACKEND_PORT}:5000 \
    ${IMAGE_NAME}:test || {
    echo -e "${RED}✗ Failed to start container!${NC}"
    exit 1
}
echo -e "${GREEN}✓ Container started!${NC}\n"

# Step 4: Wait for services to be ready
echo -e "${YELLOW}[4/6]${NC} Waiting for services to start (30s)..."
sleep 10

# Check health status
for i in {1..10}; do
    HEALTH=$(docker inspect --format='{{.State.Health.Status}}' ${CONTAINER_NAME} 2>/dev/null || echo "none")
    if [ "$HEALTH" == "healthy" ]; then
        echo -e "${GREEN}✓ Container is healthy!${NC}\n"
        break
    fi
    echo -e "   Health check attempt $i/10: ${HEALTH}"
    sleep 2
done

# Step 5: Test endpoints
echo -e "${YELLOW}[5/6]${NC} Testing endpoints..."

# Test backend health
echo -n "   Testing backend API... "
if curl -sf http://localhost:${BACKEND_PORT}/api/health > /dev/null; then
    echo -e "${GREEN}✓ Backend OK${NC}"
else
    echo -e "${RED}✗ Backend failed${NC}"
    docker logs ${CONTAINER_NAME}
    exit 1
fi

# Test frontend
echo -n "   Testing frontend... "
if curl -sf http://localhost:${FRONTEND_PORT} > /dev/null; then
    echo -e "${GREEN}✓ Frontend OK${NC}"
else
    echo -e "${RED}✗ Frontend failed${NC}"
    docker logs ${CONTAINER_NAME}
    exit 1
fi

echo ""

# Step 6: Display information
echo -e "${YELLOW}[6/6]${NC} Deployment information:"
echo -e "   ${GREEN}Frontend:${NC} http://localhost:${FRONTEND_PORT}"
echo -e "   ${GREEN}Backend:${NC}  http://localhost:${BACKEND_PORT}/api/health"
echo -e "   ${GREEN}Container:${NC} ${CONTAINER_NAME}"
echo -e "\n${BLUE}========================================${NC}"
echo -e "${GREEN}✓ All tests passed!${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Display logs
echo -e "${YELLOW}Container logs (last 20 lines):${NC}"
docker logs --tail 20 ${CONTAINER_NAME}

echo -e "\n${YELLOW}Useful commands:${NC}"
echo -e "   View logs:      docker logs -f ${CONTAINER_NAME}"
echo -e "   Stop:           docker stop ${CONTAINER_NAME}"
echo -e "   Remove:         docker rm ${CONTAINER_NAME}"
echo -e "   Exec shell:     docker exec -it ${CONTAINER_NAME} /bin/bash"
echo -e "   Push to hub:    docker tag ${IMAGE_NAME}:test ${IMAGE_NAME}:latest && docker push ${IMAGE_NAME}:latest"
