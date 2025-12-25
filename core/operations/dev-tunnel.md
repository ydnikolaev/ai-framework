# Dev Tunnel через SSH Reverse Proxy

Гайд по настройке постоянного dev-окружения для разработки Telegram Mini App.

## Архитектура

```
┌─────────────────┐     SSH Tunnels      ┌─────────────────────────────────┐
│   Твой Mac      │ ──────────────────►  │         VPS Server              │
│                 │   -R 31337:3000      │                                 │
│  localhost:3000 │   -R 31338:8080      │  ┌─────────┐    ┌────────────┐  │
│  (Nuxt dev)     │                      │  │ Traefik │───►│ Port 31337 │  │
│                 │                      │  │         │───►│ Port 31338 │  │
│  localhost:8080 │                      │  └────┬────┘    └────────────┘  │
│  (Go API)       │                      │       │                         │
└─────────────────┘                      │  HTTPS (Let's Encrypt)          │
                                         └───────┼─────────────────────────┘
                                                 │
                                        https://dev.waydownwego.ru (Frontend)
                                        https://api-dev.waydownwego.ru (API)
```

## Быстрый старт

```bash
make dev-full  # Автоматически открывает туннели и настраивает файрвол
```

## Порты и домены

| Сервис   | Локальный порт | Туннель порт | Домен                        |
|----------|----------------|--------------|------------------------------|
| Frontend | 3000           | 31337        | dev.waydownwego.ru           |
| API      | 8080           | 31338        | api-dev.waydownwego.ru       |

## Make команды

```bash
make tunnel-front    # Открыть frontend туннель
make api-tunnel      # Открыть API туннель
make tunnel-fw-add   # Добавить IP в файрвол + очистить порты
make tunnel-fw-remove # Удалить IP из файрвола
```

## Настройка (первоначальная)

### 1. DNS записи

В панели управления доменом создай A-записи:
- `dev` → IP сервера
- `api-dev` → IP сервера

### 2. Traefik конфиг

Файл `traefik_dynamic.yml` на сервере:

```yaml
http:
  routers:
    dev-router:
      rule: "Host(`dev.waydownwego.ru`)"
      service: "dev-service"
      entryPoints: ["websecure"]
      tls:
        certResolver: "myresolver"

    api-dev-router:
      rule: "Host(`api-dev.waydownwego.ru`)"
      service: "api-dev-service"
      entryPoints: ["websecure"]
      tls:
        certResolver: "myresolver"

  services:
    dev-service:
      loadBalancer:
        servers:
          - url: "http://host.docker.internal:31337"

    api-dev-service:
      loadBalancer:
        servers:
          - url: "http://host.docker.internal:31338"
```

### 3. UFW правила

```bash
# Для Docker сетей (постоянные)
sudo ufw allow from 172.17.0.0/16 to any port 31337
sudo ufw allow from 172.17.0.0/16 to any port 31338
sudo ufw allow from 172.18.0.0/16 to any port 31337
sudo ufw allow from 172.18.0.0/16 to any port 31338
```

### 4. Frontend конфиг (.env)

```bash
DEV_API_URL=https://api-dev.waydownwego.ru/api
```

## Автоматическая настройка Firewall

При смене сети (дом → кафе) меняется IP и туннели ломаются.
`make dev-full` и `make dev-restart` автоматически:

1. Добавляют текущий IP в UFW на сервере
2. Освобождают зависшие порты 31337 и 31338
3. Запускают оба туннеля

При `make dev-stop` IP автоматически удаляется из UFW.

## Troubleshooting

### Gateway Timeout

1. Проверь, запущены ли туннели
2. Проверь, запущены ли локальные сервисы (frontend на 3000, API на 8080)
3. На сервере проверь порты: `ss -tlnp | grep -E '31337|31338'`

### Remote port forwarding failed

Порт занят старой SSH сессией. Решение:

```bash
make tunnel-fw-add  # Освободит порты автоматически
```

Или вручную:
```bash
ssh deploy@waydownwego.ru "sudo fuser -k 31337/tcp; sudo fuser -k 31338/tcp"
```

### Сменился IP (дом → кафе)

`make dev-restart` автоматически добавит новый IP.

### SSL Certificate Error

Перезапусти Traefik после добавления DNS:
```bash
ssh deploy@waydownwego.ru "docker restart traefik"
```

## iTerm2 Layout

`make dev-full` создаёт 3 вкладки:

**Tab 1: Local Dev**
```
┌─────────┬─────────┬─────────┐
│   Bot   │   API   │Frontend │
├─────────┼─────────┴─────────┤
│ DB Logs │Front │API │Deploy │
│         │Tunnel│Tun │Watch  │
└─────────┴──────┴────┴───────┘
```

**Tab 2: Prod Monitoring** — логи prod-сервисов  
**Tab 3: Docker Status** — статус контейнеров
