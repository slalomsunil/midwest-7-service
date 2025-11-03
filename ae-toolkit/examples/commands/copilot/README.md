# Copilot Commands (GitHub Copilot)

This directory contains prompt file definitions for GitHub Copilot. These commands provide reusable workflows that can be invoked using slash syntax in VS Code's Copilot Chat.

## What Are Prompt Files?

Prompt files are markdown files with optional YAML frontmatter that define reusable commands for GitHub Copilot Chat. They provide:

- **Quick access**: Type `/command-name` in Copilot Chat
- **Consistency**: Same workflow every time
- **Context awareness**: Commands can reference workspace, files, and selections
- **Reusability**: Share commands across projects or teams

**Note**: Prompt files are an experimental feature and subject to change.

## File Format

Prompt files use markdown with optional YAML frontmatter. The filename becomes the command name:

```
code-review.prompt.md → /code-review
analyze-changes.prompt.md → /analyze-changes
```

### Basic Format

```markdown
---
description: Brief description of what this command does
mode: agent
model: GPT-4o
tools:
  - workspace
  - terminal
---

# Command Implementation

Command prompt content here.

Can reference ${selection}, ${workspaceFolder}, ${file}
Can use ${input:variableName} for custom input
```

### Frontmatter Options

```yaml
---
# Brief description shown in UI
description: Perform comprehensive code review

# Interaction mode or custom chat mode name
# Built-in modes: ask, edit, agent
# Custom modes: Any mode defined in .github/chatmodes/
mode: agent

# Specific AI model to use (optional)
model: GPT-4o

# Available tool sets for the command
tools:
  - workspace  # Access to entire workspace
  - terminal   # Terminal/command line operations
---
```

## Storage Locations

### Project Prompts
Store in `.github/prompts/` directory within your project:

```
.github/
└── prompts/
    ├── code-review.prompt.md
    ├── generate-tests.prompt.md
    └── analyze-changes.prompt.md
```

### Workspace Prompts
For workspace-level prompts, configure location in VS Code settings.

### Enabling Prompt Files

Add to `.vscode/settings.json`:

```json
{
  "github.copilot.chat.promptFiles": true,
  "github.copilot.enable": {
    "*": true,
    "yaml": true,
    "plaintext": false,
    "markdown": true
  }
}
```

## Command Capabilities

### Variables

Prompt files support built-in variables:

- `${selection}` - Currently selected code
- `${workspaceFolder}` - Workspace root path
- `${file}` - Current file path
- `${input:variableName}` - Prompt user for input

**Example**:
```markdown
---
description: Review selected code
---

Review this code for quality issues:

${selection}

Consider the workspace context at ${workspaceFolder}
```

### Chat Participants

Commands can use @-mentions for context:

- `@workspace` - Context about the entire workspace
- `@vscode` - VS Code specific features
- `@terminal` - Terminal/command line operations

**Example**:
```markdown
Use @workspace to understand how this code fits into the larger project structure.
```

### Custom Chat Modes

Prompt files can specify a custom chat mode to use:

```markdown
---
description: Perform security audit
mode: security-auditor  # References .github/chatmodes/security-auditor.chatmode.md
---

Perform security audit using the specialized security mode.
```

This allows commands to leverage specialized AI personas defined in chat modes.

## Invoking Commands

### In VS Code

1. Open Copilot Chat panel
2. Type `/` to see available commands (autocomplete)
3. Type `/command-name` to invoke
4. Commands also appear in Command Palette

**Example**:
```
/code-review
/generate-tests
/analyze-changes @workspace
```

### Command Discovery

- **Autocomplete**: Type `/` to see all commands
- **Command Palette**: Search for "Copilot: Run Prompt File"
- **Chat Panel**: Commands listed in help

## Differences from Claude Code Slash Commands

While similar in concept, Copilot prompt files differ from Claude Code slash commands:

| Feature | Copilot Prompt Files | Claude Code Slash Commands |
|---------|---------------------|---------------------------|
| File extension | `.prompt.md` | `.md` |
| Location | `.github/prompts/` | `.claude/commands/` |
| Frontmatter | Optional (description, mode, model, tools) | Optional (description, allowed-tools, argument-hint) |
| Variables | `${selection}`, `${input:name}` | `$ARGUMENTS`, `$1`, `$2` |
| Context | @workspace, @vscode, @terminal | `@file/path` references |
| Bash execution | Via @terminal participant | Direct `` !`command` `` syntax |
| Chat modes | Can specify mode in frontmatter | Separate agent system |

