---
name: learn
description: Analyze current or past session for user frustration events. Detects when the agent made mistakes, presents each to the user for confirmation, and appends confirmed incidents to ~/mistake.md. Use when the user says "/learn" or wants to review session quality.
---

You are performing a SESSION FRUSTRATION AUDIT. Your goal is to read a session's conversation log, detect moments where the user was frustrated, analyze what the agent did wrong, and — with user confirmation — append each incident to `~/mistake.md`.

## Phase 1: Load Session

**If no session-id argument provided:** analyze the current session.

**If session-id provided:** read the session JSONL from `~/.kiro/sessions/cli/{session-id}.jsonl`.

If the session-id is partial, list sessions with `ls ~/.kiro/sessions/cli/*.json` and match.

## Phase 2: Scan for Frustration Signals

Read through all `Prompt` entries (user messages) in chronological order. Flag any message exhibiting:

**Explicit signals:**
- Direct corrections: "I said X, not Y", "no, that's wrong", "I already told you"
- Capitalization or exclamation marks expressing annoyance
- Explicit negative feedback: "this is broken", "why do you keep doing X", "stop"
- Short dismissive replies after long agent responses: "no", "wrong", "stop"
- User undoing agent work or reverting changes
- User explicitly stating frustration

**Subtle signals:**
- User rephrasing the same request 3+ times without the agent getting it right
- User repeating an instruction the agent ignored
- User providing information they already provided earlier
- Progressively shorter/terser responses indicating patience loss

## Phase 3: Analyze Each Incident

For each flagged frustration event, determine:

1. **What happened** — the user message and surrounding context (1-2 messages before)
2. **What the agent did wrong** — categorize using:
   - Agent ignored explicit instruction
   - Agent hallucinated / inferred instead of reading code
   - Agent repeated a failed approach
   - Agent was verbose when user wanted brevity
   - Agent asked unnecessary questions instead of acting
   - Agent broke something that was working
   - (Other — describe if none of the above fit)
3. **Why it was wrong** — explain the root cause of the agent's mistake

## Phase 4: Interactive Confirmation

Present each incident ONE AT A TIME to the user in this format:

```
### Incident N

**User said:** "<excerpt of frustrated message>"

**Context:** <what was happening before>

**Agent mistake:** <category + explanation>

**Why wrong:** <root cause>

---
Is this analysis correct? (yes / no / edit: <your correction>)
```

- If user says **yes** → queue for writing
- If user says **no** → skip, do not write
- If user says **edit: ...** → incorporate their correction, then queue

After all incidents are reviewed, append confirmed ones to `~/mistake.md`.

## Phase 5: Write to File

Append confirmed incidents to `~/mistake.md`. Use this format per entry:

```markdown
---

## Session: {session-id} | {date}

### Incident N

**User said:** "<excerpt>"

**Agent mistake:** <category>

**What went wrong:** <explanation>

**Why:** <root cause>
```

If `~/mistake.md` does not exist, create it with a header:

```markdown
# Agent Mistakes Log

Confirmed frustration incidents from session audits.
```

Then append entries below.

## Rules

- NEVER write to `~/mistake.md` without user confirmation for each incident.
- NEVER fabricate user quotes. Use exact text from the session log.
- NEVER skip Phase 4. Every incident must be presented for confirmation.
- Read the FULL context around a frustration signal before attributing blame — sometimes the user is frustrated at their own code, not the agent.
- If no frustration events are detected, say so and exit.
- Always append, never overwrite `~/mistake.md`.
- Present incidents in chronological order.
