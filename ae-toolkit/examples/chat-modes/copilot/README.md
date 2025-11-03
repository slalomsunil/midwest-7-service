# GitHub Copilot Chat Modes

This directory contains pre-built chat mode definitions for GitHub Copilot that provide specialized AI assistance for common development tasks.

## What Are Copilot Chat Modes?

Chat modes are specialized configurations of GitHub Copilot Chat with custom instructions, tool access, and model selection. They create focused, purpose-specific AI assistants that maintain consistent behavior across entire conversations.

### Chat Modes vs. Prompt Files

| Aspect | Prompt Files | Chat Modes |
|--------|--------------|------------|
| **Purpose** | Reusable commands/workflows | Persistent AI personas |
| **Context** | Single execution | Entire conversation |
| **Invocation** | `/commandname` | Mode selector dropdown |
| **Persistence** | Per command | Entire session |
| **Integration** | Can specify a chat mode via `mode:` field | Can be invoked by prompt files |

See `../../commands/copilot/` for command equivalents (prompt files).

## File Format

Copilot chat modes use `.chatmode.md` files with YAML frontmatter:

```markdown
---
description: Brief description of what this mode does
tools: ['codebase', 'search', 'fetch', 'terminal']
model: gpt-4o
---

# Mode Name

## Purpose

Define the role and behavior for this chat mode.

## Guidelines
- Guideline 1
- Guideline 2

## Process
1. Step 1
2. Step 2
```

### YAML Frontmatter Fields

| Field | Required | Description | Options |
|-------|----------|-------------|---------|
| `description` | Yes | Brief mode description | Any text |
| `tools` | No | Available tools array | `codebase`, `search`, `fetch`, `terminal` |
| `model` | No | AI model to use | `gpt-4o`, `claude-sonnet`, etc. |

### Available Tools

```yaml
tools: [
  'codebase',    # Access to workspace code
  'search',      # Web search capability
  'fetch',       # Fetch web content
  'terminal'     # Terminal access
]
```

Only include tools necessary for the mode's purpose. Fewer tools = faster responses.

### Model Options

```yaml
# OpenAI Models
model: gpt-4o
model: gpt-4-turbo
model: gpt-3.5-turbo

# Anthropic Models
model: claude-sonnet
model: claude-haiku

# Default (inherit from settings)
# Omit model field
```

## Storage Location

Store chat modes in your project at:

```
project-root/
└── .github/
    └── chatmodes/
        └── your-mode.chatmode.md
```

For user profile chat modes (across all projects):

```
~/.vscode/profiles/[profile-name]/
└── chatmodes/
    └── your-mode.chatmode.md
```

## Using Chat Modes

### Via UI
1. Open Copilot Chat view in VS Code
2. Click mode selector dropdown at top
3. Select desired mode
4. Mode persists for the session

### Via Command Palette
1. Open Command Palette (Cmd/Ctrl+Shift+P)
2. Type "Copilot: Select Chat Mode"
3. Choose from available modes

### Via Prompt Files
Chat modes can be invoked automatically by prompt files using the `mode:` field:

```markdown
---
description: Review code for security issues
mode: security-auditor
---
Review the current changes for security vulnerabilities
```

## Library Organization

Chat modes are organized by task type:

```
copilot/
├── code-quality/       # Code review, refactoring, tech debt
├── testing/            # Test generation, coverage, improvement
├── documentation/      # API docs, README, inline comments
└── architecture/       # Architecture review, dependency analysis
```

Each category contains:
- **README.md**: Category purpose and when to use each mode
- **Mode files**: `.chatmode.md` files for each specialized mode

## Related Libraries

- **Rules**: `../../rules/copilot/` - Instruction rules applied to all Copilot interactions
- **Commands**: `../../commands/copilot/` - Prompt files for specific workflows
- **Cursor Modes**: `../cursor/` - Cursor equivalents of these chat modes
- **Agents**: `../../agents/` - Claude Code/OpenCode equivalents

## Customization

These chat modes are **starting points**:

- Adjust tone and communication style to match your team
- Add technology-specific knowledge relevant to your stack
- Modify quality standards to align with your practices
- Reference your project's specific rules or documentation
- Modify tool selection based on your needs
- Choose models based on your subscription and performance requirements

## Requirements

- VS Code 1.101 or later
- GitHub Copilot subscription
- Chat modes are a preview feature subject to changes

## Version Information

**Last Updated**: 2025-10-14
**Toolkit Version**: Part of AE Toolkit best practices library

For detailed documentation on Copilot chat modes, see:
- Official docs: https://code.visualstudio.com/docs/copilot/customization/custom-chat-modes
- Project docs: `../../../../docs/ai-tools/copilot/copilot-custom-chat-modes.md`
