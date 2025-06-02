@echo off
echo Starting Vermo Laravel Development Environment...
echo.

REM Check if Docker is running
docker info >nul 2>&1
if errorlevel 1 (
    echo ERROR: Docker is not running. Please start Docker Desktop first.
    pause
    exit /b 1
)

echo Docker is running...
echo.

REM Copy environment file if it doesn't exist
if not exist ".env" (
    echo Creating .env file from template...
    copy "docker\env-example" ".env"
    echo .env file created successfully!
    echo.
)

echo Starting containers...
docker-compose up -d

REM Wait for containers to start
echo Waiting for containers to initialize...
timeout /t 15 /nobreak >nul

echo.
echo Setting up Laravel application...

REM Generate application key if needed
docker-compose exec php php artisan key:generate --ansi

REM Run migrations
docker-compose exec php php artisan migrate --ansi

echo.
echo ====================================
echo Development environment is ready!
echo ====================================
echo Main application: http://localhost
echo Vite dev server: http://localhost:5173
echo ====================================
echo.
echo To view logs, run: docker-compose logs -f
echo To stop containers, run: docker-compose down
echo.
echo Press any key to exit setup...
pause >nul 