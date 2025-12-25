#!/usr/bin/env python3
"""
Makefile help formatter with proper Cyrillic support
"""
import sys
import unicodedata

# ANSI colors
RESET = '\033[0m'
BOLD = '\033[1m'
RED = '\033[31m'
GREEN = '\033[32m'
YELLOW = '\033[33m'
BLUE = '\033[34m'
MAGENTA = '\033[35m'
CYAN = '\033[36m'
DIM = '\033[2m'

import os
PROJECT_NAME = os.getenv('PROJECT_NAME', 'Project')


def display_width(text):
    """Calculate visual width of string (handles wide chars like Cyrillic)"""
    # Strip ANSI codes for width calculation
    import re
    clean = re.sub(r'\033\[[0-9;]*m', '', text)
    return sum(2 if unicodedata.east_asian_width(c) in ('F', 'W') else 1 for c in clean)


def pad_to_width(text, width):
    """Pad text to visual width"""
    current_width = display_width(text)
    padding = width - current_width
    return text + (' ' * padding if padding > 0 else '')


def print_row(col1, col2, col3, widths):
    """Print a table row with proper alignment"""
    c1 = pad_to_width(col1, widths[0])
    c2 = pad_to_width(col2, widths[1])
    c3 = pad_to_width(col3, widths[2])
    print(f"{CYAN}│{RESET} {c1} {CYAN}│{RESET} {c2} {CYAN}│{RESET} {c3} {CYAN}│{RESET}")


def print_separator(widths, style='mid'):
    """Print table separator"""
    if style == 'top':
        left, mid, right = '┌', '┬', '┐'
    elif style == 'mid':
        left, mid, right = '├', '┼', '┤'
    else:  # bottom
        left, mid, right = '└', '┴', '┘'
    
    line = f"{CYAN}{left}{'─' * (widths[0] + 2)}{mid}{'─' * (widths[1] + 2)}{mid}{'─' * (widths[2] + 2)}{right}{RESET}"
    print(line)


def main():
    # Column widths (visual)
    widths = [21, 35, 32]
    
    print(f"\n{BOLD}{MAGENTA}🤖 {PROJECT_NAME} Makefile{RESET}\n")
    
    # Header
    print_separator(widths, 'top')
    print_row(f"{BOLD}Команда{RESET}", f"{BOLD}Описание{RESET}", f"{BOLD}Когда использовать{RESET}", widths)
    
    # Development
    print_separator(widths, 'mid')
    print_row(f"{GREEN}dev{RESET}", "Локальная разработка (iTerm2)", "Основная работа над проектом", widths)
    print_row(f"{GREEN}dev-full{RESET}", "Локал + прод логи (iTerm2)", "Разработка с мониторингом прода", widths)
    print_row(f"{GREEN}api{RESET}", "Запустить API сервер", "Тестирование только бэкенда", widths)
    print_row(f"{GREEN}frontend{RESET}", "Запустить фронтенд", "Работа над интерфейсом", widths)
    print_row(f"{GREEN}bot{RESET}", "Запустить бота", "Тестирование логики бота", widths)
    
    # Process Control
    print_separator(widths, 'mid')
    print_row(f"{YELLOW}bot-stop{RESET}", "Остановить все процессы бота", "Конфликт 'other getUpdates'", widths)
    print_row(f"{YELLOW}dev-stop{RESET}", "Остановить всё dev-окружение", "Перед перезапуском", widths)
    print_row(f"{YELLOW}dev-restart{RESET}", "Перезапустить dev-окружение", "Stop + Start", widths)
    
    # Database
    print_separator(widths, 'mid')
    print_row(f"{YELLOW}db{RESET}", "Запустить базу данных", "Перед началом разработки", widths)
    print_row(f"{RED}db-reset *{RESET}", "Очистить и пересоздать БД", "Удаляет все данные!", widths)
    print_row(f"{RED}db-sync-from-prod *{RESET}", "Скачать PROD → DEV", "Перезапись DEV базы", widths)
    print_row(f"{YELLOW}migrate{RESET}", "Применить миграции (dev)", "После изменения схемы БД", widths)
    print_row(f"{RED}migrate-prod *{RESET}", "Применить миграции (prod)", "Меняет схему PROD!", widths)
    print_row(f"{RED}update-dev *{RESET}", "Обновить метаданные (dev)", "Расход API лимитов!", widths)
    print_row(f"{RED}update-prod *{RESET}", "Обновить метаданные (prod)", "Расход API лимитов!", widths)
    
    # Production
    print_separator(widths, 'mid')
    print_row(f"{BLUE}ssh{RESET}", "SSH на прод сервер", "Прямой доступ к серверу", widths)
    print_row(f"{BLUE}prod-logs{RESET}", "Логи прода (все)", "Мониторинг всех сервисов", widths)
    print_row(f"{BLUE}prod-watch{RESET}", "Мониторинг (iTerm2 2x2)", "Детальное наблюдение за продом", widths)
    print_row(f"{BLUE}prod-restart{RESET}", "Перезапустить контейнеры", "После обновления .env", widths)
    print_row(f"{BLUE}prod-status{RESET}", "Статус контейнеров (CPU/RAM)", "Проверка производительности", widths)
    print_row(f"{BLUE}prod-sync-env{RESET}", "Копировать .env на сервер", "Обновление переменных окружения", widths)
    
    # Utilities
    print_separator(widths, 'mid')
    print_row(f"{MAGENTA}tunnel{RESET}", "SSH туннель для тестирования", "Показать мини-апп на телефоне", widths)
    print_row(f"{MAGENTA}test{RESET}", "Запустить тесты", "Перед коммитом изменений", widths)
    print_row(f"{MAGENTA}clean{RESET}", "Очистить временные файлы", "Освободить место на диске", widths)
    print_row(f"{MAGENTA}deploy-watch{RESET}", "Уведомления о деплое", "Мониторинг на MacOS", widths)
    
    print_separator(widths, 'bottom')
    print(f"\n{DIM}Использование:{RESET} {BOLD}make <команда>{RESET}")
    print(f"{DIM}{RED}* = требует подтверждения{RESET}\n")


if __name__ == "__main__":
    main()
