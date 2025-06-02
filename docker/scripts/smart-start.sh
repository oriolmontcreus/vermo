#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Starting Vermo Development Environment...${NC}"
echo ""

# Check if Docker is running
echo -e "${YELLOW}🔍 Checking Docker...${NC}"
if ! docker info >/dev/null 2>&1; then
    echo -e "${RED}❌ ERROR: Docker is not running. Please start Docker Desktop first.${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Docker is running${NC}"

# Check if .env exists, create if not
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}📝 Creating .env file from template...${NC}"
    cp "docker/env-example" ".env"
    echo -e "${GREEN}✅ .env file created successfully!${NC}"
    echo ""
fi

# Check container status
echo -e "${YELLOW}🔍 Checking container status...${NC}"
containers_running=false

# Check if containers exist and are running
if docker-compose ps -q >/dev/null 2>&1; then
    running_containers=$(docker-compose ps --filter "status=running" -q 2>/dev/null | wc -l)
    if [ "$running_containers" -ge 4 ]; then
        containers_running=true
        echo -e "${GREEN}✅ All containers are already running${NC}"
    fi
fi

if [ "$containers_running" = false ]; then
    echo -e "${YELLOW}🏗️ Starting containers...${NC}"
    docker-compose up -d
    
    echo -e "${YELLOW}⏳ Waiting for services to be ready...${NC}"
    
    # Smart wait - check if services are actually ready
    max_attempts=30
    attempt=0
    all_ready=false
    
    while [ $attempt -lt $max_attempts ] && [ "$all_ready" = false ]; do
        attempt=$((attempt + 1))
        sleep 2
        
        # Check MySQL
        mysql_ready=false
        if docker-compose exec -T mysql mysqladmin ping -h localhost --silent >/dev/null 2>&1; then
            mysql_ready=true
        fi
        
        # Check PHP-FPM
        php_ready=false
        if docker-compose exec -T php php -v >/dev/null 2>&1; then
            php_ready=true
        fi
        
        # Check if both are ready
        if [ "$mysql_ready" = true ] && [ "$php_ready" = true ]; then
            all_ready=true
            echo -e "${GREEN}✅ All services are ready! (took $((attempt * 2)) seconds)${NC}"
        else
            echo -n "."
        fi
    done
    
    if [ "$all_ready" = false ]; then
        echo ""
        echo -e "${YELLOW}⚠️ Services may still be starting up. Continuing anyway...${NC}"
    fi
    
    echo ""
else
    echo -e "${CYAN}⚡ Skipping container startup (already running)${NC}"
fi

# Check and generate app key only if needed
echo -e "${YELLOW}🔑 Checking application key...${NC}"
needs_key=true

if [ -f ".env" ]; then
    if grep -q "APP_KEY=base64:[A-Za-z0-9+/]\+=" ".env" && ! grep -q "YOUR_APP_KEY_WILL_BE_GENERATED" ".env"; then
        needs_key=false
        echo -e "${GREEN}✅ Application key already exists${NC}"
    fi
fi

if [ "$needs_key" = true ]; then
    echo -e "${YELLOW}🔐 Generating application key...${NC}"
    docker-compose exec -T php php artisan key:generate --ansi
    echo -e "${GREEN}✅ Application key generated!${NC}"
fi

# Run migrations only if needed
echo -e "${YELLOW}🗄️ Checking database...${NC}"
needs_migration=true

if docker-compose exec -T php php artisan migrate:status >/dev/null 2>&1; then
    needs_migration=false
    echo -e "${GREEN}✅ Database is up to date${NC}"
fi

if [ "$needs_migration" = true ]; then
    echo -e "${YELLOW}📊 Running database migrations...${NC}"
    docker-compose exec -T php php artisan migrate --ansi
    echo -e "${GREEN}✅ Database migrations completed!${NC}"
fi

echo ""
echo -e "${GREEN}=====================================${NC}"
echo -e "${GREEN}🎉 Development environment is ready!${NC}"
echo -e "${GREEN}=====================================${NC}"
echo -e "${CYAN}Main application: http://localhost${NC}"
echo -e "${CYAN}Vite dev server: http://localhost:5173${NC}"
echo -e "${GREEN}=====================================${NC}"
echo ""
echo -e "${YELLOW}Press Ctrl+C to stop watching logs...${NC}"
echo "" 