# Telegram Mini Apps API Reference

> **Актуальные версии (декабрь 2025):**
> - **Bot API:** 9.2
> - **Mini Apps API:** 8.3

---

## Подключение

```html
<script src="https://telegram.org/js/telegram-web-app.js"></script>
```

После подключения доступен объект `window.Telegram.WebApp`.

---

## WebApp — Основные свойства

| Свойство | Тип | Описание | Версия |
|----------|-----|----------|--------|
| `initData` | string | Query string с данными авторизации | 6.0 |
| `initDataUnsafe` | object | Распарсенные данные (user, chat, etc) | 6.0 |
| `version` | string | Версия Mini App API | 6.0 |
| `platform` | string | Платформа (ios, android, web, etc) | 6.0 |
| `colorScheme` | "light" \| "dark" | Тема пользователя | 6.0 |
| `themeParams` | ThemeParams | CSS цвета темы | 6.0 |
| `isExpanded` | boolean | Развёрнуто ли приложение | 6.0 |
| `viewportHeight` | number | Высота viewport | 6.0 |
| `viewportStableHeight` | number | Стабильная высота (без клавиатуры) | 6.0 |
| `isActive` | boolean | Активно ли приложение | 8.0 |
| `isFullscreen` | boolean | В полноэкранном режиме | 8.0 |
| `isOrientationLocked` | boolean | Заблокирована ли ориентация | 8.0 |
| `safeAreaInset` | SafeAreaInset | Отступы устройства (нотч) | 8.0 |
| `contentSafeAreaInset` | ContentSafeAreaInset | Отступы от хедера Telegram | 8.0 |

---

## Safe Area — Критически важно!

### SafeAreaInset (отступы устройства)
```typescript
interface SafeAreaInset {
  top: number;    // Нотч, статус-бар
  bottom: number; // Индикатор Home
  left: number;
  right: number;
}
```

### ContentSafeAreaInset (отступы от хедера Telegram)
```typescript
interface ContentSafeAreaInset {
  top: number;    // Высота хедера Telegram
  bottom: number; // Высота нижней панели
  left: number;
  right: number;
}
```

### Использование в CSS
```javascript
// В app.vue onMounted:
const tg = window.Telegram.WebApp;

// Установить CSS переменные
if (tg.contentSafeAreaInset) {
  document.documentElement.style.setProperty(
    '--tg-content-safe-area-top', 
    `${tg.contentSafeAreaInset.top}px`
  );
}

// Слушать изменения
tg.onEvent('contentSafeAreaChanged', () => {
  // Обновить CSS переменные
});
```

```css
.main-content {
  padding-top: var(--tg-content-safe-area-top, 0px);
  padding-bottom: var(--tg-content-safe-area-bottom, 0px);
}
```

---

## WebApp — Методы

### Основные
| Метод | Описание | Версия |
|-------|----------|--------|
| `ready()` | Сообщить что приложение готово | 6.0 |
| `expand()` | Развернуть на максимальную высоту | 6.0 |
| `close()` | Закрыть Mini App | 6.0 |

