# Cursor Commands

This directory contains command definitions for Cursor. These commands provide reusable workflows that can be invoked using slash syntax in Cursor's chat.

## What Are Cursor Commands?

Cursor commands are plain markdown files that define reusable workflows. They provide:

- **Quick access**: Type `/command-name` in Cursor chat
- **Simple format**: Plain markdown, no frontmatter required
- **Auto-discovery**: Commands appear in autocomplete
- **Reusability**: Share commands across projects or teams

**Note**: Commands are currently in beta and may change as Cursor develops the feature.

## File Format

Cursor commands are plain markdown files. The filename becomes the command name:

```
code-review.md → /code-review
analyze-changes.md → /analyze-changes
```

### Simple Format

```markdown
# Command Name

Brief description of what this command does.

## Workflow

Step-by-step instructions:

1. First step
2. Second step
3. Third step

Can reference @code, @file, @folder for context.
```

**No frontmatter needed** - Unlike Claude Code or Copilot, Cursor commands are just plain markdown.

## Storage Locations

### Project Commands
Store in `.cursor/commands/` directory within your project:

```
.cursor/
└── commands/
    ├── code-review.md
    ├── generate-tests.md
    └── analyze-changes.md
```

### Global Commands
Store in `~/.cursor/commands/` for commands available across all projects.

## Command Capabilities

### Context References

Commands can use @-mentions for context:

- `@code` - Reference codebase context
- `@file` - Reference specific files
- `@folder` - Reference directories
- `@web` - Reference web search

**Example**:
```markdown
Review the code using @code context.
Check @file for specific implementation details.
```

### Cursor-Specific Features

**Composer Mode**: Multi-file editing capabilities
- Create related files in one operation
- Update multiple files simultaneously
- Maintain consistency across changes

**Codebase Indexing**: Automatic semantic understanding
- Search across entire codebase
- Context-aware suggestions
- Project structure awareness

**Model Selection**: Users can choose AI models
- GPT-4
- Claude 3 (Opus, Sonnet)
- Custom models via API

### Inline Commands (Cmd+K / Ctrl+K)

Separate from slash commands, inline commands work directly in code:
- Generate code at cursor
- Edit selected code
- Refactor with instructions

## Invoking Commands

### In Cursor

1. Open Cursor chat panel
2. Type `/` to see available commands (autocomplete)
3. Type `/command-name` to invoke
4. Commands work with currently active chat mode

**Example**:
```
/code-review
/generate-tests
/analyze-changes
```

### Command Discovery

- **Autocomplete**: Type `/` to see all commands
- **Project & Global**: Both scopes appear together
- **Simple invocation**: Just type the command name

## Relationship with Chat Modes

**Important**: Commands and chat modes are separate features in Cursor:

- Commands **cannot** programmatically invoke or switch chat modes
- Commands execute in whatever mode is currently active
- Users must manually switch modes before using commands

**Workflow**:
1. User manually switches to desired mode (e.g., "reviewer" mode)
2. User types `/code-review` to execute command
3. Command runs with active mode's context

### Suggesting Modes in Commands

Since commands can't switch modes, suggest appropriate modes in the command text:

```markdown
# Security Review

**Recommended: Switch to Ask Mode for read-only analysis**

Use Cmd+. to switch to Ask Mode for safe analysis, or stay in current mode for fixes.

## Review Process
...
```

## Differences from Other Tools

| Feature | Cursor | Claude Code | Copilot |
|---------|--------|-------------|---------|
| File extension | `.md` | `.md` | `.prompt.md` |
| Location | `.cursor/commands/` | `.claude/commands/` | `.github/prompts/` |
| Frontmatter | None (plain markdown) | Optional (YAML) | Optional (YAML) |
| Context | @code, @file, @folder | `@file/path`, `` !`bash` `` | `${selection}`, @workspace |
| Mode integration | Manual mode switching | Separate agents | Can specify in frontmatter |
| Auto-discovery | Yes, type `/` | Yes, type `/` | Yes, type `/` |

