# Changelog

All notable changes to this project will be documented in this file.

## [1.2.0] - 2025-12-23

### Added
- **DX Upgrade v2**:
  - **Auto-Cleanup**: `dev-cleanup.sh` kills zombie processes (bot/api) on restart (stops "Conflict: terminated by other getUpdates").
  - **Pretty Logs**: `dx-log-formatter.py` parses and colorizes Docker Compose logs (Postgres/Redis) with truncation.
  - **API Tunnel**: Dual tunnel support (31337 Front, 31338 API) integrated into `dev-full.py`.
  - **Deploy Watch**: Stylish header and simplified notifications.

## [1.1.0] - 2025-12-23

### Changed
- **Mermaid Rules**: Updated `mermaid-rules.md` to promote "High-Level DX" (Shapes, Icons, Chaining). Deprecated "Compatibility Mode".
- **Troubleshooting**: Added guide for fixing Mermaid rendering issues ("No diagram type detected").
- **Documentation Guide**: Clarified when to update project docs.

## [1.0.0] - 2025-12-23

### Added
- **Agent OS Core**: Introduced `core/agents/` (Architect, Developer, QA, Tech Writer).
- **Workflows (SOPs)**: Added `core/workflows/` with standard procedures for features, bugs, and refactoring.
- **Project Memory**: Added `project/memory/` for active agent context (`scratchpad.md`).
- **Project Knowledge**: Added `project/knowledge/` for static rules and `user-glossary.md`.
- **Glossary Feature**: Implemented "User-AI Glossary" for terminology mapping.
- **Templates**: Updated all project templates to reflect the v2.0 structure.

### Changed
- **Architecture**: Full upgrade to v2.0 "Agent Operating System" philosophy.
- **File Naming**: Enforced `_INDEX_[TOPIC]_[SCOPE].md` convention for all indices to avoid `README.md` ambiguity for AI.
- **Setup Script**: Updated `setup.sh` to scaffold the new directory structure and files.
- **Documentation Guide**: Updated `documentation-guide.md` with new strict rules for AI-Agent interaction.
