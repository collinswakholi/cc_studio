# ============================================================================
# Color Correction Studio - Startup Script (Windows PowerShell)
# ============================================================================
# This script starts both the backend (Python Flask) and frontend (Vite + React)
# servers in separate terminal windows for easier management and debugging.
#
# Usage: Right-click and select "Run with PowerShell" or execute: .\start_app.ps1
# 
# To stop: Close the terminal windows that were opened by this script
# ============================================================================

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  🎨 Color Correction Studio - Starting..." -ForegroundColor White
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# Start Backend Server in a new window
Write-Host "🔧 Starting Backend Server (Python Flask)..." -ForegroundColor Yellow
Write-Host "   Location: backend/server_enhanced.py" -ForegroundColor Gray
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PSScriptRoot\backend'; Write-Host '=== Backend Server (Flask) ===' -ForegroundColor Green; python server_enhanced.py"

# Wait for backend to initialize
Write-Host "   ⏳ Waiting 3 seconds for backend initialization..." -ForegroundColor Gray
Start-Sleep -Seconds 3

# Start Frontend Server in a new window
Write-Host "🌐 Starting Frontend Server (Vite + React)..." -ForegroundColor Yellow
Write-Host "   Location: root directory" -ForegroundColor Gray
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PSScriptRoot'; Write-Host '=== Frontend Server (Vite) ===' -ForegroundColor Green; npm run dev"

# Wait for frontend to start
Write-Host "   ⏳ Waiting 3 seconds for frontend initialization..." -ForegroundColor Gray
Start-Sleep -Seconds 3

# Display success message and instructions
Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host "  ✅ Both servers are running!" -ForegroundColor White
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
Write-Host "  🌐 Frontend: " -NoNewline -ForegroundColor Cyan
Write-Host "http://localhost:5173" -ForegroundColor White
Write-Host "  🔧 Backend:  " -NoNewline -ForegroundColor Cyan
Write-Host "http://localhost:5000" -ForegroundColor White
Write-Host ""
Write-Host "  📝 Two terminal windows have been opened:" -ForegroundColor Yellow
Write-Host "     • Backend server (Python Flask)" -ForegroundColor Gray
Write-Host "     • Frontend server (Vite dev server)" -ForegroundColor Gray
Write-Host ""
Write-Host "  🛑 To stop the servers:" -ForegroundColor Red
Write-Host "     • Close the terminal windows, OR" -ForegroundColor Gray
Write-Host "     • Press Ctrl+C in each terminal" -ForegroundColor Gray
Write-Host ""
Write-Host "  Press any key to open the app in your browser..." -ForegroundColor Green
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Open browser
Write-Host ""
Write-Host "  🚀 Opening browser..." -ForegroundColor Cyan
Start-Process "http://localhost:5173"

Write-Host ""
Write-Host "  👋 You can close this window now." -ForegroundColor Gray
Write-Host ""
