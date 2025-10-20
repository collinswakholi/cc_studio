# ============================================================
# Color Correction Studio - Multi-Stage Docker Build
# ============================================================
# Stage 1: Frontend Build (Node.js + Vite)
# Stage 2: Python Backend Setup
# Stage 3: Final Production Image (Nginx + Python)
# ============================================================

# ============================================================
# STAGE 1: Frontend Build
# ============================================================
FROM node:20-alpine AS frontend-builder

WORKDIR /app/frontend

# Copy package files
COPY package*.json ./

# Install dependencies with clean install for reproducibility
RUN npm ci --prefer-offline --no-audit

# Copy frontend source
COPY index.html ./
COPY vite.config.js ./
COPY tailwind.config.js ./
COPY postcss.config.js ./
COPY src/ ./src/

# Build production frontend
RUN npm run build

# ============================================================
# STAGE 2: Python Backend Setup
# ============================================================
FROM python:3.11-slim AS backend-builder

WORKDIR /app/backend

# Install system dependencies for OpenCV and image processing
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

# Copy backend requirements
COPY backend/requirements.txt ./

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# ============================================================
# STAGE 3: Final Production Image
# ============================================================
FROM python:3.11-slim

LABEL maintainer="Collins <wcoln@yahoo.com>"
LABEL description="Color Correction Studio - ML-based Image Color Correction Application"
LABEL version="1.0.0"

WORKDIR /app

# Install runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    nginx \
    supervisor \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy Python packages from builder
COPY --from=backend-builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages

# Copy backend application
COPY backend/ ./backend/
RUN chmod +x backend/*.py

# Copy built frontend from frontend-builder
COPY --from=frontend-builder /app/frontend/dist /usr/share/nginx/html

# Create necessary directories with proper permissions
RUN mkdir -p /app/backend/uploads \
    /app/backend/results \
    /app/backend/models \
    /app/logs \
    /run/nginx && \
    chmod -R 755 /app/backend && \
    chmod -R 777 /app/backend/uploads \
    /app/backend/results \
    /app/backend/models \
    /app/logs

# Copy Nginx configuration
COPY docker/nginx.conf /etc/nginx/nginx.conf

# Copy Supervisor configuration
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Environment variables
ENV PYTHONUNBUFFERED=1
ENV PORT=5000
ENV MAX_WORKERS=4
ENV REQUEST_TIMEOUT=300
ENV UPLOAD_FOLDER=/app/backend/uploads
ENV RESULTS_FOLDER=/app/backend/results
ENV MODELS_FOLDER=/app/backend/models
ENV ALLOWED_BASE_DIR=/app/backend

# Expose ports
# 80: Nginx (Frontend)
# 5000: Flask Backend API
EXPOSE 80 5000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:5000/api/health || exit 1

# Start supervisor to manage both services
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
