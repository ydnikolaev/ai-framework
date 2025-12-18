# 🔔 Deploy Notifications

> macOS уведомления о деплое через SSH polling. **Framework-agnostic** — работает с любым проектом.

---

## 📋 Обзор

Система позволяет получать **macOS уведомления** когда GitHub Actions успешно задеплоил код на продакшн.

### Архитектура (SSH File-Based)

```
GitHub Actions → SSH → echo "data" > ~/project/deploys/last
                                         │
                                         ▼
Mac polling → ssh server "cat ~/project/deploys/last" → terminal-notifier
```

**Преимущества:**
- ✅ **Framework-agnostic** — работает с Go, Node, Python, etc.
- ✅ **Нет бэкенд-кода** — только файл на сервере
- ✅ **Использует существующий SSH доступ** — не нужны токены API

---

## 🚀 Использование

### Запуск мониторинга

```bash
make deploy-watch
```

Или автоматически через:

```bash
make dev-full  # Панель 🔔 Deploy в iTerm2
```

### Остановка

`Ctrl+C` в терминале.

---

## ⚙️ Настройка

### 1. Env переменные

В `.env` должны быть:

```bash
PROD_SERVER=deploy@your-server.com
PROD_DIR=your-project
```

### 2. Mac

```bash
brew install terminal-notifier
```

**Для DND bypass:** `System Settings → Focus → Do Not Disturb → Allowed Apps` → добавить Terminal/iTerm2.

### 3. GitHub Actions

Добавить step в `deploy.yml`:

```yaml
- name: Notify Deploy (File-based)
  if: success()
  uses: appleboy/ssh-action@v1.0.3
  with:
    host: ${{ secrets.SSH_HOST }}
    username: ${{ secrets.SSH_USER }}
    key: ${{ secrets.SSH_KEY }}
    port: ${{ env.SSH_PORT }}
    script: |
      mkdir -p ~/your-project/deploys
      echo "${{ github.sha }}|${{ github.sha }}|${{ github.ref_name }}|$(date -u +%Y-%m-%dT%H:%M:%SZ)" > ~/your-project/deploys/last
```

---

## 📁 Файлы

| Путь | Описание |
|------|----------|
| `scripts/deploy-watch.sh` | Mac polling script (SSH-based) |
| `scripts/dev-full.py` | iTerm2 layout с панелью Deploy |
| `.github/workflows/deploy.yml` | GitHub Actions step |
| `Makefile` | Команда `deploy-watch` |

---

## 🧪 Тестирование

### Локальный тест

```bash
# Создай файл на сервере вручную
ssh $PROD_SERVER "mkdir -p ~/$PROD_DIR/deploys && echo 'test|abc123|main|2025-12-19T00:00:00Z' > ~/$PROD_DIR/deploys/last"

# Запусти мониторинг
make deploy-watch
# Должно прийти уведомление
```

### E2E тест

1. Запусти `make deploy-watch`
2. Сделай push в main
3. Дождись GitHub Actions → должно прийти уведомление

---

## 🔄 Расширение (Planned)

### Telegram уведомления

В бэклоге есть задача добавить также Telegram уведомления для мобильных устройств.
