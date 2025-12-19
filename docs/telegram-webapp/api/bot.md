# Telegram Bot API (Reference)

> **Серверная часть взаимодействия.**

В отличие от Mini App API (который работает в браузере), Bot API работает на твоем сервере (Go Backend).

---

## 🔑 Ключевые методы

Полный список: [core.telegram.org/bots/api](https://core.telegram.org/bots/api)

### 📨 Messages
- `sendMessage` — Отправка текста
- `sendPhoto`, `sendVideo` — Медиа
- `editMessageText` — Обновление UI "на лету"

### 💰 Payments (Stars)
- `createInvoiceLink` — Создание ссылки на оплату
- `answerPreCheckoutQuery` — Подтверждение готовности принять оплату

### 🔗 WebApp Integration
- `setChatMenuButton` — Кнопка "Menu" (или "Play") рядом с полем ввода
- `answerWebAppQuery` — Ответ на данные, присланные из WebApp (редко используется)

---

## 🛠️ Go Implementation

В проекте мы используем `tucnak/telebot` или `go-telegram-bot-api`.

```go
// Пример обработчика pre_checkout
b.Handle(tele.OnPreCheckout, func(c tele.Context) error {
    payload := c.PreCheckout().Payload
    // Проверка наличия товара
    return c.Accept() // Оплата разрешена
})
```
