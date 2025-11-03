# Development Guide

## Setup

1. Install dependencies: `npm install`
2. Start development server: `npm run dev`
3. Run tests: `npm test`
4. Start feature servers: `npm run start:features`

## Code Style

- Use TypeScript for all new code
- Follow existing naming conventions
- Use functional components with hooks
- Keep components small and focused
- Document complex algorithms and business logic

## Common Tasks

- Adding new core features: Modify `src/core/` files
- Feature-specific changes: Work in respective feature directories
- Styling changes: Update `src/styles/` files
- Adding tests: Create files in appropriate `__tests__/` directories

## Feature Development

Each feature has its own documentation structure:

- `time-travel-debug/docs/` - Debug mode implementation details
- `ai-code-poet/docs/` - AI poetry generation architecture
- `rubber-duck-simulator/docs/` - Debugging assistant implementation

## Build Process

- Development build: `npm run build:dev`
- Production build: `npm run build`
- Feature builds: `npm run build:features`
- Linting: `npm run lint`
- Type checking: `npm run type-check`