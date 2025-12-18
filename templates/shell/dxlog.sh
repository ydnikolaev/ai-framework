#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# DX Shell Utilities - Beautiful terminal output for Makefiles
# ═══════════════════════════════════════════════════════════════
# Usage: source this file in your Makefile or scripts
#   include ai-framework/templates/shell/dxlog.sh
#   $(call dx_header, "Building...")

# Colors
export COLOR_RESET='\033[0m'
export COLOR_RED='\033[31m'
export COLOR_GREEN='\033[32m'
export COLOR_YELLOW='\033[33m'
export COLOR_BLUE='\033[34m'
export COLOR_PURPLE='\033[35m'
export COLOR_CYAN='\033[36m'
export COLOR_GRAY='\033[90m'
export COLOR_BOLD='\033[1m'

# Print separator line
dx_separator() {
    echo -e "${COLOR_CYAN}════════════════════════════════════════════════════════════${COLOR_RESET}"
}

# Print header with emoji
dx_header() {
    local emoji="${1:-🔧}"
    local text="$2"
    echo ""
    dx_separator
    echo -e "${COLOR_BOLD}${emoji} ${text}${COLOR_RESET}"
}

# Print success message
dx_success() {
    echo -e "${COLOR_GREEN}✅ $1${COLOR_RESET}"
}

# Print error message
dx_error() {
    echo -e "${COLOR_RED}❌ $1${COLOR_RESET}"
}

# Print warning message
dx_warn() {
    echo -e "${COLOR_YELLOW}⚠️  $1${COLOR_RESET}"
}

# Print info message
dx_info() {
    echo -e "${COLOR_BLUE}ℹ️  $1${COLOR_RESET}"
}

# Print step in a process
dx_step() {
    local current="$1"
    local total="$2"
    local msg="$3"
    echo -e "${COLOR_GRAY}▸ [${current}/${total}]${COLOR_RESET} ${msg}"
}

# Print box around text
dx_box() {
    local text="$1"
    local len=${#text}
    local border=$(printf '═%.0s' $(seq 1 $((len + 4))))
    echo ""
    echo -e "${COLOR_CYAN}╔${border}╗${COLOR_RESET}"
    echo -e "${COLOR_CYAN}║${COLOR_RESET}  ${COLOR_BOLD}${text}${COLOR_RESET}  ${COLOR_CYAN}║${COLOR_RESET}"
    echo -e "${COLOR_CYAN}╚${border}╝${COLOR_RESET}"
    echo ""
}

# Section separator (smaller)
dx_section() {
    echo -e "${COLOR_GRAY}────────────────────────────── $1${COLOR_RESET}"
}

# Timer start (stores start time in variable)
dx_timer_start() {
    export DX_TIMER_START=$(date +%s)
}

# Timer end (prints elapsed time)
dx_timer_end() {
    local label="${1:-Elapsed}"
    local end=$(date +%s)
    local elapsed=$((end - DX_TIMER_START))
    echo -e "${COLOR_GRAY}⏱️  ${label}: ${elapsed}s${COLOR_RESET}"
}
