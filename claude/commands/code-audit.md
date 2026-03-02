---
description: Deep code audit that produces a structured bug report with human summary and agent fix instructions (TODO.md style)
---

You are performing a CODE AUDIT. Your goal is to produce a single structured document with two sections: a human-readable summary of findings and a set of precise agent fix instructions.

## Phase 1: Understand the Scope

Ask the user what to audit if not already specified:
- Which files or modules?
- Any specific concerns (concurrency, protocol parsing, ISR safety, resource usage)?
- Is this a full audit or focused on a specific area?

Then read the relevant source files. Do NOT infer logic from names — read the actual code.

## Phase 2: Find Issues

Read each file carefully. Look for:

**Critical (can cause misfires, data loss, or wrong physical output):**
- Race conditions between ISRs and main loop
- Protocol parser bugs (partial reads, off-by-one in availability checks, unconsumed bytes)
- Stale data used for time-sensitive decisions (speed, position, timing)
- Blocking calls inside tight loops or real-time paths

**High (correctness risks):**
- One-directional counters that should be bidirectional
- Re-initialisation paths that leave stale state
- Missing checksums or frame validation on physical buses
- Functions with multiple unrelated responsibilities that cause side effects

**Medium (latent risks):**
- Unsafe calls inside ISRs (non-ISR-safe APIs)
- Duplicate definitions across translation units that can silently diverge
- Side-effect calculations buried inside unrelated functions

**Low (cleanliness):**
- Wrong comments (state value ≠ comment description)
- Dead code with no explanation
- `inline` on large functions in headers
- Undefined variables in commented-out blocks

For each issue found, record:
1. **Title** — short bold label
2. **Why it happens** — root cause in the actual code (cite file:line)
3. **When it bites you** — concrete failure scenario with real numbers where possible
4. **Caveat** — conditions under which it is dormant or acceptable

## Phase 3: Write the Document

Output to a file named `TODO.md` in the project root (or the path specified by the user). Use this exact structure:

---

```markdown
# TODO — [Project Name] Review Findings

---

## Section 1: Human Summary

### Critical Bugs (can cause misfires or missed ejections)

---

**[Title]**

*Why it happens:* ...

*When it bites you:* ...

*Caveat:* ...

---

### High Severity (correctness risks)

---

**[Title]**

*Why it happens:* ...

*When it bites you:* ...

*Caveat:* ...

---

### Medium Severity (latent risks)

---

**[Title]**

*Why it matters:* ...

*Example:* ...

*Caveat:* ...

---

### Low Severity (cleanliness)

- **[Title]**: one-line description.

---

## Section 2: Agent Fix Instructions

> Each item specifies the exact file, line(s), the problem, and what to do. Read only the cited file before making a change. No full-repo scan needed.

---

### FIX-01: [Title]

**File:** `path/to/file.cpp` lines N–M

**Problem:**
[Concise description. Include a code block showing the bad code if helpful.]

**Fix:**
[Step-by-step instructions. Include a code block showing the corrected code.]

**Caveat:** [When this is safe to defer or what preconditions apply.]

---

[Repeat FIX-XX for each issue...]

---

### Fix Priority Order

1. **FIX-XX** — one-line justification
...
```

---

## Rules

- NEVER infer logic from names. Read the actual code for every finding.
- NEVER fabricate line numbers. Cite only lines you have read.
- NEVER omit the Caveat. Every finding must state when it is dormant.
- Each FIX entry must name exact file path and line numbers.
- Fix Priority Order must list every FIX in descending urgency with a one-line reason.
- Severity assignment must match the criteria in Phase 2 — do not inflate severity.
- If a section has no findings, write "None found." under the heading — do not omit the heading.
- Output the document to disk. Also print a one-paragraph executive summary to the console.

Start by confirming the scope with the user, then read the source files and produce the report.
