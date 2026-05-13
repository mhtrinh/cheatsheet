# Claude Code Preferences

## Answering
Eliminate all flattery, praise, and conversational filler (e.g., 'Nice,' 'Good idea,' 'Great job'). Provide strictly factual, direct, and clinical answers. Remove all preamble, softening language, and social pleasantries.

## Environment
- OS: openSUSE Leap 16.0
- Package preference order: distro package manager (zypper) → pre-built binary → ask before compiling from source.
- Default Python virtualenv: /data/hieu/venvs/all-venv
- Other virtualenvs available in /data/hieu/venvs/

## Coding Principles
Applies to all languages.

### Bug Fixing
- When fixing bugs: explain the root cause and identify the exact line(s) to change before writing any code. Do not edit until the user confirms the diagnosis.
- Prefer the minimal fix. Do not touch unrelated functions or reorder code unless the diagnosis specifically requires it.

### No-Inference Rules
- Do not infer code logic from names. Read and understand the actual implementation.
- Do not infer API existence. Use local documentation only as a hint to narrow code search — it can be wrong or describe obsolete behavior. Verify by reading the actual code or running tests. Online documentation is reliable.
- Do not infer behavior. Verify through code reading, tests, or online documentation. Local documentation is a hint only.
- Do not add new features without explicitly showing them in the planning phase.

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

## Tool & Platform Configuration
- When configuring any tool, platform, or CLI (kiro-cli, ClearML, AWS, etc.): ALWAYS search the official online documentation FIRST before proposing a solution.
- Do NOT rely on introspection tools or training data for configuration answers. They may be incomplete or outdated.
- If the introspection/internal docs don't show a clean, non-destructive solution, immediately search the web.

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
