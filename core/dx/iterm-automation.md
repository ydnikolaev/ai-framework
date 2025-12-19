# 🖥️ iTerm2 Automation

> Автоматизация dev-окружения через iTerm2 Python API.

---

## 📦 Зависимости

```bash
pip install iterm2 pyobjc-framework-Cocoa python-dotenv
```

**iTerm2 настройки:**
- Preferences → General → Magic → Enable Python API ✅

---

## 🚀 Скрипты

### `dev-full.py` — Полное dev-окружение

Открывает 2 вкладки:

**Tab 1: Local Dev (3x2)**
| Панель | Команда |
|--------|---------|
| 🤖 Bot | `make bot` |
| ⚡ API | `make api` |
| 📊 DB Logs | `dx-db-logs.sh` |
| 🎨 Frontend | `make frontend` |
| 🌐 Tunnel | `make tunnel` |
| 🔔 Deploy | `deploy-watch.sh` |

**Tab 2: Prod Monitoring (2x2)**
| Панель | Команда |
|--------|---------|
| 🤖 Prod Bot | SSH → docker logs bot |
| ⚡ Prod API | SSH → docker logs api |
| 📊 Prod DB | SSH → docker logs db |
| 📋 Prod Status | SSH → docker stats |

**Запуск:** `make dev-full`

---

### `dev-iterm.py` — Базовое окружение

Открывает 1 вкладку (2x2): Bot, API, Frontend, Tunnel.

**Запуск:** `make dev`

---

### `prod-watch.py` — Мониторинг прода

Открывает 1 вкладку (2x2) с SSH-логами продакшена.

**Запуск:** `make prod-watch`

---

## ⚙️ Конфигурация

Скрипты читают настройки из `.env`:

```env
PROD_SERVER=deploy@your-server.ru
PROD_DIR=project-name
```

---

## 🔧 Вспомогательные скрипты

| Скрипт | Назначение |
|--------|------------|
| `dx-db-logs.sh` | Логи локальной БД |
| `dx-logs.sh` | Универсальный просмотр docker logs |
| `dx-status.sh` | Статус локальных контейнеров |
| `dx-prod-status.sh` | Статус прод-контейнеров |
| `deploy-watch.sh` | Уведомления о деплое |

---

## 📍 Расположение файлов

| Проект | Шаблон (ai-framework) |
|--------|-----------------------|
| `scripts/dev-full.py` | `templates/shell/dev-full.py` |
| `scripts/dev-iterm.py` | `templates/shell/dev-iterm.py` |
| `scripts/prod-watch.py` | `templates/shell/prod-watch.py` |
