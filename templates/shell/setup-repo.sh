#!/bin/bash

# ═══════════════════════════════════════════════════════════════
# GitHub Repository Setup
# Creates repo on GitHub and pushes initial commit
# Requires: gh CLI authenticated
# ═══════════════════════════════════════════════════════════════

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
DIM='\033[2m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Load .env if exists
if [ -f "$PROJECT_ROOT/.env" ]; then
    source "$PROJECT_ROOT/.env"
fi

echo -e "${CYAN}🔗 GitHub Repository Setup${NC}"
echo ""

# ═══════════════════════════════════════════════════════════════
# Check prerequisites
# ═══════════════════════════════════════════════════════════════

# Check git
if [ ! -d "$PROJECT_ROOT/.git" ]; then
    echo -e "${RED}❌ Not a git repository${NC}"
    echo "   Run 'git init' first"
    exit 1
fi

# Check gh CLI
if ! command -v gh &> /dev/null; then
    echo -e "${RED}❌ GitHub CLI not installed${NC}"
    echo "   Install with: brew install gh"
    exit 1
fi

# Check gh auth
if ! gh auth status &> /dev/null; then
    echo -e "${RED}❌ GitHub CLI not authenticated${NC}"
    echo "   Run: gh auth login"
    exit 1
fi

# Get GitHub username
GH_USER=$(gh api user -q .login)
echo -e "   GitHub user: ${GREEN}${GH_USER}${NC}"

# ═══════════════════════════════════════════════════════════════
# Get project/repo name
# ═══════════════════════════════════════════════════════════════

if [ -z "$PROJECT_NAME" ]; then
    # Try to get from folder name
    PROJECT_NAME=$(basename "$PROJECT_ROOT")
fi

read -p "Repository name [$PROJECT_NAME]: " REPO_NAME
REPO_NAME=${REPO_NAME:-$PROJECT_NAME}

echo -e "   Repository: ${GREEN}${GH_USER}/${REPO_NAME}${NC}"
echo ""

# ═══════════════════════════════════════════════════════════════
# Check if repo exists
# ═══════════════════════════════════════════════════════════════

REPO_EXISTS=$(gh repo view "${GH_USER}/${REPO_NAME}" --json name -q .name 2>/dev/null || echo "")

if [ -n "$REPO_EXISTS" ]; then
    echo -e "${YELLOW}⚠️  Repository already exists: ${GH_USER}/${REPO_NAME}${NC}"
    read -p "   Use existing repository? (Y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        echo "Cancelled."
        exit 0
    fi
    CREATE_REPO=false
else
    echo -e "${CYAN}📦 Repository will be created: ${GH_USER}/${REPO_NAME}${NC}"
    
    # Ask for visibility
    echo ""
    read -p "Make repository private? (Y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        VISIBILITY="--public"
    else
        VISIBILITY="--private"
    fi
    CREATE_REPO=true
fi

# ═══════════════════════════════════════════════════════════════
# Initial commit (if needed)
# ═══════════════════════════════════════════════════════════════

cd "$PROJECT_ROOT"

# Check if there are uncommitted changes
if [ -n "$(git status --porcelain)" ]; then
    echo ""
    echo -e "${CYAN}📝 Creating initial commit...${NC}"
    git add -A
    git commit -m "Initial commit with ai-framework"
    echo -e "${GREEN}✓${NC} Initial commit created"
fi

# ═══════════════════════════════════════════════════════════════
# Create repo and push
# ═══════════════════════════════════════════════════════════════

# Check if remote already exists
REMOTE_EXISTS=$(git remote get-url origin 2>/dev/null || echo "")

if [ -z "$REMOTE_EXISTS" ]; then
    if [ "$CREATE_REPO" = true ]; then
        echo ""
        echo -e "${CYAN}🚀 Creating repository on GitHub...${NC}"
        gh repo create "${REPO_NAME}" $VISIBILITY --source=. --remote=origin --push
        echo -e "${GREEN}✓${NC} Repository created and pushed!"
    else
        # Repo exists, just add remote
        echo ""
        echo -e "${CYAN}🔗 Adding remote...${NC}"
        
        # Use SSH alias if configured
        if grep -q "Host github-${PROJECT_NAME}" ~/.ssh/config 2>/dev/null; then
            git remote add origin "git@github-${PROJECT_NAME}:${GH_USER}/${REPO_NAME}.git"
            echo -e "${DIM}   Using SSH alias: github-${PROJECT_NAME}${NC}"
        else
            git remote add origin "git@github.com:${GH_USER}/${REPO_NAME}.git"
        fi
        
        git branch -M main
        git push -u origin main
        echo -e "${GREEN}✓${NC} Pushed to existing repository!"
    fi
else
    echo ""
    echo -e "${YELLOW}⚠️  Remote 'origin' already configured${NC}"
    echo -e "${DIM}   $(git remote get-url origin)${NC}"
    
    read -p "   Push to this remote? (Y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        git push -u origin main
        echo -e "${GREEN}✓${NC} Pushed!"
    fi
fi

# ═══════════════════════════════════════════════════════════════
# Summary
# ═══════════════════════════════════════════════════════════════

echo ""
echo -e "${GREEN}✅ Repository setup complete!${NC}"
echo ""
echo "Repository: https://github.com/${GH_USER}/${REPO_NAME}"
echo ""
echo "Next steps:"
echo "  1. Configure .env with tokens and server info"
echo "  2. make dev-full (start development)"
