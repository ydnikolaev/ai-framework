# Monetization & Viral Mechanics

> **Зарабатывай деньги и привлекай пользователей.**

---

## ⭐ Telegram Stars

Валюта для оплаты цифровых товаров.

Flow:
1. Юзер выбирает товар.
2. Бэкенд создает инвойс (метод `createInvoiceLink` в Bot API).
3. Фронтенд открывает инвойс.

```typescript
// Открытие инвойса (по ссылке из Bot API)
WebApp.openInvoice(invoiceUrl, (status) => {
  if (status === 'paid') {
    WebApp.HapticFeedback.notificationOccurred('success')
    showSuccessOrder()
  } else if (status === 'cancelled') {
    WebApp.HapticFeedback.notificationOccurred('error')
  }
})
```

## 🔄 Viral: Sharing

Механика "Поделись с другом".

### Switch Inline Query
Заставляет пользователя выбрать чат и отправляет туда указанный текст (который вызывает твоего Inline бота).

```typescript
// Отправить другу реферальную ссылку
WebApp.switchInlineQuery('invite_friend_123', ['users', 'groups'])
```

### Share URL
Просто пошерить ссылку (открывает нативное меню шеринга).

```typescript
// Работает надежнее, чем Web API navigator.share
const url = 'https://t.me/kinobot?start=ref123'
const text = 'Check out this movie!'
// Нет прямого метода WebApp.shareUrl, используй:
// telegram.me/share/url?url=...&text=...
WebApp.openTelegramLink(`https://t.me/share/url?url=${url}&text=${text}`)
```
