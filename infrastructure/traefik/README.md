# 🔀 Shared Traefik

> Единый reverse proxy для всех проектов на сервере.

---

## Зачем?

- **Один SSL** на все домены (Let's Encrypt)
- **Автоматическое обнаружение** новых контейнеров
- **Меньше ресурсов** — не нужен Traefik в каждом проекте

---

## Установка

```bash
# 1. SSH на сервер
ssh deploy@YOUR_IP

# 2. Создать директорию
mkdir -p ~/traefik && cd ~/traefik

# 3. Скопировать файлы
scp -r infrastructure/traefik/* deploy@YOUR_IP:~/traefik/

# 4. Создать сеть для проектов
docker network create traefik-public

# 5. Настроить email для SSL
cp .env.example .env
nano .env  # Указать ACME_EMAIL

# 6. Запустить
docker compose up -d
```

---

## ⚠️ Firewall для dev tunnels

После создания сети `traefik-public`, нужно открыть firewall для SSH tunnels:

```bash
# Узнать subnet сети
SUBNET=$(docker network inspect traefik-public --format '{{range .IPAM.Config}}{{.Subnet}}{{end}}')
echo "Subnet: $SUBNET"  # обычно 172.19.0.0/16

# Открыть порты для dev tunnels
sudo ufw allow from $SUBNET to any port 31337 comment "Traefik -> Frontend tunnel"
sudo ufw allow from $SUBNET to any port 31338 comment "Traefik -> API tunnel"
```

> **Зачем?** Traefik контейнер обращается к `host.docker.internal:31337` для dev tunnels. Firewall по умолчанию блокирует трафик из Docker сетей.

---

## Проверка

```bash
# Логи Traefik
docker logs -f traefik

# Проверить сеть
docker network ls | grep traefik
```

---

## Добавление проекта

Каждый проект подключается через labels:

```yaml
# project/docker-compose.prod.yml
services:
  frontend:
    networks:
      - traefik-public
      - default
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.mybot-frontend.rule=Host(`example.com`)"
      - "traefik.http.routers.mybot-frontend.entrypoints=websecure"
      - "traefik.http.routers.mybot-frontend.tls.certresolver=letsencrypt"

networks:
  traefik-public:
    external: true
```

> ⚠️ **router name должен быть уникальным** — используй префикс проекта: `mybot-frontend`, `mybot-api`

---

## Файлы

| Файл | Описание |
|------|----------|
| `docker-compose.yml` | Основной compose для Traefik |
| `traefik.yml` | Статическая конфигурация |
| `.env.example` | Переменные окружения |
