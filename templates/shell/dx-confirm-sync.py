#!/usr/bin/env python3
"""
Database sync confirmation dialog with proper Unicode support
"""
import sys
import unicodedata
import subprocess
import re

# ANSI colors
RESET = '\033[0m'
BOLD = '\033[1m'
RED = '\033[31m'
GREEN = '\033[32m'
YELLOW = '\033[33m'
CYAN = '\033[36m'
DIM = '\033[2m'

import os
PROJECT_NAME = os.getenv('PROJECT_NAME', 'mybot')

BOX_WIDTH = 56  # Inner width of the box


def display_width(text):
    """Calculate visual width of string (handles wide chars)"""
    clean = re.sub(r'\033\[[0-9;]*m', '', text)
    return sum(2 if unicodedata.east_asian_width(c) in ('F', 'W') else 1 for c in clean)


def pad_to_width(text, width):
    """Pad text to visual width"""
    current = display_width(text)
    padding = width - current
    return text + (' ' * padding if padding > 0 else '')


def print_line(content="", color=None):
    """Print a box line with proper padding"""
    if color:
        text = f"  {color}{content}{RESET}"
    else:
        text = f"  {content}"
    padded = pad_to_width(text, BOX_WIDTH)
    print(f"{RED}║{RESET}{padded}{RED}║{RESET}")


def print_separator(style='mid'):
    if style == 'top':
        print(f"{RED}╔{'═' * BOX_WIDTH}╗{RESET}")
    elif style == 'mid':
        print(f"{RED}╠{'═' * BOX_WIDTH}╣{RESET}")
    else:
        print(f"{RED}╚{'═' * BOX_WIDTH}╝{RESET}")


def main():
    prod_server = sys.argv[1] if len(sys.argv) > 1 else "deploy@server"
    prod_dir = sys.argv[2] if len(sys.argv) > 2 else "project"
    
    print()
    print_separator('top')
    print_line()
    print_line(f"{BOLD}⚠️  ВНИМАНИЕ!{RESET}", color="")
    print_line()
    print_separator('mid')
    print_line()
    print_line(f"Бро, ты собираешься скачать {CYAN}PROD{RESET} базу данных")
    print_line(f"и загрузить её в {YELLOW}DEV{RESET}.")
    print_line()
    print_line(f"{RED}Все текущие данные в DEV БД пропадут{RESET}")
    print_line(f"{RED}и будут заменены продакшн данными!{RESET}")
    print_line()
    print_separator('mid')
    print_line(f"{DIM}PROD:{RESET} {CYAN}{prod_server}:{prod_dir}{RESET}")
    print_line(f"{DIM}DEV:{RESET}  {YELLOW}localhost:5433/{PROJECT_NAME}_dev{RESET}")
    print_separator('bottom')
    print()
    
    # Use gum for selection
    import os
    env = {k: v for k, v in os.environ.items() if k != 'BOLD'}
    
    try:
        result = subprocess.run(
            ['gum', 'choose', '--cursor=→ ', '--cursor.foreground=212', 
             '❌ Отмена', '✅ Да, синхронизировать'],
            stdout=subprocess.PIPE,
            stderr=None,  # Show stderr (gum draws menu there)
            stdin=None,   # Allow interactive input
            text=True,
            env=env
        )
        choice = result.stdout.strip()
    except FileNotFoundError:
        choice = input("Точно сделать? [y/N] ").strip().lower()
        if choice != 'y':
            choice = '❌ Отмена'
        else:
            choice = '✅ Да, синхронизировать'
    
    if choice != '✅ Да, синхронизировать':
        print(f"{GREEN}✓{RESET} Отменено.")
        sys.exit(1)
    
    sys.exit(0)


if __name__ == "__main__":
    main()
