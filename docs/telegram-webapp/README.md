# Telegram WebApp SDK — Documentation

> **Version:** 8.0  
> **Last Updated:** 2025-12-17  
> **Source:** https://core.telegram.org/bots/webapps

---

## 📋 Обзор

Telegram Web Apps (Mini Apps) — веб-приложения, запускаемые внутри Telegram.

**Key Features:**
- Native-like experience
- User authentication via initData
- Haptic feedback
- Theme sync
- Payment integration

---

## 🔌 Подключение

```typescript
// composables/useTelegram.ts
declare global {
  interface Window {
    Telegram?: {
      WebApp: TelegramWebApp
    }
  }
}

export const useTelegram = () => {
  const webApp = computed(() => window.Telegram?.WebApp)
  const user = computed(() => webApp.value?.initDataUnsafe?.user)
  const initData = computed(() => webApp.value?.initData)
  
  return { webApp, user, initData }
}
```

---

## 🎨 Theme

```typescript
const { webApp } = useTelegram()

// Цветовая схема
const colorScheme = webApp.value?.colorScheme // 'light' | 'dark'

// Цвета темы
const themeParams = webApp.value?.themeParams
// {
//   bg_color: '#ffffff',
//   text_color: '#000000',
//   hint_color: '#999999',
//   ...
// }
```

---

## 📳 Haptic Feedback

```typescript
const { webApp } = useTelegram()

// Impact
webApp.value?.HapticFeedback.impactOccurred('light')   // light | medium | heavy | rigid | soft

// Notification
webApp.value?.HapticFeedback.notificationOccurred('success')  // error | success | warning

// Selection
webApp.value?.HapticFeedback.selectionChanged()
```

### Когда использовать

| Событие | Тип |
|---------|-----|
| Tap на кнопку | `impactOccurred('light')` |
| Успешное действие | `notificationOccurred('success')` |
| Ошибка | `notificationOccurred('error')` |
| Выбор элемента | `selectionChanged()` |
| Длинное нажатие | `impactOccurred('medium')` |

---

## 🔐 Аутентификация

### Frontend
```typescript
const { initData } = useTelegram()

// Отправляем в заголовке
await $fetch('/api/movies', {
  headers: {
    'Authorization': initData.value
  }
})
```

### Backend (Go)
```go
func ValidateInitData(initData, botToken string) bool {
    // 1. Parse query string
    // 2. Extract and remove hash
    // 3. Sort remaining params
    // 4. Join with \n
    // 5. HMAC-SHA256 with WebAppData secret
    // 6. Compare hashes
}
```

---

## 📐 Safe Areas

```typescript
// CSS переменные от Telegram
const safeAreaInsetTop = 'var(--tg-safe-area-inset-top)'
const contentSafeAreaTop = 'var(--tg-content-safe-area-inset-top)'
```

```css
.header {
  padding-top: calc(var(--tg-content-safe-area-inset-top, 0px) + 16px);
}
```

---

## 🎛️ Основные методы

```typescript
const { webApp } = useTelegram()

// Экспанд
webApp.value?.expand()

// Закрыть
webApp.value?.close()

// Main button
webApp.value?.MainButton.setText('Submit')
webApp.value?.MainButton.show()
webApp.value?.MainButton.onClick(() => {})

// Back button
webApp.value?.BackButton.show()
webApp.value?.BackButton.onClick(() => router.back())

// Popup
webApp.value?.showPopup({
  title: 'Confirm',
  message: 'Are you sure?',
  buttons: [
    { type: 'ok' },
    { type: 'cancel' }
  ]
})

// Alert
webApp.value?.showAlert('Hello!')
```

---

## 🔗 Ссылки

- [Official Docs](https://core.telegram.org/bots/webapps)
- [WebApp API](https://core.telegram.org/bots/webapps#initializing-mini-apps)
- [Theme Parameters](https://core.telegram.org/bots/webapps#themeparams)
