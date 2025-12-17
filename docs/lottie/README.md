# 🎬 Lottie & Bodymovin — Documentation

> **Version:** 5.12.x (lottie-web)  
> **Last Updated:** 2025-12-17

---

## 📋 Обзор

**Lottie** — библиотека для рендеринга анимаций из After Effects (через Bodymovin) в вебе и мобильных приложениях.

**Bodymovin** — плагин для Adobe After Effects, экспортирующий анимации в JSON.

---

## 📦 Установка

### Vue/Nuxt
```bash
npm install lottie-web
# или для Vue-обёртки
npm install vue3-lottie
```

### Использование
```vue
<script setup>
import lottie from 'lottie-web'

onMounted(() => {
  lottie.loadAnimation({
    container: document.getElementById('lottie'),
    renderer: 'svg',        // svg | canvas | html
    loop: true,
    autoplay: true,
    path: '/animations/loading.json'
  })
})
</script>

<template>
  <div id="lottie" class="w-24 h-24" />
</template>
```

### Vue3-Lottie (рекомендуется)
```vue
<script setup>
import { Vue3Lottie } from 'vue3-lottie'
import animationData from '~/assets/animations/success.json'
</script>

<template>
  <Vue3Lottie 
    :animationData="animationData"
    :loop="true"
    :autoPlay="true"
    :speed="1"
    @onComplete="handleComplete"
  />
</template>
```

---

## 🎛️ API Reference

### loadAnimation Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `container` | Element | required | DOM element |
| `renderer` | string | 'svg' | svg, canvas, html |
| `loop` | boolean/number | false | true, false, or count |
| `autoplay` | boolean | true | Auto start |
| `path` | string | - | URL to JSON |
| `animationData` | object | - | JSON object |
| `name` | string | - | Reference name |
| `rendererSettings` | object | - | Renderer config |

### Methods

```javascript
const anim = lottie.loadAnimation({...})

// Control
anim.play()
anim.pause()
anim.stop()

// Navigation
anim.goToAndPlay(frame, isFrame)  // isFrame: true = frame, false = time
anim.goToAndStop(frame, isFrame)
anim.setDirection(1)   // 1 = forward, -1 = reverse
anim.setSpeed(2)       // 2x speed

// Segments
anim.playSegments([0, 30], true)  // Play frames 0-30

// Destroy
anim.destroy()
```

### Events

```javascript
anim.addEventListener('complete', () => {})
anim.addEventListener('loopComplete', () => {})
anim.addEventListener('enterFrame', () => {})
anim.addEventListener('segmentStart', () => {})
anim.addEventListener('DOMLoaded', () => {})
```

---

## 📁 Файловая структура

```text
assets/
└── animations/
    ├── loading.json       # Лоадеры
    ├── success.json       # Успешные действия
    ├── error.json         # Ошибки
    ├── empty-state.json   # Пустые состояния
    └── confetti.json      # Celebrations
```

---

## ⚡ Оптимизация

### 1. Размер файла
```bash
# Минификация JSON
npx lottie-minify input.json output.json
```

### 2. Lazy Loading
```vue
<script setup>
const animation = ref(null)

// Загружаем только когда нужно
const loadAnimation = async () => {
  const { default: data } = await import('~/assets/animations/heavy.json')
  animation.value = data
}
</script>
```

### 3. Canvas вместо SVG (для сложных анимаций)
```javascript
lottie.loadAnimation({
  renderer: 'canvas',  // Быстрее для сложных анимаций
  // ...
})
```

### 4. Reduce Motion
```vue
<script setup>
const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches

const shouldAnimate = computed(() => !prefersReducedMotion)
</script>

<template>
  <Vue3Lottie v-if="shouldAnimate" ... />
  <StaticImage v-else ... />
</template>
```

---

## 🎨 Best Practices

### DO's ✅
- Используй SVG renderer для простых анимаций (чётче)
- Используй Canvas для сложных (быстрее)
- Lazy load тяжёлые анимации
- Уважай `prefers-reduced-motion`
- Храни JSON в `assets/animations/`

### DON'Ts ❌
- Не используй анимации > 500KB
- Не запускай много анимаций одновременно
- Не анимируй элементы вне viewport
- Не забывай `destroy()` при unmount

---

## 📐 Размеры

| Тип | Рекомендуемый размер |
|-----|---------------------|
| Icon animation | 24-48px |
| Button feedback | 40-60px |
| Empty state | 120-200px |
| Hero animation | 200-400px |
| Full-screen | 100vw/100vh |
