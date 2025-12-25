# 🖥️ Server Setup

> Первичная настройка VPS для проектов.

---

## Требования

| Параметр | Минимум | Рекомендуется |
|----------|---------|---------------|
| OS | Ubuntu 22.04+ | Ubuntu 24.04 |
| CPU | 1 vCPU | 2 vCPU |
| RAM | 1 GB (со swap) | 2 GB |
| Disk | 20 GB SSD | 40 GB SSD |

---

## Quick Start

### 1. Создание VPS

При создании VPS в панели хостинга (Timeweb, DO, etc.) вставь содержимое `cloud-init.yaml` в поле **User Data** / **Cloud-init**.

Это автоматически:
- Установит Docker & Docker Compose
- Создаст пользователя `deploy`
- Настроит firewall (80, 443, SSH)
- Добавит 2GB swap

### 2. После загрузки

```bash
# Подключись под deploy
ssh deploy@YOUR_IP

# Проверь Docker
docker --version
docker compose version

# Установи Traefik (см. ../traefik/README.md)
```

---

## SSH Key

**Перед созданием сервера** добавь свой public key в `cloud-init.yaml`:

```yaml
ssh_authorized_keys:
  - ssh-rsa AAAAB3Nza... your-email@example.com
```

Получить свой ключ:
```bash
cat ~/.ssh/id_rsa.pub
```

---

## Firewall

По умолчанию открыты только:

| Порт | Назначение |
|------|------------|
| 22 | SSH |
| 80 | HTTP (→ HTTPS redirect) |
| 443 | HTTPS |

Traefik Dashboard (8080) **не открыт** снаружи. Доступ через SSH tunnel:

```bash
ssh -L 8080:localhost:8080 deploy@YOUR_IP
# Открой http://localhost:8080
```
