As-Built Document

asbuilt.md tracks the current state of the project. It is cumulative knowledge — a new agent in a clean session with no prior context must be able to read it alone, fully understand the system, and continue the work.

Check if an asbuilt.md already exists in the project root. If it exists, read it and update it. If it does not exist, create it.

CRITICAL: Every section below must be derived from reading the ACTUAL implemented code. Do NOT copy from the plan. Do NOT infer or assume. Read the real source files and describe what is actually there.

Required sections:

1. Summary — Describe the current state of the system. Organize by feature or subsystem with a bold header per topic (e.g., Base Index Display, Ejection Logging). For each topic, describe what the system does now in present tense — no "was replaced", no "Change N" framing, no history. End with overall build/test status (working, partial, known issues). Derived from reading the actual code and test results.

2. Module Responsibilities — One-line description of what each file actually does now. Derived from reading each file.

3. Architecture Diagram — Mermaid graph TD showing component boundaries and interfaces as they exist in the final code. Derived from reading the actual module structure and imports.

4. Data Flow Diagram — Mermaid flowchart LR showing how data actually moves through the implemented code. Derived from reading the actual function calls and data transformations.

5. Function/Call Flow Diagram — Mermaid flowchart TD showing the actual execution sequence in the implemented code. Derived from reading the actual call chains.

6. Interfaces and APIs — All public functions, classes, CLI commands, config options, and their signatures. Include input/output types and brief behavior description. Derived from reading the actual function signatures and docstrings.

7. Dependencies — External libraries, services, or system requirements. Derived from reading the actual import statements and config files.

8. How to Run — Exact commands to run, test, and verify the implementation. Derived from the actual scripts, entry points, and test commands.

9. Open Items — Anything left incomplete, deferred, or known to need future work.

10. Changelog — Bullet list of what changed in this implementation session. This is the only place for historical framing.

## PROCEDURE TO UPDATE asbuilt.md

- Phase 1: Extend based on newly added code. For each section that already has content, PRESERVE all existing accurate content and integrate new content into it. Never rewrite a section from scratch — always start from what is there. Exception: sections 3, 4, and 5 (diagrams) are always regenerated from scratch by reading the actual module structure and call chains.
- Phase 2: Review all sections that need merge/re-word/update/overwrite changes. Explain why and ask user permission before proceeding.
- Phase 3: Review if any information is obsoleted: information that is not true compared to the current code traced above. Explain why and ask for user approval before proceeding.
