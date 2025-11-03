# Agents Library

This library provides pre-built agent definitions for Claude Code and OpenCode that encapsulate specialized AI personas for common development tasks.

## What Are Agents?

Agents are specialized AI personas with custom system prompts that shape behavior, tone, and expertise for specific tasks. Unlike general-purpose chat, agents:

- Have focused expertise in specific domains (code review, testing, documentation, architecture)
- Follow consistent patterns and best practices for their task type
- Can reference rules from the rules library to maintain consistency
- Are invoked explicitly when you need specialized assistance

## Claude Code and OpenCode Specificity

**Agents are specific to Claude Code and OpenCode.** These tools support custom agent definitions stored in the `.claude/agents/` directory (Claude Code) or similar location (OpenCode). Other AI tools have different mechanisms:

- **GitHub Copilot** uses "chat modes" (see `../chat-modes/copilot/` for Copilot equivalents)
- **Cursor** uses "custom modes" configured via UI (see `../chat-modes/cursor/` for Cursor equivalents)

If you're using Copilot or Cursor, refer to the chat-modes library instead.

## When to Use Agents

Use agents when you need:

- **Specialized review**: Code review with specific quality standards
- **Focused generation**: Tests, documentation, or architectural analysis following consistent patterns
- **Domain expertise**: Deep knowledge in specific areas (refactoring, tech debt, dependency management)
- **Consistent quality**: Repeatable processes that apply the same standards every time

Don't use agents for:

- General-purpose coding assistance (use main chat)
- One-off questions or exploratory conversations
- Tasks that don't benefit from specialized expertise
- Simple code changes that don't need review

## Library Organization

Agents are organized by task type, not technology. The same code review principles apply to TypeScript, .NET, and Python, so we have one code review agent rather than separate versions per language.

```
agents/
├── code-quality/       # Code review, refactoring, tech debt analysis
├── testing/            # Test generation, coverage analysis, test improvement
├── documentation/      # API docs, README generation, inline comments
└── architecture/       # Architecture review, dependency analysis
```

Each category has:

- **README.md**: Explains the category's purpose and when to use each agent
- **Agent definitions**: Individual `.md` files with system prompts and metadata

## Using Agents

### In Claude Code

1. Copy agent definitions to `.claude/agents/` in your project
2. Invoke agents using the task UI or directly: `@agent-name your request here`
3. Agents have access to your codebase and can reference rules from `.claude/` if configured

### In OpenCode

1. Copy agent definitions to the appropriate agents directory in your project
2. Invoke agents according to OpenCode's conventions (may differ from Claude Code)
3. Verify agent format compatibility with your OpenCode version

## Agent File Format

Each agent definition is a markdown file with:

```markdown
---
name: agent-name
description: Brief description of agent's purpose
version: YYYY-MM-DD
author: Your Name/Organization
tags: [category, relevant-tech]
---

# Agent Name

## Purpose

What this agent does and when to use it.

## System Prompt

The actual prompt that defines the agent's behavior, expertise, and guidelines.

## Related Rules

- ../../rules/base/communication.md
- ../../rules/tech/typescript.md

## Examples

Example invocations and expected behavior.
```

## Customization

These agents are **starting points**, not prescriptive requirements:

- Adjust tone and communication style to match your team
- Add technology-specific knowledge relevant to your stack
- Modify quality standards to align with your team's practices
- Reference your project's specific rules or documentation
- Combine multiple agents if your workflow benefits from it

## Contributing

When adding or updating agents:

1. Follow the file format above with complete metadata
2. Include a clear description of when to use vs. when not to use
3. Add cross-references to related rules from the rules library
4. Provide 2-3 example invocations with expected outcomes
5. Test the agent in both trivial and complex scenarios
6. Update the category README if adding new patterns

## Version Information

**Last Updated**: 2025-10-14
**Toolkit Version**: Part of AE Toolkit best practices library

See `../` for other library components (rules, chat-modes, commands).
