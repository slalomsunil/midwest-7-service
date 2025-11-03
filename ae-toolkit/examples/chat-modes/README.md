# Chat Modes Library

This library provides pre-built chat mode definitions for GitHub Copilot and Cursor that encapsulate specialized AI personas for common development tasks.

## What Are Chat Modes?

Chat modes are specialized AI configurations that shape behavior, tone, and expertise for specific tasks within GitHub Copilot and Cursor. They serve a similar purpose to agents in Claude Code/OpenCode, but are implemented differently based on each tool's capabilities.

### Chat Modes vs. Agents

- **Agents** (Claude Code/OpenCode): Custom agent definitions stored in `.claude/agents/` with system prompts
- **Chat Modes** (Copilot): `.chatmode.md` files in `.github/chatmodes/` with YAML frontmatter
- **Custom Modes** (Cursor): UI-configured modes with tool selection and shortcuts

All three approaches accomplish the same goal: providing specialized AI assistance for focused tasks.

## Tool Specificity

This library is organized by tool because each has distinct implementation patterns:

```
chat-modes/
├── copilot/    # GitHub Copilot .chatmode.md files
└── cursor/     # Cursor custom mode configurations
```

**If you're using Claude Code or OpenCode**, see `../agents/` for agent definitions instead.

## When to Use Chat Modes

Use chat modes when you need:

- **Specialized review**: Code review with specific quality standards
- **Focused generation**: Tests, documentation, or architectural analysis following consistent patterns
- **Domain expertise**: Deep knowledge in specific areas (refactoring, tech debt, dependency management)
- **Consistent quality**: Repeatable processes that apply the same standards every time

Don't use chat modes for:

- General-purpose coding assistance (use main chat)
- One-off questions or exploratory conversations
- Tasks that don't benefit from specialized expertise
- Simple code changes that don't need review

## Comparison to Commands

Chat modes and commands serve different purposes:

- **Chat Modes**: Set the AI's persona and expertise for an extended conversation
- **Commands**: Trigger specific workflows or prompts for discrete tasks

You might use a chat mode for a thorough code review session, but use a command to quickly commit changes with a generated message.

## Library Organization

Both Copilot and Cursor chat modes are organized by task type, mirroring the agents library structure:

- **code-quality/**: Code review, refactoring, tech debt analysis
- **testing/**: Test generation, coverage analysis, test improvement
- **documentation/**: API docs, README generation, inline comments
- **architecture/**: Architecture review, dependency analysis

Each category has:

- **README.md**: Explains the category's purpose and when to use each mode
- **Mode definitions**: Tool-specific files (`.chatmode.md` for Copilot, `.md` for Cursor)

## Tool-Specific Details

### GitHub Copilot

See `./copilot/README.md` for:
- `.chatmode.md` file format and YAML frontmatter
- Storage location (`.github/chatmodes/`)
- Model selection and tool preferences
- How to invoke chat modes in VS Code

### Cursor

See `./cursor/README.md` for:
- UI-based configuration approach
- Tool selection and shortcuts
- Future `.cursor/modes.json` support
- How to activate custom modes

## Customization

These chat modes are **starting points**, not prescriptive requirements:

- Adjust tone and communication style to match your team
- Add technology-specific knowledge relevant to your stack
- Modify quality standards to align with your team's practices
- Reference your project's specific rules or documentation
- Combine multiple modes if your workflow benefits from it

## Contributing

When adding or updating chat modes:

1. Create versions for both Copilot and Cursor when applicable
2. Follow each tool's specific format and conventions
3. Include clear descriptions of when to use vs. when not to use
4. Add cross-references to related rules from the rules library
5. Provide 2-3 example invocations with expected outcomes
6. Test the mode in both trivial and complex scenarios
7. Update the category README if adding new patterns
8. Keep Copilot and Cursor versions conceptually aligned (same purpose, different implementation)

## Cross-References

Related libraries:

- **Agents**: `../agents/` - Claude Code/OpenCode equivalents
- **Rules**: `../rules/` - Base and technology-specific instruction rules
- **Commands**: `../commands/` - Workflow triggers and slash commands

## Version Information

**Last Updated**: 2025-10-14
**Toolkit Version**: Part of AE Toolkit best practices library

See `../` for other library components.
