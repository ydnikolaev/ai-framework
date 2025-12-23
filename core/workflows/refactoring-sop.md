# ♻️ Refactoring SOP

> **Role:** Workflow: Refactoring
> **Objective:** Improve code structure without changing behavior.

## Phase 1: Safety Check (QA Mode)

1.  **Verify Base State:**
    - Run ALL tests (`make test`).
    - **CRITICAL:** Tests must pass BEFORE starting.

## Phase 2: Refactor (Developer Mode)

1.  **Small Steps:**
    - Rename variable -> Test.
    - Extract function -> Test.
    - Move file -> Test.
2.  **No Behavior Changes:**
    - Do NOT add features.
    - Do NOT fix bugs (unless critical blocker).

## Phase 3: Review (Architect Mode)

1.  **Code Quality:**
    - Is it more readable?
    - Is it strictly typed?
    - Does it follow updated `stack` rules?

## Phase 4: Commit

1.  **Commit:**
    - `refactor: ...`