**Key difference**: Cursor commands are the simplest format - just plain markdown with clear instructions.

## Best Practices

### Keep Commands Simple

Cursor commands work best when clear and focused:

**Good**:
```markdown
# Code Review

Review the code for:
1. Quality issues
2. Security concerns
3. Performance problems

Provide specific feedback with examples.
```

**Too complex**: Trying to encode complex logic or conditionals

### Use Clear Headings

Structure commands with clear markdown headings:

```markdown
# Command Name

## Purpose
What this command does

## Workflow
Step-by-step process

## Expected Output
What the user should receive
```

### Leverage Context

Use @-mentions to provide context:

```markdown
Review @code for patterns that violate our standards.
Compare @file with similar implementations in the codebase.
Check @folder for consistency across components.
```

### Document Mode Recommendations

Since commands can't switch modes, tell users which mode works best:

```markdown
**Best Mode**: Agent Mode (for file modifications)
**Alternative**: Ask Mode (for analysis only)
```

### Front-Load Important Instructions

Put the most critical instructions first:

```markdown
# Command Name

**IMPORTANT**: Check for X before doing Y.

Now proceed with:
1. Step one
2. Step two
```

## Library Organization

Commands in this directory are organized by category:

```
cursor/
├── git-workflows/      # Git operations
├── code-quality/       # Code review and analysis
└── project-setup/      # AI initialization
```

Each category directory contains:

- **README.md**: Category-specific guidance
- **Command files**: Individual `.md` files for each command

## Integration with .cursorrules

Commands work best when combined with `.cursorrules`:

**`.cursorrules`**:
```markdown
# Project Rules

You are helping with a TypeScript/React project.

## Code Style
- Functional components with hooks
- TypeScript for type safety
- Jest for testing

## Workflow
- Follow conventional commits
- Write tests for new features
- Use existing patterns
```

Commands automatically respect these rules when executing.

## Customization

These commands are **starting points**:

- Adjust wording for your team's style
- Add project-specific context
- Modify workflows to match your processes
- Reference your specific file structures
- Add technology-specific checks
- Include organization standards

## Cross-References

Related libraries:

- **Chat Modes**: `../../chat-modes/cursor/` - Custom mode configurations
- **Rules**: `../../rules/cursor/` - Base and technology-specific rules
- **Generic Commands**: `../generic/` - Claude Code equivalents
- **Copilot Commands**: `../copilot/` - Copilot prompt file equivalents

## Contributing

When adding or updating commands:

1. Use simple, clear markdown format
2. No frontmatter needed (Cursor doesn't use it)
3. Include clear headings and structure
4. Suggest appropriate modes if relevant
5. Use @-mentions for context
6. Provide 2-3 example invocations in comments
7. Test in Cursor chat
8. Update category README if adding new patterns
9. Keep conceptually aligned with generic commands

## Common Issues

### Command Not Appearing

**Possible causes**:
- File not in `.cursor/commands/` directory
- File doesn't have `.md` extension
- Cursor hasn't detected the file yet

**Solution**:
- Verify file location: `.cursor/commands/your-command.md`
- Restart Cursor to reload commands
- Check filename has no special characters

### Command Not Working as Expected

**Possible causes**:
- Instructions unclear or ambiguous
- Wrong chat mode active for the task
- Context references not working

**Solution**:
- Simplify and clarify instructions
- Suggest appropriate mode in command text
- Use explicit @code, @file references
- Test in different chat modes

### Commands Conflict with Modes

**Issue**: Command behavior varies by active mode

**Solution**:
- Document which mode works best in command
- Design commands to work in any mode
- Suggest mode switching at start of command
- Test commands in all common modes

## Version Information

**Last Updated**: 2025-10-14
**Toolkit Version**: Part of AE Toolkit best practices library
**Tool Support**: Cursor (beta feature)

See `../` for other tool-specific command implementations.
