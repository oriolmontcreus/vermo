#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}⏳ Checking if services are ready...${NC}"

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
        break
    else
        echo -n "."
    fi
done

if [ "$all_ready" = false ]; then
    echo ""
    echo -e "${YELLOW}⚠️ Services may still be starting up after 60 seconds. Continuing anyway...${NC}"
else
    echo ""
fi 