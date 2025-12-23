# 🐛 Bug Fix SOP

> **Role:** Workflow: Bug Fix
> **Objective:** Diagnose, fix, and prevent bugs.

## Phase 1: Reproduction (QA Mode)

1.  **Identify:**
    - Read the bug report.
    - Locate the logs.
    - **Action:** Create a reproduction script or test case that FAILS.

## Phase 2: Fix (Developer Mode)

1.  **Analyze:**
    - Find the root cause (not just symptom).
2.  **Patch:**
    - Apply the fix.
3.  **Verify:**
    - Run the reproduction test case — it must PASS.

## Phase 3: Prevention (Architect Mode)

1.  **Root Cause Analysis:**
    - Why did this happen?
    - **Action:** Add entry to `core/reference/troubleshooting.md`.
2.  **Regression Test:**
    - Ensure new test remains in the suite.

## Phase 4: Release

1.  **Commit:**
    - `fix: ...`
2.  **Changelog:**
    - Update `project/CHANGELOG.md` (Fixed section).
