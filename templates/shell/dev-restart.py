#!/usr/bin/env python3
"""
iTerm2 Dev Environment Restart
Restarts all processes in the existing dev window by POSITION (not by name).

The layout is fixed from dev-full.py:
Tab 1 (Local Dev) - 7 sessions in order:
  1. Bot        2. API        3. DB Logs
  4. Frontend   5. Tunnel     6. Deploy Watch
  7. Status

Tab 2 (Prod Monitoring) - 4 sessions in order:
  1. Prod Bot   2. Prod API
  3. Prod DB    4. Prod Status

Usage: 
  python3 scripts/dev-restart.py [project_dir]
  python3 scripts/dev-restart.py [project_dir] --local-only  # Only Tab 1
"""

import iterm2
import sys
import os
import asyncio

# Load .env from project root
PROJECT_DIR = sys.argv[1] if len(sys.argv) > 1 else os.getcwd()
env_path = os.path.join(PROJECT_DIR, '.env')
if os.path.exists(env_path):
    from dotenv import load_dotenv
    load_dotenv(env_path)

# Server config from .env
SERVER = os.getenv('PROD_SERVER', 'deploy@waydownwego.ru')
PROD_DIR = os.getenv('PROD_DIR', 'kinobot')

# Commands for each session by POSITION
# Tab 1: Local Dev (7 sessions)
TAB1_COMMANDS = [
    ("🤖 Bot", f"cd '{PROJECT_DIR}' && make bot"),
    ("🎨 Frontend", f"cd '{PROJECT_DIR}' && make frontend"),
    ("⚡ API", f"cd '{PROJECT_DIR}' && make api"),
    ("🌐 Tunnel", f"cd '{PROJECT_DIR}' && make tunnel"),
    ("🔔 Deploy", f"cd '{PROJECT_DIR}' && ./scripts/deploy-watch.sh"),
    ("📊 DB Logs", f"cd '{PROJECT_DIR}' && ./scripts/dx-db-logs.sh"),
    ("📋 Status", f"cd '{PROJECT_DIR}' && ./scripts/dx-status.sh"),
]

# Tab 2: Prod Monitoring (4 sessions)
TAB2_COMMANDS = [
    ("🤖 Prod Bot", f"cd '{PROJECT_DIR}' && ssh {SERVER} 'cd {PROD_DIR} && ./scripts/dx-logs.sh kinobot_bot'"),
    ("📊 Prod DB", f"cd '{PROJECT_DIR}' && ssh {SERVER} 'cd {PROD_DIR} && ./scripts/dx-logs.sh kinobot_db'"),
    ("⚡ Prod API", f"cd '{PROJECT_DIR}' && ssh {SERVER} 'cd {PROD_DIR} && ./scripts/dx-logs.sh kinobot_api'"),
    ("📋 Prod Status", f"cd '{PROJECT_DIR}' && ssh {SERVER} 'cd {PROD_DIR} && ./scripts/dx-prod-status.sh'"),
]


async def restart_session(session, command, name):
    """Stop current process and restart with new command"""
    try:
        # Send Ctrl+C to stop current process
        await session.async_send_text("\x03")
        await asyncio.sleep(0.3)
        
        # Clear terminal
        await session.async_send_text("clear\n")
        await asyncio.sleep(0.1)
        
        # Run the command
        await session.async_send_text(f"{command}\n")
        return True
    except Exception as e:
        print(f"   ⚠️  Error restarting {name}: {e}")
        return False


async def find_dev_window(app):
    """Find the dev window by layout (2 tabs, 4+ sessions in first tab)"""
    for window in app.windows:
        if len(window.tabs) >= 2:
            if len(window.tabs[0].sessions) >= 4:
                return window
    return None


async def main(connection):
    app = await iterm2.async_get_app(connection)
    debug = "--debug" in sys.argv
    
    dev_window = await find_dev_window(app)
    
    if not dev_window:
        print("❌ Dev window not found!")
        print("   Run 'make dev-full' first to create the dev environment.")
        return
    
    print("🔄 Restarting dev environment...")
    
    local_only = "--local-only" in sys.argv or "--local" in sys.argv
    restarted = 0
    
    # Tab 1: Local Dev
    tab1 = dev_window.tabs[0]
    sessions1 = tab1.sessions
    
    if debug:
        print(f"   [DEBUG] Tab 1 has {len(sessions1)} sessions, expecting {len(TAB1_COMMANDS)}")
    
    for i, session in enumerate(sessions1):
        if i < len(TAB1_COMMANDS):
            name, command = TAB1_COMMANDS[i]
            if debug:
                print(f"   [DEBUG] Position {i}: {name}")
            print(f"   ↻ {name}...")
            success = await restart_session(session, command, name)
            if success:
                restarted += 1
    
    # Tab 2: Prod Monitoring (if not --local-only)
    if not local_only and len(dev_window.tabs) > 1:
        tab2 = dev_window.tabs[1]
        sessions2 = tab2.sessions
        
        if debug:
            print(f"   [DEBUG] Tab 2 has {len(sessions2)} sessions, expecting {len(TAB2_COMMANDS)}")
        
        for i, session in enumerate(sessions2):
            if i < len(TAB2_COMMANDS):
                name, command = TAB2_COMMANDS[i]
                if debug:
                    print(f"   [DEBUG] Position {i}: {name}")
                print(f"   ↻ {name}...")
                success = await restart_session(session, command, name)
                if success:
                    restarted += 1
    
    # Focus the dev window and first tab
    await dev_window.async_activate()
    if dev_window.tabs:
        await dev_window.tabs[0].async_select()
    
    print(f"✅ Restarted {restarted} sessions!")
    if local_only:
        print("   (Used --local-only, prod monitoring was skipped)")


if __name__ == "__main__":
    iterm2.run_until_complete(main)
