#!/bin/bash
# Deploy Watch - Polls for new deployments via SSH and shows macOS notifications
# Framework-agnostic: works with any project type
# 
# Usage: ./scripts/deploy-watch.sh
# Requirements: terminal-notifier (brew install terminal-notifier)

set -e

# Load env for server config
if [ -f .env ]; then
    export $(grep -E '^(PROD_SERVER|PROD_DIR)=' .env | xargs)
fi

# Config from .env (with defaults)
SERVER="${PROD_SERVER:-deploy@localhost}"
REMOTE_DIR="${PROD_DIR:-${PROJECT_NAME:-mybot}}"
DEPLOY_FILE="${REMOTE_DIR}/deploys/last"
POLL_INTERVAL=5
LAST_DEPLOY_FILE="/tmp/deploy-watch-last-$(echo $SERVER | tr '@:' '_')"

# Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
DIM='\033[2m'
NC='\033[0m'

echo -e "${CYAN}🔔 Deploy Watch (SSH)${NC}"
echo -e "   Server: ${SERVER}"
echo -e "   Remote: ~/${DEPLOY_FILE}"
echo -e "   Interval: ${POLL_INTERVAL}s"
echo ""

# Check if terminal-notifier is installed
if ! command -v terminal-notifier &> /dev/null; then
    echo -e "${YELLOW}⚠️  terminal-notifier not found. Install with: brew install terminal-notifier${NC}"
    echo "   Using osascript fallback"
    USE_FALLBACK=1
fi

send_notification() {
    local title="$1"
    local message="$2"
    
    if [ -z "$USE_FALLBACK" ]; then
        # Suppress "Removing previously sent notification" message
        terminal-notifier -title "$title" -message "$message" -sound "Glass" -group "deploy-watch" 2>/dev/null
    else
        osascript -e "display notification \"$message\" with title \"$title\" sound name \"Glass\""
    fi
}

# Initialize with current deploy (to avoid notification on start)
CURRENT=$(ssh -o ConnectTimeout=5 -o BatchMode=yes "$SERVER" "cat ~/${DEPLOY_FILE} 2>/dev/null" || echo "")
echo "$CURRENT" > "$LAST_DEPLOY_FILE"

echo -e "${GREEN}✓${NC} Watching for deploys..."
echo -e "${DIM}Press Ctrl+C to stop${NC}"
echo ""

while true; do
    # Read last known deploy
    LAST=$(cat "$LAST_DEPLOY_FILE" 2>/dev/null || echo "")
    
    # Poll server for current deploy
    CURRENT=$(ssh -o ConnectTimeout=5 -o BatchMode=yes "$SERVER" "cat ~/${DEPLOY_FILE} 2>/dev/null" 2>/dev/null || echo "")
    
    # Compare
    if [ -n "$CURRENT" ] && [ "$CURRENT" != "$LAST" ]; then
        # Parse: version|commit|branch|timestamp
        VERSION=$(echo "$CURRENT" | cut -d'|' -f1)
        COMMIT=$(echo "$CURRENT" | cut -d'|' -f2 | head -c 7)
        BRANCH=$(echo "$CURRENT" | cut -d'|' -f3)
        
        echo -e "${GREEN}🚀 New Deploy!${NC} ${VERSION} (${COMMIT}) on ${BRANCH}"
        send_notification "🚀 Deploy Complete" "${VERSION} (${COMMIT}) on ${BRANCH}"
        
        # Play sound (may bypass DND)
        afplay /System/Library/Sounds/Glass.aiff &
        
        # Save new deploy
        echo "$CURRENT" > "$LAST_DEPLOY_FILE"
    fi
    
    sleep $POLL_INTERVAL
done
