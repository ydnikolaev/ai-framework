#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# Pretty Docker Logs Viewer (Server-side)
# Usage: ./scripts/dx-logs.sh [container_name] [tail_lines]
# ═══════════════════════════════════════════════════════════════

CONTAINER="${1:-kinobot_bot}"
TAIL="${2:-50}"

# Colors
CYAN='\033[36m'
MAGENTA='\033[35m'
GREEN='\033[32m'
YELLOW='\033[33m'
DIM='\033[2m'
RESET='\033[0m'
BOLD='\033[1m'

# Get container short name for display
DISPLAY_NAME=$(echo "$CONTAINER" | sed 's/kinobot_//')

clear

echo -e "${MAGENTA}${BOLD}═══════════════════════════════════════${RESET}"
echo -e "${MAGENTA}${BOLD}  📋 Logs: ${DISPLAY_NAME^^}${RESET}"
echo -e "${MAGENTA}${BOLD}═══════════════════════════════════════${RESET}"
echo ""
echo -e "${DIM}  Container: $CONTAINER${RESET}"
echo -e "${DIM}  Press Ctrl+C to exit${RESET}"
echo ""

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
