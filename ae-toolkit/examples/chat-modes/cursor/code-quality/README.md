# Code Quality Custom Modes

Custom modes in this category focus on maintaining and improving code quality through review, refactoring guidance, and technical debt analysis.

## Available Custom Modes

### code-reviewer
**Purpose**: Thorough code review applying consistent quality standards

**When to use**:
- Before committing significant changes
- When you want detailed feedback on code quality
- To identify potential bugs, security issues, or performance problems
- For architecture and design review of new features

**When NOT to use**:
- For trivial changes (formatting, simple variable renames)
- When you just want to understand existing code (use normal mode)
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

All code quality custom modes:

- Reference rules from `../../../rules/cursor/base/` for consistent standards
- Provide actionable feedback, not vague suggestions
- Consider both short-term fixes and long-term improvements
- Balance perfectionism with pragmatism
- Explain the "why" behind recommendations

## Usage Examples

### Code Reviewer
1. Switch to code-reviewer mode via `Cmd+.` (Mac) / `Ctrl+.` (Windows/Linux)
2. Ask: "Review my changes to the authentication module, focusing on security and error handling"
3. Mode provides detailed, structured review

### Refactoring Advisor
1. Switch to refactoring-advisor mode
2. Ask: "The UserService class has grown to 500 lines. What refactoring would make it more maintainable?"
3. Mode suggests safe, incremental refactorings

### Tech Debt Analyzer
1. Switch to tech-debt-analyzer mode
2. Ask: "Analyze the codebase and identify the top 5 areas where technical debt is slowing us down. Prioritize by impact on velocity"
3. Mode provides prioritized analysis with recommendations

## Customization Tips

- **Standards**: Modify modes to reference your team's coding standards or linting rules
- **Priorities**: Adjust what the modes emphasize (security vs. performance vs. maintainability)
- **Scope**: Configure modes to focus on specific areas (frontend, backend, infrastructure)
- **Tone**: Make modes more or less strict based on your team's preferences
- **Tools**: Add appropriate tools based on your workflow needs

## Related Resources

- **Rules**: `../../../rules/cursor/base/` - Base code quality standards
- **Commands**: `../../../commands/cursor/code-quality/` - Commands for specific workflows
- **Agents**: `../../../agents/code-quality/` - Claude Code/OpenCode equivalents

## Mode Configuration

Each mode is configured via Cursor Settings → Chat → Custom Modes. Copy the instructions from each `.md` file in this directory into the UI.

To configure:
1. Open Cursor Settings
2. Navigate to Chat → Custom Modes
3. Enable "Custom Modes (Beta)"
4. Create a new mode for each configuration file
5. Copy the instructions from the "Configuration" section of each file

## Version Information

**Last Updated**: 2025-10-14
**Toolkit Version**: Part of AE Toolkit best practices library
