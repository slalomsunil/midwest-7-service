# Architecture

## Overview

Multi-feature development platform with modular architecture supporting innovative developer tools.

## Core Architecture

```
src/
├── core/
│   ├── app.tsx
│   ├── router.tsx
│   └── store/
├── shared/
│   ├── components/
│   ├── hooks/
│   └── utils/
├── features/
│   ├── time-travel-debug/
│   ├── ai-code-poet/
│   └── rubber-duck-simulator/
└── styles/
    └── global.css
```

## Feature Integration

Each feature is self-contained but integrates with the core system:

- **Time Travel Debug Mode**: Hooks into the development environment
- **AI Code Poet**: Integrates with code analysis pipeline
- **Rubber Duck Simulator**: Provides debugging assistance interface

## State Management

- Core state: Redux Toolkit for global application state
- Feature state: Local state management within feature boundaries
- Shared state: Context providers for cross-feature communication

## Communication Patterns

- Event-driven architecture for feature interactions
- Pub/sub pattern for loose coupling
- Shared services for common functionality

## Plugin System

Features are implemented as plugins that can be:
- Enabled/disabled at runtime
- Configured independently
- Extended with additional functionality