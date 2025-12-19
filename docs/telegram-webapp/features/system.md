# System Integration

> **Бесшовная интеграция с интерфейсом Telegram.**

---

## 🌗 Themes (ThemeParams)

Приложение получает параметры темы при запуске и обновлении.

```typescript
// WebApp.themeParams
{
  bg_color: "#ffffff",
  text_color: "#000000",
  hint_color: "#999999",
  link_color: "#2481cc",
  button_color: "#2481cc",
  button_text_color: "#ffffff",
  // ... и другие
}
```

> **Совет:** Используй CSS переменные Telegram (`var(--tg-theme-bg-color)`), чтобы не парсить это JS-ом вручную. SDK делает это за тебя (обычно).

## 🖥️ Fullscreen Mode

Позволяет приложению занять весь экран (убирает шапку Mini App).

```typescript
// Запросить полный экран
WebApp.requestFullscreen()
```

В сочетании с `WebApp.expand()`, это делает приложение похожим на нативное.

## 📱 Device Info

```typescript
console.log(WebApp.platform) // 'ios', 'android', 'tdesktop', 'macos', 'web'
console.log(WebApp.version)  // Версия Bot API (например, '7.10')
console.log(WebApp.colorScheme) // 'light' | 'dark'
```

## 🚨 Popups & Alerts

Используй нативные алерты Telegram.

```typescript
// Alert
WebApp.showAlert('Hello World!')

// Confirm
WebApp.showConfirm('Are you sure?', (confirmed) => {
  if (confirmed) deleteItem()
})

// Popup (Bottom Sheet)
WebApp.showPopup({
  title: 'Choose action',
  message: 'What detailed action?',
  buttons: [
    { id: 'ok', type: 'ok', text: 'Yes' },
    { id: 'cancel', type: 'cancel' },
    { id: 'destr', type: 'destructive', text: 'Delete' }
  ]
}, (btnId) => {
  if (btnId === 'destr') deleteItem()
})
```
