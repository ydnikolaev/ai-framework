# 🔄 Multi-Project Deployment

> Как добавлять несколько проектов на один сервер.

---

## Архитектура

```
~/                              # Home directory on server
├── traefik/                    # Shared Traefik (один на сервер)
│   ├── docker-compose.yml
│   ├── dynamic.yml             # Dev tunnels для ВСЕХ проектов
│   └── letsencrypt/
│
├── kinobot/                    # Проект 1
│   ├── docker-compose.prod.yml
│   ├── .env
│   └── ...
│
├── newbot/                     # Проект 2
│   ├── docker-compose.prod.yml
│   ├── .env
│   └── ...
│
└── thirdbot/                   # Проект 3
    └── ...
```

---

## Добавление нового проекта

### 1. Деплой через GitHub Actions

```bash
# GitHub Action автоматически создаст ~/PROJECT_NAME
git push origin main
```

### 2. Проверить контейнеры

```bash
ssh deploy@SERVER
docker ps  # Должны быть: traefik + project_bot + project_api + project_frontend
```

### 3. Настроить dev tunnel (опционально)

Добавить в `~/traefik/dynamic.yml`:

```yaml
http:
  routers:
    newbot-dev:
      rule: "Host(`dev.newdomain.ru`)"
      service: "newbot-dev-service"
      entryPoints: ["websecure"]
      tls:
        certResolver: "letsencrypt"

  services:
    newbot-dev-service:
      loadBalancer:
        servers:
          - url: "http://host.docker.internal:31339"  # Уникальный порт!
```

---

## Правила

### Уникальные порты для SSH tunnels

| Проект | Frontend Tunnel | API Tunnel |
|--------|-----------------|------------|
| kinobot | 31337 | 31338 |
| newbot | 31339 | 31340 |
| thirdbot | 31341 | 31342 |

### Уникальные router names

```yaml
# ✅ Правильно
traefik.http.routers.kinobot-api.rule=...
traefik.http.routers.newbot-api.rule=...

# ❌ Неправильно (конфликт)
traefik.http.routers.api.rule=...
```

### Уникальные container names

```yaml
# docker-compose.prod.yml
container_name: ${PROJECT_NAME}_bot  # kinobot_bot, newbot_bot, etc.
```

---

## Ресурсы сервера

| Проекты | RAM (рекомендуется) |
|---------|---------------------|
| 1-2 | 2 GB |
| 3-4 | 4 GB |
| 5+ | 8 GB |

> **Совет:** Мониторь через `htop` или `docker stats`
