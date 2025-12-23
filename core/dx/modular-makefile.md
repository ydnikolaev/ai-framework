# 🧩 Модульная архитектура Makefile

Этот документ описывает систему расширения Makefile для project-specific команд.

---

## Концепция

**Проблема:** ai-framework должен быть project-agnostic, но каждый проект имеет свои уникальные команды.

**Решение:** Модульная архитектура с опциональным подключением `.make/project.mk`.

```
project/
├── Makefile                    # Основной (включает dx.mk)
├── .make/
│   ├── dx.mk                   # Core DX utilities (из ai-framework)
│   └── project.mk              # ← PROJECT-SPECIFIC команды
└── ai-framework/
    └── templates/
        └── Makefile.template   # Шаблон (только универсальные команды)
```

---

## Как это работает

### 1. В главном Makefile

```makefile
# Core DX utilities
include .make/dx.mk

# Project-specific commands (optional, won't fail if missing)
-include .make/project.mk
```

Ключ: **`-include`** (с минусом) — не выдаёт ошибку, если файл отсутствует.

### 2. В `.make/project.mk`

Формат команд:

```makefile
# 🎬 Название секции
# ═══════════════════════════════════════

.PHONY: your-command another-command

your-command: ## Краткое описание для make help
	$(call log_header,🚀 Заголовок)
	@your_actual_command_here
	$(call log_success,Done!)

another-command: ## Ещё одна команда
	@echo "Hello"
```

**Важно:** Используй `## Описание` после двоеточия — это парсится `make help`.

### 3. Автоматический вывод в `make help`

Скрипт `scripts/make-help.py` автоматически парсит `.make/project.mk` и выводит project-specific команды отдельной секцией.

---

## Создание нового проекта

1. **Скопируй шаблонный Makefile:**
   ```bash
   cp ai-framework/templates/Makefile.template Makefile
   ```

2. **Создай `.make/project.mk`:**
   ```bash
   mkdir -p .make
   touch .make/project.mk
   ```

3. **Добавь свои команды:**
   ```makefile
   # .make/project.mk
   
   .PHONY: my-command
   
   my-command: ## My custom command
   	@echo "Hello from my project!"
   ```

---

## Примеры

### KinoBot (рекомендации фильмов)

```makefile
# .make/project.mk

.PHONY: seed-movies seed-clusters db-stats enrich-movies

seed-movies: ## Seed 500 movies from cluster JSON files
	$(call log_header,🎬 Seeding Movies)
	@cd backend && go run ./cmd/seedall/main.go
	$(call log_success,Seeding complete!)

db-stats: ## Show database statistics
	$(call log_header,📊 Database Statistics)
	@cd backend && go run ./cmd/dbstats/main.go

enrich-movies: ## Enrich movies with full data (director, actors, studio)
	$(call log_header,🔧 Enriching Movies)
	$(call log_info,Fetching full data from Kinopoisk API...)
	@cd backend && go run ./cmd/enrichmovies/main.go
	$(call log_success,Enrichment complete!)
```

### FinanceApp (финансовый трекер)

```makefile
# .make/project.mk

.PHONY: import-rates sync-accounts

import-rates: ## Import currency exchange rates
	$(call log_header,💱 Importing Rates)
	@cd backend && go run ./cmd/import_rates/main.go

sync-accounts: ## Sync bank accounts
	$(call log_header,🏦 Syncing Accounts)
	@cd backend && go run ./cmd/sync_accounts/main.go
```

---

## Преимущества

| Аспект | Описание |
|--------|----------|
| **Separation of concerns** | ai-framework содержит только универсальные команды |
| **Расширяемость** | Каждый проект добавляет свой `.make/project.mk` |
| **Backwards compatible** | `-include` не ломается, если файл отсутствует |
| **make help** | Автоматически подхватывает `## comments` |
| **Git-friendly** | `.make/project.mk` коммитится в репо проекта |

---

## Доступные DX Utilities

В `project.mk` доступны все макросы из `dx.mk`:

| Макрос | Описание |
|--------|----------|
| `$(call log_header,🚀 Title)` | Красивый заголовок секции |
| `$(call log_info,Message)` | Информационное сообщение |
| `$(call log_success,Done!)` | Сообщение об успехе (зелёное) |
| `$(call log_warning,Careful!)` | Предупреждение (жёлтое) |
| `$(call log_error,Failed!)` | Ошибка (красное) |

---

## Troubleshooting

### Команды не отображаются в `make help`

Убедись, что:
1. Файл находится в `.make/project.mk`
2. Команды имеют формат `command: ## Description`
3. `scripts/make-help.py` содержит функцию `parse_project_mk()`

### Ошибка "command not found"

Проверь `.PHONY` — все имена команд должны быть там:
```makefile
.PHONY: seed-movies seed-clusters db-stats
```
