#!/bin/bash

# ═══════════════════════════════════════════════════════════════
# AI-Framework Setup
# Unified entry point - auto-detects gum for interactive mode
# ═══════════════════════════════════════════════════════════════

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🧠 AI-Framework Setup"
echo "====================="
echo ""

# Check if gum is available for interactive mode
if command -v gum &> /dev/null; then
    echo "✨ Interactive mode (gum detected)"
    exec "$SCRIPT_DIR/install-interactive.sh" "$@"
else
    echo "📋 Basic mode (install gum for interactive: brew install gum)"
    exec "$SCRIPT_DIR/install.sh" "$@"
fi
