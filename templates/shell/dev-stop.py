#!/usr/bin/env python3
"""
iTerm2 Dev Environment Stop
Finds existing dev window and stops all processes in place (Ctrl+C).

IMPORTANT: For prod monitoring tab, this only stops the SSH monitoring sessions,
it does NOT kill actual production processes (bot, api, db).

Usage: 
  python3 scripts/dev-stop.py [project_dir]
  python3 scripts/dev-stop.py [project_dir] --local-only  # Stop only local tab
"""

import iterm2
import sys
import os
import asyncio

PROJECT_DIR = sys.argv[1] if len(sys.argv) > 1 else os.getcwd()

# Patterns to identify dev sessions (same as dev-restart.py)
DEV_PATTERNS = ["(bot)", "(api)", "(docker-compose)", "(node)", "(docker)", "(bash)", "(ssh)", "(sleep)"]


async def stop_session(session, name):
    """Send Ctrl+C to stop current process"""
    try:
        await session.async_send_text("\x03")
        await asyncio.sleep(0.2)
        return True
    except Exception as e:
        print(f"   ⚠️  Error stopping {name}: {e}")
        return False


async def find_dev_window(app):
    """Find the dev window by looking for known session patterns"""
    for window in app.windows:
        for tab in window.tabs:
            for session in tab.sessions:
                name = await session.async_get_variable("name")
                if name:
                    for pattern in DEV_PATTERNS:
                        if pattern in name:
                            return window
    
    # Fallback: look for windows with 2+ tabs and 4+ sessions
    for window in app.windows:
        if len(window.tabs) >= 2 and len(window.tabs[0].sessions) >= 4:
            return window
    
    return None


async def main(connection):
    app = await iterm2.async_get_app(connection)
    debug = "--debug" in sys.argv
    
    dev_window = await find_dev_window(app)
    
    if not dev_window:
        print("❌ Dev window not found!")
        print("   No dev environment to stop.")
        return
    
    print("🛑 Stopping dev environment...")
    
    # Parse args
    local_only = "--local-only" in sys.argv or "--local" in sys.argv
    
    stopped = 0
    
    for tab_index, tab in enumerate(dev_window.tabs):
        is_prod_tab = tab_index == 1
        
        # Skip prod tab if --local-only
        if is_prod_tab and local_only:
            continue
        
        for session in tab.sessions:
            name = await session.async_get_variable("name")
            if not name:
                continue
            
            # Check if this is a dev session
            is_dev_session = any(pattern in name for pattern in DEV_PATTERNS)
            
            if is_dev_session:
                # Determine display name
                if "(bot)" in name:
                    display_name = "🤖 Bot"
                elif "(api)" in name:
                    display_name = "⚡ API"
                elif "(docker-compose)" in name:
                    display_name = "📊 DB Logs"
                elif "(node)" in name:
                    display_name = "🎨 Frontend"
                elif "(docker)" in name and "(docker-compose)" not in name:
                    display_name = "📋 Status"
                elif "(bash)" in name:
                    display_name = "🔔 Deploy"
                elif "(sleep)" in name:
                    display_name = "🔔 Deploy"
                elif "(ssh)" in name:
                    display_name = "🌐 SSH" if not is_prod_tab else "🌐 Prod Monitor"
                else:
                    display_name = name
                
                if debug:
                    print(f"   [DEBUG] Stopping: {name} -> {display_name}")
                
                print(f"   ⏹ {display_name}...")
                success = await stop_session(session, display_name)
                if success:
                    stopped += 1
    
    print(f"✅ Stopped {stopped} sessions!")
    if local_only:
        print("   (Used --local-only, prod monitoring was skipped)")
    else:
        print("   (Prod containers still running, only monitoring stopped)")


if __name__ == "__main__":
    iterm2.run_until_complete(main)
