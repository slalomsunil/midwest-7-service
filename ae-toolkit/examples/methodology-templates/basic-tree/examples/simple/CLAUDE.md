# CLAUDE.md

## What This File Is

This file provides guidance to [Claude Code](https://claude.ai/code) when working with this simple todo application. It serves as the entry point for AI agents to understand the project structure, behavioral expectations, and navigation patterns for discovering relevant documentation.

## Agent Rules

- Do what has been asked; nothing more, nothing less
- Take your time to understand the codebase before making changes
- Follow existing code patterns and conventions
- Always test changes before considering them complete
- Prefer editing existing files over creating new ones

## Project Overview

This is a basic todo application built with React and TypeScript. The app allows users to create, edit, complete, and delete todo items with a clean, intuitive interface.

## Directory Tree

```
simple-todo-app/
├── CLAUDE.md                  # This file
├── docs/                      # General project documentation
│   ├── development-guide.md   # Development setup and workflow
│   ├── architecture.md        # Project structure and design
│   └── testing.md             # Testing guidelines
├── src/                       # Main application source code
│   ├── components/            # React components
│   ├── styles/                # CSS and styling
│   ├── types/                 # TypeScript type definitions
│   └── App.tsx                # Main application component
├── package.json               # Project dependencies and scripts
└── README.md                  # Project setup and usage instructions
```

## Essential Reading

Start with `docs/` for general project information, then navigate to specific areas as needed based on your task:

1. `docs/development-guide.md` - Development setup and workflow
2. `docs/architecture.md` - Project structure and design decisions
3. `docs/testing.md` - Testing guidelines and practices