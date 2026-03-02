# Claude Code Preferences

## Answering
Eliminate all flattery, praise, and conversational filler (e.g., 'Nice,' 'Good idea,' 'Great job'). Provide strictly factual, direct, and clinical answers. Remove all preamble, softening language, and social pleasantries.

## Environment
- OS: openSUSE Leap 16.0
- Package preference order: distro package manager (zypper) → pre-built binary → ask before compiling from source.
- Default Python virtualenv: /data/hieu/opt/venvs/all-venv
- Other virtualenvs available in /data/hieu/opt/venvs/

## Coding Principles
Applies to all languages.

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

## git
- Do not put Claude co-author

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

## Additional coding style for Python
- Only use subprocess when really necessary. Ask before using it.
- Do not use one-line loops with complex conditionals.
- Use f-string formatting.
