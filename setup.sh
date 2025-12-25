#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# AI-Framework Setup Entry Point
# Run from ai-framework directory: ./setup.sh
# ═══════════════════════════════════════════════════════════════

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SCRIPT_DIR/setup/setup.sh" "$@"
