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

## Main directive
See [claude/CLAUDE.md](claude/CLAUDE.md)

## Skill/command

See [claude/commands](claude/commands/)