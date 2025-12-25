#!/bin/bash

# ═══════════════════════════════════════════════════════════════
# New Project Setup — One Command to Rule Them All
# Creates a complete new project with ai-framework
#
# Usage: ./new-project.sh [project-name]
# ═══════════════════════════════════════════════════════════════

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
DIM='\033[2m'
NC='\033[0m'

# AI-Framework submodule URL
AI_FRAMEWORK_URL="git@github.com:ydnikolaev/ai-framework.git"

echo -e "${CYAN}"
echo "═══════════════════════════════════════════════════════════════"
echo "  🚀 New Project Setup"
echo "═══════════════════════════════════════════════════════════════"
echo -e "${NC}"

# ═══════════════════════════════════════════════════════════════
# Check prerequisites
# ═══════════════════════════════════════════════════════════════

echo -e "${CYAN}🔍 Checking prerequisites...${NC}"

# Check gh CLI
if ! command -v gh &> /dev/null; then
    echo -e "${RED}❌ GitHub CLI not installed${NC}"
    echo "   Install with: brew install gh"
    exit 1
fi
echo -e "   ${GREEN}✓${NC} gh CLI installed"

# Check gh auth
if ! gh auth status &> /dev/null; then
    echo -e "${RED}❌ GitHub CLI not authenticated${NC}"
    echo "   Run: gh auth login"
    exit 1
fi
echo -e "   ${GREEN}✓${NC} gh authenticated"

# Get GitHub username
GH_USER=$(gh api user -q .login)
echo -e "   ${GREEN}✓${NC} GitHub user: ${GH_USER}"

echo ""

# ═══════════════════════════════════════════════════════════════
# Get project name
# ═══════════════════════════════════════════════════════════════

PROJECT_NAME="$1"

if [ -z "$PROJECT_NAME" ]; then
    read -p "Project name (lowercase): " PROJECT_NAME
fi

if [ -z "$PROJECT_NAME" ]; then
    echo -e "${RED}❌ Project name required${NC}"
    exit 1
fi

# Validate project name
if [[ ! "$PROJECT_NAME" =~ ^[a-z][a-z0-9-]*$ ]]; then
    echo -e "${RED}❌ Invalid project name${NC}"
    echo "   Must be lowercase, start with letter, only a-z, 0-9, and -"
    exit 1
fi

echo -e "${CYAN}📦 Creating project: ${GREEN}${PROJECT_NAME}${NC}"
echo ""

# ═══════════════════════════════════════════════════════════════
# Get parent directory
# ═══════════════════════════════════════════════════════════════

PARENT_DIR=$(pwd)
PROJECT_DIR="${PARENT_DIR}/${PROJECT_NAME}"

if [ -d "$PROJECT_DIR" ]; then
    echo -e "${RED}❌ Directory already exists: ${PROJECT_DIR}${NC}"
    exit 1
fi

# ═══════════════════════════════════════════════════════════════
# Create project
# ═══════════════════════════════════════════════════════════════

echo -e "${CYAN}📁 Step 1/5: Creating directory...${NC}"
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"
git init
echo -e "${GREEN}✓${NC} Git initialized"

echo ""
echo -e "${CYAN}📦 Step 2/5: Adding ai-framework submodule...${NC}"
git submodule add "$AI_FRAMEWORK_URL" ai-framework
echo -e "${GREEN}✓${NC} Submodule added"

echo ""
echo -e "${CYAN}⚙️  Step 3/5: Running setup.sh...${NC}"
cd ai-framework && ./setup.sh && cd ..
echo -e "${GREEN}✓${NC} Setup complete"

echo ""
echo -e "${CYAN}🔐 Step 4/5: Setting up SSH keys...${NC}"
./scripts/setup-ssh.sh
echo -e "${GREEN}✓${NC} SSH configured"

echo ""
echo -e "${CYAN}🔗 Step 5/5: Creating GitHub repository...${NC}"
./scripts/setup-repo.sh
echo -e "${GREEN}✓${NC} Repository created"

# ═══════════════════════════════════════════════════════════════
# Summary
# ═══════════════════════════════════════════════════════════════

echo ""
echo -e "${GREEN}"
echo "═══════════════════════════════════════════════════════════════"
echo "  ✅ Project ${PROJECT_NAME} created successfully!"
echo "═══════════════════════════════════════════════════════════════"
echo -e "${NC}"
echo ""
echo "Created:"
echo "  • Directory: ${PROJECT_DIR}"
echo "  • Repository: https://github.com/${GH_USER}/${PROJECT_NAME}"
echo "  • SSH alias: github-${PROJECT_NAME}"
echo ""
echo "Next steps:"
echo "  cd ${PROJECT_NAME}"
echo "  # Edit .env with your tokens"
echo "  make dev-full"
echo ""
