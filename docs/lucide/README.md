# Lucide Icons — Documentation

> **Version:** 0.460  
> **Last Updated:** 2025-12-17  
> **Source:** https://lucide.dev

---

## 📋 Обзор

Lucide — open-source библиотека иконок (форк Feather Icons).

**Key Features:**
- 1500+ иконок
- Tree-shakeable
- Customizable (size, color, stroke)
- Vue/React/Svelte support

---

## 📦 Установка

```bash
npm install lucide-vue-next
```

---

## 🎨 Использование

### Прямой импорт (рекомендуется)
```vue
<script setup>
import { Home, Search, User, Settings } from 'lucide-vue-next'
</script>

<template>
  <Home :size="24" :stroke-width="2" />
  <Search class="w-6 h-6 text-gray-500" />
</template>
```

### Динамический импорт
```vue
<script setup>
import { icons } from 'lucide-vue-next'

const Icon = computed(() => icons[props.name])
</script>

<template>
  <component :is="Icon" :size="24" />
</template>
```

---

## 🎛️ Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `size` | number/string | 24 | Width & height |
| `color` | string | currentColor | Stroke color |
| `stroke-width` | number | 2 | Line thickness |
| `absolute-stroke-width` | boolean | false | Fixed stroke regardless of size |

---

## 📐 Размеры

| Context | Size | Class |
|---------|------|-------|
| Inline text | 16px | `w-4 h-4` |
| Button icon | 20px | `w-5 h-5` |
| List item | 24px | `w-6 h-6` |
| Feature icon | 32px | `w-8 h-8` |
| Hero icon | 48px | `w-12 h-12` |

---

## 🎨 Стилизация

### Через props
```vue
<Home :size="24" color="#007aff" :stroke-width="1.5" />
```

### Через CSS
```vue
<Home class="w-6 h-6 text-blue-500" />
```

### Tailwind dark mode
```vue
<Home class="w-6 h-6 text-gray-900 dark:text-white" />
```

---

## 📁 Организация

```typescript
// utils/icons.ts
export { 
  // Navigation
  Home,
  Search,
  ArrowLeft,
  
  // Actions
  Plus,
  Trash2,
  Edit,
  Check,
  X,
  
  // Media
  Film,
  Tv,
  Play,
  Pause,
  
  // UI
  ChevronRight,
  ChevronDown,
  MoreHorizontal,
  Settings,
  User
} from 'lucide-vue-next'
```

---

## ⚡ Оптимизация

### Tree-shaking (работает автоматически)
```typescript
// ✅ Good: только нужные иконки
import { Home, Search } from 'lucide-vue-next'

// ❌ Bad: весь пакет
import * as icons from 'lucide-vue-next'
```

### Lazy loading (для редких иконок)
```typescript
const RareIcon = defineAsyncComponent(() => 
  import('lucide-vue-next').then(m => m.SomeRareIcon)
)
```

---

## 🔗 Ссылки

- [Icon Search](https://lucide.dev/icons)
- [Vue Guide](https://lucide.dev/guide/packages/lucide-vue-next)
- [Figma Plugin](https://www.figma.com/community/plugin/939567362549682242)
