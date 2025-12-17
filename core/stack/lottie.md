# 🎬 Lottie & Bodymovin — Правила

> Роль: Ты — Motion Designer. Твоя задача — создавать плавные и производительные анимации.

---

## 1. ФИЛОСОФИЯ

- **Анимация = Feedback** — показывай пользователю, что что-то происходит
- **Subtlety > Flash** — тонкие анимации лучше кричащих
- **Performance First** — анимация не должна тормозить UI

---

## 2. КОГДА ИСПОЛЬЗОВАТЬ

### ✅ Хорошие кейсы
- Loading indicators
- Success/Error feedback
- Empty states
- Onboarding illustrations
- Micro-interactions (button press, toggle)
- Celebrations (confetti, achievements)

### ❌ Плохие кейсы
- Фоновые анимации на всю страницу
- Автоматически играющие тяжёлые анимации
- Анимации, мешающие взаимодействию
- Анимации без смысла (ради красоты)

---

## 3. ПРАВИЛА РЕАЛИЗАЦИИ

### Структура компонента

```vue
<script setup lang="ts">
import { Vue3Lottie } from 'vue3-lottie'

// Props
interface Props {
  animation: 'loading' | 'success' | 'error' | 'empty'
  size?: 'sm' | 'md' | 'lg'
  loop?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  size: 'md',
  loop: true
})

// Lazy load animation
const animationData = ref(null)

onMounted(async () => {
  const { default: data } = await import(
    `~/assets/animations/${props.animation}.json`
  )
  animationData.value = data
})

// Size mapping
const sizeClasses = {
  sm: 'w-12 h-12',
  md: 'w-24 h-24',
  lg: 'w-48 h-48'
}
</script>

<template>
  <div :class="sizeClasses[size]">
    <Vue3Lottie 
      v-if="animationData"
      :animationData="animationData"
      :loop="loop"
    />
  </div>
</template>
```

### Правила импорта

```typescript
// ❌ Bad: Импорт всего сразу
import loading from '~/assets/animations/loading.json'
import success from '~/assets/animations/success.json'
import error from '~/assets/animations/error.json'

// ✅ Good: Dynamic import
const loadAnimation = async (name: string) => {
  const { default: data } = await import(
    `~/assets/animations/${name}.json`
  )
  return data
}
```

---

## 4. ACCESSIBILITY

### Respect Reduced Motion

```typescript
const prefersReducedMotion = computed(() => 
  window.matchMedia('(prefers-reduced-motion: reduce)').matches
)
```

```vue
<template>
  <!-- Animated version -->
  <Vue3Lottie v-if="!prefersReducedMotion" ... />
  
  <!-- Static fallback -->
  <img v-else src="/static/success.svg" />
</template>
```

### Screen Readers

```vue
<div 
  role="img" 
  aria-label="Loading animation"
>
  <Vue3Lottie ... />
</div>
```

---

## 5. PERFORMANCE

### Targets
| Metric | Target |
|--------|--------|
| File size | < 100KB |
| Frame rate | 60fps |
| Simultaneous animations | ≤ 3 |

### Рекомендации

1. **Destroy on unmount**
```typescript
onUnmounted(() => {
  lottieInstance?.destroy()
})
```

2. **Pause when out of view**
```typescript
const { stop } = useIntersectionObserver(
  lottieRef,
  ([{ isIntersecting }]) => {
    isIntersecting ? anim.play() : anim.pause()
  }
)
```

3. **Preload critical animations**
```typescript
// В layout или app.vue
const preloadAnimations = ['loading', 'success']
await Promise.all(
  preloadAnimations.map(name => 
    import(`~/assets/animations/${name}.json`)
  )
)
```

---

## 6. NAMING CONVENTION

```text
assets/animations/
├── ui/
│   ├── loading-spinner.json
│   ├── loading-dots.json
│   └── loading-skeleton.json
├── feedback/
│   ├── success-check.json
│   ├── error-cross.json
│   └── warning-alert.json
├── states/
│   ├── empty-movies.json
│   ├── empty-search.json
│   └── error-network.json
└── celebrations/
    ├── confetti.json
    └── achievement.json
```

---

## 7. ЧЕКЛИСТ

- [ ] Анимация < 100KB
- [ ] Lazy loaded (dynamic import)
- [ ] Destroy on unmount
- [ ] Respects reduced motion
- [ ] Has aria-label
- [ ] Pauses when out of view
- [ ] Uses correct renderer (svg/canvas)
