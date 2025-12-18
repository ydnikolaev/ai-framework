# Kinopoisk Unofficial API

> Справочник по API kinopoiskapiunofficial.tech

## Общая информация

- **Base URL:** `https://kinopoiskapiunofficial.tech`
- **Авторизация:** Header `X-API-KEY: {token}`
- **Rate Limit:** 20 req/sec
- **Документация:** https://kinopoiskapiunofficial.tech/documentation/api/

## Ключевые эндпоинты

### Поиск по ключевому слову
```
GET /api/v2.1/films/search-by-keyword?keyword={query}&page=1
```

**Response:**
```json
{
  "keyword": "matrix",
  "pagesCount": 1,
  "films": [
    {
      "filmId": 301,
      "nameRu": "Матрица",
      "nameEn": "The Matrix",
      "year": "1999",
      "description": "...",
      "posterUrl": "https://...",
      "posterUrlPreview": "https://...",
      "rating": "8.5"
    }
  ]
}
```

### Получить фильм по ID
```
GET /api/v2.2/films/{id}
```

**Response:**
```json
{
  "kinopoiskId": 301,
  "nameRu": "Матрица",
  "nameOriginal": "The Matrix",
  "year": 1999,
  "description": "...",
  "posterUrl": "https://...",
  "ratingKinopoisk": 8.5,
  "ratingImdb": 8.7,
  "type": "FILM",
  "countries": [...],
  "genres": [...]
}
```

### Типы контента
- `FILM` — фильм
- `TV_SERIES` — сериал
- `MINI_SERIES` — мини-сериал
- `TV_SHOW` — ТВ-шоу

## Использование в проекте

- **Primary:** `kinopoisk.dev` (основной API)
- **Fallback:** `kinopoiskapiunofficial.tech` (бесплатный резерв)

## ENV переменные
```env
KINOPOISK_UNOFFICIAL_API_KEY=your-key-here
```
