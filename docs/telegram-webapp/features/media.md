# Media & Contacts

> **Взаимодействие с реальным миром и данными пользователя.**

---

## 📷 QR Scanner

Нативный сканер QR-кодов.

```typescript
const params = {
  text: 'Scan QR code' 
}

WebApp.showScanQrPopup(params, (text) => {
  // text - содержимое QR кода
  console.log('QR Scanned:', text)
  // return true; // Если нужно закрыть сканер после первого сканирования
})

// Закрыть программно
WebApp.closeScanQrPopup()
```

## 👤 Contact Access

Запрос контактных данных пользователя (телефон).

```typescript
WebApp.requestContact((success, contact) => {
  if (success) {
    console.log(`Phone: ${contact.phone_number}`)
    console.log(`First Name: ${contact.first_name}`)
  }
})
```

## 📁 Files & Camera

Mini Apps используют стандартные веб-технологии.

```html
<!-- Открыть камеру -->
<input type="file" capture="environment" accept="image/*">

<!-- Открыть галерею -->
<input type="file" accept="image/*">
```

> **Совет:** Для загрузки файлов на сервер используй `FormData`.

## 📋 Clipboard

Чтение текста из буфера.

```typescript
WebApp.readTextFromClipboard((text) => {
  console.log('Clipboard:', text)
})
```
