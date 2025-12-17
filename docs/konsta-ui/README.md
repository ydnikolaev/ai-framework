# Konsta UI — Documentation

> **Version:** 5.0  
> **Last Updated:** 2025-12-17  
> **Source:** https://konstaui.com/vue

---

## 📋 Обзор

Konsta UI — UI библиотека в стиле iOS и Material Design для Vue, React, Svelte.

**Key Features:**
- iOS-native look (Liquid Glass effect)
- Dark/Light theme support
- Touch-optimized components
- Tailwind CSS based

---

## 📦 Установка

```bash
npm install konsta
```

```typescript
// nuxt.config.ts
export default defineNuxtConfig({
  build: {
    transpile: ['konsta']
  }
})
```

---

## 🎨 Theming

### App Container
```vue
<template>
  <k-app theme="ios" :dark="isDark">
    <NuxtPage />
  </k-app>
</template>
```

### Custom Colors
```css
:root {
  --k-color-primary: #007aff;
  --k-color-brand-red: #ff3b30;
}
```

---

## 🧩 Основные компоненты

### Page & Navbar
```vue
<k-page>
  <k-navbar title="Movies" />
  <k-list>...</k-list>
</k-page>
```

### List
```vue
<k-list strong inset>
  <k-list-item title="Inception" subtitle="2010" link />
  <k-list-item title="Interstellar" subtitle="2014" link />
</k-list>
```

### Sheet (Bottom Drawer)
```vue
<k-sheet v-model:opened="isOpen">
  <k-toolbar>
    <k-link @click="isOpen = false">Close</k-link>
  </k-toolbar>
  <k-block>Content</k-block>
</k-sheet>
```

### Popup (Modal)
```vue
<k-popup v-model:opened="showPopup">
  <k-page>
    <k-navbar title="Details" />
    <k-block>...</k-block>
  </k-page>
</k-popup>
```

### Buttons
```vue
<k-button>Default</k-button>
<k-button fill>Filled</k-button>
<k-button outline>Outline</k-button>
<k-button tonal>Tonal</k-button>
```

---

## 🎭 Liquid Glass Effect

Для iOS 26 стиля:
```vue
<div class="backdrop-blur-xl bg-white/40 dark:bg-black/40 rounded-3xl">
  <!-- Content -->
</div>
```

---

## ⚠️ Важные моменты

1. **Всегда оборачивай в `<k-app>`**
2. **Используй `theme="ios"` для iOS стиля**
3. **Sheet/Popup — v-model:opened, не v-model**
4. **List inset — скруглённые углы**

---

## 🔗 Ссылки

- [Konsta Vue Docs](https://konstaui.com/vue)
- [Components List](https://konstaui.com/vue/introduction)
- [Colors Customization](https://konstaui.com/vue/colors)
