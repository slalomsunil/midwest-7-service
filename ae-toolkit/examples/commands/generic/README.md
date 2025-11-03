# Generic Commands (Claude Code / OpenCode)

This directory contains slash command definitions for Claude Code and OpenCode. These tools support custom commands stored as markdown files that expand to full prompts when invoked.

## What Are Slash Commands?

Slash commands are text-based triggers (e.g., `/commit`, `/review-changes`) that expand to complete prompts. They provide:

- **Quick access**: Type `/command-name` instead of lengthy prompts
- **Consistency**: Same workflow every time
- **Context awareness**: Commands can reference files, execute bash commands, and use arguments
- **Reusability**: Share commands across projects or teams

## File Format

Slash commands are markdown files with optional YAML frontmatter. The filename becomes the command name:

```
commit-workflow.md → /commit-workflow
pr-creation.md → /pr-creation
```

### Basic Format

```markdown
---
description: Brief description of what this command does
argument-hint: [expected arguments]
---

Command prompt content here.

Can reference $ARGUMENTS or $1, $2, etc. for individual arguments.
Can include @file/references.md
Can execute !`bash commands` (requires allowed-tools)
```

### Frontmatter Options

```yaml
---
# Brief description (character budget limited)
description: Create a commit with conventional format

# Argument hints for users
argument-hint: [optional commit message]

# Restrict to specific bash commands (enables !`command` syntax)
allowed-tools: Bash(git:*, npm:*)

# Specify model to use (optional)
model: specific-model-name

# Control whether model is invoked (advanced)
disable-model-invocation: false
---
```

## Storage Locations

### Project Commands
Store in `.claude/commands/` directory within your project:

```
.claude/
└── commands/
    ├── commit-workflow.md
    ├── pr-creation.md
    └── review-changes.md
```

### Personal Commands
Store in user-specific directory for commands available across all projects:

- **macOS/Linux**: `~/.config/claude/commands/`
- **Windows**: `%APPDATA%\claude\commands\`

## Command Capabilities

### File References

Use `@` prefix to reference files:

```markdown
Review the changes according to @.claude/rules/code-quality.md
```

**Note**: File references in commands are aggressively read into context (unlike in rule files where they're suggestions).

### Bash Command Execution

Execute bash commands inline using backticks with `!` prefix:

```markdown
The current branch is !`git branch --show-current`
```

**Requirements**:
- Must include `allowed-tools` in frontmatter
- Output is trimmed of whitespace
- Example: `allowed-tools: Bash(git:*, npm:*)`

### Arguments

Commands can accept arguments:

- `$ARGUMENTS` - All arguments passed to the command
- `$1`, `$2`, etc. - Individual positional arguments

**Important**:
- Argument substitution is literal and happens before the agent sees the command
- When no arguments provided, `$ARGUMENTS` is NOT replaced with empty string (remains as literal text)
- Makes optional arguments challenging to implement

Example:

```markdown
---
description: Create a PR with custom title
argument-hint: [PR title]
---

Create a pull request with the title: $1
```

Invoke: `/create-pr "Fix authentication bug"`

### Namespacing

Organize commands in subdirectories to create command hierarchies:

```
.claude/commands/
├── git/
│   ├── commit.md      → /git/commit
│   └── branch.md      → /git/branch
└── review/
    └── changes.md      → /review/changes
```

## Invoking Commands

### In Claude Code

1. Type `/` in chat to see available commands (autocomplete)
2. Type `/command-name` followed by any arguments
3. Press Enter to execute

Example:
```
/commit-workflow
/pr-creation Ready for review
/review-changes @src/auth.ts
```

### Command Discovery

- **Autocomplete**: Type `/` to see available commands
- **Help**: `/help` shows all commands
- **Command Palette**: Use Claude Code's command palette

## Context and Inheritance

Slash commands inherit all active context including:

- `CLAUDE.md` instructions
- Project rules from `.claude/`
- Conversation history
- Tool permissions

**Important**: Commands may malfunction if conflicting rules or instructions are present in the context. You may need to customize commands for specific projects.

## Best Practices

### Keep Commands Focused

Each command should do one thing well. Don't create mega-commands that try to handle multiple workflows.

**Good**: `/commit-workflow`, `/pr-creation`, `/review-changes`
**Bad**: `/git-all` that tries to handle commits, PRs, and reviews

### Be Explicit with Multi-Step Workflows

For commands that require multiple steps, be very explicit:

```markdown
Follow each step below in order:

1. Run `git status` to see uncommitted changes
2. Review the changes for quality issues
3. Generate a commit message in conventional format
4. Create the commit with the generated message
5. Report the commit SHA and summary
```

**Don't** provide general directions and let the agent improvise - specify exactly what should happen.

### Use File References for Shared Content

When multiple commands need the same information, store it in a shared file:

```
.claude/
├── lib/
│   └── commit-conventions.md
└── commands/
    ├── commit-workflow.md      # References @.claude/lib/commit-conventions.md
    └── pr-description.md        # References @.claude/lib/commit-conventions.md
```

### Test with Thinking Mode

Users can activate thinking mode (via tab). Test your commands with thinking mode enabled as it affects behavior.

### Consider Command Length

Commands consume context window space. Keep them concise while still being explicit about the desired workflow.

## OpenCode Compatibility

These commands are designed for Claude Code but should work with OpenCode if it supports the same slash command format. Verify:

- File format compatibility (markdown with YAML frontmatter)
- Storage location conventions
- `$ARGUMENTS` and file reference support
- Bash command execution syntax

## Library Organization

Commands in this directory are organized by category:

```
generic/
├── git-workflows/      # Git operations
├── code-quality/       # Code review and analysis
└── project-setup/      # AI initialization and configuration
```

Each category directory contains:

- **README.md**: Category-specific guidance
- **Command files**: Individual `.md` files for each command

## Customization

These commands are **starting points**:

- Adjust wording to match your team's style
- Add project-specific context or constraints
- Modify workflows to align with your processes
- Add technology-specific knowledge
- Reference your project's specific rules or documentation
- Change argument handling to fit your needs

## Cross-References

Related libraries:

- **Agents**: `../../agents/` - Specialized AI personas for Claude Code
- **Rules**: `../../rules/generic/` - Base and technology-specific rules
- **Copilot Commands**: `../copilot/` - GitHub Copilot prompt file equivalents
- **Cursor Commands**: `../cursor/` - Cursor command equivalents

## Contributing

When adding or updating commands:

1. Follow the file format with complete frontmatter
2. Include clear description of purpose and arguments
3. Add cross-references to related rules or agents if applicable
4. Provide example invocations in the file comments
5. Test in both trivial and complex scenarios
6. Consider context inheritance and potential conflicts
7. Update the category README if adding new patterns

## Version Information

**Last Updated**: 2025-10-14
**Toolkit Version**: Part of AE Toolkit best practices library
**Tool Support**: Claude Code (confirmed), OpenCode (expected)

See `../` for other tool-specific command implementations.
