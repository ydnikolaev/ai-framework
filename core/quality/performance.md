# ⚡ Performance Audit & Rules

> Роль: Ты — Performance Engineer. Твоя задача — обеспечить быструю загрузку и отзывчивый интерфейс.

---

## 🎯 Целевые метрики

| Метрика | Target | Critical |
|---------|--------|----------|
| **LCP** (Largest Contentful Paint) | < 2.5s | < 4s |
| **FID** (First Input Delay) | < 100ms | < 300ms |
| **CLS** (Cumulative Layout Shift) | < 0.1 | < 0.25 |
| **TTI** (Time to Interactive) | < 3.8s | < 7.3s |
| **Bundle Size** (JS) | < 200KB gzip | < 500KB |
| **API Response** | < 200ms | < 1s |

---

## 🖼️ Изображения

### DO's ✅
- **Lazy Loading:** Используй `loading="lazy"` для всех изображений ниже fold
- **Responsive Images:** `srcset` для разных размеров экрана
- **Modern Formats:** WebP с fallback на JPEG
- **CDN:** Храни изображения на CDN (не в репозитории)
- **Placeholder:** Skeleton или blur-up во время загрузки

### DON'Ts ❌
- НЕ загружай изображения > 500KB
- НЕ используй PNG для фотографий
- НЕ загружай изображения вне viewport на первом рендере

### Пример
```vue
<img 
  :src="movie.poster_url"
  loading="lazy"
  decoding="async"
  @error="showFallback = true"
>
```

---

## 📦 Bundle Size

### Анализ
```bash
# Nuxt
npx nuxi analyze

# Vite
npx vite-bundle-visualizer
```

### Оптимизация
1. **Tree Shaking:** Импортируй только нужные функции
   ```typescript
   // ❌ Bad
   import _ from 'lodash'
   
   // ✅ Good
   import debounce from 'lodash/debounce'
   ```

2. **Code Splitting:** Разбивай по роутам (Nuxt делает автоматически)

3. **Dynamic Imports:** Для тяжёлых компонентов
   ```typescript
   const HeavyComponent = defineAsyncComponent(() => 
     import('./HeavyComponent.vue')
   )
   ```

---

## 🗄️ База данных

### Индексы
- Индексируй все колонки в `WHERE` и `ORDER BY`
- Композитные индексы для частых комбинаций
- `EXPLAIN ANALYZE` для всех медленных запросов (> 100ms)

### Запросы
```sql
-- ❌ Bad: N+1 проблема
SELECT * FROM movies WHERE user_id = ?
-- Потом в цикле: SELECT * FROM reviews WHERE movie_id = ?

-- ✅ Good: JOIN или подзапрос
SELECT m.*, r.* FROM movies m
LEFT JOIN reviews r ON r.movie_id = m.id
WHERE m.user_id = ?
```

### Пагинация
```sql
-- ❌ Bad: OFFSET (медленно на больших данных)
SELECT * FROM movies ORDER BY id LIMIT 20 OFFSET 1000

-- ✅ Good: Cursor-based
SELECT * FROM movies WHERE id > ? ORDER BY id LIMIT 20
```

---

## 🔄 Кэширование

### Frontend
- **SWR Pattern:** Показывай кэш, обновляй в фоне
- **localStorage:** Для редко меняющихся данных (настройки)
- **Service Worker:** Для оффлайн-режима (если нужен)

### Backend
- **Redis:** Для сессий и частых запросов
- **HTTP Cache Headers:** `Cache-Control`, `ETag`
- **CDN:** Для статики и изображений

---

## 📊 Мониторинг

### Инструменты
- **Lighthouse:** В DevTools или CLI
- **Web Vitals:** Библиотека для real-user metrics
- **Telegram Debug:** `Telegram.WebApp.showAlert(ms)` для замера времени

### Логирование
```typescript
// Замер времени API
const start = performance.now()
await fetchMovies()
console.log(`API took: ${performance.now() - start}ms`)
```

---

## ✅ Чеклист перед релизом

- [ ] Bundle < 200KB gzip
- [ ] Все изображения lazy-loaded
- [ ] API ответы < 200ms
- [ ] Нет N+1 запросов
- [ ] Lighthouse score > 90
- [ ] Skeleton/loading states везде

## 📂 Аудиты
Отчеты по производительности складывай в `/project/audits/performance/`.
