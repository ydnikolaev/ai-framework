# CloudStorage

> **Key-Value хранилище в облаке Telegram.**

Зачем:
- Синхронизация настроек между устройствами
- Сохранение состояния онбординга
- Хранение черновиков

Лимиты: 1024 ключа, 4096 байт на значение.

---

## 💾 API

Все методы асинхронные (callback-based в сыром SDK, лучше обернуть в Promise).

### Set Strategy
```typescript
WebApp.CloudStorage.setItem('theme_mode', 'dark', (err, saved) => {
  if (saved) console.log('Saved!')
})
```

### Get Strategy
```typescript
WebApp.CloudStorage.getItem('theme_mode', (err, value) => {
  if (value) applyTheme(value)
})

// Получить несколько
WebApp.CloudStorage.getItems(['theme_mode', 'language'], (err, values) => {
  // values = { theme_mode: 'dark', language: 'en' }
})
```

### Remove
```typescript
WebApp.CloudStorage.removeItem('draft_text')
```

## 💡 Use Cases

1. **Туториал:** Запомнить `onboarding_completed=true`.
2. **Формы:** Сохранять черновик формы ввода, чтобы юзер мог продолжить с десктопа.
3. **Конфиг:** Избранный язык, сортировка списка.
