# User Rabbit Trailing Pattern

## Detection Signals

IMPORTANT! These signals are exemplary, not exhaustive or constraints.

- [User behavior] Starts fixing unrelated issues mid-task
- [User behavior] Multiple task branches without completion
- [Agent behavior] Confusion about primary objective
- [User behavior] Has to redirect back to original task

## Root Cause
User notices incidental issues during implementation and immediately branches to fix them, causing the agent to lose track of the primary task context.

## Impact
- Agent loses focus on primary objective
- Increased interaction rounds
- Frustration from repeated redirections

## Improvement Strategies
### For Users
- Complete current task before addressing incidental issues
- Create a "to fix later" list during implementation
- Use explicit task management (e.g., "Let's finish X first, then address Y")

### For Documentation
- Add explicit task management guidance to project documentation
- Document expected task flow patterns in project rules file