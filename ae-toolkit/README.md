# AE Toolkit

A collection of tools for practicing AI-accelerated engineering in your projects. Each tool addresses specific aspects of setting up, maintaining, and optimizing AI development practices on your team.

### What this is
A foundational set of tools to help you get started with AI development, designed for easy adaptation to your specific project needs.

### What this is not
A one-size-fits-all solution or a tool you'll use unchanged forever. Expect to customize and extend it as your project evolves.

## How to use

**New to AE?** Start with the [Getting Started Guide](./getting-started/README.md) to understand which tools to use for your specific situation.

1. **Choose the right tool** from the Available Tools section below based on your needs
2. **Follow each tool's README** for specific usage instructions
3. **Adapt and extend** the outputs as needed for your workflow

> Start with the appropriate tool, adapt as you go, and customize for your specific context.

## Available Tools

### [AI Initializer](./ai-initializer/README.md)
Transform your existing project for AI development with structured assessment and customized implementation. Best for teams setting up AI development infrastructure for the first time.

### [Context Refresher](./context-refresher/README.md) 
Keep your AI context documentation current by analyzing git history to identify what has changed since your documentation was last updated. Best for maintaining existing AI setups.

### [Rules Manager](./rules-manager/README.md)
Deploy modular, router-based rules across different AI development tools with intelligent context detection and tool-specific adaptations. Best for teams managing consistent AI behavior across multiple tools.

### [Scratch Management Utilities](./scratch-management-utilities/README.md)
Maintain context across multiple AI chat sessions with structured memory management and seamless handoffs. Best for complex work that spans multiple conversations.

### [Interaction Analyzer](./interaction-analyzer/README.md)
A diagnostic tool that helps teams understand why their AI interactions are inefficient by analyzing AI-human interactions in the context of your project's documentation infrastructure.

### [Examples Collection](./examples/README.md)
Example methodologies, projects, and best practice libraries (rules, agents, chat modes, commands) provided for reference. Includes ready-to-use artifacts for all major AI development tools.

## Prerequisites

**Required:** Any AI coding assistant (Claude, Copilot, Cursor, etc.)

## Toolkit Structure

```
ae-toolkit/
├── ai-initializer/              # Transform existing projects for AI development
├── context-refresher/           # Keep AI context documentation current
├── examples/                    # Example methodologies, projects, and best practice libraries
│   ├── agents/                  # Pre-built agent definitions (Claude Code/OpenCode)
│   ├── chat-modes/              # Custom chat modes (Copilot/Cursor)
│   ├── commands/                # Reusable command templates (all tools)
│   ├── methodology-templates/   # File-based methodology templates
│   ├── projects/                # Example projects demonstrating AI concepts
│   └── rules/                   # Curated rules library (all tools)
├── getting-started/             # Guide for choosing the right toolkit modules
├── interaction-analyzer/        # Diagnose and optimize AI-human interactions
├── rules-manager/               # Deploy modular rules across AI development tools
├── scratch-management-utilities/# Maintain context across multiple AI chat sessions
├── GLOSSARY.md                  # Key terminology
└── README.md                    # This file
```

For additional resources and terminology, see the [GLOSSARY.md](./GLOSSARY.md).
