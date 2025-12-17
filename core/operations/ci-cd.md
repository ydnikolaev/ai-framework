# 🔄 CI/CD with GitHub Actions

> Роль: Ты — DevOps Engineer. Твоя задача — автоматизировать тестирование и деплой.

---

## 📂 Структура

```text
.github/
└── workflows/
    ├── ci.yml      # Тесты на каждый PR
    └── deploy.yml  # Деплой при push в main
```

---

## 🧪 CI Pipeline (ci.yml)

```yaml
name: CI

on:
  pull_request:
    branches: [main]
  push:
    branches: [main]

jobs:
  lint-backend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: actions/setup-go@v5
        with:
          go-version: '1.23'
      
      - name: golangci-lint
        uses: golangci/golangci-lint-action@v4
        with:
          working-directory: backend

  lint-frontend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
          cache-dependency-path: frontend/package-lock.json
      
      - run: cd frontend && npm ci
      - run: cd frontend && npm run lint
      - run: cd frontend && npm run typecheck

  test-backend:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:16-alpine
        env:
          POSTGRES_USER: test
          POSTGRES_PASSWORD: test
          POSTGRES_DB: test
        ports:
          - 5432:5432
    steps:
      - uses: actions/checkout@v4
      
      - uses: actions/setup-go@v5
        with:
          go-version: '1.23'
      
      - name: Run tests
        run: cd backend && go test -v ./...
        env:
          DATABASE_URL: postgres://test:test@localhost:5432/test?sslmode=disable

  test-frontend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
          cache-dependency-path: frontend/package-lock.json
      
      - run: cd frontend && npm ci
      - run: cd frontend && npm run test
```

---

## 🚀 Deploy Pipeline (deploy.yml)

```yaml
name: Deploy

on:
  push:
    branches: [main]

env:
  SSH_PORT: ${{ secrets.SSH_PORT || '22' }}

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Copy files to server
        uses: appleboy/scp-action@v0.1.7
        with:
          host: ${{ secrets.SSH_HOST }}
          username: ${{ secrets.SSH_USER }}
          key: ${{ secrets.SSH_KEY }}
          port: ${{ env.SSH_PORT }}
          source: "."
          target: "~/project"
          rm: true
          strip_components: 0

      - name: Deploy
        uses: appleboy/ssh-action@v1.0.3
        with:
          host: ${{ secrets.SSH_HOST }}
          username: ${{ secrets.SSH_USER }}
          key: ${{ secrets.SSH_KEY }}
          port: ${{ env.SSH_PORT }}
          script: |
            cd ~/project
            
            # Проверяем .env
            if [ ! -f .env ]; then
              echo "❌ .env not found!"
              exit 1
            fi
            
            # Rebuild and restart
            docker compose -f docker-compose.prod.yml up -d --build --force-recreate
            
            # Cleanup old images
            docker image prune -f
            
            echo "✅ Deployed successfully!"
```

---

## 🔐 GitHub Secrets

Настрой в `Settings → Secrets and variables → Actions`:

| Secret | Description |
|--------|-------------|
| `SSH_HOST` | IP адрес сервера |
| `SSH_USER` | Пользователь (e.g., `deploy`) |
| `SSH_KEY` | Приватный SSH ключ |
| `SSH_PORT` | Порт SSH (опционально, default: 22) |

---

## 📋 Best Practices

### Кэширование
```yaml
- uses: actions/cache@v4
  with:
    path: |
      ~/.cache/go-build
      ~/go/pkg/mod
    key: go-${{ hashFiles('**/go.sum') }}
```

### Параллельные jobs
Jobs выполняются параллельно по умолчанию. Используй `needs` для зависимостей:
```yaml
deploy:
  needs: [lint-backend, lint-frontend, test-backend, test-frontend]
```

### Условное выполнение
```yaml
if: github.event_name == 'push' && github.ref == 'refs/heads/main'
```

---

## ✅ CI/CD Checklist

- [ ] Lint проходит на каждый PR
- [ ] Тесты запускаются с реальной БД (сервисы)
- [ ] Deploy только при push в main
- [ ] Секреты не в коде
- [ ] Логи deployment видны в Actions
