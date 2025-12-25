#!/bin/bash

# ═══════════════════════════════════════════════════════════════
# AI-Framework Interactive Setup
# Uses gum for beautiful CLI prompts
# ═══════════════════════════════════════════════════════════════

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRAMEWORK_DIR="$(dirname "$SCRIPT_DIR")"
PROJECT_ROOT="$(dirname "$FRAMEWORK_DIR")"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
DIM='\033[2m'
NC='\033[0m'

# ═══════════════════════════════════════════════════════════════
# Check gum
# ═══════════════════════════════════════════════════════════════

if ! command -v gum &> /dev/null; then
    echo -e "${YELLOW}⚠️  gum not found${NC}"
    echo -e "${DIM}Install with: brew install gum${NC}"
    echo ""
    echo "Falling back to basic setup..."
    exec "$SCRIPT_DIR/install.sh"
fi

# ═══════════════════════════════════════════════════════════════
# Header
# ═══════════════════════════════════════════════════════════════

clear
gum style \
    --foreground 212 --border-foreground 212 --border double \
    --align center --width 50 --margin "1 2" --padding "1 2" \
    '🧠 AI-Framework Setup' '' 'Interactive Project Configuration'

# ═══════════════════════════════════════════════════════════════
# Project Name
# ═══════════════════════════════════════════════════════════════

echo ""
gum style --foreground 212 "📦 Project Configuration"
echo ""

PROJECT_NAME=$(gum input --placeholder "Project name (lowercase, e.g. mybot)" --value "mybot")
if [ -z "$PROJECT_NAME" ]; then
    echo "❌ Project name is required"
    exit 1
fi

echo -e "   ${GREEN}✓${NC} Project: $PROJECT_NAME"

# ═══════════════════════════════════════════════════════════════
# Backend Selection
# ═══════════════════════════════════════════════════════════════

echo ""
gum style --foreground 212 "⚙️  Backend"
echo ""

BACKEND=$(gum choose --cursor="→ " --cursor.foreground="212" \
    "go (Telegram Bot + API)" \
    "none (Frontend only)")

BACKEND_TYPE=$(echo "$BACKEND" | cut -d' ' -f1)
echo -e "   ${GREEN}✓${NC} Backend: $BACKEND_TYPE"

# ═══════════════════════════════════════════════════════════════
# Frontend Selection
# ═══════════════════════════════════════════════════════════════

echo ""
gum style --foreground 212 "🎨 Frontend"
echo ""

FRONTEND=$(gum choose --cursor="→ " --cursor.foreground="212" \
    "nuxt (Vue 3 + Nuxt 4)" \
    "react (React + Vite)" \
    "none (API only)")

FRONTEND_TYPE=$(echo "$FRONTEND" | cut -d' ' -f1)
echo -e "   ${GREEN}✓${NC} Frontend: $FRONTEND_TYPE"

# ═══════════════════════════════════════════════════════════════
# UI Library Selection (if frontend selected)
# ═══════════════════════════════════════════════════════════════

UI_LIBS=""
if [ "$FRONTEND_TYPE" != "none" ]; then
    echo ""
    gum style --foreground 212 "🎯 UI Libraries (Space to select, Enter to confirm)"
    echo ""
    
    UI_LIBS=$(gum choose --no-limit --cursor="→ " --cursor.foreground="212" \
        "konsta-ui (iOS/Android native look)" \
        "nuxt-ui (Tailwind-based, full kit)" \
        "shadcn-vue (Radix-based, customizable)" \
        "primevue-unstyled (80+ headless components)" \
        "radix-vue (Primitives, accessibility-first)" \
        "headless-ui (Tailwind Labs, minimal)" \
        "none")
    
    if [ -n "$UI_LIBS" ] && [ "$UI_LIBS" != "none" ]; then
        echo -e "   ${GREEN}✓${NC} UI: $(echo "$UI_LIBS" | tr '\n' ', ' | sed 's/,$//')"
    else
        echo -e "   ${DIM}No UI libraries selected${NC}"
    fi
