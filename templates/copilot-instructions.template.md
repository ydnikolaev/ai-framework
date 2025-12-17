# GitHub Copilot Instructions

> Этот файл автоматически читается GitHub Copilot.

## Language
Communicate in Russian (русский язык).

## Project Context
Before answering, read:
1. `ai-framework/project/CONFIG.yaml` — tech stack and versions
2. `ai-framework/project/CONTEXT.md` — project specifics
3. `ai-framework/core/_INDEX.md` — documentation map

## Documentation Structure
```
ai-framework/
├── core/           # Universal rules (READ-ONLY)
│   ├── stack/      # Tech rules: golang.md, nuxt-vue.md, konsta-ui.md
│   ├── quality/    # Audits: performance.md, security.md, seo.md
│   └── reference/  # troubleshooting.md, documentation-guide.md
├── docs/           # Framework API docs
└── project/        # THIS project's context
```

## Coding Standards
- **Go:** Follow `ai-framework/core/stack/golang.md`
- **Vue/Nuxt:** Follow `ai-framework/core/stack/nuxt-vue.md`
- **UI:** Follow `ai-framework/core/stack/konsta-ui.md` (Liquid Glass style)
- **Telegram:** Follow `ai-framework/core/stack/telegram.md`

## After Completing Tasks
**ALWAYS update documentation!** See `ai-framework/core/reference/documentation-guide.md`

| Event | Update |
|-------|--------|
| Fixed bug | `core/reference/troubleshooting.md` |
| Made decision | `project/DECISIONS.md` |
| Added feature | `project/CHANGELOG.md` |
| Learned quirk | `docs/[framework]/README.md` |

## Code Style
- Use Composition API (`<script setup>`)
- Handle errors explicitly in Go
- Never remove existing comments unless rewriting logic
- Check for TODO/FIXME near code you touch
