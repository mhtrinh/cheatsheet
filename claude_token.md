# /clear 

Why you should clear history often: because each query re-send EVERYTHING (cumulative) from all previous prompt:
```
STRATEGY A: THE SNOWBALL (No Clearing)
Result: Costs spiral out of control.

      TURN 1           TURN 2           TURN 3
    (Cost: 5)        (Cost: 8)        (Cost: 11)

                                      [^^^^] (Q3)
                                      [::::] (A2)
                     [^^^^] (Q2)      [::::] (Q2)
                     [::::] (A1)      [::::] (A1)
    [^^^^] (Q1)      [::::] (Q1)      [::::] (Q1)
    [====] (File)    [====] (File)    [====] (File)
    [====] (File)    [====] (File)    [====] (File)
    [====] (File)    [====] (File)    [====] (File)
    [====] (File)    [====] (File)    [====] (File)
    ---------        ---------        ---------
    Total: 5         Total: 8         Total: 11

===================================================================

STRATEGY B: THE RESET (Using /clear)
Result: Costs stay flat.

      TURN 1           TURN 2           TURN 3
    (Cost: 5)        (Cost: 5)        (Cost: 5)

    [^^^^] (Q1)      [^^^^] (Q2)      [^^^^] (Q3)
    [====] (File)    [====] (File)    [====] (File)
    [====] (File)    [====] (File)    [====] (File)
    [====] (File)    [====] (File)    [====] (File)
    [====] (File)    [====] (File)    [====] (File)
    ---------        ---------        ---------
    Total: 5         Total: 5         Total: 5
```

`/context` is quite useful 


# /diagram
```
In a markdown file in a format "diagram.name.md", generate the architecture, the algorithm, the data and function flow diagrams.
Come up with a shortname yourself. If an existing file exist, update it if appropriate, otherwise, may need to name it differently. 
Use Mermaid diagram.
Do NOT use UMl style diagram.
```

# /discuss
```
---
description: Interactive requirements and architecture discussion without generating plans
---

We are in DISCUSSION MODE. You are a senior developer and architect.

## Phase 1: Requirements Gathering
- Ask clarifying questions about the problem, constraints, and goals
- Understand the context: existing systems, scale, team capabilities, timeline
- Identify non-functional requirements: performance, security, maintainability

## Phase 2: Architectural Solutions (when requirements are clear)
- Propose 2-3 architectural approaches with trade-offs
- For each approach: strengths, weaknesses, risks, complexity
- Use diagrams (ASCII/Mermaid) when helpful
- Reference existing codebase patterns with @ when relevant
- Discuss: "Which approach aligns with your constraints?"

## Formatting Rules
- When offering choices, ALWAYS use letters (A, B, C) or numbers (1, 2, 3)
- Example: "A) REST API  B) GraphQL  C) gRPC"
- User can respond with just the letter/number

## Rules
- DO NOT generate implementation plans, task lists, or step-by-step breakdowns
- DO NOT use numbered action items
- Stay conversational and exploratory
- One question or one architectural proposal at a time
- Challenge assumptions, surface hidden complexity
- When I say "create the plan" or "let's plan" → exit discussion mode
- When asking user, make sure to 

## Transitions
- Requirements unclear → ask questions
- Requirements clear → propose architectures
- Architecture agreed → wait for explicit plan request

Start: I am here to brainstorm and explore. 
```

## /myplan
See [claude.myplan.md](claude.myplan.md)
