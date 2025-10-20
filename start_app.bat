@echo off
REM Color Correction Studio - Startup Script (Windows CMD)
REM This script starts both the backend and frontend servers

echo.
echo ============================================================
echo   Color Correction Studio - Starting...
echo ============================================================
echo.

REM Start Backend Server in a new window
echo Starting Backend Server (Python Flask)...
start "Backend Server" cmd /k "cd /d %~dp0backend && python server_enhanced.py"

REM Wait for backend to initialize
timeout /t 3 /nobreak >nul

REM Start Frontend Server in a new window
echo Starting Frontend Server (Vite + React)...
start "Frontend Server" cmd /k "cd /d %~dp0 && npm run dev"

REM Wait for frontend to start
timeout /t 3 /nobreak >nul

echo.
echo ============================================================
echo   Both servers are starting!
echo ============================================================
echo.
echo   Frontend: http://localhost:5173
echo   Backend:  http://localhost:5000
echo.
echo   Two terminal windows have been opened for each server
echo   Close those terminal windows to stop the servers
echo.
echo   Press any key to open the app in your browser...
pause >nul

REM Open browser
start http://localhost:5173

exit
