# Dev Tunnel через SSH Reverse Proxy

Этот гайд описывает настройку постоянного dev-туннеля для разработки Telegram Mini App без ngrok.

## Архитектура

```
┌─────────────────┐     SSH Tunnel      ┌─────────────────────────────────┐
│   Твой Mac      │ ──────────────────► │         VPS Server              │
│                 │   -R 31337:3000     │                                 │
│  localhost:3000 │                     │  ┌─────────┐    ┌────────────┐  │
│  (Nuxt dev)     │                     │  │ Traefik │───►│ Port 31337 │  │
└─────────────────┘                     │  └────┬────┘    └────────────┘  │
                                        │       │                          │
                                        │  HTTPS (Let's Encrypt)          │
                                        └───────┼─────────────────────────┘
                                                │
                                        https://dev.waydownwego.ru
```

## Предварительные требования

- VPS с Ubuntu 24.04 и Docker
- Traefik настроен как reverse proxy
- Домен с DNS записью `dev.yourdomain.ru` → IP сервера
- SSH доступ к серверу

## Настройка (один раз)

### 1. DNS запись

В панели управления доменом создай A-запись:
- **Хост:** `dev`
- **Значение:** IP твоего сервера

### 2. Включить GatewayPorts на сервере

```bash
ssh user@server "sudo sed -i 's/#GatewayPorts no/GatewayPorts yes/g' /etc/ssh/sshd_config && sudo systemctl restart ssh"
```

### 3. Открыть порт для Docker сетей

```bash
ssh user@server "sudo ufw allow from 172.17.0.0/16 to any port 31337"
ssh user@server "sudo ufw allow from 172.18.0.0/16 to any port 31337"
ssh user@server "sudo ufw reload"
```

### 4. Создать динамический конфиг Traefik

Файл `traefik_dynamic.yml`:

```yaml
http:
  routers:
    dev-router:
      rule: "Host(`dev.yourdomain.ru`)"
      service: "dev-service"
      entryPoints:
        - "websecure"
      tls:
        certResolver: "myresolver"

  services:
    dev-service:
      loadBalancer:
        servers:
          - url: "http://host.docker.internal:31337"
```

### 5. Обновить docker-compose.prod.yml

В секции `traefik`:

```yaml
services:
  traefik:
    # ... existing config ...
    command:
      # ... existing commands ...
      - "--providers.file.filename=/etc/traefik/dynamic_conf.yml"
      # ВАЖНО: Разрешить encoded slashes для Vite dev mode
      - "--entrypoints.web.http.encodedcharacters.allowencodedslash=true"
      - "--entrypoints.websecure.http.encodedcharacters.allowencodedslash=true"
    volumes:
      - "./traefik_dynamic.yml:/etc/traefik/dynamic_conf.yml"
    extra_hosts:
      - "host.docker.internal:host-gateway"
```

> ⚠️ **ВАЖНО:** Traefik v3.6+ по умолчанию блокирует `%2F` в URL. Без `allowencodedslash=true` Vite dev mode выдаёт 400 Bad Request.

### 6. Настроить Nuxt/Vite для туннеля

В `frontend/nuxt.config.ts`:

```typescript
vite: {
  server: {
    allowedHosts: true,
    origin: process.env.TUNNEL_URL || 'http://localhost:3000',
    fs: {
      strict: false,
      allow: ['/'],
    },
    hmr: {
      host: '0.0.0.0',
      clientPort: process.env.TUNNEL_URL ? 443 : undefined,
      protocol: process.env.TUNNEL_URL ? 'wss' : undefined,
    },
  },
},
```

### 7. Задеплоить изменения

```bash
git add traefik_dynamic.yml docker-compose.prod.yml
git commit -m "feat: setup dev tunnel"
git push origin main
```

## Использование (каждый раз при разработке)

### 1. Запустить локальный dev сервер

```bash
make frontend  # или cd frontend && npm run dev
```

### 2. Открыть туннель

```bash
ssh -R 31337:localhost:3000 deploy@waydownwego.ru -N
```

Флаги:
- `-R 31337:localhost:3000` — пробросить порт 31337 сервера на локальный 3000
- `-N` — не открывать shell, только туннель

### 3. Открыть в браузере

https://dev.waydownwego.ru

## Telegram Dev Bot

1. Создай нового бота через @BotFather (`/newbot`)
2. В настройках бота: **Menu Button** → `https://dev.waydownwego.ru`
3. Используй токен этого бота в локальном `.env`

## Автоматическая настройка Firewall

При смене сети (дом → кафе) меняется IP и туннель ломается. 
`make dev-full` и `make dev-restart` автоматически:

1. Добавляют текущий IP в UFW на сервере
2. Освобождают зависший порт 31337
3. Запускают туннель

При `make dev-stop` IP автоматически удаляется из UFW.

### Ручное управление

```bash
make tunnel-fw-add     # Добавить IP + освободить порт
make tunnel-fw-remove  # Удалить IP из UFW
```

## Troubleshooting

### Gateway Timeout

1. Проверь, запущен ли туннель: `ssh -R ...`
2. Проверь, запущен ли локальный сервер на порту 3000
3. На сервере проверь, слушает ли порт: `ss -tlnp | grep 31337`

### Туннель не слушает на 0.0.0.0

Проверь `GatewayPorts yes` в `/etc/ssh/sshd_config` и перезапусти SSH.

### Docker не достает до туннеля

Проверь UFW правила для Docker сетей (172.17.x.x и 172.18.x.x).

```bash
# Диагностика изнутри контейнера
docker exec traefik wget -qO- http://host.docker.internal:31337 --timeout=5
```

### Remote port forwarding failed

Порт 31337 занят старой SSH сессией. Решение:

```bash
make tunnel-fw-add  # Освободит порт автоматически
```

Или вручную:
```bash
ssh deploy@waydownwego.ru "sudo fuser -k 31337/tcp"
```

### Сменился IP (дом → кафе)

`make dev-restart` автоматически добавит новый IP. 

Или вручную:
```bash
make tunnel-fw-add
```

## Алиас для удобства

Добавь в `~/.zshrc`:

```bash
alias dev-tunnel="ssh -R 31337:localhost:3000 deploy@waydownwego.ru -N"
```

Теперь просто: `dev-tunnel` и работай!

