# Vue 3 — Documentation

> **Version:** 3.5+  
> **Last Updated:** 2025-12-17  
> **Source:** https://vuejs.org

---

## 📋 Обзор

Vue 3 — progressive JavaScript framework с:
- **Composition API** — основной способ написания логики
- **Reactivity System** — ref, reactive, computed, watch
- **SFC** — Single File Components (`.vue`)
- **TypeScript** — first-class support

---

## 🎯 Composition API (основной)

### Script Setup (рекомендуется)
```vue
<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'

// Props
interface Props {
  title: string
  count?: number
}
const props = withDefaults(defineProps<Props>(), {
  count: 0
})

// Emits
const emit = defineEmits<{
  update: [value: number]
  close: []
}>()

// State
const isOpen = ref(false)

// Computed
const doubled = computed(() => props.count * 2)

// Methods
const handleClick = () => {
  emit('update', doubled.value)
}

// Lifecycle
onMounted(() => {
  console.log('Component mounted')
})
</script>
```

---

## 🔄 Reactivity

### ref (примитивы и объекты)
```typescript
import { ref } from 'vue'

const count = ref(0)
count.value++  // Доступ через .value

const user = ref({ name: 'John' })
user.value.name = 'Jane'
```

### reactive (только объекты)
```typescript
import { reactive } from 'vue'

const state = reactive({
  count: 0,
  user: { name: 'John' }
})
state.count++  // Без .value
```

### computed
```typescript
import { computed } from 'vue'

const doubled = computed(() => count.value * 2)
// readonly по умолчанию

// Writable computed
const fullName = computed({
  get: () => `${first.value} ${last.value}`,
  set: (val) => {
    [first.value, last.value] = val.split(' ')
  }
})
```

### watch / watchEffect
```typescript
import { watch, watchEffect } from 'vue'

// watch конкретного значения
watch(count, (newVal, oldVal) => {
  console.log(`Changed: ${oldVal} → ${newVal}`)
})

// watch нескольких
watch([firstName, lastName], ([newFirst, newLast]) => {
  // ...
})

// watchEffect (автоматически отслеживает зависимости)
watchEffect(() => {
  console.log(`Count is: ${count.value}`)
})
```

---

## 🧩 Composables

### Создание
```typescript
// composables/useCounter.ts
import { ref, computed } from 'vue'

export const useCounter = (initial = 0) => {
  const count = ref(initial)
  const doubled = computed(() => count.value * 2)
  
  const increment = () => count.value++
  const decrement = () => count.value--
  
  return { count, doubled, increment, decrement }
}
```

### Использование
```vue
<script setup>
import { useCounter } from '~/composables/useCounter'

const { count, increment } = useCounter(10)
</script>
```

### Правила
- Имя начинается с `use`
- Вызывай только на верхнем уровне `<script setup>`
- НЕ вызывай внутри функций, условий, циклов

---

## 📐 Template Syntax

### Bindings
```vue
<template>
  <!-- Text -->
  <p>{{ message }}</p>
  
  <!-- Attribute -->
  <div :id="dynamicId" :class="{ active: isActive }"></div>
  
  <!-- Event -->
  <button @click="handleClick">Click</button>
  <input @keyup.enter="submit" />
  
  <!-- Two-way -->
  <input v-model="text" />
  
  <!-- Conditional -->
  <div v-if="isVisible">Visible</div>
  <div v-else-if="isLoading">Loading...</div>
  <div v-else>Hidden</div>
  
  <!-- Loop -->
  <li v-for="item in items" :key="item.id">
    {{ item.name }}
  </li>
</template>
```

### v-model modifiers
```vue
<input v-model.trim="text" />
<input v-model.number="age" />
<input v-model.lazy="query" />
```

---

## 🔗 Component Communication

### Props (parent → child)
```vue
<!-- Parent -->
<Child :title="title" :count="5" />

<!-- Child -->
<script setup>
const props = defineProps<{ title: string; count: number }>()
</script>
```

### Emits (child → parent)
```vue
<!-- Child -->
<script setup>
const emit = defineEmits<{ update: [value: string] }>()
emit('update', 'new value')
</script>

<!-- Parent -->
<Child @update="handleUpdate" />
```

### Provide/Inject (deep passing)
```typescript
// Ancestor
import { provide } from 'vue'
provide('theme', 'dark')

// Descendant
import { inject } from 'vue'
const theme = inject('theme', 'light') // default
```

---

## 🎣 Lifecycle Hooks

```typescript
import {
  onBeforeMount,
  onMounted,
  onBeforeUpdate,
  onUpdated,
  onBeforeUnmount,
  onUnmounted
} from 'vue'

onMounted(() => {
  // DOM доступен
})

onUnmounted(() => {
  // Cleanup (remove listeners, etc.)
})
```

---

## 📝 TypeScript

### Typing refs
```typescript
const count = ref<number>(0)
const user = ref<User | null>(null)
```

### Typing props
```typescript
interface Props {
  title: string
  items: Item[]
  callback?: (id: number) => void
}

const props = defineProps<Props>()
```

### Typing emits
```typescript
const emit = defineEmits<{
  change: [id: number]
  update: [value: string]
}>()
```

---

## ⚠️ Common Mistakes

### ❌ Деструктуризация reactive
```typescript
// ❌ Теряется реактивность
const { count } = reactive({ count: 0 })

// ✅ Используй toRefs
const state = reactive({ count: 0 })
const { count } = toRefs(state)
```

### ❌ Забыть .value для ref
```typescript
const count = ref(0)
// ❌
console.log(count)
// ✅
console.log(count.value)
```

### ❌ Async в setup без await
```typescript
// ❌ Ломает Suspense
const data = ref(null)
fetchData().then(res => data.value = res)

// ✅ С await (если нужен Suspense)
const data = ref(await fetchData())
```

---

## 🔗 Ссылки

- [Vue 3 Docs](https://vuejs.org/guide/introduction.html)
- [Composition API](https://vuejs.org/guide/extras/composition-api-faq.html)
- [TypeScript with Vue](https://vuejs.org/guide/typescript/overview.html)
- [VueUse](https://vueuse.org/) — коллекция полезных composables
