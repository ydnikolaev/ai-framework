#!/usr/bin/env python3
"""
Universal confirmation dialog for dangerous Makefile commands.
Usage: dx-confirm.py "TITLE" "DESCRIPTION" [--danger]
"""
import sys
import subprocess
import os

# ANSI colors
RESET = '\033[0m'
BOLD = '\033[1m'
RED = '\033[31m'
GREEN = '\033[32m'
YELLOW = '\033[33m'
CYAN = '\033[36m'
DIM = '\033[2m'

BOX_WIDTH = 50


def display_width(text):
    """Calculate visual width (strip ANSI codes)"""
    import re
    import unicodedata
    clean = re.sub(r'\033\[[0-9;]*m', '', text)
    return sum(2 if unicodedata.east_asian_width(c) in ('F', 'W') else 1 for c in clean)


def pad_to_width(text, width):
    current = display_width(text)
    padding = width - current
    return text + (' ' * padding if padding > 0 else '')


def print_line(content=""):
    padded = pad_to_width(f"  {content}", BOX_WIDTH)
    print(f"{RED}║{RESET}{padded}{RED}║{RESET}")


def print_separator(style='mid'):
    if style == 'top':
        print(f"{RED}╔{'═' * BOX_WIDTH}╗{RESET}")
    elif style == 'mid':
        print(f"{RED}╠{'═' * BOX_WIDTH}╣{RESET}")
    else:
        print(f"{RED}╚{'═' * BOX_WIDTH}╝{RESET}")


def main():
    if len(sys.argv) < 3:
        print("Usage: dx-confirm.py 'TITLE' 'DESCRIPTION'")
        sys.exit(1)
    
    title = sys.argv[1]
    description = sys.argv[2]
    
    print()
    print_separator('top')
    print_line()
    print_line(f"{BOLD}⚠️  {title}{RESET}")
    print_line()
    print_separator('mid')
    print_line()
    
    # Split description by newlines
    for line in description.split('\\n'):
        print_line(f"{RED}{line}{RESET}")
    
    print_line()
    print_separator('bottom')
    print()
    
    # Use gum for selection
    env = {k: v for k, v in os.environ.items() if k != 'BOLD'}
    
    try:
        result = subprocess.run(
            ['gum', 'choose', '--cursor=→ ', '--cursor.foreground=212', 
             '❌ Отмена', '✅ Продолжить'],
            stdout=subprocess.PIPE,
            stderr=None,
            stdin=None,
            text=True,
            env=env
        )
        choice = result.stdout.strip()
    except FileNotFoundError:
        choice = input("Продолжить? [y/N] ").strip().lower()
        choice = '✅ Продолжить' if choice == 'y' else '❌ Отмена'
    
    if choice != '✅ Продолжить':
        print(f"{GREEN}✓{RESET} Отменено.")
        sys.exit(1)
    
    print()
    sys.exit(0)


if __name__ == "__main__":
    main()
