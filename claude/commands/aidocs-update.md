---
description: Update ai-docs/ after a non-trivial implementation
---

Update `ai-docs/` to reflect the implementation just completed. Run while the implementation is still in context.

## Protocol

1. From context, list all source files that were touched or created in the implementation.

2. Read `ai-docs/index.md` to get the full list of sub-doc paths.

3. For each sub-doc path, read only its first 30 lines (the frontmatter). Check if any `sources:` entry matches a touched file.

4. Load only the matching sub-docs fully.

5. For each matching sub-doc:
   - Read the source headers listed in its `sources:` frontmatter to understand current behavior.
   - Update only the behavioral sections affected by the implementation.
   - Do not add implementation details (no mutex types, lock strategies, internal data structures, algorithm internals).

6. If new modules were added that are not covered by any existing sub-doc:
   - Determine the appropriate subsystem for the new module.
   - Add the new source files to that subsystem's sub-doc `sources:` frontmatter, or create a new sub-doc if warranted.
   - Update `ai-docs/index.md` to reflect any new sub-docs or changed concepts.

## Rules

- Describe WHAT, not HOW.
- Only update sections that are actually affected by the implementation.
- Do not rewrite unrelated sections.
- All modified sub-docs must retain their `sources:` frontmatter.
