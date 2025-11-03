# Cursor Custom Modes

This directory contains pre-built custom mode configurations for Cursor that provide specialized AI assistance for common development tasks.

## What Are Cursor Custom Modes?

Custom modes are specialized AI configurations in Cursor with custom tools, behaviors, and instructions. They create focused, purpose-specific AI assistants that maintain consistent behavior across entire conversations.

### Custom Modes vs. Commands

| Aspect | Commands (`.cursor/commands/`) | Modes |
|--------|--------------------------------|-------|
| **Purpose** | Specific workflow execution | AI behavior configuration |
| **Context** | Single execution | Entire conversation |
| **Invocation** | `/commandname` | Mode selector dropdown or `Cmd+.` |
| **Persistence** | Per command | Entire session |
| **Configuration** | Markdown files | UI-based configuration |

See `../../commands/cursor/` for command equivalents.

## Current Implementation

Custom modes in Cursor are currently **configured via UI**, not files. This is a beta feature that may evolve to support file-based configuration in the future.

### Configuring Custom Modes

1. Open Cursor Settings
2. Navigate to Chat → Custom Modes
3. Enable "Custom Modes (Beta)"
4. Create and configure your custom modes

### Mode Switching
- **Keyboard**: `Cmd+.` (Mac) / `Ctrl+.` (Windows/Linux)
- **UI**: Mode selector dropdown in chat

## Mode Configuration

Each custom mode can be configured with:

### Tool Selection

**Search Tools**
- Codebase Search - Search across all project files
- File Search - Search within specific files
- Symbol Search - Find definitions and references

**Edit Tools**
- Edit & Reapply - Modify code with context
- Multi-file Edit - Change multiple files simultaneously
- Refactor - Structural code improvements

**Terminal Tools**
- Command Execution - Run shell commands
- Test Running - Execute test suites
- Build Operations - Compile and build projects

**Read Tools**
- File Reading - View file contents
- Documentation Access - Read project docs
- History Viewing - Git history and changes

### Instructions

Custom instructions that define the mode's:
- Role and expertise
- Behavioral guidelines
- Process or workflow
- Output format preferences
- Quality standards

### Model Selection

Choose from available models based on task complexity and speed requirements.

## Library Organization

Mode configurations are organized by task type, mirroring the agents and Copilot chat modes:

```
cursor/
├── code-quality/       # Code review, refactoring, tech debt
├── testing/            # Test generation, coverage, improvement
├── documentation/      # API docs, README, inline comments
└── architecture/       # Architecture review, dependency analysis
```

Each category contains:
- **README.md**: Category purpose and when to use each mode
- **Mode configuration files**: `.md` files describing how to configure each mode in the UI

## Mode File Format

Since Cursor uses UI-based configuration, our files describe how to set up each mode:

```markdown
# Mode Name

## Purpose

Brief description of what this mode does and when to use it.

## Configuration

### Tools
- Tool 1
- Tool 2

### Model
Recommended model (e.g., GPT-4, Claude)

### Instructions
```
[Full instructions text to copy into UI]
```

## Usage Examples

Example invocations and expected behavior.
```

## Future File-Based Support

Cursor may add support for `.cursor/modes.json` or similar file-based configuration in the future. When that happens, these configurations can be easily adapted from the current UI-based descriptions.

## Related Libraries

- **Rules**: `../../rules/cursor/` - Instruction rules applied to all Cursor interactions
- **Commands**: `../../commands/cursor/` - Slash commands for specific workflows
- **Copilot Modes**: `../copilot/` - GitHub Copilot equivalents
- **Agents**: `../../agents/` - Claude Code/OpenCode equivalents

## Customization

These custom modes are **starting points**:

- Adjust tone and communication style to match your team
- Add technology-specific knowledge relevant to your stack
- Modify quality standards to align with your practices
- Reference your project's specific rules or documentation
- Modify tool selection based on your workflow needs
- Choose models based on your subscription and performance requirements

## Best Practices

### Mode Design
- **Single Purpose**: Each mode should excel at one type of task
- **Tool Minimization**: Only include necessary tools for performance
- **Clear Instructions**: Provide specific behavioral guidelines

### Tool Selection
- **Safety First**: Limit destructive tools in exploration modes
- **Performance**: Fewer tools = faster responses
- **Appropriateness**: Match tools to task requirements

### Workflow Integration
- **Mode Switching**: Train yourself to switch modes for different tasks
- **Documentation**: Document which modes to use when
- **Team Sharing**: Export and share effective configurations

## Beta Status

Custom modes are experimental and may change as the feature evolves. Current limitations:

- UI-based configuration only (no file-based config yet)
- Cannot programmatically switch modes
- Tool availability may vary
- Feature is still being actively developed

## Requirements

- Cursor with custom modes feature enabled
- Settings → Chat → Custom Modes → Enable "Custom Modes (Beta)"

## Version Information

**Last Updated**: 2025-10-14
**Toolkit Version**: Part of AE Toolkit best practices library

For detailed documentation on Cursor custom modes, see:
- Official docs: https://cursor.com/docs/agent/modes
- Project docs: `../../../../docs/ai-tools/cursor/cursor-custom-modes.md`
