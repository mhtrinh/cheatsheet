---
name: aidocs-drift
description: Reconcile ai-docs/ when documentation has drifted after multiple changes. Use when ai-docs may be outdated relative to the current codebase.
---

Reconcile `ai-docs/` with the current codebase. Use this when docs may have drifted after changes made outside the current conversation.

All subagents must read `ai-docs/guidelines.md` before doing any work.

## Step 1 — Analyze

Spawn a subagent pipeline with a single stage:

```json
{
  "task": "Analyze ai-docs drift against recent git changes",
  "stages": [
    {
      "name": "analyze",
      "role": "default",
      "prompt_template": "You are an analyzer. Read-only — do not edit any files.\n\nFirst, read `ai-docs/guidelines.md` to understand ai-docs conventions.\n\nThen:\n1. Read `ai-docs/index.md` to get the full list of sub-doc paths.\n2. Run `git diff --name-only HEAD~20` and `git diff --name-only` to collect all changed source files. Union the results. Filter to source files only (exclude docs, configs, tests unless tests reveal behavioral contracts).\n3. For each sub-doc path, read only its first 30 lines (the frontmatter). Check if any `sources:` entry matches a changed file.\n4. Collect matched sub-docs and their `sources:` file lists.\n5. Identify changed files NOT listed in any sub-doc's `sources:` — these are unmatched files that may need a new sub-doc or addition to an existing one.\n6. Run `wc -l` on every source file across all matched sub-docs' `sources:` lists. Sum the total.\n\nReturn a manifest with:\n- `matchedSubDocs`: list of `{ path, sources, changedFiles }` for each matched sub-doc\n- `unmatchedFiles`: list of changed source files not covered by any sub-doc\n- `totalSourceLines`: the summed line count"
    }
  ]
}
```

## Step 2 — Decide strategy

From the manifest:

- `totalSourceLines < 3000` → proceed to Step 3 directly.
- `totalSourceLines >= 3000` → confirm with user before proceeding (large context cost).

## Step 3 — Generate proposals

Spawn a subagent pipeline where each matched sub-doc gets its own stage, chained sequentially. Each stage depends on the previous one. The master agent constructs each `prompt_template` by interpolating `{path}`, `{sources}`, and `{changedFiles}` from the manifest before invoking the tool:

```json
{
  "task": "Generate ai-docs update proposals",
  "stages": [
    {
      "name": "update-{sub-doc-1-name}",
      "role": "default",
      "prompt_template": "First, read `ai-docs/guidelines.md` to understand ai-docs conventions.\n\nYou are a documentation updater. You will propose changes — do not edit the real sub-doc.\n\nYour assignment:\n- Sub-doc path: `{path}`\n- Source files: `{sources}`\n- Changed files in this sub-doc's scope: `{changedFiles}`\n\nInstructions:\n1. Read the sub-doc fully.\n2. Read the source files listed above.\n3. Compare documented behavior against actual code behavior.\n4. When reading other sub-docs for cross-reference, check `/tmp/aidocs-drift/` first — if a proposed version exists there, use it instead of the real file.\n5. Write the proposed updated sub-doc to `/tmp/aidocs-drift/{sub-doc-filename}`.\n6. Return a summary (under 1000 words) of what changed and why.\n7. If you encounter a detail that may violate guidelines and is not marked `[pinned]`, note it in your summary for the user to decide."
    },
    {
      "name": "update-{sub-doc-2-name}",
      "role": "default",
      "prompt_template": "...(same template with sub-doc-2 variables)...",
      "depends_on": ["update-{sub-doc-1-name}"]
    }
  ]
}
```

Each stage depends on the previous — ensuring cross-referenced sub-docs read the latest proposed version from `/tmp/aidocs-drift/`.

## Step 4 — Handle unmatched files

If the manifest contains `unmatchedFiles`, spawn a subagent:

```json
{
  "task": "Propose ai-docs coverage for unmatched source files",
  "stages": [
    {
      "name": "unmatched",
      "role": "default",
      "prompt_template": "Read `ai-docs/guidelines.md` first. Then read `ai-docs/index.md` for existing sub-doc structure.\n\nThe following source files changed but are not covered by any sub-doc:\n{unmatchedFiles list}\n\nFor each file:\n1. Read the file to understand its role.\n2. Determine the appropriate subsystem.\n3. Propose adding it to an existing sub-doc's `sources:` list, OR propose a new sub-doc if it represents a new module.\n4. For new sub-docs, write the proposal to `/tmp/aidocs-drift/{new-sub-doc-filename}`.\n5. When reading other sub-docs for context, check `/tmp/aidocs-drift/` first — if a proposed version exists there, use it instead of the real file.\n\nReturn a summary of what you propose for each unmatched file."
    }
  ]
}
```

Include the subagent's proposals in the summary presented to the user.

## Step 5 — Present to user for approval

Present a summary of all proposed changes:
- For each sub-doc: what sections changed and why (from subagent summaries).
- Any new sub-docs proposed.
- Any `[pinned]` questions.

Wait for user response.

## Step 6 — Apply or revise

**User approves** ("good", "ok", "apply", etc.):
- Copy each proposed file from `/tmp/aidocs-drift/` to its real sub-doc path.
- Update `ai-docs/index.md` if new sub-docs were added.

**User requests tweaks**:
- Spawn a subagent to apply the revision:

```json
{
  "task": "Revise ai-docs proposal per user feedback",
  "stages": [
    {
      "name": "revise",
      "role": "default",
      "prompt_template": "Read `ai-docs/guidelines.md` first. Then read `/tmp/aidocs-drift/{filename}`. Apply the following revision: {tweak instructions from user}. Write the revised version back to `/tmp/aidocs-drift/{filename}`. Return a summary of what changed."
    }
  ]
}
```

- Re-present the updated summary to the user.
- Loop until approved, then apply as above.

## Rules

- Master agent must never read source files directly — delegate to subagents.
- All proposals go to `/tmp/aidocs-drift/` before touching real files.
- Sub-doc update stages run sequentially (chained `depends_on`) — sub-docs may cross-reference each other, so each stage must be able to read prior proposals from `/tmp/aidocs-drift/`.
- All other documentation rules are in `ai-docs/guidelines.md` — do not duplicate them here.
