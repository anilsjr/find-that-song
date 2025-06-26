@echo off
echo Starting Find That Song Backend API...
echo.
cd /d "%~dp0backend\song-serch-api"
echo Installing dependencies (if needed)...
call npm install
echo.
echo Starting server on http://localhost:3000
echo Press Ctrl+C to stop the server
echo.
node index.js
pause
