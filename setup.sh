#!/bin/bash

# AI-Framework Setup Script
# Запускай из папки ai-framework: ./setup.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "🧠 AI-Framework Setup"
echo "====================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 1. Copy templates to project/
echo -e "${YELLOW}📋 Копирую шаблоны в project/...${NC}"

copy_if_not_exists() {
    local src="$1"
    local dest="$2"
    if [ ! -f "$dest" ]; then
        cp "$src" "$dest"
        echo -e "   ${GREEN}✓${NC} Создан: $(basename $dest)"
    else
        echo "   ⏭️  Пропущен (уже существует): $(basename $dest)"
    fi
}

# Project files
copy_if_not_exists "$SCRIPT_DIR/templates/CONFIG.template.yaml" "$SCRIPT_DIR/project/CONFIG.yaml"
copy_if_not_exists "$SCRIPT_DIR/templates/CONTEXT.template.md" "$SCRIPT_DIR/project/CONTEXT.md"
copy_if_not_exists "$SCRIPT_DIR/templates/BACKLOG.template.md" "$SCRIPT_DIR/project/BACKLOG.md"
copy_if_not_exists "$SCRIPT_DIR/templates/DECISIONS.template.md" "$SCRIPT_DIR/project/DECISIONS.md"
copy_if_not_exists "$SCRIPT_DIR/templates/PROMPTS.template.md" "$SCRIPT_DIR/project/PROMPTS.md"
copy_if_not_exists "$SCRIPT_DIR/templates/CHANGELOG.template.md" "$SCRIPT_DIR/project/CHANGELOG.md"

echo ""

# 2. Copy Makefile to project root
echo -e "${YELLOW}⚙️  Копирую Makefile в корень проекта...${NC}"
copy_if_not_exists "$SCRIPT_DIR/templates/Makefile.template" "$PROJECT_ROOT/Makefile"

# 3. Copy .env.example
echo -e "${YELLOW}🔐 Копирую .env.example...${NC}"
copy_if_not_exists "$SCRIPT_DIR/templates/.env.example" "$PROJECT_ROOT/.env.example"

# 4. Copy .gitignore additions
if [ -f "$PROJECT_ROOT/.gitignore" ]; then
    if ! grep -q "# AI-Framework" "$PROJECT_ROOT/.gitignore"; then
        echo "" >> "$PROJECT_ROOT/.gitignore"
        cat "$SCRIPT_DIR/templates/.gitignore.append" >> "$PROJECT_ROOT/.gitignore"
        echo -e "   ${GREEN}✓${NC} Добавлены записи в .gitignore"
    fi
else
    cp "$SCRIPT_DIR/templates/.gitignore.append" "$PROJECT_ROOT/.gitignore"
    echo -e "   ${GREEN}✓${NC} Создан .gitignore"
fi

echo ""

# 5. Create .cursorrules for AI IDEs (Cursor, Windsurf, etc.)
echo -e "${YELLOW}🤖 Создаю конфиги для AI IDE...${NC}"
mkdir -p "$PROJECT_ROOT/.cursorrules"
mkdir -p "$PROJECT_ROOT/.github"
copy_if_not_exists "$SCRIPT_DIR/templates/cursorrules.template.md" "$PROJECT_ROOT/.cursorrules/cursor-rules.md"
copy_if_not_exists "$SCRIPT_DIR/templates/copilot-instructions.template.md" "$PROJECT_ROOT/.github/copilot-instructions.md"

echo ""
echo -e "${GREEN}✅ Setup завершён!${NC}"
echo ""
echo "Следующие шаги:"
echo "  1. Отредактируй ai-framework/project/CONFIG.yaml"
echo "  2. Отредактируй ai-framework/project/CONTEXT.md"
echo "  3. Создай .env из .env.example"
echo "  4. Запусти: make dev"
echo ""
