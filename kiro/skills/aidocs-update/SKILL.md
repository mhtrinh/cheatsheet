---
name: aidocs-update
description: Update ai-docs/ after a non-trivial implementation. Use right after completing an implementation while context is fresh.
---

Update `ai-docs/` to reflect recent implementation changes. Run this right after an implementation while context is fresh.

Read `ai-docs/guidelines.md` before proceeding.

## Step 1 — Collect touched files

From context, list all source files that were touched or created in the implementation.

## Step 2 — Identify affected sub-docs

1. Read `ai-docs/index.md` to get the full list of sub-doc paths.
2. For each sub-doc path, read only its first 30 lines (the frontmatter). Check if any `sources:` entry matches a touched file from Step 1.
3. Collect the matching sub-docs.

## Step 3 — Detect undocumented source files

From the touched files, identify any that are NOT listed in any sub-doc's `sources:` frontmatter. These are candidates for:
- Adding to an existing sub-doc's `sources:` list, or
- Creating a new sub-doc if they represent a new subsystem/module.

## Step 4 — Update matching sub-docs

For each matching sub-doc:
1. Read it fully.
2. Read the source files listed in its `sources:` frontmatter to understand **current** behavior.
3. Compare the documented behavior against actual code behavior.
4. Update only the sections where behavior has diverged.

## Step 5 — Handle new modules

If Step 3 found undocumented source files:
1. Determine the appropriate subsystem for each.
2. Add the files to that subsystem's sub-doc `sources:` frontmatter, or create a new sub-doc if warranted.
3. For new sub-docs, populate using the behavioral sections defined in `ai-docs/guidelines.md`.
4. Update `ai-docs/index.md` to reflect any new sub-docs or changed concepts.
