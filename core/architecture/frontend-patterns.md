# 🎨 Frontend UI Patterns

> Роль: Ты — Senior Frontend Engineer с фокусом на UX. Твоя задача — создавать отзывчивые и предсказуемые интерфейсы.
>
> ➡️ **Токены и компоненты:** см. [Design System](../design/design-system.md)

---

## 🖼️ Fallback Images

Когда изображение не загружается, показывай красивый fallback вместо битой иконки.

### Паттерн

```vue
<script setup>
const imageError = ref(false)
</script>

<template>
  <div class="relative overflow-hidden">
    <!-- Actual Image -->
    <img 
      v-if="imageUrl && !imageError"
      :src="imageUrl"
      @error="imageError = true"
      class="w-full h-full object-cover"
    >
    
    <!-- Fallback -->
    <div 
      v-else
      class="w-full h-full flex items-center justify-center
             bg-gradient-to-br from-purple-900 via-indigo-900 to-black"
    >
      <span class="text-4xl font-bold text-white/20">
        {{ title?.charAt(0)?.toUpperCase() || '?' }}
      </span>
    </div>
  </div>
</template>
```

### Гайдлайны
- Градиентный фон соответствует теме приложения
- Первая буква названия крупно в центре
- Иконка типа контента (опционально)
- Поддержка темной И светлой темы

---

## ⏳ Loading States

**Правило:** Пользователь ВСЕГДА должен видеть, что что-то происходит.

### Skeleton Loader

```vue
<!-- Для списка карточек -->
<template v-if="loading">
  <div v-for="i in 5" :key="i" class="animate-pulse">
    <div class="h-32 bg-gray-300 rounded-2xl"></div>
  </div>
</template>
<template v-else>
  <MovieCard v-for="movie in movies" ... />
</template>
```

### Inline Loading

```vue
<button :disabled="isSubmitting">
  <span v-if="isSubmitting" class="animate-spin">⏳</span>
  <span v-else>Сохранить</span>
</button>
```

### Pull-to-Refresh
Для списков используй индикатор обновления при свайпе вниз.

---

## ❌ Error States

### Типы ошибок

| Тип | UI | Действие |
|-----|-----|----------|
| Network Error | Полноэкранное сообщение | Кнопка "Повторить" |
| 404 Not Found | "Не найдено" | Кнопка "На главную" |
| Validation Error | Inline под полем | Подсветить поле |
| Server Error | Toast/Snackbar | Автоскрыть через 5с |

### Пример Error Boundary

```vue
<template>
  <div v-if="error" class="flex flex-col items-center py-12">
    <span class="text-4xl mb-4">😕</span>
    <h3 class="text-xl font-bold">Что-то пошло не так</h3>
    <p class="text-gray-500 mt-2">{{ error.message }}</p>
    <button @click="retry" class="mt-6 px-6 py-2 bg-blue-500 rounded-xl">
      Попробовать снова
    </button>
  </div>
  <slot v-else />
</template>
```

---

## 📭 Empty States

Когда данных нет — не показывай пустоту.

```vue
<div v-if="movies.length === 0" class="text-center py-12">
  <span class="text-6xl">🎬</span>
  <h3 class="text-xl font-bold mt-4">Пока пусто</h3>
  <p class="text-gray-500">Добавьте первый фильм</p>
  <button @click="openSearch" class="mt-6 ...">
    Найти фильм
  </button>
</div>
```

### Гайдлайны
- Релевантная иконка/эмодзи
- Объяснение ситуации
- Call-to-Action (что делать дальше)

---

## 🌓 Dark/Light Theme

### Адаптивные классы

```vue
<div :class="isDark ? 'bg-black text-white' : 'bg-white text-black'">

<!-- Или через CSS -->
<style>
.card {
  @apply bg-white dark:bg-black;
  @apply text-black dark:text-white;
}
</style>
```

### Thematic Gradients

```typescript
const gradient = computed(() => 
  isDark.value 
    ? 'from-purple-900 via-indigo-900 to-black'
    : 'from-purple-200 via-indigo-100 to-white'
)
```

---

## 📱 Responsive Patterns

### Mobile-First

```css
/* Base: Mobile */
.card { width: 100%; }

/* Tablet */
@media (min-width: 768px) {
  .card { width: 50%; }
}

/* Desktop */
@media (min-width: 1024px) {
  .card { width: 33.33%; }
}
```

### Touch Feedback

```vue
<button class="active:scale-95 transition-transform">
  Tap me
</button>
```

---

## ✅ UI Checklist

- [ ] Все изображения имеют fallback
- [ ] Все async операции показывают loading
- [ ] Все ошибки обрабатываются и показываются
- [ ] Пустые состояния информативны
- [ ] Работает в светлой И тёмной теме
- [ ] Touch feedback на всех интерактивных элементах
