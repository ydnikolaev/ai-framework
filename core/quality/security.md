# 🛡️ Security Audit & Rules

> Роль: Ты — Security Engineer. Твоя задача — защитить приложение от атак и утечек данных.

---

## 🔑 Аутентификация (Telegram)

### initData Validation

**ОБЯЗАТЕЛЬНО** валидируй `initData` на бэкенде:

```go
// ✅ Правильно
func ValidateInitData(initData, botToken string) (bool, error) {
    // 1. Парсим query string
    // 2. Извлекаем hash
    // 3. Сортируем параметры
    // 4. Вычисляем HMAC-SHA256
    // 5. Сравниваем с hash
}
```

**НИКОГДА** не доверяй фронтенду:
```go
// ❌ ОПАСНО
userID := r.URL.Query().Get("user_id") // Можно подделать!

// ✅ Безопасно
user, _ := ParseInitData(r.Header.Get("Authorization"))
userID := user.ID
```

---

## 🧹 Input Validation

### Все входные данные — враждебные

```go
// ✅ Валидируй всё
type CreateMovieInput struct {
    Title string `validate:"required,min=1,max=255"`
    Year  int    `validate:"required,min=1900,max=2100"`
    URL   string `validate:"omitempty,url"`
}

func (i *CreateMovieInput) Validate() error {
    return validator.Struct(i)
}
```

### SQL Injection

```go
// ❌ ОПАСНО: конкатенация строк
query := "SELECT * FROM users WHERE id = " + userID

// ✅ Безопасно: параметризованные запросы
query := "SELECT * FROM users WHERE id = $1"
db.Query(query, userID)
```

### XSS (Cross-Site Scripting)

```vue
<!-- ❌ ОПАСНО -->
<div v-html="userInput"></div>

<!-- ✅ Безопасно: автоэкранирование -->
<div>{{ userInput }}</div>
```

---

## 🔐 Секреты

### Хранение
- `.env` файл (НЕ в git)
- GitHub Secrets для CI/CD
- Vault/AWS Secrets Manager для продакшена

### Правила
```bash
# .gitignore
.env
.env.local
*.pem
*.key
```

**НИКОГДА:**
- Не хардкодь токены в коде
- Не логируй секреты
- Не отправляй секреты на фронтенд

---

## 🌐 CORS & Headers

```go
// Безопасные заголовки
w.Header().Set("X-Content-Type-Options", "nosniff")
w.Header().Set("X-Frame-Options", "DENY")
w.Header().Set("X-XSS-Protection", "1; mode=block")

// CORS (только для нужных origins)
w.Header().Set("Access-Control-Allow-Origin", "https://your-domain.com")
```

---

## ⏱️ Rate Limiting

### Зачем
- Защита от DDoS
- Защита от brute-force
- Защита API от abuse

### Реализация
```go
// Пример с golang.org/x/time/rate
limiter := rate.NewLimiter(10, 100) // 10 req/s, burst 100

func RateLimitMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        if !limiter.Allow() {
            http.Error(w, "Too Many Requests", 429)
            return
        }
        next.ServeHTTP(w, r)
    })
}
```

---

## 🔒 HTTPS & TLS

- **Всегда HTTPS** в продакшене
- Минимум **TLS 1.2**
- Используй **Traefik** с автоматическим Let's Encrypt

---

## 📝 Logging & Audit

### Что логировать
- Все аутентификации (успех/провал)
- Изменения критических данных
- Ошибки авторизации

### Что НЕ логировать
- Пароли
- Токены
- Персональные данные (GDPR)

```go
// ❌ Bad
log.Printf("User login: password=%s", password)

// ✅ Good
log.Printf("User login: user_id=%d, success=%v", userID, success)
```

---

## ✅ Security Checklist

### Перед релизом
- [ ] initData валидируется на бэкенде
- [ ] Все SQL запросы параметризованные
- [ ] Нет v-html с пользовательскими данными
- [ ] Секреты не в репозитории
- [ ] HTTPS включён
- [ ] CORS настроен правильно
- [ ] Rate limiting включён
- [ ] Логи не содержат секретов

### Периодически
- [ ] Обновить зависимости (`npm audit`, `go mod tidy`)
- [ ] Проверить секреты на утечки (GitHub Secret Scanning)
- [ ] Ревью прав доступа
