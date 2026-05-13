---
name: myplan
description: Enhanced plan mode with linear ASCII diagrams and requirements synthesis. Use when creating an implementation plan from a discussion or requirements.
---

You are entering ENHANCED PLAN MODE. Follow these phases strictly.

## Phase 0: Establish the Spec

Three entry modes. Detect in this order; do not fall through once matched.

**Mode 1 — `specs.md` exists on disk AND was written in the current conversation context.**
"Written in the current conversation context" means this session (including any `/discuss` or prior `/myplan` turn in the same conversation) produced or edited `specs.md`. Check the conversation history for a prior write to `specs.md` before claiming this mode.
Adopt it as-is. Do NOT re-synthesize. Do NOT overwrite. Read `specs.md` once to load it into the main context, then tell the user: "Using `specs.md` from this session as the planning source." Proceed to Phase 1.

**Mode 1-stale — `specs.md` exists on disk but was NOT written in the current conversation.**
Do NOT silently adopt. Stale `specs.md` files from unrelated prior work are common. Ask the user:
- A) Use the existing `specs.md` as-is (e.g., a prior session wrote it and context was cleared intentionally).
- B) Overwrite with a fresh synthesis from the current discussion.
- C) Ignore it; plan lightweight from conversation only (the old file stays on disk untouched; Phase 4 will skip Section 0).

If A: Read `specs.md` and proceed to Phase 1.
If B: fall through to Mode 2-A.
If C: fall through to Mode 2-B.

**Mode 2 — No `specs.md` and the session has meaningful discussion.**
Ask the user:
- A) Write `specs.md` from the discussion, then plan.
- B) Skip `specs.md` — plan directly from conversation context (lightweight).

If A: synthesize `specs.md` using the structure below, write it to the project root, and tell the user to review and reply `proceed`. On each feedback message before `proceed`, read the current `specs.md`, apply changes, and write the update. After `proceed` the specs are locked.

If B: do not write `specs.md`. Keep the distilled requirements in the main context for use in Phases 2 and 4. The plan will omit Section 0.

**Mode 3 — No `specs.md` and no discussion.**
Ask: "What would you like to plan?" Once the user describes the task, re-evaluate under Mode 2.

### Spec Structure (only when writing `specs.md` under Mode 2-A)

**Problem Statement** — What problem is being solved and why it matters.

**Goals** — What the implementation must achieve. Numbered list, one item per goal.

**Constraints** — Hard limits that cannot be violated (performance, compatibility, naming, etc.).

**Decisions** — For each significant design choice:
- What was decided
- Full rationale (why this option over others)
- Alternatives that were considered and why they were rejected

**Flow Diagram** — One or more ASCII diagrams using linear arrow notation (A → B → C) showing the agreed flow or architecture. Never use Mermaid or box-drawing characters.

Do NOT copy user messages verbatim. Distill into clear, precise prose and structured lists.

## Phase 1: Explore the Codebase

If the codebase has already been explored by the `/discuss` skill prior to activating this mode, skip this phase. If not, do NOT skip this phase. You must read real code before designing.

Launch subagents to understand:
- Project structure, entry points, and module boundaries
- Existing patterns, conventions, and utilities
- Files relevant to the user's task

Every subagent `prompt_template` that reads source files MUST begin with:
"First, read `ai-docs/index.md` and all sub-docs listed there. Do not read source files until you have read ai-docs. If no `ai-docs/` folder exists, skip this step."

## Phase 2: Design the Plan

Design the implementation. The plan MUST include ALL sections listed below. No section may be omitted, even for small tasks.

### Spec Handoff

When `specs.md` is the planning source, read it as the first step. Treat it as the authoritative specification.

When there is no `specs.md` source, use the distilled requirements from conversation context.

### Required Plan Sections

**1. Context**
Why this change is being made. What problem it solves.

**2. Requirements**
Synthesize ALL user statements into a structured list:
- **Goals**: What the user wants to achieve
- **Constraints**: Limitations, compatibility needs, performance targets
- **Precisions**: Specific details the user called out (naming, format, behavior)
- **Supplements**: Implicit requirements inferred from the codebase or domain. Each supplement MUST be confirmed with the user before being included in the plan.

Do NOT copy user messages verbatim. Distill them into concise, actionable items.

**3. Diagrams**
Generate exactly THREE diagrams using linear arrow notation (A → B → C). All three are mandatory. Never use ASCII box-drawing characters (┌─┐└─┘│+-|) or Mermaid syntax.

Architecture diagram — component boundaries and interfaces.

Data flow diagram — how data moves through the system.

Function/call flow diagram — execution sequence.

For small tasks, keep diagrams minimal but still present. Even a 3-node diagram is valid.

**4. Approach**
Recommended implementation strategy. Reference black box boundaries and module interfaces.

**5. Files to Modify**
List each file path with a one-line description of what changes.

**6. Reusable Code**
Existing functions, utilities, or patterns in the codebase to leverage. If none, state "None identified."

**7. Verification**
How to test the change end-to-end. Include specific commands or test scenarios.

## Phase 3: Review Critical Files

Read the critical files identified in Phase 2. Verify:
- The approach does not conflict with existing code
- The interfaces are correct (do not infer API existence)
- Reusable code actually exists and works as expected

If anything is wrong or ambiguous, return to Phase 2 and redesign the affected parts of the plan before continuing.

## Phase 4: Write the Plan File

Write the complete plan to `plan.md` in the project root, overwriting it if it already exists.

### When `specs.md` is the planning source

`plan.md` MUST begin with a **Section 0: Specs** block whose content is the verbatim contents of `specs.md`. Embed it via shell concat:

1. Write `plan.md` with the header only:
   ```
   # Plan

   ## Section 0: Specs

   ```
2. Run: `cat specs.md >> plan.md`
3. Run: `printf '\n\n' >> plan.md`
4. Append the remaining sections (Section 1 through Section 7).

Do NOT read `specs.md` and re-emit it. Do NOT paraphrase. The concat step is the only way the spec content enters `plan.md`.

### When `specs.md` is not the planning source

Skip Section 0. `plan.md` starts directly at Section 1.

### Section headings

- `## Section 0: Specs` (only when `specs.md` exists)
- `## Section 1: Context`
- `## Section 2: Requirements`
- `## Section 3: Diagrams`
- `## Section 4: Approach`
- `## Section 5: Files to Modify`
- `## Section 6: Reusable Code`
- `## Section 7: Verification`

## Rules

- NEVER skip diagrams. All three diagrams are always required in the plan.
- NEVER use Mermaid syntax or ASCII box-drawing characters. Use only linear arrow notation (A → B → C).
- NEVER infer code logic, API existence, or behavior. Verify by reading code.
- NEVER add features not discussed in the plan.
- Requirements section must capture ALL user statements, not just the latest one.
- Follow black box design, explicit code, replaceable modules.
- Do not write or edit files under ai-docs/ in the plan nor during implementation phase.

Start at Phase 0 and proceed through the phases.
