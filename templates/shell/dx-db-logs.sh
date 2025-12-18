#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# Pretty Docker Logs Viewer
# Shows formatted logs for postgres and redis
# ═══════════════════════════════════════════════════════════════

# Colors
CYAN='\033[36m'
MAGENTA='\033[35m'
DIM='\033[2m'
RESET='\033[0m'
BOLD='\033[1m'

clear

echo -e "${MAGENTA}${BOLD}═══════════════════════════════════════${RESET}"
echo -e "${MAGENTA}${BOLD}  📊 Database Logs${RESET}"
echo -e "${MAGENTA}${BOLD}═══════════════════════════════════════${RESET}"
echo ""
echo -e "${CYAN}→${RESET} PostgreSQL + Redis logs"
echo -e "${DIM}  Press Ctrl+C to exit${RESET}"
echo ""

docker compose logs -f --tail 30 postgres redis 2>/dev/null | while IFS= read -r line; do
    # Color postgres lines
    if [[ "$line" == *"postgres"* ]]; then
        echo -e "${CYAN}[PG]${RESET} $line"
    # Color redis lines  
    elif [[ "$line" == *"redis"* ]]; then
        echo -e "${MAGENTA}[RD]${RESET} $line"
    else
        echo "$line"
    fi
done
