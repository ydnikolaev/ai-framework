# 🐳 Docker Best Practices

> Роль: Ты — DevOps Engineer. Твоя задача — создавать оптимизированные и безопасные Docker образы.

---

## 📦 Структура проекта

```text
project/
├── docker-compose.yml          # Для разработки
├── docker-compose.prod.yml     # Для продакшена
├── .dockerignore               # Что не копировать
│
├── backend/
│   └── Dockerfile
│
└── frontend/
    └── Dockerfile
```

---

## 🔧 Dockerfile: Go Backend

```dockerfile
# Build stage
FROM golang:1.23-alpine AS builder

WORKDIR /app

# Кэшируем зависимости
COPY go.mod go.sum ./
RUN go mod download

# Копируем код и собираем
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /app/server ./cmd/api

# Production stage
FROM alpine:3.19

# Безопасность: не root
RUN adduser -D -g '' appuser
USER appuser

WORKDIR /app
COPY --from=builder /app/server .

EXPOSE 8080
CMD ["./server"]
```

---

## 🔧 Dockerfile: Nuxt Frontend

```dockerfile
# Build stage
FROM node:20-alpine AS builder

WORKDIR /app

# Кэшируем зависимости
COPY package*.json ./
RUN npm ci

# Копируем код и собираем
COPY . .
RUN npm run build

# Production stage
FROM node:20-alpine

WORKDIR /app

# Копируем только необходимое
COPY --from=builder /app/.output ./.output
COPY --from=builder /app/package*.json ./

EXPOSE 3000
CMD ["node", ".output/server/index.mjs"]
```

---

## 📋 .dockerignore

```
# Dependencies
node_modules/
vendor/

# Build artifacts
.output/
.nuxt/
dist/
*.exe

# Development
.env*
.git/
.github/
*.md
Makefile

# IDE
.idea/
.vscode/
*.swp
```

---

## 🔄 Docker Compose: Development

```yaml
# docker-compose.yml
services:
  api:
    build: ./backend
    ports:
      - "8080:8080"
    environment:
      - DATABASE_URL=postgres://user:pass@db:5432/app
    depends_on:
      - db
    volumes:
      - ./backend:/app  # Hot reload

  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    volumes:
      - ./frontend:/app
      - /app/node_modules

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
      POSTGRES_DB: app
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

---

## 🚀 Docker Compose: Production

```yaml
# docker-compose.prod.yml
services:
  api:
    build: ./backend
    restart: unless-stopped
    env_file: .env
    networks:
      - internal
      - web
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.api.rule=Host(`api.domain.com`)"
      - "traefik.http.routers.api.tls.certresolver=letsencrypt"
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

  frontend:
    build: ./frontend
    restart: unless-stopped
    networks:
      - internal
      - web
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.frontend.rule=Host(`domain.com`)"

  db:
    image: postgres:16-alpine
    restart: unless-stopped
    env_file: .env
    networks:
      - internal
    volumes:
      - postgres_data:/var/lib/postgresql/data

networks:
  internal:
  web:
    external: true

volumes:
  postgres_data:
```

---

## ✅ Docker Checklist

### Безопасность
- [ ] Non-root user в контейнере
- [ ] Минимальный базовый образ (alpine)
- [ ] Нет секретов в образе
- [ ] Multi-stage build

### Оптимизация
- [ ] .dockerignore настроен
- [ ] Слои кэшируются правильно (COPY package.json BEFORE code)
- [ ] Размер образа < 200MB

### Production
- [ ] restart: unless-stopped
- [ ] Логи ограничены (10m x 3)
- [ ] Health checks настроены
- [ ] Networks разделены (internal vs web)
