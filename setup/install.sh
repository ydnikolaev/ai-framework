#!/bin/bash

# AI-Framework Setup Script
# Запускай из папки ai-framework/setup: ./setup.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRAMEWORK_DIR="$(dirname "$SCRIPT_DIR")"
PROJECT_ROOT="$(dirname "$FRAMEWORK_DIR")"

echo "🧠 AI-Framework Setup"
echo "====================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 1. Copy templates to project/
echo -e "${YELLOW}📋 Копирую шаблоны в project/...${NC}"

# Create directory structure
mkdir -p "$PROJECT_ROOT/project"
mkdir -p "$PROJECT_ROOT/project/assets/animations"
mkdir -p "$PROJECT_ROOT/project/assets/design"
mkdir -p "$PROJECT_ROOT/project/assets/images"
mkdir -p "$PROJECT_ROOT/project/testing"
mkdir -p "$PROJECT_ROOT/project/audits/security"
mkdir -p "$PROJECT_ROOT/project/audits/seo"
mkdir -p "$PROJECT_ROOT/project/audits/performance"

copy_if_not_exists() {
    local src="$1"
    local dest="$2"
    if [ ! -f "$dest" ]; then
        cp "$src" "$dest"
        echo -e "   ${GREEN}✓${NC} Создан: project/$(basename $dest)"
    else
        echo "   ⏭️  Пропущен (уже существует): project/$(basename $dest)"
    fi
}

# Project files
copy_if_not_exists "$FRAMEWORK_DIR/templates/project/CONFIG.yaml.template" "$PROJECT_ROOT/project/CONFIG.yaml"
copy_if_not_exists "$FRAMEWORK_DIR/templates/project/CONTEXT.md.template" "$PROJECT_ROOT/project/CONTEXT.md"
copy_if_not_exists "$FRAMEWORK_DIR/templates/project/BACKLOG.md.template" "$PROJECT_ROOT/project/BACKLOG.md"
copy_if_not_exists "$FRAMEWORK_DIR/templates/project/DECISIONS.md.template" "$PROJECT_ROOT/project/DECISIONS.md"
copy_if_not_exists "$FRAMEWORK_DIR/templates/project/PROMPTS.md.template" "$PROJECT_ROOT/project/PROMPTS.md"
copy_if_not_exists "$FRAMEWORK_DIR/templates/project/CHANGELOG.md.template" "$PROJECT_ROOT/project/CHANGELOG.md"
copy_if_not_exists "$FRAMEWORK_DIR/templates/project/NOTES.md.template" "$PROJECT_ROOT/project/NOTES.md"
copy_if_not_exists "$FRAMEWORK_DIR/templates/project/ARCHITECTURE.md.template" "$PROJECT_ROOT/project/ARCHITECTURE.md"

# 1.1 Create Subdirectories
mkdir -p "$PROJECT_ROOT/project/features"
mkdir -p "$PROJECT_ROOT/project/seeds"
mkdir -p "$PROJECT_ROOT/project/archive"

copy_if_not_exists "$FRAMEWORK_DIR/templates/project/features/_INDEX_FEATURES_PROJECT.md.template" "$PROJECT_ROOT/project/features/_INDEX_FEATURES_PROJECT.md"
copy_if_not_exists "$FRAMEWORK_DIR/templates/project/seeds/_INDEX_SEEDS_PROJECT.md.template" "$PROJECT_ROOT/project/seeds/_INDEX_SEEDS_PROJECT.md"
copy_if_not_exists "$FRAMEWORK_DIR/templates/project/archive/_INDEX_ARCHIVE_PROJECT.md.template" "$PROJECT_ROOT/project/archive/_INDEX_ARCHIVE_PROJECT.md"
copy_if_not_exists "$FRAMEWORK_DIR/templates/project/testing/_INDEX_TESTING_PROJECT.md.template" "$PROJECT_ROOT/project/testing/_INDEX_TESTING_PROJECT.md"
copy_if_not_exists "$FRAMEWORK_DIR/templates/project/assets/_INDEX_ASSETS_PROJECT.md.template" "$PROJECT_ROOT/project/assets/_INDEX_ASSETS_PROJECT.md"
copy_if_not_exists "$FRAMEWORK_DIR/templates/project/audits/_INDEX_AUDITS_PROJECT.md.template" "$PROJECT_ROOT/project/audits/_INDEX_AUDITS_PROJECT.md"

