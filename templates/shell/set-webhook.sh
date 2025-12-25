#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# Telegram Bot Webhook Setup
# Usage: ./scripts/set-webhook.sh [dev|prod]
# ═══════════════════════════════════════════════════════════════

set -e

# Load environment
if [ -f .env ]; then
    export $(grep -E '^(TELEGRAM_BOT_TOKEN|TELEGRAM_BOT_TOKEN_DEV|DOMAIN|DEV_API_URL)=' .env | xargs)
fi

MODE="${1:-dev}"

# Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}🔗 Telegram Webhook Setup${NC}"
echo ""

if [ "$MODE" = "prod" ]; then
    TOKEN="$TELEGRAM_BOT_TOKEN"
    URL="https://${DOMAIN}/api/webhook"
    echo -e "   Mode: ${GREEN}Production${NC}"
else
    TOKEN="$TELEGRAM_BOT_TOKEN_DEV"
    URL="${DEV_API_URL}/webhook"
    echo -e "   Mode: ${YELLOW}Development${NC}"
fi

# Validate token
if [ -z "$TOKEN" ]; then
    if [ "$MODE" = "prod" ]; then
        echo -e "${RED}❌ TELEGRAM_BOT_TOKEN not set in .env${NC}"
    else
        echo -e "${RED}❌ TELEGRAM_BOT_TOKEN_DEV not set in .env${NC}"
    fi
    exit 1
fi

# Validate URL
if [ -z "$URL" ] || [ "$URL" = "/webhook" ]; then
    if [ "$MODE" = "prod" ]; then
        echo -e "${RED}❌ DOMAIN not set in .env${NC}"
    else
        echo -e "${RED}❌ DEV_API_URL not set in .env${NC}"
    fi
    exit 1
fi

echo -e "   URL: ${CYAN}${URL}${NC}"
echo ""

# Set webhook
echo -e "Setting webhook..."
RESPONSE=$(curl -s "https://api.telegram.org/bot${TOKEN}/setWebhook?url=${URL}")

# Check result
if echo "$RESPONSE" | grep -q '"ok":true'; then
    echo -e "${GREEN}✅ Webhook set successfully!${NC}"
else
    echo -e "${RED}❌ Failed to set webhook${NC}"
    echo "$RESPONSE" | jq . 2>/dev/null || echo "$RESPONSE"
    exit 1
fi

# Show current webhook info
echo ""
echo -e "Current webhook info:"
curl -s "https://api.telegram.org/bot${TOKEN}/getWebhookInfo" | jq .
