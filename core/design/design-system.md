# 🎨 Design System Definition

> **Role:** Senior Frontend Architect & Design System Lead
> **Target:** Nuxt 4, Vue 3, Konsta UI (Tailwind CSS)

---

## 1. 🧱 Дизайн-токены (Foundations)

> **Связанные документы:**
> - [Frontend Patterns](../architecture/frontend-patterns.md) — UX паттерны и состояния
> - [Telegram Patterns](../../docs/telegram-webapp/design/patterns.md) — Специфика Mini Apps

Мы используем нативные CSS-переменные Telegram для автоматической адаптации к темам (Light/Dark/Colored), расширяя их через Tailwind config.

### 🎨 Цветовая палитра (Colors)

Все цвета должны ссылаться на переменные Telegram (`--tg-*`).

| Token | CSS Variable | Fallback (Light) | Fallback (Dark) | Usage |
|-------|--------------|------------------|-----------------|-------|
| `bg-primary` | `--tg-theme-bg-color` | `#ffffff` | `#000000` | Основной фон страницы |
| `bg-secondary` | `--tg-theme-secondary-bg-color` | `#f0f0f0` | `#1c1c1d` | Карточки, списки |
| `text-primary` | `--tg-theme-text-color` | `#000000` | `#ffffff` | Основной текст |
| `text-secondary` | `--tg-theme-hint-color` | `#8e8e93` | `#8e8e93` | Подсказки, мета-данные |
| `brand-primary` | `--tg-theme-button-color` | `#2481cc` | `#2481cc` | Кнопки, активные элементы |
| `brand-contrast` | `--tg-theme-button-text-color` | `#ffffff` | `#ffffff` | Текст на кнопке |
| `status-destructive`| `--tg-theme-destructive-text-color`| `#ff3b30` | `#ff453a` | Ошибки, удаление |

### 🔡 Типографика (Typography)

Шрифты системные: San Francisco (iOS), Roboto (Android).

| Class | Size (px) | Line Height | Weight | Usage |
|-------|-----------|-------------|--------|-------|
| `text-h1` | 28px | 34px | Bold (700) | Заголовки страниц |
| `text-h2` | 22px | 28px | Semibold (600) | Заголовки секций |
| `text-h3` | 20px | 24px | Semibold (600) | Карточки |
| `text-body` | 17px | 22px | Regular (400) | Основной контент |
| `text-caption`| 13px | 16px | Regular (400) | Подписи, даты |
| `text-tiny` | 11px | 13px | Medium (500) | Бейджи, теги |

### 📏 Сетка и Отступы (Spacing)

Base unit: **4px**.

| Token | Size | Example |
|-------|------|---------|
| `p-1` | 4px | Внутренние отступы бейджей |
| `p-2` | 8px | Отступ текста от иконки |
| `p-3` | 12px | Стандартный padding внутри карточки |
| `p-4` | 16px | Отступ от края экрана (Safe Area) |
| `p-6` | 24px | Отступ между секциями |

### 🔄 Скругления (Radius)

| Token | Size | Usage |
|-------|------|-------|
| `rounded-sm` | 8px | Вложенные элементы, кнопки XS |
| `rounded-md` | 12px | Кнопки, инпуты, карточки |
| `rounded-lg` | 16px | Модалки, большие карточки |
| `rounded-full`| 9999px | Аватарки, pill-buttons |

---

## 2. 🧩 Спецификация компонентов

### 👤 Avatar
Отображает фото пользователя или инициалы.

**Props:**
- `src?: string` — URL изображения
- `initials?: string` — Если нет картинки (например, "YN")
- `size: 'xs' | 's' | 'm' | 'l' | 'xl'` (24, 32, 48, 64, 88 px)
- `shape: 'circle' | 'square'` (default: circle)
- `status?: 'online' | 'offline'` (зеленая/серая точка)

### 🔘 Button
Базовая интерактивная кнопка.

**Props:**
- `variant: 'primary' | 'secondary' | 'ghost' | 'clear'`
  - `primary`: `--tg-theme-button-color`
  - `secondary`: `--tg-theme-secondary-bg-color` (или tint)
  - `ghost`: Transparent bg, colored text
