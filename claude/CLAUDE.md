# Claude Code Preferences

## Environment
- OS: openSUSE Leap 16.0
- Try hard to find pre-built package. Ask if you need to compile a package.
- By default, use python virtualenv in /data/hieu/opt/venvs/all-venv
- Other virtualenv are avail in /data/hieu/opt/venvs/

## Coding Principles
- Do not infer code logic based on names. Read and understand the actual implementation.
- Do not infer API existence. Always verify APIs exist by checking documentation or running tests before using them.
- Do not infer behavior. Verify actual behavior through code reading, tests, or documentation.
- Do not add new feature without explicitly showing it in the planning phase.

## git
- Do not put Claude co-author

## Diagram
- Always output diagram in console in ASCII format.
- Only use mermaid diagram in markdown.

## Architecture Style
- Favor black-box modules: hide implementation, expose clean interfaces.
- Design for replaceability — any module should be rewritable from its interface alone.
- Identify core primitives first. Build complexity through composition, not complicated types.
- Single responsibility per module. Split when a module tries to do too much.
- When refactoring: identify primitives, draw black-box boundaries, design interfaces, implement incrementally.

## Python
- Only use subprocess when really necessary. Ask before using it.
- Do not use one-line loops with complex conditionals.
- Use f-string formatting.
- Functions have cognitive cost. They must justify their existence — ask if unsure.
- Write code inline first. Only extract to a function when it repeats or clearly reduces cognitive load.