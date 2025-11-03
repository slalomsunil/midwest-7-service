# Architecture

## Overview

Simple React application with component-based architecture.

## Key Components

- `App.tsx` - Main application component
- `TodoList.tsx` - Manages todo items display and interactions
- `TodoItem.tsx` - Individual todo item component
- `AddTodo.tsx` - Form for adding new todos

## State Management

Uses React's built-in `useState` and `useReducer` hooks for state management.

## Data Flow

1. User interactions trigger events in components
2. Events update local state
3. State changes trigger re-renders
4. Components reflect updated state

## File Structure

```
src/
├── components/
│   ├── TodoList.tsx
│   ├── TodoItem.tsx
│   └── AddTodo.tsx
├── styles/
│   └── main.css
├── types/
│   └── todo.ts
└── App.tsx
```