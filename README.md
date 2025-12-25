# 🧠 AI-First Framework

> Универсальный фреймворк для разработки Telegram Mini Apps на стеке **Go + Nuxt**.
> Оптимизирован для работы с AI-ассистентами (Claude, Gemini, GPT).

> **🤖 AI-AGENT:** Start navigation here → [`core/_INDEX_CORE_FRAMEWORK.md`](core/_INDEX_CORE_FRAMEWORK.md)

---

## ⚡ Quick Start

### Новый проект

```bash
# 1. Создай папку проекта
mkdir my-bot && cd my-bot
git init

# 2. Добавь фреймворк как submodule
git submodule add https://github.com/YOUR_USER/ai-framework.git ai-framework

# 3. Запусти установку
cd ai-framework && ./setup.sh && cd ..

# 4. Готово! Создано:
#    - docker-compose.yml / docker-compose.prod.yml
#    - Makefile, .env.example
#    - project/CONFIG.yaml, project/CONTEXT.md
```

> 📋 **Полное руководство:** [setup/README.md](setup/README.md) — от SSH ключей до деплоя

### Существующий проект

```bash
git submodule add https://github.com/YOUR_USER/ai-framework.git ai-framework
cd ai-framework && ./setup.sh
```

---

## 📂 Структура

```text
ai-framework/
│
├── README.md                # ← Ты здесь
├── setup.sh                 # Entry point для установки
│
├── setup/                   # 🚀 SETUP & GUIDES
│   ├── README.md           # Полное руководство (от 0 до deploy)
│   ├── CHECKLIST.md        # Чеклист для нового проекта
│   ├── setup.sh            # Unified setup (auto gum detection)
│   ├── install.sh          # Базовая установка
│   └── install-interactive.sh # Интерактивная установка (gum)
│
├── core/                    # 🔒 FRAMEWORK RULES (read-only)
│   ├── _INDEX_CORE_FRAMEWORK.md # 🤖 Карта для AI
│   ├── agents/             # AI Personas
│   ├── workflows/          # SOPs
│   ├── architecture/       # Архитектура
│   ├── design/             # Design System
│   ├── stack/              # Правила по технологиям
│   ├── quality/            # Аудиты и качество
│   ├── operations/         # DevOps
│   ├── dx/                 # Developer Experience
│   └── reference/          # Справочники
│
├── docs/                    # 📚 FRAMEWORK DOCS
│   └── [frameworks...]     # (Vue, Nuxt, Telegram, etc.)
│
├── infrastructure/          # 🏗️ SERVER-LEVEL
│   ├── traefik/            # Shared Traefik setup
│   ├── server-setup/       # Cloud-init, VPS настройка
│   └── multi-project/      # Multi-project deployment
│
├── templates/               # 📦 PROJECT TEMPLATES
│   └── _INDEX_TEMPLATES_FRAMEWORK.md
│
└── project/ (создаётся)     # 📝 PROJECT CONTEXT (editable)
```

---

## 🎯 Как пользоваться

### Для человека

| Хочу... | Открой файл |
|---------|-------------|
| Добавить идею/фичу | `project/BACKLOG.md` |
| Написать кастомный промпт | `project/PROMPTS.md` |
| Зафиксировать решение | `project/DECISIONS.md` |
| Понять архитектуру | `core/architecture/` |
| Проверить производительность | `core/quality/performance.md` |
| Задеплоить | `core/operations/deployment.md` |

### Для AI-модели

**Первым делом читай:**
```
ai-framework/core/_INDEX_CORE_FRAMEWORK.md
```

Этот файл содержит карту всех документов и инструкцию "когда какой файл открывать".

**Контекст проекта:**
```
ai-framework/project/CONTEXT.md
```

---

## 🔄 Обновление фреймворка

```bash
# Обновить до последней версии
cd ai-framework
git pull origin main
cd ..
git add ai-framework
git commit -m "chore: update ai-framework"
```

Файлы в `project/` **не затрагиваются** — они твои.

---

## 📋 Makefile команды

После `setup.sh` в корне проекта появится `Makefile`:

```bash
make dev          # Запуск dev-окружения
make api          # Запуск только backend
make frontend     # Запуск только frontend
make test         # Все тесты
make lint         # Линтинг
make deploy       # Деплой на прод
make logs         # Логи продакшена
```

---

## 🔑 Принципы

1. **`core/` = Read-Only** — никогда не редактируй в проекте, обновляй через git pull
2. **`project/` = Твоё** — здесь живёт контекст конкретного проекта
3. **AI-First** — структура оптимизирована для понимания LLM-моделями
4. **Human-Friendly** — понятная навигация для разработчика

---

## 📝 Лицензия

Private / Internal Use.
