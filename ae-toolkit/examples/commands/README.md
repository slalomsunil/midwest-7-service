# Commands Library

This library provides reusable command definitions that encapsulate common workflows and best practices for AI-assisted development.

## What Are Commands?

Commands are trigger mechanisms that invoke specific workflows or prompts for discrete tasks. Different AI tools implement commands in different ways:

- **Slash Commands** (Claude Code/OpenCode): Text-based commands stored in `.claude/commands/` that expand to full prompts
- **Prompt Files** (GitHub Copilot): Reusable prompts stored in `.github/prompts/` that can be invoked in chat
- **Commands** (Cursor): Configurable commands that can be triggered via shortcuts or command palette

### Commands vs. Chat Modes/Agents

Commands and chat modes/agents serve complementary but different purposes:

- **Commands**: Trigger specific workflows for discrete tasks (e.g., create a commit, run a code review)
  - Quick, focused actions
  - Single-purpose invocations
  - Often part of a larger workflow

- **Chat Modes/Agents**: Set the AI's persona and expertise for extended conversations
  - Sustained interaction with consistent behavior
  - Multi-turn conversations
  - Comprehensive analysis or generation

**Example workflow**: Use a code review *agent/mode* to conduct a thorough review session, then use a commit *command* to create a well-formatted commit message based on the changes.

## Tool-Specific Implementation

Because each AI tool implements commands differently, this library is organized by tool:

```
commands/
├── generic/    # Claude Code/OpenCode slash commands
├── copilot/    # GitHub Copilot prompt files
└── cursor/     # Cursor command configurations
```

Each tool directory contains the same category structure:

- **git-workflows/**: Git operations (commit, PR creation, branch management)
- **code-quality/**: Code review and analysis (review changes, analyze complexity)
- **project-setup/**: AI initialization and configuration (AI setup, rules configuration)

## When to Use Commands

Use commands when you need:

- **Repeatable workflows**: Standard processes you run frequently (committing, creating PRs)
- **Consistent formatting**: Output that follows specific patterns (commit messages, PR descriptions)
- **Quick triggers**: Fast access to common operations without typing long prompts
- **Integration points**: Hooks into tool-specific functionality (git operations, project scanning)

Don't use commands for:

- Extended conversations (use chat modes/agents instead)
- Novel or one-off tasks (use regular chat)
- Tasks that require back-and-forth clarification
- Exploratory work where the outcome is unclear

## Library Organization

### By Tool (Top Level)

Commands are first organized by tool because implementation differs significantly:

- **generic/**: Claude Code and OpenCode slash commands (markdown files with prompts)
- **copilot/**: GitHub Copilot prompt files (markdown with optional frontmatter)
- **cursor/**: Cursor commands (tool-specific format)

### By Category (Within Each Tool)

Within each tool directory, commands are organized by workflow category:

```
{tool}/
├── git-workflows/
│   ├── README.md
│   ├── commit-workflow.md
│   ├── pr-creation.md
│   └── branch-management.md
├── code-quality/
│   ├── README.md
│   ├── review-changes.md
│   └── analyze-complexity.md
└── project-setup/
    ├── README.md
    ├── initialize-ai.md
    └── configure-rules.md
```

Each category has:

- **README.md**: Explains the category's purpose and when to use each command
- **Command definitions**: Individual `.md` files with command prompts and metadata

## Tool-Specific Details

### Generic (Claude Code/OpenCode)

See `./generic/README.md` for:
- Slash command format and syntax
- Storage location (`.claude/commands/`)
- How to invoke commands in Claude Code
- OpenCode compatibility considerations

### GitHub Copilot

See `./copilot/README.md` for:
- Prompt file format and optional frontmatter
- Storage location (`.github/prompts/` or workspace-specific)
- How to invoke prompts in VS Code
- Differences from slash commands

### Cursor

See `./cursor/README.md` for:
- Command configuration approach
- Integration with custom modes
- Keyboard shortcuts and command palette
- Command chaining and composition

## Using Commands

### In Claude Code

1. Copy command files to `.claude/commands/` in your project
2. Invoke using `/command-name` in chat
3. Commands can reference project files and rules

### In GitHub Copilot

1. Copy prompt files to `.github/prompts/` in your project (or workspace prompts directory)
2. Invoke prompts via the prompt picker in VS Code
3. Prompts can include variables and context references

### In Cursor

1. Configure commands according to Cursor's conventions
2. Trigger via keyboard shortcuts or command palette
3. Commands can integrate with custom modes

## Customization

These commands are **starting points**, not prescriptive requirements:

- Adjust wording to match your team's style
- Add project-specific context or constraints
- Modify workflows to align with your processes
- Add technology-specific knowledge relevant to your stack
- Combine or chain commands for complex workflows
- Reference your project's specific rules or documentation

## Common Command Patterns

### Git Workflows

Commands that help with version control operations:

- **commit-workflow**: Guide through creating well-formatted commits
- **pr-creation**: Analyze changes and create PR with generated description
- **branch-management**: Create, switch, and manage branches with conventions

### Code Quality

Commands that assist with code review and improvement:

- **review-changes**: Review uncommitted changes with quality standards
- **analyze-complexity**: Identify complex code that needs refactoring

### Project Setup

Commands that bootstrap AI assistance in projects:

- **initialize-ai**: Set up AI tool configuration in a new or existing project
- **configure-rules**: Select and install rules from the rules library

## Cross-Tool Consistency

While implementation differs across tools, the commands library maintains conceptual consistency:

- **Same categories**: All tools have git-workflows, code-quality, project-setup
- **Same purposes**: Each command serves the same goal across tools
- **Aligned workflows**: The process and output should be similar regardless of tool
- **Common documentation**: Category READMEs provide universal guidance

This allows teams using different tools to share workflow patterns and best practices.

## Contributing

When adding or updating commands:

1. Create versions for all three tools (generic, copilot, cursor) when applicable
2. Follow each tool's specific format and conventions
3. Include clear descriptions of when to use vs. when not to use
4. Add cross-references to related rules or agents/modes from other libraries
5. Provide 2-3 example invocations with expected outcomes
6. Test the command in realistic project scenarios
7. Update the category README if adding new patterns
8. Keep tool versions conceptually aligned (same purpose, different implementation)

## Cross-References

Related libraries:

- **Agents**: `../agents/` - Claude Code/OpenCode specialized AI personas
- **Chat Modes**: `../chat-modes/` - Copilot/Cursor specialized AI configurations
- **Rules**: `../rules/` - Base and technology-specific instruction rules

## Version Information

**Last Updated**: 2025-10-14
**Toolkit Version**: Part of AE Toolkit best practices library

See `../` for other library components.
