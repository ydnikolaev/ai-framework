#!/usr/bin/env python3
"""
iTerm2 Production Monitoring (2x2 grid)
Prod Bot | Prod API
Prod DB  | Prod Status

Requirements:
- pip install iterm2 python-dotenv
- Enable "Python API" in iTerm2 Preferences > General > Magic
- Create .env with PROD_SERVER and PROD_DIR

Usage: python3 scripts/prod-watch.py [project_dir]
"""

import iterm2
import sys
import os

# Load .env from project root
PROJECT_DIR = sys.argv[1] if len(sys.argv) > 1 else os.getcwd()
env_path = os.path.join(PROJECT_DIR, '.env')
if os.path.exists(env_path):
    from dotenv import load_dotenv
    load_dotenv(env_path)

# Server config from .env
SERVER = os.getenv('PROD_SERVER', 'deploy@waydownwego.ru')
PROD_DIR = os.getenv('PROD_DIR', 'kinobot')

async def main(connection):
    app = await iterm2.async_get_app(connection)
    
    # Create new window
    window = await iterm2.Window.async_create(connection)
    tab = window.current_tab
    
    # Row 1: Prod Bot | Prod API
    prod_bot = tab.current_session
    await prod_bot.async_set_name("🤖 Prod Bot")
    await prod_bot.async_send_text(f"ssh {SERVER} 'cd {PROD_DIR} && ./scripts/dx-logs.sh kinobot_bot'\n")
    
    prod_api = await prod_bot.async_split_pane(vertical=True)
    await prod_api.async_set_name("⚡ Prod API")
    await prod_api.async_send_text(f"ssh {SERVER} 'cd {PROD_DIR} && ./scripts/dx-logs.sh kinobot_api'\n")
    
    # Row 2: Prod DB | Prod Status
    prod_db = await prod_bot.async_split_pane(vertical=False)
    await prod_db.async_set_name("📊 Prod DB")
    await prod_db.async_send_text(f"ssh {SERVER} 'cd {PROD_DIR} && ./scripts/dx-logs.sh kinobot_db'\n")
    
    prod_status = await prod_api.async_split_pane(vertical=False)
    await prod_status.async_set_name("📋 Prod Status")
    await prod_status.async_send_text(f"ssh {SERVER} 'cd {PROD_DIR} && ./scripts/dx-prod-status.sh'\n")
    
    print("✅ Production monitoring started in iTerm2!")
    print(f"   Server: {SERVER}")

if __name__ == "__main__":
    iterm2.run_until_complete(main)