# 1.2 Create v2.0 Context Directories (Process & Memory)
mkdir -p "$PROJECT_ROOT/project/memory"
mkdir -p "$PROJECT_ROOT/project/knowledge"
mkdir -p "$PROJECT_ROOT/project/status/reports"

# Memory
copy_if_not_exists "$FRAMEWORK_DIR/templates/project/memory/scratchpad.md" "$PROJECT_ROOT/project/memory/scratchpad.md"

# Knowledge
copy_if_not_exists "$FRAMEWORK_DIR/templates/project/knowledge/_INDEX_KNOWLEDGE_PROJECT.md" "$PROJECT_ROOT/project/knowledge/_INDEX_KNOWLEDGE_PROJECT.md"
copy_if_not_exists "$FRAMEWORK_DIR/templates/project/knowledge/business-rules.md" "$PROJECT_ROOT/project/knowledge/business-rules.md"
copy_if_not_exists "$FRAMEWORK_DIR/templates/project/knowledge/user-glossary.md" "$PROJECT_ROOT/project/knowledge/user-glossary.md"

# Status
copy_if_not_exists "$FRAMEWORK_DIR/templates/project/status/_INDEX_STATUS_PROJECT.md" "$PROJECT_ROOT/project/status/_INDEX_STATUS_PROJECT.md"
copy_if_not_exists "$FRAMEWORK_DIR/templates/project/status/roadmap.md" "$PROJECT_ROOT/project/status/roadmap.md"
copy_if_not_exists "$FRAMEWORK_DIR/templates/project/status/reports/_INDEX_REPORTS_PROJECT.md" "$PROJECT_ROOT/project/status/reports/_INDEX_REPORTS_PROJECT.md"

echo ""

# 2. Copy Makefile to project root
echo -e "${YELLOW}⚙️  Копирую Makefile в корень проекта...${NC}"
copy_if_not_exists "$FRAMEWORK_DIR/templates/Makefile.template" "$PROJECT_ROOT/Makefile"

# 3. Copy .env.example
echo -e "${YELLOW}🔐 Копирую .env.example...${NC}"
copy_if_not_exists "$FRAMEWORK_DIR/templates/.env.example" "$PROJECT_ROOT/.env.example"

# 3.1 Copy Docker Compose templates
echo -e "${YELLOW}🐳 Копирую Docker templates...${NC}"
copy_if_not_exists "$FRAMEWORK_DIR/templates/docker-compose.template.yml" "$PROJECT_ROOT/docker-compose.yml"
copy_if_not_exists "$FRAMEWORK_DIR/templates/docker-compose.prod.template.yml" "$PROJECT_ROOT/docker-compose.prod.yml"

# 4. Copy .gitignore additions
if [ -f "$PROJECT_ROOT/.gitignore" ]; then
    if ! grep -q "# AI-Framework" "$PROJECT_ROOT/.gitignore"; then
        echo "" >> "$PROJECT_ROOT/.gitignore"
        cat "$FRAMEWORK_DIR/templates/.gitignore.append" >> "$PROJECT_ROOT/.gitignore"
        echo -e "   ${GREEN}✓${NC} Добавлены записи в .gitignore"
    fi
else
    cp "$FRAMEWORK_DIR/templates/.gitignore.append" "$PROJECT_ROOT/.gitignore"
    echo -e "   ${GREEN}✓${NC} Создан .gitignore"
fi

echo ""

# 5. Create .cursorrules for AI IDEs (Cursor, Windsurf, etc.)
echo -e "${YELLOW}🤖 Создаю конфиги для AI IDE...${NC}"
mkdir -p "$PROJECT_ROOT/.cursorrules"
mkdir -p "$PROJECT_ROOT/.github"
copy_if_not_exists "$FRAMEWORK_DIR/templates/cursorrules.template.md" "$PROJECT_ROOT/.cursorrules/cursor-rules.md"
copy_if_not_exists "$FRAMEWORK_DIR/templates/copilot-instructions.template.md" "$PROJECT_ROOT/.github/copilot-instructions.md"

