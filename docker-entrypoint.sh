#!/bin/bash
set -e

echo "============================================================"
echo "  🎨 Color Correction Studio - Docker Container"
echo "============================================================"
echo ""

# Create directories if they don't exist
mkdir -p /app/uploads /app/results /app/models
mkdir -p /app/backend/uploads /app/backend/results /app/backend/models

echo "📁 Directory structure verified"

# Check if ColorCorrectionPipeline is available
if python -c "import ColorCorrectionPipeline" 2>/dev/null; then
    echo "✅ ColorCorrectionPipeline: Available"
else
    echo "⚠️  ColorCorrectionPipeline: Not Available (optional)"
fi

# Start backend with Gunicorn for production
echo ""
echo "🚀 Starting Flask Backend Server..."
echo "   Backend API: http://localhost:5000"
echo "   Frontend: Served from /app/frontend/dist"
echo ""

cd /app/backend

# Use Gunicorn with gevent workers for better concurrent request handling
exec gunicorn \
    --bind 0.0.0.0:5000 \
    --workers 4 \
    --worker-class gevent \
    --worker-connections 1000 \
    --timeout 300 \
    --keepalive 5 \
    --log-level info \
    --access-logfile - \
    --error-logfile - \
    server_enhanced:app
