#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔍 Vermo Development Environment Status${NC}"
echo -e "${GREEN}=======================================${NC}"
echo ""

# Check Docker
if docker info >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Docker: Running${NC}"
else
    echo -e "${RED}❌ Docker: Not running${NC}"
    exit 1
fi

# Check containers
echo ""
echo -e "${YELLOW}📦 Container Status:${NC}"
if docker-compose ps >/dev/null 2>&1; then
    docker-compose ps
else
    echo -e "${RED}❌ Could not get container status${NC}"
fi

# Check services
echo ""
echo -e "${YELLOW}🚀 Service Health:${NC}"

# Check MySQL
if docker-compose exec -T mysql mysqladmin ping -h localhost --silent >/dev/null 2>&1; then
    echo -e "${GREEN}✅ MySQL: Ready${NC}"
else
    echo -e "${RED}❌ MySQL: Not ready${NC}"
fi

# Check PHP
if docker-compose exec -T php php -v >/dev/null 2>&1; then
    echo -e "${GREEN}✅ PHP: Ready${NC}"
else
    echo -e "${RED}❌ PHP: Not ready${NC}"
fi

# Check Nginx
if curl -s -o /dev/null -w "%{http_code}" http://localhost 2>/dev/null | grep -q "200"; then
    echo -e "${GREEN}✅ Nginx: Ready (http://localhost)${NC}"
else
    echo -e "${RED}❌ Nginx: Not accessible${NC}"
fi

# Check Vite
if curl -s -o /dev/null -w "%{http_code}" http://localhost:5173 2>/dev/null | grep -q "200"; then
    echo -e "${GREEN}✅ Vite: Ready (http://localhost:5173)${NC}"
else
    echo -e "${YELLOW}⚠️ Vite: May be starting up${NC}"
fi

echo ""
echo -e "${CYAN}🔗 Access URLs:${NC}"
echo -e "${WHITE}   Main App:  http://localhost${NC}"
echo -e "${WHITE}   Vite HMR:  http://localhost:5173${NC}"
echo "" 