#!/usr/bin/env python3
"""
iTerm2 Basic Dev Environment (2x2 grid)
Bot | API
Frontend | Tunnel

Requirements:
- pip install iterm2
- Enable "Python API" in iTerm2 Preferences > General > Magic

Usage: python3 scripts/dev-iterm.py [project_dir]
"""

import iterm2
import sys
import os

PROJECT_DIR = sys.argv[1] if len(sys.argv) > 1 else os.getcwd()

async def main(connection):
    app = await iterm2.async_get_app(connection)
    
    # Create new window
    window = await iterm2.Window.async_create(connection)
    tab = window.current_tab
    
    # Row 1: Bot | API
    bot = tab.current_session
    await bot.async_set_name("🤖 Bot")
    await bot.async_send_text(f"cd '{PROJECT_DIR}' && make bot\n")
    
    api = await bot.async_split_pane(vertical=True)
    await api.async_set_name("⚡ API")
    await api.async_send_text(f"cd '{PROJECT_DIR}' && make api\n")
    
    # Row 2: Frontend | Tunnel
    frontend = await bot.async_split_pane(vertical=False)
    await frontend.async_set_name("🎨 Frontend")
    await frontend.async_send_text(f"cd '{PROJECT_DIR}' && make frontend\n")
    
    tunnel = await api.async_split_pane(vertical=False)
    await tunnel.async_set_name("🌐 Tunnel")
    await tunnel.async_send_text(f"cd '{PROJECT_DIR}' && make tunnel\n")
    
    print("✅ Dev environment started in iTerm2!")

if __name__ == "__main__":
    iterm2.run_until_complete(main)
