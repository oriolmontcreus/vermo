@echo off
echo 🚀 Starting Vermo Laravel Development Environment...
echo.

REM Check if Docker is running
docker info >nul 2>&1
if errorlevel 1 (
    echo ❌ ERROR: Docker is not running. Please start Docker Desktop first.
    pause
    exit /b 1
)

echo ✅ Docker is running...
echo.

REM Use the bash script for smart startup
echo 🏗️ Running smart startup...
bash docker/scripts/smart-start.sh

if errorlevel 1 (
    echo ❌ Startup failed. Please check the errors above.
    pause
    exit /b 1
)

echo.
echo 📋 To view logs: docker-compose logs -f
echo 📋 To stop containers: docker-compose down
echo 📋 To restart: npm run docker:restart
echo.
echo Press any key to start watching logs (Ctrl+C to exit)...
pause >nul

REM Show logs
docker-compose logs -f 