#!/usr/bin/env python3
"""
iTerm2 Dev Environment Launcher
Opens 2 TABS: Local Dev (3x2) + Prod Monitoring (2x2)

Features:
- Detects external monitor and opens window there (maximized)
- Uses project directory for all panes
- Reads server config from .env (PROD_SERVER, PROD_DIR)

Requirements:
- pip install iterm2 pyobjc-framework-Cocoa python-dotenv
- Enable "Python API" in iTerm2 Preferences > General > Magic
- Create .env with PROD_SERVER and PROD_DIR

Usage: python3 scripts/dev-full.py [project_dir]
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

# Server config from .env (with defaults for this project)
SERVER = os.getenv('PROD_SERVER', 'deploy@waydownwego.ru')
PROD_DIR = os.getenv('PROD_DIR', 'kinobot')



def get_display_info():
    """Get screen info: returns (has_external, frame) where frame is (x, y, width, height)"""
    try:
        from AppKit import NSScreen
        screens = NSScreen.screens()
        
        if len(screens) > 1:
            # External monitor detected - use the second screen (external)
            external = screens[1]
            frame = external.frame()
            return True, (int(frame.origin.x), int(frame.origin.y), 
                         int(frame.size.width), int(frame.size.height))
        else:
            # Only built-in display - use default large size
            main = screens[0]
            frame = main.frame()
            # Center with 80% of screen
            w, h = int(frame.size.width * 0.85), int(frame.size.height * 0.85)
            x = int((frame.size.width - w) / 2)
            y = int((frame.size.height - h) / 2)
            return False, (x, y, w, h)
    except Exception as e:
        print(f"⚠️  Could not detect displays: {e}")
        return False, (50, 50, 1400, 900)


async def main(connection):
    app = await iterm2.async_get_app(connection)
    
    # Detect external monitor
    has_external, (x, y, width, height) = get_display_info()
    
    # Create new window with custom frame
    window = await iterm2.Window.async_create(
        connection,
        profile_customizations=iterm2.LocalWriteOnlyProfile()
    )
    
    # Set window position and size
    await window.async_set_frame(iterm2.Frame(
        origin=iterm2.Point(x, y),
        size=iterm2.Size(width, height)
    ))
    
    # ═══════════════════════════════════════════════════════════════
    # TAB 1: LOCAL DEV (3x2 grid)
    # ═══════════════════════════════════════════════════════════════
    tab1 = window.current_tab
    
    # Row 1: Bot | API | DB Logs
    bot = tab1.current_session
    await bot.async_set_name("🤖 Bot")
    await bot.async_send_text(f"cd '{PROJECT_DIR}' && make bot\n")
    
    api = await bot.async_split_pane(vertical=True)
    await api.async_set_name("⚡ API")
    await api.async_send_text(f"cd '{PROJECT_DIR}' && make api\n")
    
    db_logs = await api.async_split_pane(vertical=True)
    await db_logs.async_set_name("📊 DB Logs")
    await db_logs.async_send_text(f"cd '{PROJECT_DIR}' && ./scripts/dx-db-logs.sh\n")
    
    # Row 2: Frontend | Tunnel | Status
    frontend = await bot.async_split_pane(vertical=False)
    await frontend.async_set_name("🎨 Frontend")
    await frontend.async_send_text(f"cd '{PROJECT_DIR}' && make frontend\n")
    
    tunnel = await api.async_split_pane(vertical=False)
    await tunnel.async_set_name("🌐 Tunnel")
    await tunnel.async_send_text(f"cd '{PROJECT_DIR}' && make tunnel\n")
    
    status = await db_logs.async_split_pane(vertical=False)
    await status.async_set_name("📋 Status")
    await status.async_send_text(f"cd '{PROJECT_DIR}' && ./scripts/dx-status.sh\n")
    
    # ═══════════════════════════════════════════════════════════════
    # TAB 2: PROD MONITORING (2x2 grid)
    # ═══════════════════════════════════════════════════════════════
    tab2 = await window.async_create_tab()
    
    # Row 1: Prod Bot | Prod API
    prod_bot = tab2.current_session
    await prod_bot.async_set_name("🤖 Prod Bot")
    await prod_bot.async_send_text(f"cd '{PROJECT_DIR}' && ssh {SERVER} 'cd {PROD_DIR} && ./scripts/dx-logs.sh kinobot_bot'\n")
    
    prod_api = await prod_bot.async_split_pane(vertical=True)
    await prod_api.async_set_name("⚡ Prod API")
    await prod_api.async_send_text(f"cd '{PROJECT_DIR}' && ssh {SERVER} 'cd {PROD_DIR} && ./scripts/dx-logs.sh kinobot_api'\n")
    
    # Row 2: Prod DB | Prod Status
    prod_db = await prod_bot.async_split_pane(vertical=False)
    await prod_db.async_set_name("📊 Prod DB")
    await prod_db.async_send_text(f"cd '{PROJECT_DIR}' && ssh {SERVER} 'cd {PROD_DIR} && ./scripts/dx-logs.sh kinobot_db'\n")
    
    prod_status = await prod_api.async_split_pane(vertical=False)
    await prod_status.async_set_name("📋 Prod Status")
    await prod_status.async_send_text(f"cd '{PROJECT_DIR}' && ssh {SERVER} 'cd {PROD_DIR} && ./scripts/dx-prod-status.sh'\n")
    
    # Switch to Tab 1
    await tab1.async_select()
    
    monitor_info = "🖥️  External monitor" if has_external else "💻 Built-in display"
    print(f"✅ Full dev environment started! ({monitor_info})")
    print(f"   Window: {width}x{height} at ({x}, {y})")
    print("   Tab 1: 🖥️  Local Dev (bot, api, frontend, tunnel, db logs, status)")
    print("   Tab 2: 🌐 Prod Monitoring (bot, api, postgres, status)")

if __name__ == "__main__":
    iterm2.run_until_complete(main)