fi

# ═══════════════════════════════════════════════════════════════
# Database Selection
# ═══════════════════════════════════════════════════════════════

echo ""
gum style --foreground 212 "🗄️  Database"
echo ""

DATABASE=$(gum choose --cursor="→ " --cursor.foreground="212" \
    "postgres (PostgreSQL + pgvector)" \
    "sqlite (Local SQLite)" \
    "none (No database)")

DATABASE_TYPE=$(echo "$DATABASE" | cut -d' ' -f1)
echo -e "   ${GREEN}✓${NC} Database: $DATABASE_TYPE"

# ═══════════════════════════════════════════════════════════════
# Summary & Confirmation
# ═══════════════════════════════════════════════════════════════

echo ""
gum style --foreground 212 --border normal --padding "1 2" \
    "📋 Configuration Summary" \
    "" \
    "Project:  $PROJECT_NAME" \
    "Backend:  $BACKEND_TYPE" \
    "Frontend: $FRONTEND_TYPE" \
    "Database: $DATABASE_TYPE"

echo ""
if ! gum confirm "Proceed with setup?"; then
    echo "Setup cancelled."
    exit 0
fi

# ═══════════════════════════════════════════════════════════════
# Run Base Setup
# ═══════════════════════════════════════════════════════════════

echo ""
gum spin --spinner dot --title "Running base setup..." -- "$SCRIPT_DIR/install.sh"

# ═══════════════════════════════════════════════════════════════
# Update .env with PROJECT_NAME
# ═══════════════════════════════════════════════════════════════

if [ -f "$PROJECT_ROOT/.env.example" ] && [ ! -f "$PROJECT_ROOT/.env" ]; then
    sed "s/PROJECT_NAME=mybot/PROJECT_NAME=$PROJECT_NAME/g" "$PROJECT_ROOT/.env.example" > "$PROJECT_ROOT/.env"
    echo -e "${GREEN}✓${NC} Created .env with PROJECT_NAME=$PROJECT_NAME"
fi

# ═══════════════════════════════════════════════════════════════
# Update CONFIG.yaml
# ═══════════════════════════════════════════════════════════════

if [ -f "$PROJECT_ROOT/project/CONFIG.yaml" ]; then
    sed -i '' "s/name: \"new-bot\"/name: \"$PROJECT_NAME\"/g" "$PROJECT_ROOT/project/CONFIG.yaml" 2>/dev/null || \
    sed -i "s/name: \"new-bot\"/name: \"$PROJECT_NAME\"/g" "$PROJECT_ROOT/project/CONFIG.yaml"
    
    sed -i '' "s/backend: \"go\"/backend: \"$BACKEND_TYPE\"/g" "$PROJECT_ROOT/project/CONFIG.yaml" 2>/dev/null || \
    sed -i "s/backend: \"go\"/backend: \"$BACKEND_TYPE\"/g" "$PROJECT_ROOT/project/CONFIG.yaml"
    
    sed -i '' "s/frontend: \"nuxt\"/frontend: \"$FRONTEND_TYPE\"/g" "$PROJECT_ROOT/project/CONFIG.yaml" 2>/dev/null || \
    sed -i "s/frontend: \"nuxt\"/frontend: \"$FRONTEND_TYPE\"/g" "$PROJECT_ROOT/project/CONFIG.yaml"
    
    echo -e "${GREEN}✓${NC} Updated project/CONFIG.yaml"
fi

# ═══════════════════════════════════════════════════════════════
# Success
# ═══════════════════════════════════════════════════════════════

echo ""
gum style \
    --foreground 46 --border-foreground 46 --border double \
    --align center --width 50 --margin "1 2" --padding "1 2" \
    '✅ Setup Complete!' '' \
    "Project: $PROJECT_NAME" \
    '' \
    'Next steps:' \
    '1. Edit .env with your tokens' \
    '2. make db (start database)' \
    '3. make dev-full (start dev)'
