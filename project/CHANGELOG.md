# 📜 Changelog — KinoBot

> История значимых изменений проекта.

---

## [Unreleased]

### Added
- **Deploy Notifications**: macOS уведомления о деплое через webhook + polling
  - Backend: `/api/deploy-webhook` и `/api/deploy-status` эндпоинты
  - Mac: `make deploy-watch` команда + `scripts/deploy-watch.sh`
  - GitHub Actions: автоматическая отправка webhook после деплоя
  - iTerm2: `🔔 Deploy` панель в `make dev-full`
- **DX Process Management**: Команды для управления dev-процессами
  - `make bot-stop` — остановить все процессы бота (включая Go бинарники)
  - `make dev-stop` — остановить всё dev-окружение
  - `make dev-restart` — перезапустить dev-окружение
  - `make dev-full` теперь автоматически вызывает `dev-stop` перед стартом
- **AI-Framework DX Reorganization**:
  - Новая папка `core/dx/` для DX-документации
  - `_INDEX.md` файлы в каждой папке `core/` для быстрой навигации
  - `development-rules.md` — правила при добавлении make-команд

### Fixed
- **Bot Conflict Fix**: `bot-stop` теперь убивает и скомпилированные Go бинарники (`/exe/bot`, `go-build/bot`)

---

## [0.5.5] - 2025-12-18 (Hotfix)

### Fixed
- Исправлен порядок миграций (переименованы 000xxx → 007-010)
- Исправлен DATABASE_URL hostname в продакшн (postgres вместо db)
- Удален spammy лог "No .env file found" из продакшн логов

---

## [0.5.4] - 2025-12-18

### Fixed
- **Network**: Forced IPv4 usage for all HTTP clients (resolved `connect: connection refused` ipv6 errors on Docker).

---

## [0.5.3] - 2025-12-18

### Fixed
- **DB Migrations**: Now idempotent (checking `IF NOT EXISTS`), preventing errors on container restart.
- **Secrets Management**: Unified Google Cloud credentials path and added secure injection via GitHub Secrets.
- **Vision API**: Fixed "credentials file not found" warning on production.

### Added
- **Deployment Docs**: Added guide for managing file-based secrets.
- **Docker Production**: Added volume mounts for secrets directory.

---

## [0.5.2] - 2025-12-18

### Changed
- **iTerm2 Scripts rewritten to Python API** — более надёжно чем AppleScript
- **Smart Monitor Detection** — окно открывается на полный экран на внешнем мониторе
- **Configurable via .env** — `PROD_SERVER` и `PROD_DIR` из переменных окружения
- **Directory reuse** — все панели открываются в папке проекта

### Added
- Новые зависимости: `pip install iterm2 pyobjc-framework-Cocoa python-dotenv`
- `.env.example` обновлён с `PROD_SERVER` и `PROD_DIR`

---

## [0.5.1] - 2025-12-18

### Added
- **DX Automation Scripts:**
  - `make dev-full` — расширенная разработка (3x2 grid + DB logs + status)
  - `make prod-watch` — мониторинг прода в iTerm2 (2x2 grid с логами)
  - `make prod-logs-api/bot` — быстрый доступ к логам
  - `make prod-status` — статус контейнеров
- **Pretty output scripts:**
  - `dx-logs.sh` — универсальные логи с цветами (container_name)
  - `dx-prod-status.sh` — красивый статус-дашборд
  - `dx-db-logs.sh`, `dx-status.sh` — локальные dev-скрипты
- **AI-Framework improvements:**
  - Merged `nuxt-conventions.md` into `nuxt-vue.md`
  - Moved API docs to `docs/` folder
  - New `api-design.md` — REST conventions

---

## [0.5.0] - 2025-12-18

### Added
- **DX Logger package** (`backend/pkg/dxlog`) — красивые логи с разделителями, цветами, таймерами
- **iTerm2 multi-pane launcher** (`make dev`) — автоматический запуск 4 панелей: bot, api, frontend, tunnel
- **AI-Framework DX templates:**
  - `templates/go/dxlog/` — Go logging utilities
  - `templates/make/dx.mk` — Makefile log functions
  - `templates/shell/dxlog.sh` — Bash log utilities
- `setup.sh` автоматически копирует dxlog при инициализации проекта
- `make dev-docker` — Docker Compose workflow (старое поведение `make dev`)
- **Vision API improvements:**
  - `cleanEntity()` — очистка generic prefixes ("poster X" → "X")
  - Расширен OCR фильтр UI-элементов
- **KP Enrichment fallback** — Unofficial API при ошибке 403
- **JustWatch URL parsing** — поддержка slug для поиска
- **YouTube/IMDb video** → AI extraction вместо парсинга
- `project/testing/` папка для хранения тестов

### Changed
- `make dev` теперь открывает iTerm2 с 4 панелями
- API startup использует dxlog (Box + Success/Fail)

### Fixed
- Session context pollution между запросами (URLs не сохраняются)
- Generic entity detection в Vision API

---

## [0.4.0] - 2025-12-18

### Added
- **Smart Fallback Search**: Автоматический поиск по оригинальному запросу, если AI вернул некорректные данные или фильм не найден в базах.
- **Kinopoisk Unofficial API**: Вторичный источник данных для повышения надежности поиска (рейтинги, постеры).
- **Duplicate Prevention**: Уникальные индексы и миграция для удаления дубликатов фильмов и связей.
- **User Feedback**: Явное уведомление "Сохранено" vs "Обновлено" при добавлении фильмов.

### Fixed
- Дублирование карточек фильмов в списках.
- Ошибка "mismatched param count" при сохранении.
- Отсутствие рейтингов IMDB при поиске через fallback.
- Обработка галлюцинаций AI (вымышленные фильмы, неправильные годы).

---

## [0.3.0] - 2025-12-17

### Added
- Admin interface (stats, users, groups)
- Premium poster fallback design
- Dynamic filter visibility

### Changed
- Profile menu cleanup (admin-only links)
- useTelegram refactored to singleton

### Fixed
- Avatar persistence in database
- Photo_url sync from Telegram
- Poster fallback for missing images
- Vue lifecycle warning in composables

---

## [0.2.0] - 2025-12-16

### Added
- Kinopoisk API integration
- Dual rating display (KP + IMDB)
- Safe area handling for fullscreen

### Changed
- SSR disabled (`ssr: false`)
- Traefik configuration updated

### Fixed
- Encoded slash in URLs (Traefik)
- Auth flow with initData

---

## [0.1.0] - 2025-12-15

### Added
- Initial deployment to Timeweb VPS
- GitHub Actions CI/CD
- Basic movie CRUD
- Telegram Bot + Mini App integration
- TMDB API integration
