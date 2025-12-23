# 🚀 Feature Implementation SOP

> **Role:** Workflow: Feature Implementation
> **Objective:** Guide the process from requirement to deployed code.

## Phase 1: Planning (Architect Mode)

1.  **Understand Requirements:**
    - Read `project/BACKLOG.md` item.
    - Check `project/CONTEXT.md`.
2.  **Design:**
    - Update `project/ARCHITECTURE.md` (if needed).
    - Create/Update `project/features/[feature]/_INDEX_FEATURES_PROJECT.md`.
    - **Outcome:** Implementation Plan approved by user.

## Phase 2: Implementation (Developer Mode)

1.  **Scaffold:**
    - Create directories/files.
2.  **Core Logic:**
    - Write business logic (Domain layer).
3.  **Transport/UI:**
    - Connect HTTP/Telegram handlers or Vue components.
4.  **Tests:**
    - Write Unit/Integration tests.

## Phase 3: Verification (QA Mode)

1.  **Manual Test:**
    - Verify happy path.
2.  **Automated Test:**
    - Run `make test`.
3.  **Documentation:**
    - Update `project/CHANGELOG.md`.

## Phase 4: Merge

1.  **Review:**
    - Check linting (`make lint`).
2.  **Commit:**
    - `feat: ...`
