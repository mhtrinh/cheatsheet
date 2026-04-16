---
name: aidocs-init
description: Initialize and bootstrap ai-docs/ documentation for the current project. Use when setting up ai-docs for a new project or when asked to create project documentation structure.
disable-model-invocation: true
---

Initialize `ai-docs/` documentation for the current project. Run both phases in sequence.

## Phase 1 — Discovery and Structure

1. List all source files under `src/` (including subdirectories).
2. Group files into logical subsystems. Common groupings:
   - Camera Input (grabbing, SDK callbacks, frame sync)
   - Vision Processing (detection, thresholding, blob analysis)
   - Data Transport (ring buffers, frame packs, queues)
   - UI Rendering (diagnostic overlays, widgets, tabs)
   - Ejection (timing, triggering, solenoid control)
   - Orchestration / Pipeline (top-level coordination, main loop)
   - Complex individual modules that warrant deep docs go in `ai-docs/modules/`
3. Create folder structure:
   - `ai-docs/`
   - `ai-docs/subsystems/`
   - `ai-docs/modules/`
4. Copy `${CLAUDE_SKILL_DIR}/assets/guidelines.md` to `ai-docs/guidelines.md`.
5. Read `ai-docs/guidelines.md` to understand the writing rules before proceeding.
6. Write `ai-docs/README.md`:
   - Explains folder intent
   - States the no-implementation-leakage rule: docs describe WHAT, not HOW
   - Describes agent update protocol: run `/aidocs-update` after non-trivial implementations, run `/aidocs-drift` for reconciliation
   - References `ai-docs/guidelines.md` as the authoritative writing rules
7. Write `ai-docs/index.md`:
   - Concept-based master index listing subsystem concepts and their sub-doc paths
   - No source file references in this file — those live in each sub-doc's frontmatter
8. Write each sub-doc as a stub with YAML frontmatter as defined in `ai-docs/guidelines.md`.

## Phase 2 — Populate sub-docs

For each sub-doc path listed in `ai-docs/index.md`:

1. Read only the source files listed in its `sources:` frontmatter, following the reading strategy in `ai-docs/guidelines.md`.
2. Write the behavioral sections defined in `ai-docs/guidelines.md`.
3. Complete one sub-doc fully before moving to the next.