### Внешний вид (6.1+)
| Метод | Описание |
|-------|----------|
| `setHeaderColor(color)` | Цвет хедера (#RRGGBB) |
| `setBackgroundColor(color)` | Цвет фона |
| `setBottomBarColor(color)` | Цвет нижней панели (7.10+) |

### Полноэкранный режим (8.0+)
| Метод | Описание |
|-------|----------|
| `requestFullscreen()` | Войти в полноэкранный режим |
| `exitFullscreen()` | Выйти из полноэкранного режима |
| `lockOrientation()` | Заблокировать ориентацию |
| `unlockOrientation()` | Разблокировать ориентацию |

### Навигация
| Метод | Описание | Версия |
|-------|----------|--------|
| `openLink(url)` | Открыть внешнюю ссылку | 6.0 |
| `openTelegramLink(url)` | Открыть ссылку t.me | 6.0 |
| `switchInlineQuery(query, types)` | Inline режим | 6.7 |
| `shareToStory(media, params)` | Поделиться в Stories | 7.8 |
| `shareMessage(msg_id)` | Поделиться сообщением | 8.0 |

### Home Screen (8.0+)
| Метод | Описание |
|-------|----------|
| `addToHomeScreen()` | Добавить на главный экран |
| `checkHomeScreenStatus()` | Проверить статус |

### Клавиатура (9.1+)
| Метод | Описание |
|-------|----------|
| `hideKeyboard()` | **НОВОЕ!** Скрыть клавиатуру |

---

## Компоненты

### BackButton (6.1+)
```javascript
const tg = window.Telegram.WebApp;

// Показать кнопку назад
tg.BackButton.show();
tg.BackButton.onClick(() => {
  router.back();
});

// Скрыть при уходе со страницы
tg.BackButton.hide();
```

### MainButton / SecondaryButton (BottomButton)
```javascript
// MainButton (основная кнопка внизу)
tg.MainButton.text = 'Сохранить';
tg.MainButton.color = '#007AFF';
tg.MainButton.show();
tg.MainButton.onClick(() => { /* save */ });

// SecondaryButton (7.10+)
tg.SecondaryButton.text = 'Отмена';
tg.SecondaryButton.show();
```

### HapticFeedback (6.1+)
```javascript
// Тактильная обратная связь
tg.HapticFeedback.impactOccurred('light');   // light, medium, heavy, rigid, soft
tg.HapticFeedback.notificationOccurred('success'); // success, warning, error
tg.HapticFeedback.selectionChanged();
```

### SettingsButton (7.0+)
```javascript
tg.SettingsButton.show();
tg.SettingsButton.onClick(() => {
  // Открыть настройки
});
```

---

## Хранилище данных

### CloudStorage (6.9+)
```javascript
// Облачное хранилище (до 1024 ключей)
await tg.CloudStorage.setItem('key', 'value');
const value = await tg.CloudStorage.getItem('key');
await tg.CloudStorage.removeItem('key');
```

### DeviceStorage (9.0+) — НОВОЕ!
```javascript
// Локальное хранилище на устройстве
await tg.DeviceStorage.setItem('key', 'value');
const value = await tg.DeviceStorage.getItem('key');
```

### SecureStorage (9.0+) — НОВОЕ!
```javascript
// Безопасное хранилище (Keychain/Keystore)
// Для токенов, секретов, auth state
await tg.SecureStorage.setItem('token', 'secret_value');
const token = await tg.SecureStorage.getItem('token');
```

---

## Сенсоры (8.0+)

### Accelerometer
```javascript
tg.Accelerometer.start();
tg.onEvent('accelerometerChanged', () => {
  const { x, y, z } = tg.Accelerometer;
});
tg.Accelerometer.stop();
```

### Gyroscope
```javascript
tg.Gyroscope.start();
tg.onEvent('gyroscopeChanged', () => {
  const { x, y, z } = tg.Gyroscope;
});
```

### DeviceOrientation
```javascript
tg.DeviceOrientation.start();
tg.onEvent('deviceOrientationChanged', () => {
  const { alpha, beta, gamma } = tg.DeviceOrientation;
});
```

### LocationManager
```javascript
tg.LocationManager.init();
tg.LocationManager.getLocation((location) => {
  const { latitude, longitude } = location;
});
```

---

## События

```javascript
tg.onEvent('eventType', callback);
tg.offEvent('eventType', callback);
```

| Событие | Описание | Версия |
|---------|----------|--------|
| `themeChanged` | Изменилась тема | 6.0 |
| `viewportChanged` | Изменился viewport | 6.0 |
| `mainButtonClicked` | Нажата MainButton | 6.0 |
| `backButtonClicked` | Нажата BackButton | 6.1 |
| `settingsButtonClicked` | Нажата SettingsButton | 7.0 |
| `popupClosed` | Закрыт popup | 6.2 |
| `qrTextReceived` | QR код отсканирован | 6.4 |
| `clipboardTextReceived` | Буфер обмена получен | 6.4 |
| `secondaryButtonClicked` | Нажата SecondaryButton | 7.10 |
| `activated` | Приложение активировано | 8.0 |
| `deactivated` | Приложение деактивировано | 8.0 |
| `safeAreaChanged` | Изменился safe area | 8.0 |
| `contentSafeAreaChanged` | Изменился content safe area | 8.0 |
| `fullscreenChanged` | Изменился fullscreen | 8.0 |
| `fullscreenFailed` | Ошибка fullscreen | 8.0 |
| `homeScreenAdded` | Добавлено на Home Screen | 8.0 |

---

## ThemeParams — CSS переменные

```css
:root {
  --tg-theme-bg-color: ...;
  --tg-theme-text-color: ...;
  --tg-theme-hint-color: ...;
  --tg-theme-link-color: ...;
  --tg-theme-button-color: ...;
  --tg-theme-button-text-color: ...;
  --tg-theme-secondary-bg-color: ...;
  --tg-theme-header-bg-color: ...;       /* 7.0+ */
  --tg-theme-accent-text-color: ...;     /* 7.0+ */
  --tg-theme-section-bg-color: ...;      /* 7.0+ */
  --tg-theme-section-header-text-color: ...; /* 7.0+ */
  --tg-theme-bottom-bar-bg-color: ...;   /* 7.10+ */
}
```

---

## Валидация initData (Backend)

```go
// Go пример
import (
  "crypto/hmac"
  "crypto/sha256"
  "encoding/hex"
  "sort"
  "strings"
)

func ValidateInitData(initData, botToken string) bool {
  // 1. Парсим query string
  params := parseQueryString(initData)
  hash := params["hash"]
  delete(params, "hash")
  
  // 2. Сортируем и собираем data-check-string
  var keys []string
  for k := range params {
    keys = append(keys, k)
  }
  sort.Strings(keys)
  
  var pairs []string
  for _, k := range keys {
    pairs = append(pairs, k+"="+params[k])
  }
  dataCheckString := strings.Join(pairs, "\n")
  
  // 3. Вычисляем secret_key = HMAC-SHA256(bot_token, "WebAppData")
  secretKey := hmacSHA256([]byte("WebAppData"), []byte(botToken))
  
  // 4. Проверяем hash = HMAC-SHA256(data_check_string, secret_key)
  expectedHash := hex.EncodeToString(hmacSHA256(secretKey, []byte(dataCheckString)))
  
  return hmac.Equal([]byte(hash), []byte(expectedHash))
}
```

---

## Best Practices

### 1. Инициализация
```javascript
onMounted(() => {
  const tg = window.Telegram?.WebApp;
  if (!tg) return; // Не в Telegram
  
  tg.ready();
  tg.expand();
  
  // Safe area
  if (tg.contentSafeAreaInset) {
    applySafeArea(tg.contentSafeAreaInset);
  }
  
  // Theme
  applyTheme(tg.colorScheme);
  tg.onEvent('themeChanged', () => {
    applyTheme(tg.colorScheme);
  });
});
```

### 2. Проверка версии
```javascript
const isVersionAtLeast = (version, required) => {
  const v = version.split('.').map(Number);
  const r = required.split('.').map(Number);
  for (let i = 0; i < r.length; i++) {
    if ((v[i] || 0) > r[i]) return true;
    if ((v[i] || 0) < r[i]) return false;
  }
  return true;
};

// Использование
if (isVersionAtLeast(tg.version, '6.1')) {
  tg.HapticFeedback.impactOccurred('light');
}
```

### 3. Нативные элементы вместо HTML
- ❌ `<button>` внизу страницы
- ✅ `tg.MainButton.show()`
- ❌ Кастомный back button
- ✅ `tg.BackButton.show()`
- ❌ `alert()` / `confirm()`
- ✅ `tg.showPopup()` / `tg.showConfirm()`

---

## Changelog Summary

| Версия | Дата | Ключевые фичи |
|--------|------|---------------|
| **9.2** | 2025 | Latest stable |
| **9.1** | Jul 2025 | `hideKeyboard()` |
| **9.0** | Apr 2025 | DeviceStorage, SecureStorage |
| **8.0** | Nov 2024 | Fullscreen, SafeArea, HomeScreen, Sensors, Emoji Status |
| **7.10** | Sep 2024 | SecondaryButton, bottomBarColor |
| **7.8** | Jul 2024 | Main Mini App, shareToStory |
| **7.0** | Dec 2023 | SettingsButton, ThemeParams extended |
| **6.1** | 2023 | BackButton, HapticFeedback, setHeaderColor |
