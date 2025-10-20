# Color Correction Studio - Docker Build and Test Script (PowerShell)
# =====================================================================

$ErrorActionPreference = "Stop"

# Configuration
$IMAGE_NAME = "collins137/cc_studio"
$CONTAINER_NAME = "color-correction-test"
$FRONTEND_PORT = 8080
$BACKEND_PORT = 5000

Write-Host "========================================" -ForegroundColor Blue
Write-Host "Color Correction Studio - Build & Test" -ForegroundColor Blue
Write-Host "========================================`n" -ForegroundColor Blue

# Step 1: Build Docker image
Write-Host "[1/6] Building Docker image..." -ForegroundColor Yellow
try {
    docker build -t ${IMAGE_NAME}:test .
    Write-Host "✓ Build successful!`n" -ForegroundColor Green
} catch {
    Write-Host "✗ Build failed!" -ForegroundColor Red
    exit 1
}

# Step 2: Stop and remove existing container
Write-Host "[2/6] Cleaning up existing containers..." -ForegroundColor Yellow
docker stop $CONTAINER_NAME 2>$null
docker rm $CONTAINER_NAME 2>$null
Write-Host "✓ Cleanup complete!`n" -ForegroundColor Green

# Step 3: Run container
Write-Host "[3/6] Starting container..." -ForegroundColor Yellow
try {
    docker run -d `
        --name $CONTAINER_NAME `
        -p ${FRONTEND_PORT}:80 `
        -p ${BACKEND_PORT}:5000 `
        ${IMAGE_NAME}:test
    Write-Host "✓ Container started!`n" -ForegroundColor Green
} catch {
    Write-Host "✗ Failed to start container!" -ForegroundColor Red
    exit 1
}

# Step 4: Wait for services to be ready
Write-Host "[4/6] Waiting for services to start (30s)..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Check health status
for ($i = 1; $i -le 10; $i++) {
    try {
        $health = docker inspect --format='{{.State.Health.Status}}' $CONTAINER_NAME 2>$null
        if ($health -eq "healthy") {
            Write-Host "✓ Container is healthy!`n" -ForegroundColor Green
            break
        }
        Write-Host "   Health check attempt $i/10: $health"
        Start-Sleep -Seconds 2
    } catch {
        Write-Host "   Health check attempt $i/10: pending"
        Start-Sleep -Seconds 2
    }
}

# Step 5: Test endpoints
Write-Host "[5/6] Testing endpoints..." -ForegroundColor Yellow

# Test backend health
Write-Host "   Testing backend API... " -NoNewline
try {
    $response = Invoke-WebRequest -Uri "http://localhost:${BACKEND_PORT}/api/health" -UseBasicParsing -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        Write-Host "✓ Backend OK" -ForegroundColor Green
    }
} catch {
    Write-Host "✗ Backend failed" -ForegroundColor Red
    docker logs $CONTAINER_NAME
    exit 1
}

# Test frontend
Write-Host "   Testing frontend... " -NoNewline
try {
    $response = Invoke-WebRequest -Uri "http://localhost:${FRONTEND_PORT}" -UseBasicParsing -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        Write-Host "✓ Frontend OK`n" -ForegroundColor Green
    }
} catch {
    Write-Host "✗ Frontend failed" -ForegroundColor Red
    docker logs $CONTAINER_NAME
    exit 1
}

# Step 6: Display information
Write-Host "[6/6] Deployment information:" -ForegroundColor Yellow
Write-Host "   Frontend: " -NoNewline; Write-Host "http://localhost:${FRONTEND_PORT}" -ForegroundColor Green
Write-Host "   Backend:  " -NoNewline; Write-Host "http://localhost:${BACKEND_PORT}/api/health" -ForegroundColor Green
Write-Host "   Container: " -NoNewline; Write-Host "$CONTAINER_NAME" -ForegroundColor Green

Write-Host "`n========================================" -ForegroundColor Blue
Write-Host "✓ All tests passed!" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Blue

# Display logs
Write-Host "Container logs (last 20 lines):" -ForegroundColor Yellow
docker logs --tail 20 $CONTAINER_NAME

Write-Host "`nUseful commands:" -ForegroundColor Yellow
Write-Host "   View logs:      docker logs -f $CONTAINER_NAME"
Write-Host "   Stop:           docker stop $CONTAINER_NAME"
Write-Host "   Remove:         docker rm $CONTAINER_NAME"
Write-Host "   Exec shell:     docker exec -it $CONTAINER_NAME /bin/bash"
Write-Host "   Push to hub:    docker tag ${IMAGE_NAME}:test ${IMAGE_NAME}:latest; docker push ${IMAGE_NAME}:latest"
