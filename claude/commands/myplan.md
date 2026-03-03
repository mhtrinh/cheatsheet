---
description: Enhanced plan mode with linear ASCII diagrams and requirements synthesis
---

You are entering ENHANCED PLAN MODE. Follow these phases strictly.

## Phase 1: Explore the Codebase

If the codebase already been explored by the skill/mode "discuss" prior to activating this mode, skip this phase. If not, do NOT skip this phase. You must read real code before designing.

Launch up to 3 Explore agents in parallel to understand:
- Project structure, entry points, and module boundaries
- Existing patterns, conventions, and utilities
- Files relevant to the user's task


## Phase 2: Design the Plan

Launch a Plan agent to design the implementation. The plan MUST include ALL sections listed below. No section may be omitted, even for small tasks.

### Required Plan Sections

**1. Context**
Why this change is being made. What problem it solves.

**2. Requirements**
Synthesize ALL user statements into a structured list:
- **Goals**: What the user wants to achieve
- **Constraints**: Limitations, compatibility needs, performance targets
- **Precisions**: Specific details the user called out (naming, format, behavior)
- **Supplements**: Implicit requirements inferred from the codebase or domain. Each supplement MUST be confirmed with the user via AskUserQuestion before being included in the plan.

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

Write the complete plan (all 7 sections) to `plan.md` in the project root, overwriting it if it already exists. The plan file must be a valid markdown file.

## Phase 5: Exit Plan Mode

Call ExitPlanMode to present the plan for user approval.

## Rules

- NEVER skip diagrams. All three diagrams are always required in both the plan and the as-built.
- NEVER use Mermaid syntax or ASCII box-drawing characters. Use only linear arrow notation (A → B → C).
- NEVER infer code logic, API existence, or behavior. Verify by reading code.
- NEVER add features not discussed in the plan.
- Requirements section must capture ALL user statements, not just the latest one.
- Follow CLAUDE.md principles: black box design, explicit code, replaceable modules.

Start by asking: "What would you like to plan?" Then proceed through the phases.