**Key difference**: Copilot commands are more integrated with VS Code's workspace context, while Claude Code commands have more direct bash execution capabilities.

## Best Practices

### Keep Commands Focused

Each command should do one thing well. Don't create mega-commands that handle multiple workflows.

**Good**: `/code-review`, `/generate-tests`, `/analyze-changes`
**Bad**: `/do-everything` that tries to handle review, tests, and commits

### Use Appropriate Modes

- **`agent` mode**: For complex tasks requiring multiple steps
- **`edit` mode**: For direct code modifications
- **`ask` mode**: For simple questions or explanations

### Leverage Variables

Use variables to make commands flexible:

```markdown
Analyze this ${input:target}: ${selection}

Check for ${input:issue_type} issues.
```

### Provide Clear Instructions

Commands should have clear, structured prompts:

```markdown
Follow these steps:

## Step 1: Analyze
[Clear instructions]

## Step 2: Evaluate
[Clear instructions]

## Step 3: Report
[Clear instructions]
```

### Reference Context

Use @workspace for codebase awareness:

```markdown
Review the selected code in the context of @workspace architecture patterns.
```

## Library Organization

Commands in this directory are organized by category:

```
copilot/
├── git-workflows/      # Git operations
├── code-quality/       # Code review and analysis
└── project-setup/      # AI initialization and configuration
```

Each category directory contains:

- **README.md**: Category-specific guidance
- **Prompt files**: Individual `.prompt.md` files for each command

## Customization

These commands are **starting points**:

- Adjust wording to match your team's style
- Modify modes and tools to fit your needs
- Add project-specific context or constraints
- Change variable usage to fit your workflows
- Reference your project's specific chat modes
- Add organization-specific quality standards

## Integration with Chat Modes

Prompt files work best when combined with custom chat modes:

- **Chat Modes** (`../../chat-modes/copilot/`): Define specialized AI personas
- **Prompt Files**: Trigger workflows that can use those personas

**Pattern**: Create chat modes for sustained conversations, prompt files for discrete tasks.

**Example workflow**:
1. Use `/code-review` command to analyze changes
2. Switch to `code-reviewer` chat mode for deeper discussion
3. Use `/commit-workflow` command to create commit

## Cross-References

Related libraries:

- **Chat Modes**: `../../chat-modes/copilot/` - Specialized AI configurations
- **Rules**: `../../rules/copilot/` - Base and technology-specific rules
- **Generic Commands**: `../generic/` - Claude Code slash command equivalents
- **Cursor Commands**: `../cursor/` - Cursor command equivalents

## Contributing

When adding or updating prompt files:

1. Follow the `.prompt.md` naming convention
2. Include complete frontmatter with description
3. Use appropriate mode (agent, edit, ask)
4. Add variables where commands need user input
5. Provide 2-3 example invocations in comments
6. Test in VS Code with Copilot Chat
7. Update the category README if adding new patterns
8. Keep conceptually aligned with generic commands (same purpose, different implementation)

## Common Issues

### Command Not Appearing

**Possible causes**:
- Prompt files not enabled in VS Code settings
- File not in `.github/prompts/` directory
- File doesn't have `.prompt.md` extension

**Solution**:
- Add `"github.copilot.chat.promptFiles": true` to settings
- Verify file location and naming
- Reload VS Code window

### Command Not Working as Expected

**Possible causes**:
- Variables not properly formatted
- Chat mode referenced doesn't exist
- Tools not properly specified

**Solution**:
- Check variable syntax: `${variableName}`
- Verify chat mode exists in `.github/chatmodes/`
- Ensure tools array is valid: `workspace`, `terminal`

### Context Not Available

**Possible causes**:
- @workspace not used for codebase context
- File/selection variables empty

**Solution**:
- Add `@workspace` to prompt for broader context
- Check that `${selection}` is used when expecting selected code
- Ensure workspace folder is open in VS Code

## Version Information

**Last Updated**: 2025-10-14
**Toolkit Version**: Part of AE Toolkit best practices library
**Tool Support**: GitHub Copilot in VS Code (experimental feature)

See `../` for other tool-specific command implementations.
