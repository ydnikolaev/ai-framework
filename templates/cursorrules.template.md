# AI BEHAVIOR RULES

> Этот файл автоматически читается AI-моделями в IDE (Cursor, Windsurf, etc.)

Общайся со мной только на русском языке.

---

## 1. CONTEXT — ЧИТАЙ ПЕРВЫМ!

**ПЕРЕД любой работой с проектом:**

1. **`ai-framework/project/CONFIG.yaml`** — стек, версии, настройки
2. **`ai-framework/project/CONTEXT.md`** — специфика проекта
3. **`ai-framework/core/_INDEX.md`** — карта всей документации

---

## 2. СТРУКТУРА ДОКУМЕНТАЦИИ

```text
ai-framework/
├── core/           # Универсальные правила (READ-ONLY)
│   ├── stack/      # Правила по технологиям (Go, Nuxt, Konsta, etc.)
│   ├── quality/    # Аудиты (performance, security, seo)
│   ├── operations/ # DevOps (docker, ci-cd, deployment)
│   └── reference/  # Справочники (troubleshooting, cheat-sheet)
│
├── docs/           # API документация фреймворков
│   └── [framework]/README.md
│
└── project/        # Специфика ЭТОГО проекта
    ├── CONFIG.yaml
    ├── CONTEXT.md
    ├── DECISIONS.md
    └── PROMPTS.md
```

---

## 3. CODING STANDARDS

- **Go:** `ai-framework/core/stack/golang.md`
- **Frontend:** `ai-framework/core/stack/nuxt-vue.md`
- **UI:** `ai-framework/core/stack/konsta-ui.md`
- **Telegram:** `ai-framework/core/stack/telegram.md`
- **Database:** `ai-framework/core/stack/database.md`
- **Анимации:** `ai-framework/core/stack/lottie.md`

---

## 4. ПОСЛЕ ЗАВЕРШЕНИЯ ЗАДАЧИ — ОБНОВИ ДОКУМЕНТАЦИЮ!

> Смотри: `ai-framework/core/reference/documentation-guide.md`

| Событие | Что обновить |
|---------|--------------|
| Исправил баг | `core/reference/troubleshooting.md` |
| Принял решение | `project/DECISIONS.md` |
| Добавил фичу | `project/CHANGELOG.md` |
| Узнал quirk | `docs/[framework]/README.md` |

---

## 5. ПРАВИЛА РАБОТЫ

- **Never** remove existing comments unless rewriting logic
- **Always** check for existing "TODO" or "FIXME" near code you touch
- **Always** update documentation after significant changes
- Be concise, focus on the solution
- Explain "Why" only if the decision is non-obvious
