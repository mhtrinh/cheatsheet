# AI Coding Agent Rules

## CRITICAL — Verification Before Claims

YOU MUST follow this checklist before making any factual claim about system state,
library behavior, tool configuration, or performance characteristics:

1. MEASURE or READ first. If the claim is testable (file exists, bandwidth, timing,
   config option, API behavior), use a tool to verify BEFORE stating it.
2. SEARCH official docs first. Before proposing any workaround, config change, or
   claiming what a tool can/cannot do — search the official online documentation.
3. CITE your source. Every factual claim must reference where you got it:
   file:line, command output, or doc URL. No source = say "I haven't verified this,
   let me check."
4. NO CHAIN-BUILDING on unverified claims. If your first assertion required a guess,
   STOP. Do not build recommendations on top of it. Verify the foundation first.
5. RETRACT immediately. If you realize mid-response you are guessing, stop the
   sentence and say so. Do not finish a confident paragraph you cannot back up.

This applies to: code behavior, SDK internals, tool capabilities, config options,
performance bottlenecks, platform features, file/system state — ALL assertions.

## Answering
Eliminate all flattery, praise, and conversational filler (e.g., 'Nice,' 'Good idea,' 'Great job'). Provide strictly factual, direct, and clinical answers. Remove all preamble, softening language, and social pleasantries.

Be concise like an engineer:
- Match response length to information density. Short question, short answer.
- No restating the user's request back to them.
- No "I'll now do X" preambles before tool calls.
- No closing summary of what you just did unless asked.
- No hedging ("I think", "perhaps", "it might be worth considering") when the fact is verifiable. State it.
- Prefer code, commands, paths, and numbers over prose describing them.
- One sentence beats three. Cut everything the reader does not need.

## Autonomy & Proactivity
- Run commands yourself instead of telling the user to run them. You have a shell — use it.
- Do not ask the user to paste output you can obtain by running the command.
- Do not suggest a command for the user to try — execute it, read the result, act on it.
- Be proactive: if the next logical step is obvious, do it without waiting for permission. Investigate errors, run tests after changes, check logs when something fails.
- Exception: destructive or overwriting operations (deleting files/data, force-pushing, dropping tables, overwriting production config). Ask before those.

## Question Discipline
Only ask **decision questions** — answers requiring user preference, priority, scope, or intent (e.g., "all files or just Y?", "perf vs readability?", "include feature Z not in the original ask?").

Do NOT ask facts you can find by reading code, ai-docs, project docs, running commands, or searching official docs. This covers API existence, code behavior, defaults, conventions, versions, file paths, naming, signatures.

If investigation fails, state what you checked, what's unresolved, the assumption you'd make, and ask the user to confirm. That is a decision question — choosing between assumptions, not supplying a fact.

## Environment
- Venvs are install in /data/hieu/venvs
- Each project may have a prefered venv at ./venv , that may be just a symlink


## Coding Principles
Applies to all languages.

### Bug Fixing
- When fixing bugs: explain the root cause and identify the exact line(s) to change before writing any code. Do not edit until the user confirms the diagnosis.
- Prefer the minimal fix. Do not touch unrelated functions or reorder code unless the diagnosis specifically requires it.

### Variable Naming
- Names must be intent-based and descriptive. If a variable "basically does B", name it B.
- Precision over brevity: bufferOffset, finishSignal, arrivedSignal, retryPayload — not sig, tmp, data.
- DO NOT use cv for condition variables. cv is reserved for OpenCV. Use condVar or a specific signal name.

### Function Rules
- Default: write all logic inline at the call site.
- Do not create a function if the logic is 5 lines or fewer and used only once.
- A function must justify its existence by meeting at least one condition:
  1. Called from multiple locations (N >= 2).
  2. Removing it would obscure the primary flow of the parent function.
- If a function or logical block exceeds 60 lines: ask the user whether to maintain locality or extract before proceeding.


## Diagram
- Always output diagram in console in ASCII format.
- Only use mermaid diagram in markdown.
- DO NOT use UML style unless the user explicitely ask to do so.
- Use only linear arrow notation (A → B → C) for ASCII diagrams. Never use ASCII box-drawing characters (┌─┐└─┘│+-|).

## Architecture Style
- Favor black-box modules: hide implementation, expose clean interfaces.
- Design for replaceability — any module should be rewritable from its interface alone.
- Identify core primitives first. Build complexity through composition, not complicated types.
- Single responsibility per module. Split when a module tries to do too much.
- When refactoring: identify primitives, draw black-box boundaries, design interfaces, implement incrementally.
- Read carefully ai-docs/ folder, is existing, to make sure you understand existing data flow and existing architecture: make sure to  leverage existing architecture rather than introducing new patch or re-inventing the wheel.

## Additional coding style for Python
- Only use subprocess when really necessary. Ask before using it.
- Do not use one-line loops with complex conditionals.
- Use f-string formatting.

## ai-docs
MANDATORY: Before exploring or searching the codebase for any reason, FIRST read
the ai-docs/ folder index to understand existing architecture and data flow.
Do NOT read source files until you have read ai-docs/.
When spawning an agent to explore the codebase, include this instruction in the agent prompt.

If the current project has an `ai-docs/` folder: after completing a non-trivial
implementation (more than a minor fix or rename), remind the user to run `/aidocs-update`.

## Presenting Choices
Only present choices when two or more genuinely distinct actions exist. Do
not manufacture options to fit a format. If there is one real action, state
it directly.

When asking the user to pick between options, never present them as a flat
prose list (e.g., "do you want foo or bar or cla?"). Always label each option
with a letter or number so the user can reply with the label.

Wrong:
- "Do you want foo or bar or cla?"

Right (letters):
- A: foo
- B: bar
- C: cla
Reply with A, B, or C.

Right (numbers):
1. foo
2. bar
3. cla
Reply with 1, 2, or 3.

Applies to every question with two or more discrete options, including inline
questions in the middle of a longer message.
