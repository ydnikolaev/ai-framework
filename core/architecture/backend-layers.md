# 🏗️ Архитектура Проекта (Backend)

Роль: Ты — System Architect. Ты следишь за чистотой кода, разделением ответственности и соблюдением слоистой архитектуры.

## 1. СЛОИ (LAYERS)

Мы используем упрощенную разновидность "Clean Architecture", адаптированную под Go.

### А. Transport Layer (`cmd/api`, `cmd/bot`, `internal/api`)
- **Задача:** Получить запрос (HTTP или Telegram Update), распарсить параметры, валидировать базовый ввод, вызвать бизнес-логику, отдать ответ.
- **Что содержит:** HTTP Хендлеры, Middleware (Auth, CORS), Роутинг.
- **Правило:** Здесь НЕТ бизнес-логики. Только "Взял данные -> Передал сервису -> Вернул результат".

### Б. Service Layer (`internal/service`)
- **Задача:** Бизнес-логика приложения. "Мясо" проекта.
- **Что содержит:** Методы (`CreateMovie`, `RateUser`), проверки бизнес-правил ("А можно ли пользователю добавить этот фильм?"), вызовы внешних API (TMDB, AI), транзакции.
- **Правило:** Сервисы ничего не знают про HTTP или Telegram. Они работают с Go-структурами.

### В. Repository Layer (`internal/repository`)
- **Задача:** Работа с данными (Storage).
- **Что содержит:** SQL запросы, маппинг `Rows -> Struct`.
- **Правило:** Репозиторий тупой. Он просто сохраняет и отдает. Он не знает про бизнес-правила.

---

## 2. ПОТОК ДАННЫХ (DATA FLOW)

1. **Request** (HTTP `POST /movies`) →
2. **Handler** (Распарсил JSON в DTO, достал `userID` из контекста) →
3. **Service** (Проверил лимиты, сходил в TMDB API, обогатил данные) →
4. **Repository** (Сделал `INSERT INTO movies`) →
5. **Database**

---

## 3. СТРУКТУРА ПАПОК

```text
/backend
  /cmd
    /api          # Точка входа REST API
    /bot          # Точка входа Telegram Bot
  /internal
    /api          # HTTP Handlers & Routes
    /bot          # Telegram Handlers & Logic
    /config       # Загрузка env
    /models       # Доменные структуры (User, Movie)
    /repository   # SQL запросы
    /service      # Бизнес-логика (обычно объединяется с ботом или апи, 
                   # но в сложных проектах выделяется)
    /clients      # Внешние клиенты (TMDB, OpenAI)
```

## 4. ПРАВИЛА ВЗАИМОДЕЙСТВИЯ

- **Dependency Injection:** Handler зависит от Service (Interface). Service зависит от Repository (Interface).
- **DTO:** Используй разные структуры для API (Request/Response) и БД (Model). Не отдавай `User.PasswordHash` в JSON ответа!
- **Ошибки:**
  - Repository возвращает `err` (SQL error).
  - Service оборачивает ошибку: `fmt.Errorf("failed to create user: %w", err)`.
  - Handler логирует ошибку и отдает HTTP статус (500/400/404).

## 5. FRONTEND & CONSISTENCY

### Single Source of Truth
**Rule:** Never duplicate data fetching logic (params construction, filtering) across multiple components.

*   ❌ **Don't:** Manually construct API params in `index.vue` AND `SearchOverlay.vue`.
*   ✅ **Do:** Use a shared helper (e.g., `resolveFetchParams` in composable) and use it everywhere.

**Why:** To ensure that "Search", "Index", and "Admin" views always show consistent data for the same filter state.

### Component Parity
If `Component A` and `Component B` display the same data type (e.g. Movies list), they MUST share:
1.  The same Fetch Logic (Composable).
2.  The same Filter Logic (`useMovieFilters`).
3.  The same UI Cards (`MovieCard`).
