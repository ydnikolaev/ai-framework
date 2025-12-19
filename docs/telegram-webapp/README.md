# Telegram Mini Apps Documentation

> **Version:** 7.10+ (Bot API)
> **Last Updated:** 2025-12-19

## 📋 Обзор

Telegram Mini Apps — это веб-приложения, которые запускаются внутри Telegram. Они имеют доступ к специфичному API для взаимодействия с клиентом (темы, биометрия, тактильный отклик, QR и др.).

---

## 🏗️ Структура документации

### 🛠️ API & SDK
- [WebApp API](api/webapp.md) — Основной JS SDK (`window.Telegram.WebApp`)
- [Bot API](api/bot.md) — Серверное взаимодействие

### 🎨 Design & UX
- [Design Patterns](design/patterns.md) — Цвета, лейаут, принципы нативности

### ✨ Features (Guides)
| Фича | Описание |
|------|----------|
| [Haptics](features/haptics.md) | Вибрация и тактильный отклик |
| [Biometrics](features/biometrics.md) | FaceID / TouchID auth |
| [CloudStorage](features/cloud-storage.md) | Синхронизация настроек (K/V) |
| [Sensors](features/sensors.md) | Гироскоп и акселерометр |
| [System](features/system.md) | Fullscreen, создание ярлыков, темы |
| [Media & Files](features/media.md) | Камера, галерея, контакты |
| [Monetization](features/monetization.md) | Stars, Sharing, Viral |

---

## � Быстрый старт (Vue/Nuxt)

### Установка SDK
```bash
npm install @twa-dev/sdk
```

### Использование
```typescript
import WebApp from '@twa-dev/sdk'

onMounted(() => {
  WebApp.ready()
  WebApp.expand()
})
```
