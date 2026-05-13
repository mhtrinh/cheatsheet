---
name: aidocs-init
description: Initialize and bootstrap ai-docs/ documentation for the current project. Use when setting up ai-docs for a new project or when asked to create project documentation structure.
---

Initialize `ai-docs/` documentation for the current project. Run all phases in sequence.

## Phase 1 — Setup

1. Run: `cp ~/.kiro/skills/aidocs-init/assets/guidelines.md ai-docs/guidelines.md` (create `ai-docs/` if it doesn't exist).
2. Read `ai-docs/guidelines.md` to understand the writing rules before proceeding.

## Phase 2 — Discovery

1. List top-level directories in the project root, excluding: `.git`, `.kiro`, `node_modules`, `__pycache__`, `build`, `dist`, `.cache`, `target`, `out`, `ai-docs`, and hidden directories.
2. For each directory found:
   - If its name is a generic container (`src`, `lib`, `app`, `packages`, `cmd`, `internal`, `pkg`), scan one level deeper and treat each subdirectory inside as a separate component.
   - Otherwise, treat the directory itself as a component.
3. For each component, scan its source files and infer its logical role.
4. Group components into subsystems. Complex individual modules that warrant deep docs go in `modules/`.
5. **STOP and present the proposed groupings to the user.** Show which components map to which subsystem docs, and which (if any) get their own module doc. Wait for user approval or adjustments before proceeding.

## Phase 3 — Scaffold

After user approves the groupings:

1. Create folder structure:
   - `ai-docs/subsystems/`
   - `ai-docs/modules/`
2. Write `ai-docs/README.md`:
   - Explains folder intent.
   - States the no-implementation-leakage rule: docs describe WHAT, not HOW.
   - Describes agent update protocol: run `/aidocs-update` after non-trivial implementations, run `/aidocs-drift` for reconciliation.
   - References `ai-docs/guidelines.md` as the authoritative writing rules.
3. Write `ai-docs/index.md`:
   - Concept-based master index listing subsystem/module concepts and their sub-doc paths.
   - No source file references in this file — those live in each sub-doc's frontmatter.
4. Write each sub-doc as a stub with YAML frontmatter (`sources:` listing the relevant source files) and empty behavioral section headings.

## Phase 4 — Populate sub-docs

For each sub-doc path listed in `ai-docs/index.md`:

1. Read only the source files listed in its `sources:` frontmatter, following the reading strategy in `ai-docs/guidelines.md`.
2. Write the behavioral sections defined in `ai-docs/guidelines.md`.
3. Complete one sub-doc fully before moving to the next.
