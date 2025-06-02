#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🔑 Checking application key...${NC}"

needs_key=true

if [ -f ".env" ]; then
    if grep -q "APP_KEY=base64:[A-Za-z0-9+/]\+=" ".env" && ! grep -q "YOUR_APP_KEY_WILL_BE_GENERATED" ".env"; then
        needs_key=false
        echo -e "${GREEN}✅ Application key already exists${NC}"
    fi
else
    echo -e "${YELLOW}⚠️ .env file not found. Please run setup first.${NC}"
    exit 1
fi

if [ "$needs_key" = true ]; then
    echo -e "${YELLOW}🔐 Generating application key...${NC}"
    docker-compose exec -T php php artisan key:generate --ansi
    echo -e "${GREEN}✅ Application key generated!${NC}"
fi 