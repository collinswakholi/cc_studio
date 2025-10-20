#!/bin/bash
# Color Correction Studio - Startup Script (Linux/macOS)
# This script starts both the backend and frontend servers

echo ""
echo "============================================================"
echo "  🎨 Color Correction Studio - Starting..."
echo "============================================================"
echo ""

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Start Backend Server in background
echo "🔧 Starting Backend Server (Python Flask)..."
cd "$SCRIPT_DIR/backend"
python server_enhanced.py &
BACKEND_PID=$!
echo "   Backend PID: $BACKEND_PID"

# Wait for backend to initialize
sleep 3

# Start Frontend Server in background
echo "🌐 Starting Frontend Server (Vite + React)..."
cd "$SCRIPT_DIR"
npm run dev &
FRONTEND_PID=$!
echo "   Frontend PID: $FRONTEND_PID"

# Wait for frontend to start
sleep 3

echo ""
echo "============================================================"
echo "  ✅ Both servers are running!"
echo "============================================================"
echo ""
echo "  🌐 Frontend: http://localhost:5173"
echo "  🔧 Backend:  http://localhost:5000"
echo ""
echo "  📝 Process IDs:"
echo "     Backend:  $BACKEND_PID"
echo "     Frontend: $FRONTEND_PID"
echo ""
echo "  ⚠️  Press Ctrl+C to stop both servers"
echo ""

# Function to cleanup on exit
cleanup() {
    echo ""
    echo "🛑 Stopping servers..."
    kill $BACKEND_PID 2>/dev/null
    kill $FRONTEND_PID 2>/dev/null
    echo "✅ Servers stopped."
    exit 0
}

# Trap Ctrl+C and call cleanup
trap cleanup INT TERM

# Open browser (works on macOS and some Linux systems)
if command -v xdg-open > /dev/null; then
    xdg-open "http://localhost:5173" 2>/dev/null &
elif command -v open > /dev/null; then
    open "http://localhost:5173" 2>/dev/null &
fi

# Keep script running and wait for Ctrl+C
wait
