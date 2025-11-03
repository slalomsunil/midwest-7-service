# Code Quality Agents

Agents in this category focus on maintaining and improving code quality through review, refactoring guidance, and technical debt analysis.

## Available Agents

### code-reviewer
**Purpose**: Thorough code review applying consistent quality standards

**When to use**:
- Before committing significant changes
- When you want detailed feedback on code quality
- To identify potential bugs, security issues, or performance problems
- For architecture and design review of new features

**When NOT to use**:
- For trivial changes (formatting, simple variable renames)
- When you just want to understand existing code (use main chat)
- During exploratory prototyping (wait until code stabilizes)

### refactoring-advisor
**Purpose**: Safe refactoring suggestions with minimal behavior changes

**When to use**:
- When code works but feels messy or hard to maintain
- To identify refactoring opportunities before adding features
- When you want to improve code structure without changing behavior
- For incremental improvement of legacy code

**When NOT to use**:
- For new feature development (not refactoring)
- When making breaking changes is acceptable (use code-reviewer instead)
- For complete rewrites (that's beyond refactoring scope)

### tech-debt-analyzer
**Purpose**: Identify and prioritize technical debt across the codebase

**When to use**:
- Planning maintenance sprints or refactoring work
- Before major feature additions to understand current state
- To build a tech debt backlog with prioritization
- When investigating why velocity is slowing

**When NOT to use**:
- For immediate bug fixes (use code-reviewer)
- During active feature development
- When you already know the specific problem to fix

## Common Patterns

All code quality agents:

- Reference rules from `../../rules/base/code-quality.md` for consistent standards
- Provide actionable feedback, not vague suggestions
- Consider both short-term fixes and long-term improvements
- Balance perfectionism with pragmatism
- Explain the "why" behind recommendations

## Usage Examples

### Code Reviewer
```
@code-reviewer Review my changes to the authentication module.
Focus on security and error handling.
```

### Refactoring Advisor
```
@refactoring-advisor The UserService class has grown to 500 lines.
What refactoring would make it more maintainable?
```

### Tech Debt Analyzer
```
@tech-debt-analyzer Analyze the codebase and identify the top 5 areas
where technical debt is slowing us down. Prioritize by impact on velocity.
```

## Customization Tips

- **Standards**: Modify agents to reference your team's coding standards or linting rules
- **Priorities**: Adjust what the agents emphasize (security vs. performance vs. maintainability)
- **Scope**: Configure agents to focus on specific areas (frontend, backend, infrastructure)
- **Tone**: Make agents more or less strict based on your team's preferences

## Related Resources

- **Rules**: `../../rules/base/code-quality.md` - Base code quality standards
- **Commands**: `../../commands/generic/code-quality/` - Workflow commands for code quality tasks
- **Chat Modes**: For Copilot/Cursor equivalents, see `../../chat-modes/`

## Contributing

When adding code quality agents:

- Ensure they provide specific, actionable feedback
- Include examples of good and bad patterns they should recognize
- Test with both trivial and complex code scenarios
- Document how they differ from existing agents
- Consider whether this should be a new agent or enhancement to existing ones
