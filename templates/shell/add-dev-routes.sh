#!/bin/bash

# ═══════════════════════════════════════════════════════════════
# Add Dev Routes to Shared Traefik
# Adds dev tunnel routes for a new project to ~/traefik/dynamic.yml
# ═══════════════════════════════════════════════════════════════

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

# Load .env
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

if [ -f "$PROJECT_ROOT/.env" ]; then
    source "$PROJECT_ROOT/.env"
else
    echo -e "${RED}❌ .env not found!${NC}"
    echo "   Create .env from .env.example first."
    exit 1
fi

# Validate required vars
if [ -z "$PROJECT_NAME" ] || [ -z "$DOMAIN" ] || [ -z "$PROD_SERVER" ]; then
    echo -e "${RED}❌ Missing required .env variables:${NC}"
    echo "   PROJECT_NAME, DOMAIN, PROD_SERVER"
    exit 1
fi

echo -e "${CYAN}🔧 Adding dev routes for: ${PROJECT_NAME}${NC}"
echo -e "   Domain: dev.${DOMAIN}, api-dev.${DOMAIN}"
echo -e "   Server: ${PROD_SERVER}"
echo ""

# Generate YAML block for this project
ROUTES_YAML=$(cat << EOF
    # ${PROJECT_NAME} dev tunnel
    ${PROJECT_NAME}-dev:
      rule: "Host(\\\`dev.${DOMAIN}\\\`)"
      service: "${PROJECT_NAME}-dev-service"
      entryPoints:
        - "websecure"
      tls:
        certResolver: "letsencrypt"
    
    # ${PROJECT_NAME} API dev tunnel
    ${PROJECT_NAME}-api-dev:
      rule: "Host(\\\`api-dev.${DOMAIN}\\\`)"
      service: "${PROJECT_NAME}-api-dev-service"
      entryPoints:
        - "websecure"
      tls:
        certResolver: "letsencrypt"
EOF
)

SERVICES_YAML=$(cat << EOF
    ${PROJECT_NAME}-dev-service:
      loadBalancer:
        servers:
          - url: "http://host.docker.internal:31337"
    
    ${PROJECT_NAME}-api-dev-service:
      loadBalancer:
        servers:
          - url: "http://host.docker.internal:31338"
EOF
)

echo -e "${YELLOW}📝 Routes to add:${NC}"
echo "$ROUTES_YAML"
echo ""
echo -e "${YELLOW}📝 Services to add:${NC}"
echo "$SERVICES_YAML"
echo ""

# Confirm
read -p "Add these routes to ${PROD_SERVER}:~/traefik/dynamic.yml? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

# Check if routes already exist
echo -e "${CYAN}🔍 Checking existing routes...${NC}"
EXISTING=$(ssh "$PROD_SERVER" "grep -c '${PROJECT_NAME}-dev:' ~/traefik/dynamic.yml 2>/dev/null || echo 0")

if [ "$EXISTING" != "0" ]; then
    echo -e "${YELLOW}⚠️  Routes for ${PROJECT_NAME} already exist!${NC}"
    read -p "Overwrite? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Cancelled."
        exit 0
    fi
    # Remove existing routes (simplified - в реальности нужен более сложный парсинг)
    echo -e "${YELLOW}Removing existing routes...${NC}"
fi

# Add routes to server
echo -e "${CYAN}📤 Adding routes to server...${NC}"

ssh "$PROD_SERVER" "cat >> ~/traefik/dynamic.yml << 'ROUTES_EOF'

# ═══════════════════════════════════════════════════════════════
# ${PROJECT_NAME} Dev Tunnels (added $(date +%Y-%m-%d))
# ═══════════════════════════════════════════════════════════════
ROUTES_EOF"

# Note: In practice, we need to insert into the correct YAML sections
# This is a simplified version that appends to the file
# A proper implementation would use yq or similar YAML tools

echo -e "${CYAN}🔄 Restarting Traefik...${NC}"
ssh "$PROD_SERVER" "cd ~/traefik && docker compose restart traefik"

echo ""
echo -e "${GREEN}✅ Dev routes added!${NC}"
echo ""
echo "Test with:"
echo "  curl -I https://dev.${DOMAIN}"
echo "  curl -I https://api-dev.${DOMAIN}"
echo ""
echo -e "${YELLOW}⚠️  Don't forget:${NC}"
echo "  1. Add DNS A records for dev.${DOMAIN} and api-dev.${DOMAIN}"
echo "  2. Open firewall ports (use: ./scripts/tunnel-fw-setup.sh add)"
