#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# Pretty Docker Logs Viewer (Server-side) — Auto-Reconnect
# Usage: ./scripts/dx-logs.sh [container_name] [tail_lines]
# ═══════════════════════════════════════════════════════════════

# Load PROJECT_NAME from .env if available
if [ -f .env ]; then
    export $(grep -E '^PROJECT_NAME=' .env | xargs 2>/dev/null) || true
fi

CONTAINER="${1:-${PROJECT_NAME:-mybot}_bot}"
TAIL="${2:-50}"
RECONNECT_DELAY=5

# Colors
CYAN='\033[36m'
MAGENTA='\033[35m'
GREEN='\033[32m'
YELLOW='\033[33m'
DIM='\033[2m'
RESET='\033[0m'
BOLD='\033[1m'

# Get container short name for display (strip project prefix)
DISPLAY_NAME=$(echo "$CONTAINER" | sed "s/${PROJECT_NAME:-mybot}_//")

show_header() {
    clear
    echo -e "${MAGENTA}${BOLD}═══════════════════════════════════════${RESET}"
    echo -e "${MAGENTA}${BOLD}  📋 Logs: ${DISPLAY_NAME^^}${RESET}"
    echo -e "${MAGENTA}${BOLD}═══════════════════════════════════════${RESET}"
    echo ""
    echo -e "${DIM}  Container: $CONTAINER${RESET}"
    echo -e "${DIM}  Auto-reconnect enabled (${RECONNECT_DELAY}s delay)${RESET}"
    echo -e "${DIM}  Press Ctrl+C to exit${RESET}"
    echo ""
}

stream_logs() {
    docker logs -f --tail "$TAIL" "$CONTAINER" 2>&1 | while IFS= read -r line; do
        # Colorize log levels
        if [[ "$line" == *"ERROR"* ]] || [[ "$line" == *"error"* ]]; then
            echo -e "${YELLOW}${line}${RESET}"
        elif [[ "$line" == *"INFO"* ]] || [[ "$line" == *"info"* ]]; then
            echo -e "${line}"
        elif [[ "$line" == *"DEBUG"* ]] || [[ "$line" == *"debug"* ]]; then
            echo -e "${DIM}${line}${RESET}"
        else
            echo "$line"
        fi
    done
}

# Main loop with auto-reconnect
while true; do
    show_header
    stream_logs
    
    # If we get here, container stopped or connection lost
    echo ""
    echo -e "${YELLOW}⚠️  Container stopped. Reconnecting in ${RECONNECT_DELAY}s...${RESET}"
    sleep $RECONNECT_DELAY
done
