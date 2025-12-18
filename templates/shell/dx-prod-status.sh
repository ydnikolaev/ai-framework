#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# Pretty Docker Status (Server-side)
# Usage: ./scripts/dx-prod-status.sh
# ═══════════════════════════════════════════════════════════════

# Colors
CYAN='\033[36m'
GREEN='\033[32m'
YELLOW='\033[33m'
MAGENTA='\033[35m'
DIM='\033[2m'
RESET='\033[0m'
BOLD='\033[1m'

while true; do
    clear
    
    echo -e "${MAGENTA}${BOLD}═══════════════════════════════════════${RESET}"
    echo -e "${MAGENTA}${BOLD}  📊 Production Status${RESET}"
    echo -e "${MAGENTA}${BOLD}═══════════════════════════════════════${RESET}"
    echo ""
    
    # Container status with colors
    echo -e "${CYAN}${BOLD}Containers:${RESET}"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null | while IFS= read -r line; do
        if [[ "$line" == *"Up"* ]] && [[ "$line" == *"healthy"* ]]; then
            echo -e "${GREEN}●${RESET} $line"
        elif [[ "$line" == *"Up"* ]]; then
            echo -e "${GREEN}○${RESET} $line"
        elif [[ "$line" == *"NAMES"* ]]; then
            echo -e "${DIM}$line${RESET}"
        else
            echo -e "${YELLOW}○${RESET} $line"
        fi
    done
    
    echo ""
    echo -e "${CYAN}${BOLD}Resources:${RESET}"
    docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}" 2>/dev/null | while IFS= read -r line; do
        if [[ "$line" == *"NAME"* ]]; then
            echo -e "${DIM}$line${RESET}"
        else
            echo "  $line"
        fi
    done
    
    echo ""
    echo -e "${DIM}Updated: $(date '+%H:%M:%S') | Refresh: 5s | Ctrl+C to exit${RESET}"
    
    sleep 5
done
