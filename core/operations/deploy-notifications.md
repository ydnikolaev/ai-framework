# 🔔 Deploy Notifications

> Система уведомлений о деплое на macOS.

---

## 📋 Обзор

Система позволяет получать **macOS уведомления** когда GitHub Actions успешно задеплоил код на продакшн. Это решает проблему пропущенных уведомлений при включённом режиме "Не беспокоить".

### Архитектура

```
GitHub Actions ──POST──▶ waydownwego.ru/api/deploy-webhook
                                    │
                                    ▼ (in-memory store)
                                    
Mac polling script ◀──GET── waydownwego.ru/api/deploy-status
         │
         ▼
   terminal-notifier
```

---

## 🔧 Компоненты

### 1. Backend API

**Файлы:**
- `backend/internal/api/webhook.go` — хендлеры
- `backend/internal/api/server.go` — роуты
- `backend/pkg/config/config.go` — конфиг (`DeployWebhookToken`)

**Эндпоинты:**

| Метод | URL | Описание |
|-------|-----|----------|
| POST | `/api/deploy-webhook` | Принимает событие деплоя от GitHub Actions |
| GET | `/api/deploy-status?since=<timestamp>` | Возвращает деплои после указанного времени |

**Аутентификация:** Токен в заголовке `X-Deploy-Token`

### 2. GitHub Actions

**Файл:** `.github/workflows/deploy.yml`

```yaml
- name: Notify Deploy Webhook
  if: success()
  run: |
    curl -s -X POST "https://waydownwego.ru/api/deploy-webhook" \
      -H "X-Deploy-Token: ${{ secrets.DEPLOY_WEBHOOK_TOKEN }}" \
      -H "Content-Type: application/json" \
      -d '{"version":"${{ github.sha }}","commit":"${{ github.sha }}","branch":"${{ github.ref_name }}"}'
```

### 3. Mac Polling Script

**Файл:** `scripts/deploy-watch.sh`

- Polling каждые 5 секунд
- Использует `terminal-notifier` (или osascript fallback)
- Хранит last_check в `/tmp/deploy-watch-last`

### 4. iTerm2 Integration

**Файл:** `scripts/dev-full.py`

Панель `🔔 Deploy` добавлена в Tab 1 (Local Dev) рядом с Tunnel.

---

## 🚀 Использование

### Запуск мониторинга

```bash
make deploy-watch
```

Или автоматически через:

```bash
make dev-full  # Включает панель 🔔 Deploy
```

### Остановка

`Ctrl+C` в терминале.

---

## ⚙️ Настройка

### 1. Локальная разработка

Добавь в `.env`:

```bash
DEPLOY_WEBHOOK_TOKEN=<твой-токен>
```

### 2. Production

Добавь в `.env.production` и синхронизируй:

```bash
echo "DEPLOY_WEBHOOK_TOKEN=<токен>" >> .env.production
make prod-sync-env
make prod-restart
```

### 3. GitHub Secrets

Добавь секрет `DEPLOY_WEBHOOK_TOKEN` в репозитории:
`Settings → Secrets and variables → Actions → New repository secret`

### 4. Mac

```bash
brew install terminal-notifier
```

---

## 🔐 Безопасность

- Токен передаётся в заголовке `X-Deploy-Token`
- Без токена запросы отклоняются с 401 Unauthorized
- Генерация токена: `openssl rand -hex 16`

---

## 🧪 Тестирование

### Локальный тест

```bash
# Запусти API локально
make api

# В другом терминале — отправь тестовый webhook
curl -X POST "http://localhost:8080/api/deploy-webhook" \
  -H "X-Deploy-Token: $DEPLOY_WEBHOOK_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"version":"test-v1","commit":"abc123","branch":"main"}'

# Проверь статус
curl -H "X-Deploy-Token: $DEPLOY_WEBHOOK_TOKEN" \
  "http://localhost:8080/api/deploy-status"
```

### E2E тест

1. Запусти `make deploy-watch`
2. Сделай push в main
3. Дождись GitHub Actions → должно прийти уведомление

---

## 📁 Файлы

| Путь | Описание |
|------|----------|
| `backend/internal/api/webhook.go` | Backend хендлеры |
| `scripts/deploy-watch.sh` | Mac polling script |
| `scripts/dev-full.py` | iTerm2 layout с панелью Deploy |
| `.github/workflows/deploy.yml` | GitHub Actions step |
| `Makefile` | Команда `deploy-watch` |

---

## 🔄 Расширение

### Telegram уведомления (planned)

В бэклоге есть задача добавить также Telegram уведомления:
- Добавить step в GitHub Actions
- Отправлять сообщение админу через бота

### Redis storage (optional)

Сейчас используется in-memory storage. При необходимости можно перейти на Redis:
- Добавить Redis клиент в `cmd/api/main.go`
- Заменить `DeployStore` на Redis SET/GET
