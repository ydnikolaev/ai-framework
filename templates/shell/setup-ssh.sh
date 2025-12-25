#!/bin/bash

# ═══════════════════════════════════════════════════════════════
# SSH Setup for Project
# Generates named SSH key and configures ~/.ssh/config
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

# Try to load PROJECT_NAME from .env
if [ -f "$PROJECT_ROOT/.env" ]; then
    source "$PROJECT_ROOT/.env"
fi

echo -e "${CYAN}🔐 SSH Setup${NC}"
echo ""

# ═══════════════════════════════════════════════════════════════
# Get project name
# ═══════════════════════════════════════════════════════════════

if [ -z "$PROJECT_NAME" ]; then
    read -p "Project name (lowercase): " PROJECT_NAME
    if [ -z "$PROJECT_NAME" ]; then
        echo -e "${RED}❌ Project name required${NC}"
        exit 1
    fi
fi

KEY_NAME="id_ed25519_${PROJECT_NAME}"
KEY_PATH="$HOME/.ssh/$KEY_NAME"

echo -e "   Project: ${GREEN}${PROJECT_NAME}${NC}"
echo -e "   Key: ${GREEN}${KEY_PATH}${NC}"
echo ""

# ═══════════════════════════════════════════════════════════════
# Generate SSH key
# ═══════════════════════════════════════════════════════════════

if [ -f "$KEY_PATH" ]; then
    echo -e "${YELLOW}⚠️  Key already exists: ${KEY_PATH}${NC}"
    read -p "   Skip key generation? (Y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        echo -e "${DIM}   Using existing key${NC}"
    else
        echo -e "${CYAN}🔑 Generating new key...${NC}"
        ssh-keygen -t ed25519 -C "${PROJECT_NAME}-deploy" -f "$KEY_PATH" -N ""
    fi
else
    echo -e "${CYAN}🔑 Generating SSH key...${NC}"
    ssh-keygen -t ed25519 -C "${PROJECT_NAME}-deploy" -f "$KEY_PATH" -N ""
fi

echo ""

# ═══════════════════════════════════════════════════════════════
# Add to ~/.ssh/config
# ═══════════════════════════════════════════════════════════════

SSH_CONFIG="$HOME/.ssh/config"

# Check if already configured
if grep -q "Host github-${PROJECT_NAME}" "$SSH_CONFIG" 2>/dev/null; then
    echo -e "${YELLOW}⚠️  GitHub config already exists for ${PROJECT_NAME}${NC}"
else
    echo -e "${CYAN}📝 Adding GitHub config to ~/.ssh/config...${NC}"
    
    cat >> "$SSH_CONFIG" << EOF

# === ${PROJECT_NAME} ===
Host github-${PROJECT_NAME}
  HostName github.com
  User git
  IdentityFile ${KEY_PATH}
  IdentitiesOnly yes
EOF
    
    echo -e "${GREEN}✓${NC} Added github-${PROJECT_NAME}"
fi

# ═══════════════════════════════════════════════════════════════
# Server config (optional - if we have server info)
# ═══════════════════════════════════════════════════════════════

# Try to get server from .env or ask
SERVER_IP=""
if [ -n "$PROD_SERVER" ]; then
    # Extract IP from user@ip format
    SERVER_IP=$(echo "$PROD_SERVER" | cut -d'@' -f2)
fi

if [ -z "$SERVER_IP" ]; then
    echo ""
    read -p "Server IP (or press Enter to skip): " SERVER_IP
fi

if [ -n "$SERVER_IP" ]; then
    if grep -q "Host ${PROJECT_NAME}-server" "$SSH_CONFIG" 2>/dev/null; then
        echo -e "${YELLOW}⚠️  Server config already exists${NC}"
    else
        echo -e "${CYAN}📝 Adding server config...${NC}"
        
        cat >> "$SSH_CONFIG" << EOF

Host ${PROJECT_NAME}-server
  HostName ${SERVER_IP}
  User deploy
  IdentityFile ${KEY_PATH}
  IdentitiesOnly yes
EOF
        
        echo -e "${GREEN}✓${NC} Added ${PROJECT_NAME}-server"
    fi
fi

# ═══════════════════════════════════════════════════════════════
# Add to GitHub via gh CLI (if available)
# ═══════════════════════════════════════════════════════════════

echo ""
KEY_TITLE="${PROJECT_NAME}-deploy"

if command -v gh &> /dev/null; then
    # Check if gh is authenticated
    if gh auth status &> /dev/null; then
        echo -e "${CYAN}🔗 Adding SSH key to GitHub via gh CLI...${NC}"
        
        # Check if key already exists on GitHub
        EXISTING_KEY=$(gh ssh-key list 2>/dev/null | grep "$KEY_TITLE" || true)
        
        if [ -n "$EXISTING_KEY" ]; then
            echo -e "${YELLOW}⚠️  Key '$KEY_TITLE' already exists on GitHub${NC}"
            read -p "   Delete and re-add? (y/N) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                # Get key ID and delete
                KEY_ID=$(echo "$EXISTING_KEY" | awk '{print $1}')
                gh ssh-key delete "$KEY_ID" --yes 2>/dev/null || true
                gh ssh-key add "${KEY_PATH}.pub" --title "$KEY_TITLE" --type authentication
                echo -e "${GREEN}✓${NC} Key re-added to GitHub"
            fi
        else
            gh ssh-key add "${KEY_PATH}.pub" --title "$KEY_TITLE" --type authentication
            echo -e "${GREEN}✓${NC} Key added to GitHub as '$KEY_TITLE'"
        fi
    else
        echo -e "${YELLOW}⚠️  GitHub CLI not authenticated${NC}"
        echo -e "${DIM}   Run 'gh auth login' first, or add key manually${NC}"
        # Fallback to clipboard
        if command -v pbcopy &> /dev/null; then
            cat "${KEY_PATH}.pub" | pbcopy
            echo -e "${GREEN}✓${NC} Public key copied to clipboard"
        fi
    fi
else
    echo -e "${DIM}💡 Install GitHub CLI for automatic key upload: brew install gh${NC}"
    # Fallback to clipboard
    if command -v pbcopy &> /dev/null; then
        cat "${KEY_PATH}.pub" | pbcopy
        echo -e "${GREEN}✓${NC} Public key copied to clipboard"
    else
        echo -e "${YELLOW}Public key:${NC}"
        cat "${KEY_PATH}.pub"
    fi
fi

# ═══════════════════════════════════════════════════════════════
# Summary
# ═══════════════════════════════════════════════════════════════

echo ""
echo -e "${GREEN}✅ SSH setup complete!${NC}"
echo ""
echo "Configured:"
echo "  • Key: ${KEY_PATH}"
echo "  • GitHub alias: github-${PROJECT_NAME}"
if [ -n "$SERVER_IP" ]; then
    echo "  • Server alias: ${PROJECT_NAME}-server"
fi
echo ""
echo -e "${DIM}Usage: git clone git@github-${PROJECT_NAME}:YOUR_USER/repo.git${NC}"

# Show remaining manual steps only if gh is not available or not authenticated
if ! command -v gh &> /dev/null || ! gh auth status &> /dev/null 2>&1; then
    echo ""
    echo "Manual steps:"
    echo "  1. Add key to GitHub: https://github.com/settings/keys"
    echo "     Title: ${KEY_TITLE}"
    echo "     Type: Authentication Key"
fi

if [ -n "$SERVER_IP" ]; then
    echo ""
    echo "Server setup:"
    echo "  ssh-copy-id -i ${KEY_PATH}.pub deploy@${SERVER_IP}"
fi

