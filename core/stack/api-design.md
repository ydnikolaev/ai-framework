# 🔌 REST API Design Guidelines

> **Роль:** Ты — API Architect, специализирующийся на RESTful API design.

---

## 1. URL Structure

```
GET    /api/v1/movies           # List
GET    /api/v1/movies/:id       # Get one
POST   /api/v1/movies           # Create
PUT    /api/v1/movies/:id       # Update (full)
PATCH  /api/v1/movies/:id       # Update (partial)
DELETE /api/v1/movies/:id       # Delete
```

### Правила

- **Существительные во множественном числе:** `/movies`, не `/movie`
- **Lowercase + hyphens:** `/user-profiles`, не `/userProfiles`
- **Никаких глаголов в URL:** `/movies`, не `/getMovies`
- **Вложенность max 2 уровня:** `/users/:id/movies`, не `/users/:id/movies/:id/comments`

---

## 2. Response Format

### Success

```json
{
  "data": { ... },
  "meta": {
    "total": 100,
    "page": 1,
    "limit": 20
  }
}
```

### Error

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid email format",
    "details": [
      { "field": "email", "message": "must be valid email" }
    ]
  }
}
```

---

## 3. HTTP Status Codes

| Code | Когда использовать |
|------|--------------------|
| 200 | OK — успешный GET/PUT/PATCH |
| 201 | Created — успешный POST |
| 204 | No Content — успешный DELETE |
| 400 | Bad Request — невалидные данные |
| 401 | Unauthorized — нет/невалидный токен |
| 403 | Forbidden — нет прав |
| 404 | Not Found — ресурс не найден |
| 409 | Conflict — дубликат |
| 422 | Unprocessable Entity — бизнес-логика ошибка |
| 500 | Internal Server Error — баг на сервере |

---

## 4. Error Codes (project-specific)

```go
const (
    ErrValidation    = "VALIDATION_ERROR"
    ErrNotFound      = "NOT_FOUND"
    ErrUnauthorized  = "UNAUTHORIZED"
    ErrForbidden     = "FORBIDDEN"
    ErrConflict      = "CONFLICT"
    ErrInternal      = "INTERNAL_ERROR"
    ErrExternalAPI   = "EXTERNAL_API_ERROR"  // TMDB, KP failed
)
```

---

## 5. Pagination

### Query params

```
GET /movies?page=2&limit=20&sort=-created_at
```

| Param | Description |
|-------|-------------|
| `page` | Номер страницы (1-indexed) |
| `limit` | Записей на страницу (max 100) |
| `sort` | Поле сортировки (- = desc) |

### Response meta

```json
{
  "meta": {
    "total": 150,
    "page": 2,
    "limit": 20,
    "pages": 8
  }
}
```

---

## 6. Filtering

```
GET /movies?year=2024&genre=thriller&rating_min=7.5
```

- Используй query params для фильтров
- Для range: `_min`, `_max` суффиксы
- Для поиска: `q` или `search`

---

## 7. Versioning

```
/api/v1/movies    # Version in URL (preferred)
```

**НЕ ломай** существующие endpoints без bump версии.
