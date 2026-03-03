---
description: Initialize and bootstrap ai-docs/ documentation for the current project
---

Initialize `ai-docs/` documentation for the current project. Run both phases in sequence.

## Phase 1 — Discovery and Structure

1. List all source files under `src/` (including subdirectories).
2. Group files into logical subsystems. Common groupings for this codebase:
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
4. Write `ai-docs/README.md`:
   - Explains folder intent
   - States the no-implementation-leakage rule: docs describe WHAT, not HOW
   - Describes agent update protocol: run `/aidocs-update` after non-trivial implementations
5. Write `ai-docs/index.md`:
   - Concept-based master index listing subsystem concepts and their sub-doc paths
   - No source file references in this file — those live in each sub-doc's frontmatter
6. Write each sub-doc as a stub with YAML frontmatter:

```yaml
---
sources:
  - src/FrameSynchronizer.hpp
  - src/FrameSynchronizer.cpp
---
```

## Phase 2 — Populate sub-docs

For each sub-doc path listed in `ai-docs/index.md`:

1. Read only the source files listed in its `sources:` frontmatter.
   - Prefer `.hpp` headers; read `.cpp` only if the header is insufficient to understand behavior.
2. Write behavioral sections:
   - **Responsibilities** — what this module/subsystem is accountable for
   - **Inputs / Outputs** — what it receives, what it produces, and in what form
   - **Key Contracts** — preconditions, postconditions, invariants the caller must respect
   - **Expected Behavior** — how it behaves under normal conditions and notable edge cases
3. Describe WHAT, not HOW. No mutex types, lock strategies, internal data structures, algorithm internals, or implementation-specific details.
4. Complete one sub-doc fully before moving to the next. Do not accumulate all headers in context simultaneously.

## Rules

- No implementation leakage in any sub-doc.
- If a source file doesn't fit any existing subsystem, create a new subsystem entry in `ai-docs/index.md` and a new sub-doc.
- All sub-docs must have `sources:` frontmatter listing their authoritative source files.
