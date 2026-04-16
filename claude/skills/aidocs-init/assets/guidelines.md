# ai-docs Guidelines

This file is the single source of truth for ai-docs writing rules. All commands and subagents that create or modify ai-docs must follow these guidelines.

## Content Rules

### WHAT, not HOW

- Describe observable behavior, responsibilities, inputs, outputs, contracts.
- Do not describe: mutex types, lock strategies, internal data structures, algorithm internals, implementation-specific details.

### Behavioral Sections

Each sub-doc should contain these sections as applicable:

- **Responsibilities** — what this module/subsystem is accountable for.
- **Inputs / Outputs** — what it receives, what it produces, and in what form.
- **Key Contracts** — preconditions, postconditions, invariants the caller must respect.
- **Expected Behavior** — how it behaves under normal conditions and notable edge cases.

### Reading Strategy

- Prefer header/interface files over implementation files. Read implementation only if the interface is insufficient to understand behavior.
- Complete one sub-doc fully before moving to the next. Do not accumulate multiple sub-docs' source files in context simultaneously.

### Minimal Edits

- Only update sections where documented behavior diverges from actual code.
- Do not rewrite sections that are still accurate.

### Frontmatter

All sub-docs must have `sources:` YAML frontmatter listing their authoritative source files:

```yaml
---
sources:
  - src/FrameSynchronizer.hpp
  - src/FrameSynchronizer.cpp
---
```

### Pinned Entries

Some sub-docs contain specific values (thresholds, magic numbers, fixed strings, hardware constants) marked with `[pinned]`. These were placed deliberately by the user as part of the specification.

- If marked `[pinned]` — leave it. Only remove if the corresponding feature is confirmed obsolete.
- If a detail appears to violate "WHAT not HOW" and is **not** marked `[pinned]` — flag it for the user to decide. If the user says keep, add the `[pinned]` footnote.
- Never silently remove a `[pinned]` entry. Ask the user first.

## Structural Rules

### index.md

- `ai-docs/index.md` is a concept-based master index listing subsystem concepts and their sub-doc paths.
- No source file references in index.md — those live in each sub-doc's frontmatter.

### Subsystem Grouping

- Files that belong to the same logical subsystem share a sub-doc.
- If a source file doesn't fit any existing subsystem, create a new sub-doc and add it to index.md.

### Folder Structure

- `ai-docs/subsystems/` — subsystem-level documentation.
- `ai-docs/modules/` — complex individual modules that warrant deep docs.
