# 📦 Templates — Index

> **Role:** Project Template Reference
> **Objective:** Provide starter files for new projects.
> **Context:** Used by setup.sh to initialize project structure.

---

## 📂 Структура

```
templates/
├── .env.example              # Переменные окружения
├── .gitignore.append         # Добавки в .gitignore
├── Makefile.template         # Makefile для проекта
│
├── docker-compose.template.yml       # Dev compose
├── docker-compose.prod.template.yml  # Production compose
│
├── project/                  # Шаблоны для project/
│   ├── CONFIG.yaml.template
│   ├── CONTEXT.md.template
│   ├── BACKLOG.md.template
│   └── ...
│
├── shell/                    # DX скрипты
│   ├── dev-full.py
│   ├── dev-restart.py
│   ├── dx-logs.sh
│   └── ...
│
├── go/                       # Go-specific templates
│   └── dxlog/
│
└── make/                     # Makefile includes
    └── dx.mk
```

---

## 🎯 Использование

Templates копируются при запуске `./setup.sh`:
1. `project/*.template` → `project/*`
2. `Makefile.template` → `Makefile`
3. `shell/*` → `scripts/*`
4. `docker-compose.*.template.yml` → `docker-compose.*.yml`

---

## ⚠️ Подстановка переменных

Все шаблоны используют `${PROJECT_NAME}` и другие переменные из `.env`.
Hardcoded значения запрещены.

---

## 🔗 Связанные

- [../setup/](../setup/) — Setup scripts
- [.env.example](.env.example) — Полный список переменных
