# Nuxt 4 — Documentation

> **Version:** 4.0  
> **Last Updated:** 2025-12-17  
> **Source:** https://nuxt.com/docs

---

## 📋 Обзор

Nuxt — full-stack Vue.js фреймворк с:
- Auto-imports (components, composables, utils)
- File-based routing
- SSR/SSG/SPA modes
- Nitro server engine

---

## 📦 Конфигурация

```typescript
// nuxt.config.ts
export default defineNuxtConfig({
  // Для Telegram Mini Apps
  ssr: false,
  
  // TypeScript
  typescript: {
    typeCheck: false  // В Docker может падать
  },
  
  // Nitro
  nitro: {
    preset: 'node-server'
  },
  
  // Dev Server
  devServer: {
    host: '0.0.0.0'  // --host
  }
})
```

---

## 🔄 Data Fetching

### useFetch (в setup)
```typescript
const { data, pending, error, refresh } = await useFetch('/api/movies')
```

### $fetch (в функциях)
```typescript
const handleClick = async () => {
  const result = await $fetch('/api/movies', {
    method: 'POST',
    body: { title: 'Inception' }
  })
}
```

---

## 🧩 Composables

```typescript
// composables/useMovies.ts
export const useMovies = () => {
  const movies = ref<Movie[]>([])
  
  const fetchMovies = async () => {
    movies.value = await $fetch('/api/movies')
  }
  
  return { movies, fetchMovies }
}
```

**Важно:** Для singleton-данных выносите `ref()` на уровень модуля.

---

## 📁 Структура

```text
├── app.vue           # Root component
├── pages/            # File-based routing
├── components/       # Auto-imported
├── composables/      # Auto-imported (use*.ts)
├── layouts/          # Layout components
├── middleware/       # Route middleware
├── plugins/          # Nuxt plugins
├── server/           # API routes (Nitro)
└── public/           # Static files
```

---

## 🔗 Полезные ссылки

- [Nuxt Docs](https://nuxt.com/docs)
- [Nuxt Modules](https://nuxt.com/modules)
- [Nuxt DevTools](https://devtools.nuxt.com/)
