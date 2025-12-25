# 🧠 AI-First Framework

> **Knowledge Base** & **Architecture Patterns** for AI-driven development.
> Designed to be used with **Sky CLI**.

> **🤖 AI-AGENT:** Start navigation here → [`core/_INDEX_CORE_FRAMEWORK.md`](core/_INDEX_CORE_FRAMEWORK.md)

---

## ⚡ Quick Start

This repository contains the **intellectual core** (rules, architecture, memories).
To create a new project and set up the environment, use **Sky CLI**:

```bash
# 1. Install Sky CLI (if not installed)
make install

# 2. Create a new project
sky init
```

Sky CLI will automatically:
- Scaffolding the project structure
- Generate Makefile & Environments
- Include this **AI Framework** (as a submodule) for architecture reference

---

## 📂 Structure

```text
ai-framework/
│
├── README.md                # ← You are here
│
├── core/                    # 🔒 FRAMEWORK RULES (The "Brain")
│   ├── _INDEX_CORE_FRAMEWORK.md # 🤖 AI Map
│   ├── agents/             # AI Agents Personas
│   ├── workflows/          # Standard Operating Procedures
│   ├── architecture/       # Architectural Patterns (Clean Arch)
│   ├── design/             # Design System Principles
│   ├── stack/              # Technology Stack Rules
│   ├── quality/            # QA & Audits
│   ├── operations/         # Git Flow & Documentation Rules
│   ├── dx/                 # Developer Experience Standards
│   ├── meta/               # Framework Principles
│   └── reference/          # Glossaries
│
└── docs/                    # 📚 TECHNOLOGIES (External Docs)
    └── [frameworks...]     # (Vue, Nuxt, Telegram, etc.)
```

> **Note:** Infrastructure, Deployment scripts, and DevOps tooling have moved to **Sky CLI**.

---

## 🎯 Usage

### For Humans
Use this repository as a **Reference Manual**:
- **Architecture:** How to structure code? (`core/architecture/`)
- **Git Flow:** How to manage branches? (`core/operations/git-flow.md`)
- **Prompts:** How to generate docs? (`core/operations/ai-documentation-generation.md`)

### For AI Models
Always read `core/_INDEX_CORE_FRAMEWORK.md` first to understand the rules of the game before generating code.

---

## 🔄 Updates

To update the knowledge base in your project:

```bash
cd ai-framework
git pull origin main
```

---

## 📝 License

Private / Internal Use.
