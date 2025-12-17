# 🔍 SEO Audit & Rules

> Роль: Ты — SEO Specialist. Твоя задача — обеспечить видимость в поисковых системах.

---

## ⚠️ Важно для Telegram Mini Apps

Telegram Mini Apps работают **в iframe** и обычно **не индексируются** поисковиками.

**Когда SEO важно:**
- Landing page для бота
- Публичные страницы (шеринг)
- Web-версия вне Telegram

**Когда SEO НЕ важно:**
- Контент внутри Mini App (только для авторизованных)

---

## 📋 Meta Tags Checklist

### Обязательные
```html
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Page Title — Site Name</title>
  <meta name="description" content="Описание страницы до 160 символов">
</head>
```

### Nuxt/Vue
```typescript
// В компоненте страницы
useSeoMeta({
  title: 'Page Title',
  description: 'Description here',
  ogTitle: 'Open Graph Title',
  ogDescription: 'OG Description',
  ogImage: 'https://domain.com/og-image.jpg',
})
```

---

## 📱 Open Graph (для шеринга)

```html
<meta property="og:title" content="Title">
<meta property="og:description" content="Description">
<meta property="og:image" content="https://domain.com/image.jpg">
<meta property="og:url" content="https://domain.com/page">
<meta property="og:type" content="website">
<meta property="og:site_name" content="Site Name">
```

### Требования к изображению
- Размер: 1200x630 px (Facebook) или 1200x1200 (Twitter)
- Формат: JPEG или PNG
- Размер файла: < 1MB

---

## 🐦 Twitter Cards

```html
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Title">
<meta name="twitter:description" content="Description">
<meta name="twitter:image" content="https://domain.com/image.jpg">
```

---

## 📐 Структурированные данные (JSON-LD)

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebApplication",
  "name": "KinoBot",
  "description": "Telegram бот для отслеживания фильмов",
  "url": "https://t.me/kinobot",
  "applicationCategory": "Entertainment",
  "operatingSystem": "Telegram"
}
</script>
```

### Типы для контента
- `Movie` — для страниц фильмов
- `Review` — для отзывов
- `BreadcrumbList` — для навигации

---

## 🗺️ Sitemap

### Генерация (Nuxt)
```typescript
// nuxt.config.ts
export default defineNuxtConfig({
  modules: ['@nuxtjs/sitemap'],
  sitemap: {
    hostname: 'https://your-domain.com',
  }
})
```

### robots.txt
```
User-agent: *
Allow: /
Disallow: /api/
Disallow: /admin/

Sitemap: https://your-domain.com/sitemap.xml
```

---

## 🔗 URL Structure

### Правила
- **Читаемые URL:** `/movie/inception-2010` вместо `/movie/12345`
- **Lowercase:** Всегда в нижнем регистре
- **Дефисы:** Вместо подчёркиваний
- **Канонические URL:** Указывай `<link rel="canonical">`

```html
<link rel="canonical" href="https://domain.com/movie/inception">
```

---

## ✅ SEO Checklist

### Технический
- [ ] Title уникальный на каждой странице (< 60 символов)
- [ ] Description уникальный (< 160 символов)
- [ ] Open Graph tags настроены
- [ ] Canonical URL указан
- [ ] sitemap.xml создан
- [ ] robots.txt настроен

### Контентный
- [ ] H1 один на страницу
- [ ] Иерархия заголовков (H1 → H2 → H3)
- [ ] Alt-текст для изображений
- [ ] Внутренняя перелинковка

### Технические требования
- [ ] HTTPS включён
- [ ] Мобильная версия (responsive)
- [ ] Быстрая загрузка (LCP < 2.5s)
- [ ] Нет битых ссылок (404)