- `size: 's' | 'm' | 'l'`
- `loading: boolean` — показывает спиннер, блокирует клик
- `disabled: boolean` — opacity 0.5, no events
- `icon?: string` — (имя иконки, slot preferrable)
- `block: boolean` — width 100%

### 📝 Input
Текстовое поле в стиле iOS/Telegram.

**Props:**
- `modelValue: string | number`
- `label?: string` — Верхняя подпись (floating/static)
- `placeholder?: string`
- `type: 'text' | 'password' | 'email' | 'date'`
- `error?: string` — Текст ошибки (красный)
- `clearable: boolean` — Крестик очистки

### 📄 List Item (Cell)
Основной строительный блок меню и списков.

**Props:**
- `title: string`
- `subtitle?: string`
- `after?: string` — Текст справа (например, "Details >")
- `media?: string` — Slot для иконки/аватара слева
- `divider: boolean` — Линия снизу (default: true)
- `chevron: boolean` — Стрелочка справа (default: false)
- `link: boolean` — Hover эффект

### 📱 Sheet (Modal)
Нижняя шторка.

**Props:**
- `opened: boolean` (v-model)
- `title?: string`
- `backdrop: boolean` (default: true)
- `breakpoints?: number[]` (например, [0.5, 1.0])

---

## 3. 🏗️ Архитектура (Nuxt 4)

### Структура папок

Мы используем паттерн "UI Wrapper". Мы не используем Konsta компоненты напрямую в pages, а оборачиваем их в свои `App*` компоненты. Это позволяет менять библиотеку или стили в одном месте.

```text
components/
├── ui/                  # Базовые UI-компоненты (Design System)
│   ├── AppButton.vue
│   ├── AppInput.vue
│   ├── AppAvatar.vue
│   └── AppCell.vue
├── domain/              # Бизнес-компоненты
│   ├── movie/
│   │   └── MovieCard.vue
│   └── user/
│       └── UserProfile.vue
└── icons/               # Иконки (если не используются через библиотеку)
```

### Интеграция Konsta UI + Tailwind

Tailwind позволяет переопределять классы точечно.

**Пример: AppButton.vue**

```vue
<script setup lang="ts">
import { kButton } from 'konsta/vue';

// Define Props with Default Values & Types
interface Props {
  variant?: 'primary' | 'secondary' | 'ghost';
  size?: 's' | 'm' | 'l';
  loading?: boolean;
  disabled?: boolean;
  block?: boolean;
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'primary',
  size: 'm',
  loading: false,
  disabled: false,
  block: false,
});

// Map variants to Konsta colors/classes
const colors = computed(() => {
  if (props.variant === 'primary') return 'primary'; // uses --tg-theme-button-color
  if (props.variant === 'secondary') return 'secondary';
  return 'primary';
});

// Custom classes blending Tailwind
const classes = computed(() => {
  return [
    props.block ? 'w-full' : '',
    props.variant === 'ghost' ? '!bg-transparent !text-[var(--tg-theme-button-color)]' : ''
  ].join(' ');
});
</script>

<template>
  <k-button
    :colors="colors"
    :small="size === 's'"
    :large="size === 'l'"
    :disabled="disabled || loading"
    :class="classes"
    @click="$emit('click', $event)"
  >
    <div v-if="loading" class="animate-spin mr-2">⏳</div>
    <slot />
  </k-button>
</template>
```

---

## 4. 📝 Правила использования

### Naming Conventions

1. **Components:** Prefix `App` для UI компонентов (избегаем конфликтов с HTML и другими либами).
   - `AppButton`, `AppInput`, `AppModal`.
2. **Props:** camelCase.
3. **Events:** kebab-case в шаблоне (`@click-action`), но стандартные `@click` пробрасываем.

### Extension Rules

1. **Не ломай обратную совместимость.** Если меняешь проп, поддержи старый или сделай миграцию.
2. **Composition over Inheritance.** Если кнопка слишком сложная, сделай `AppIconButton.vue`, использующий `AppButton`, или вообще отдельный, но не раздувай один файл.
3. **Tailwind First.** Стилизуй через utility-классы, избегай `<style>` блоков, если возможно.

---

> **Note:** Эта документация является живым контрактом. Любые изменения в дизайн-системе должны сначала отражаться здесь.
