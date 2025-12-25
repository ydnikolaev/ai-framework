# 🏗️ Infrastructure

> **Server-level конфигурации для всех проектов.**
>
> Не привязано к конкретному проекту — устанавливается один раз на сервер.

---

## 📂 Структура

```
infrastructure/
├── traefik/           # Shared Traefik (reverse proxy)
│   ├── README.md
│   ├── docker-compose.yml
│   ├── traefik.yml
│   └── .env.example
│
├── server-setup/      # Первичная настройка сервера
│   ├── README.md
│   └── cloud-init.yaml
│
└── multi-project/     # Как добавлять проекты
    └── README.md
```

---

## 🚀 Quick Start

### Первый сервер

1. **Создай VPS** с cloud-init из `server-setup/cloud-init.yaml`
2. **Установи Traefik:**
   ```bash
   ssh deploy@YOUR_IP
   mkdir -p ~/traefik && cd ~/traefik
   # Скопируй файлы из infrastructure/traefik/
   docker network create traefik-public
   docker compose up -d
   ```

### Добавить новый проект

См. → [multi-project/README.md](multi-project/README.md)

---

## 📋 Навигация

| Задача | Документ |
|--------|----------|
| Настроить новый сервер | `server-setup/README.md` |
| Установить Traefik | `traefik/README.md` |
| Добавить проект на сервер | `multi-project/README.md` |