# 5.1 Create .editorconfig
echo -e "${YELLOW}📐 Копирую .editorconfig...${NC}"
copy_if_not_exists "$FRAMEWORK_DIR/templates/.editorconfig" "$PROJECT_ROOT/.editorconfig"

# 5.2 Create .vscode settings
echo -e "${YELLOW}🔧 Копирую .vscode settings...${NC}"
mkdir -p "$PROJECT_ROOT/.vscode"
copy_if_not_exists "$FRAMEWORK_DIR/templates/vscode/extensions.json" "$PROJECT_ROOT/.vscode/extensions.json"
copy_if_not_exists "$FRAMEWORK_DIR/templates/vscode/settings.json" "$PROJECT_ROOT/.vscode/settings.json"

echo ""

# 6. Copy DX utilities for Go projects (if backend exists)
if [ -d "$PROJECT_ROOT/backend" ]; then
    echo -e "${YELLOW}🎨 Копирую DX утилиты для Go...${NC}"
    
    # Create pkg/dxlog directory
    mkdir -p "$PROJECT_ROOT/backend/pkg/dxlog"
    
    if [ ! -f "$PROJECT_ROOT/backend/pkg/dxlog/dxlog.go" ]; then
        if [ -f "$FRAMEWORK_DIR/templates/go/dxlog/dxlog.go" ]; then
            cp "$FRAMEWORK_DIR/templates/go/dxlog/dxlog.go" "$PROJECT_ROOT/backend/pkg/dxlog/"
            echo -e "   ${GREEN}✓${NC} Создан: backend/pkg/dxlog/dxlog.go"
        fi
    else
        echo "   ⏭️  Пропущен (уже существует): dxlog.go"
    fi
    echo ""
fi

# 7. Copy Makefile DX include
echo -e "${YELLOW}⚙️  Копирую Makefile DX утилиты...${NC}"
mkdir -p "$PROJECT_ROOT/.make"
if [ ! -f "$PROJECT_ROOT/.make/dx.mk" ]; then
    if [ -f "$FRAMEWORK_DIR/templates/make/dx.mk" ]; then
        cp "$FRAMEWORK_DIR/templates/make/dx.mk" "$PROJECT_ROOT/.make/"
        echo -e "   ${GREEN}✓${NC} Создан: .make/dx.mk"
        echo -e "   ${YELLOW}💡${NC} Добавь в Makefile: include .make/dx.mk"
    fi
else
    echo "   ⏭️  Пропущен (уже существует): dx.mk"
fi

echo ""
echo -e "${GREEN}✅ Setup завершён!${NC}"
echo ""
echo "Следующие шаги:"
echo "  1. Отредактируй project/CONFIG.yaml"
echo "  2. Отредактируй project/CONTEXT.md"
echo "  3. Создай .env из .env.example"
echo "  4. Запусти: make dev"
echo ""

# 8. Copy DX scripts
echo -e "${YELLOW}📜 Копирую DX скрипты...${NC}"
mkdir -p "$PROJECT_ROOT/scripts"

copy_script() {
    local name="$1"
    local src="$FRAMEWORK_DIR/templates/shell/$name"
    local dest="$PROJECT_ROOT/scripts/$name"
    if [ ! -f "$dest" ] && [ -f "$src" ]; then
        cp "$src" "$dest"
        chmod +x "$dest"
        echo -e "   ${GREEN}✓${NC} Создан: scripts/$name"
    fi
}

# Copy all DX scripts if templates exist
for script in dx-logs.sh dx-prod-status.sh dx-db-logs.sh dx-status.sh; do
    copy_script "$script"
done

# Copy Python iTerm2 scripts and setup utilities
for script in dev-full.py dev-iterm.py prod-watch.py make-help.py deploy-watch.sh set-webhook.sh dev-restart.py dev-stop.py dx-confirm.py dx-confirm-sync.py add-dev-routes.sh setup-ssh.sh setup-repo.sh; do
    copy_script "$script"
done

echo ""
echo -e "${GREEN}✅ Setup завершён!${NC}"
echo ""
echo "Доступные команды:"
echo "  make dev       — Базовая разработка (2x2 grid)"
echo "  make dev-full  — Полная разработка (Local + Prod tabs)"
echo "  make prod-watch — Мониторинг прода"
echo ""
