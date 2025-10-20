# Multi-stage Dockerfile for Color Correction Studio
# Optimized for size and performance

# Stage 1: Build Frontend
FROM node:20-alpine AS frontend-builder

WORKDIR /app/frontend

# Copy package files for dependency caching
COPY package*.json ./

# Install dependencies with clean install
RUN npm ci --only=production && npm cache clean --force

# Copy frontend source
COPY index.html ./
COPY vite.config.js ./
COPY tailwind.config.js ./
COPY postcss.config.js ./
COPY src/ ./src/

# Build production frontend
RUN npm run build

# Stage 2: Python Backend with OpenCV
FROM python:3.11-slim AS backend

WORKDIR /app

# Install system dependencies for OpenCV and image processing
RUN apt-get update && apt-get install -y --no-install-recommends \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    libgl1-mesa-glx \
    && rm -rf /var/lib/apt/lists/*

# Copy backend requirements
COPY backend/requirements.txt ./backend/

# Install Python dependencies with optimizations
RUN pip install --no-cache-dir -r backend/requirements.txt && \
    pip install --no-cache-dir gunicorn gevent

# Copy backend source
COPY backend/ ./backend/

# Copy built frontend from builder stage
COPY --from=frontend-builder /app/frontend/dist ./frontend/dist

# Create necessary directories with proper permissions
RUN mkdir -p uploads results models backend/uploads backend/results backend/models && \
    chmod -R 755 uploads results models backend

# Set environment variables
ENV FLASK_ENV=production \
    PYTHONUNBUFFERED=1 \
    PORT=5000 \
    FRONTEND_PORT=5173

# Expose ports
EXPOSE 5000 5173

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000/health').read()" || exit 1

# Create startup script
COPY docker-entrypoint.sh /app/
RUN chmod +x /app/docker-entrypoint.sh

ENTRYPOINT ["/app/docker-entrypoint.sh"]
