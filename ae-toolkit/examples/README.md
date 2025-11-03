# Examples

**Reference implementations and templates for AI-accelerated engineering practices.**

This module provides concrete examples of methodologies, projects, and best practice libraries that demonstrate effective patterns for working with AI development tools.

> **Not sure if these examples apply to your situation?** Check the [Getting Started Guide](../getting-started/README.md) for guidance on when to use each toolkit module.

## Structure

### methodology-templates/
Well-defined, file-based methodology templates ranging from basic to robust. These can be used as reference or taken wholesale as starting points for projects of different scales.

See [methodology-templates/README.md](methodology-templates/README.md)

### projects/
Example projects demonstrating methodologies and AI coding concepts as practically applied. These show how rules and methodologies work in real development contexts.

See [projects/README.md](projects/README.md)

### rules/
A curated library of best practice rules for AI development tools (Claude Code, GitHub Copilot, Cursor). Organized into base rules (communication, session management, code quality) and technology-specific rules (TypeScript, React, .NET, Python).

Rules are static instruction files that guide AI behavior across all interactions in a project.

See [rules/README.md](rules/README.md)

### agents/
A collection of pre-built agent definitions for Claude Code and OpenCode. Agents are specialized AI personas with specific system prompts designed for focused tasks like code review, testing, documentation generation, and architecture analysis.

**Tool support:** Claude Code, OpenCode only (agents are not supported by GitHub Copilot or Cursor)

See [agents/README.md](agents/README.md)

### chat-modes/
Custom chat mode definitions for GitHub Copilot and Cursor. Chat modes provide specialized AI behavior for specific tasks, similar to agents but implemented using each tool's native capabilities.

**Tool support:** GitHub Copilot (`.chatmode.md` files), Cursor (custom modes via UI configuration)

See [chat-modes/README.md](chat-modes/README.md)

### commands/
Reusable command templates for all three major AI tools. Commands are workflow triggers that expand to prompts, encapsulating common development tasks like commit workflows, code review, and project setup.

**Tool-specific formats:** Claude Code/OpenCode (slash commands), GitHub Copilot (prompt files), Cursor (command templates)

See [commands/README.md](commands/README.md)

## Choosing Between Libraries

### When to Use Rules
- **Use when:** You need persistent guidance that applies to all AI interactions
- **Examples:** Communication style, code quality standards, framework conventions
- **Tools:** All tools (Claude Code, Copilot, Cursor)

### When to Use Agents (Claude Code/OpenCode)
- **Use when:** You need a specialized AI persona for a focused, complex task
- **Examples:** Thorough code review, comprehensive test generation, architecture analysis
- **Tools:** Claude Code, OpenCode only

### When to Use Chat Modes (Copilot/Cursor)
- **Use when:** You need specialized behavior equivalent to agents for Copilot or Cursor
- **Examples:** Same use cases as agents, but using tool-native capabilities
- **Tools:** GitHub Copilot, Cursor

### When to Use Commands
- **Use when:** You have a repeatable workflow that benefits from a trigger/template
- **Examples:** Git workflows, code analysis, project initialization
- **Tools:** All tools (format varies by tool)

### Combining Libraries
These libraries are designed to work together:
- **Rules + Commands**: Rules guide overall behavior; commands trigger specific workflows
- **Rules + Agents/Modes**: Rules provide context; agents/modes handle specialized tasks
- **Commands + Agents/Modes**: Commands initiate workflows; agents/modes can be invoked within those workflows

## Tool-Specific Navigation

### For Claude Code Users
- Rules: Use files from `rules/generic/` directories
- Agents: Use all agent definitions from `agents/`
- Commands: Use templates from `commands/generic/`

### For GitHub Copilot Users
- Rules: Use files from `rules/copilot/` directories
- Chat Modes: Use definitions from `chat-modes/copilot/`
- Commands: Use prompt files from `commands/copilot/`

### For Cursor Users
- Rules: Use files from `rules/cursor/` directories
- Chat Modes: Use configurations from `chat-modes/cursor/`
- Commands: Use templates from `commands/cursor/`