# Scratch Directory Structure

## Standard Layout

Every scratch directory follows a consistent structure that enables seamless context transfer between AI sessions.

```
ai-scratch-<descriptor>/
├── README.md                  # Core scratch definition and progress
├── implementations/           # Incremental implementation records
│   ├── 01-<topic>.md         # Numbered for chronological clarity
│   ├── 02-<topic>.md
│   └── 03-<topic>.md
└── discoveries/              # Findings and learnings
    ├── <constraint>.md       # Discovered limitations
    ├── <pattern>.md         # Successful approaches
    └── <gotcha>.md          # Non-obvious issues
```

## Directory Naming

**Format**: `ai-scratch-<descriptor>`

**Descriptor Guidelines**:
- Use kebab-case
- Keep it short but meaningful
- Include key technology or feature
- Avoid generic terms

**Good Examples**:
- `ai-scratch-oauth-impl`
- `ai-scratch-payment-integration`
- `ai-scratch-db-migration-v2`

**Poor Examples**:
- `ai-scratch-work`
- `ai-scratch-temp`
- `ai-scratch-tuesday-scratch`

## README.md Format

The central document that anchors the entire scratch space context.

```markdown
# Scratch: [Clear objective statement]

## Status
- Started: YYYY-MM-DD
- Last Update: YYYY-MM-DD HH:MM
- Progress: [percentage or phase]

## Objective
[1-2 paragraphs describing what we're building and why]

## Context
[Key background information, constraints, requirements]

## Current State
[Where we are right now, what's been completed]

## Blockers
- [ ] [Active blocker with details]
- [x] [Resolved blocker with solution]

## Next Steps
1. [Immediate next action]
2. [Following action]
3. [Future action]

## Key Decisions
- [Decision]: [Rationale]
- [Decision]: [Rationale]

## References
- [Link or file path]: [Description]
```

## Implementation Files

Track incremental progress with numbered markdown files.

### Naming Convention
`##-<descriptive-name>.md`

- Two-digit prefix for ordering (01, 02, 03...)
- Descriptive name using kebab-case
- Chronological numbering

### Content Structure
```markdown
# Implementation: [Title]

## Date: YYYY-MM-DD

## What We Did
[Summary of implementation work]

## Key Changes
- [File/component]: [Change description]
- [File/component]: [Change description]

## Decisions Made
- [Technical choice]: [Why we chose this]

## Discovered Issues
- [Issue]: [How we resolved or worked around it]

## Testing Notes
[How we validated this implementation]

## Next Phase
[What comes after this implementation]
```

## Discovery Files

Document unexpected findings and important learnings.

### Categories

**Constraints** (`<system>-constraint.md`)
- Technical limitations discovered
- API restrictions
- Performance boundaries
- Security requirements

**Patterns** (`<feature>-pattern.md`)
- Successful implementation approaches
- Reusable solutions
- Effective workflows

**Gotchas** (`<tech>-gotcha.md`)
- Non-obvious issues
- Misleading documentation
- Hidden dependencies
- Surprising behaviors

### Content Template
```markdown
# Discovery: [Title]

## Date Discovered: YYYY-MM-DD

## Summary
[One paragraph overview]

## Details
[Full explanation of the discovery]

## Impact
[How this affects our implementation]

## Resolution/Workaround
[How we handled this]

## Should Be Documented
L2 Candidate: [Yes/No - if yes, where in project docs]
```

## Example: OAuth Implementation

```
ai-scratch-oauth-impl/
├── README.md                         # OAuth integration objectives
├── implementations/
│   ├── 01-provider-setup.md         # Initial OAuth provider config
│   ├── 02-token-management.md       # JWT handling implementation
│   └── 03-callback-flow.md          # Redirect and callback logic
└── discoveries/
    ├── postgres-ssl-constraint.md   # SSL cert validation issue
    ├── jwt-refresh-pattern.md       # Successful refresh strategy
    └── redirect-uri-gotcha.md       # Trailing slash requirement
```

## Checkpoint Priorities

When updating scratch during a session, prioritize capturing:

1. **Context Shifts** - New understanding that changes approach
2. **Implementation Choices** - Why we chose approach A over B
3. **Blockers Resolved** - How we worked around issues
4. **Dependencies Discovered** - Hidden couplings or requirements
5. **Next Session Setup** - What the next session needs to know