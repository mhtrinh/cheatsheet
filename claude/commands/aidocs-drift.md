---
description: Reconcile ai-docs/ when documentation has drifted after multiple changes
---

Reconcile `ai-docs/` with the current codebase. Use this when docs may have drifted after changes made outside the current conversation.

All subagents spawned by this command must first read `ai-docs/guidelines.md` (in the same directory as this command) before doing any work.

## Step 1 — Analyze (subagent)

Spawn a subagent with the following instructions:

> You are an analyzer. Read-only — do not edit any files.
>
> First, read `ai-docs/guidelines.md` to understand ai-docs conventions.
>
> Then:
> 1. Read `ai-docs/index.md` to get the full list of sub-doc paths.
> 2. Run `git diff --name-only HEAD~20` and `git diff --name-only` to collect all changed source files. Union the results. Filter to source files only (exclude docs, configs, tests unless tests reveal behavioral contracts).
> 3. For each sub-doc path, read only its first 30 lines (the frontmatter). Check if any `sources:` entry matches a changed file.
> 4. Collect matched sub-docs and their `sources:` file lists.
> 5. Identify changed files NOT listed in any sub-doc's `sources:` — these are unmatched files that may need a new sub-doc or addition to an existing one.
> 6. Run `wc -l` on every source file across all matched sub-docs' `sources:` lists. Sum the total.
>
> Return a manifest with:
> - `matchedSubDocs`: list of `{ path, sources, changedFiles }` for each matched sub-doc
> - `unmatchedFiles`: list of changed source files not covered by any sub-doc
> - `totalSourceLines`: the summed line count

## Step 2 — Decide strategy

From the manifest returned by the analyzer:

- `totalSourceLines < 3000` → **inline mode**: the master agent processes each sub-doc itself.
- `totalSourceLines >= 3000` → **fan-out mode**: each sub-doc is processed by a dedicated subagent.

## Step 3 — Generate proposals

Process each matched sub-doc **sequentially** (one at a time, never in parallel).

### Inline mode

For each matched sub-doc:
1. Read the sub-doc fully.
2. Read the source files listed in its `sources:` frontmatter.
3. Compare documented behavior against actual code behavior.
4. Write the proposed updated sub-doc to `/tmp/aidocs-drift/<sub-doc-filename>`.
5. Do not edit the real sub-doc.

### Fan-out mode

For each matched sub-doc, spawn a subagent with these instructions:

> First, read `ai-docs/guidelines.md` to understand ai-docs conventions.
>
> You are a documentation updater. You will propose changes — do not edit the real sub-doc.
>
> Your assignment:
> - Sub-doc path: `{path}`
> - Source files: `{sources}`
> - Changed files in this sub-doc's scope: `{changedFiles}`
>
> Instructions:
> 1. Read the sub-doc fully.
> 2. Read the source files listed above.
> 3. Compare documented behavior against actual code behavior.
> 4. Write the proposed updated sub-doc to `/tmp/aidocs-drift/{sub-doc-filename}`.
> 5. Return a summary (under 1000 words) of what changed and why.
> 6. If you encounter a detail that may violate guidelines and is not marked `[pinned]`, note it in your summary for the user to decide.

Wait for the subagent to complete before spawning the next one.

## Step 4 — Handle unmatched files

If the manifest contains `unmatchedFiles`:
1. For each file, determine the appropriate subsystem.
2. Propose adding it to an existing sub-doc's `sources:` list, or propose a new sub-doc.
3. Write any new sub-doc proposals to `/tmp/aidocs-drift/`.
4. Include these in the summary presented to the user.

## Step 5 — Present to user for approval

Present a summary of all proposed changes:
- For each sub-doc: what sections changed and why (from subagent summaries or inline analysis).
- Any new sub-docs proposed.
- Any `[pinned]` questions.

Wait for user response.

## Step 6 — Apply or revise

**User approves** ("good", "ok", "apply", etc.):
- Master copies each proposed file from `/tmp/aidocs-drift/` to its real sub-doc path directly.
- Master updates `ai-docs/index.md` if new sub-docs were added.

**User requests tweaks**:
- Discuss the tweaks with the user (natural language, no file reads).
- Once the tweak is understood, spawn a subagent:

> Read `ai-docs/guidelines.md` first. Then read `/tmp/aidocs-drift/{filename}`. Apply the following revision: {tweak instructions from user}. Write the revised version back to `/tmp/aidocs-drift/{filename}`. Return a summary of what changed.

- Re-present the updated summary to the user.
- Loop until approved, then master applies as above.

## Rules

- Master agent must never read source files directly — delegate to analyzer or per-sub-doc subagents.
- All proposals go to `/tmp/aidocs-drift/` before touching real files.
- Sequential processing only — never spawn parallel subagents.
- All other documentation rules are in `ai-docs/guidelines.md` — do not duplicate them here.
