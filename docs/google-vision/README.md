# Google Vision API Integration

## Описание

Google Vision API используется для анализа изображений (постеры, скриншоты) и извлечения информации о фильмах.

## Возможности

1. **Web Entity Detection** — распознавание известных объектов (фильмы, актёры, постеры)
2. **OCR (Text Detection)** — извлечение текста из скриншотов
3. **Label Detection** — определение типа контента (poster, screenshot, etc.)

## Логика обработки

```
Изображение → Vision API
    ↓
┌─ Web Entities найдены?
│   ├─ Да → cleanEntity() → Поиск в Kinopoisk
│   │           ↓
│   │   Найден? → Готово ✓
│   │           ↓
│   │   Нет → Fallback to AI
│   │
│   └─ Нет → OCR текст есть?
│            ├─ Да → Фильтрация UI-элементов → Поиск в KP
│            └─ Нет → AI extraction
```

## Конфигурация

### Переменные окружения

```bash
GOOGLE_CLOUD_CREDENTIALS=secrets/service-account.json
```

### Service Account

1. Создай проект в Google Cloud Console
2. Включи Vision API
3. Создай Service Account с ролью `Vision API User`
4. Скачай JSON ключ в `backend/secrets/`

## Фильтрация

### Generic Entities (cleanEntity)

Убираем generic prefixes из Vision entities:
- "poster inside out" → "inside out"
- "screenshot netflix" → "netflix"

### UI Text Filter (OCR)

Игнорируем типичные UI-элементы:
- Navigation: "episodes", "season", "back", "next"
- Actions: "play", "subscribe", "share"
- Platforms: "netflix", "kinopoisk", "telegram"

## API Stats

Ежедневный подсчёт вызовов хранится в `backend/data/api_stats.json`.

## Troubleshooting

| Проблема | Решение |
|----------|---------|
| 403 Forbidden | Проверь Service Account permissions |
| No entities | Изображение слишком маленькое/размытое |
| Wrong movie | Entity generic → добавь в cleanEntity prefixes |
