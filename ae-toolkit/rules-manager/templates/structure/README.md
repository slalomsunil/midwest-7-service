# Structure Templates

These templates define the overall architecture and organization patterns for the modular rules system.

## Templates

- `ROUTER.template.md` - Main routing logic that determines which rules apply based on context
- `PROJECT_CONTEXT.template.md` - Project-specific customization template with routing integration

## Router System

The router serves as the central coordinator that:

- **Detects context** based on file types, project structure, and user intent
- **Composes rule sets** by combining base, SDLC, technology, and user preference rules
- **Provides consistency** across different AI tools and development scenarios
- **Enables modularity** by loading only relevant rules for each situation

## Project Context Integration

The project context template shows how to:

- **Customize routing logic** for your specific project patterns
- **Define technology mappings** based on your tech stack
- **Set SDLC triggers** based on your development workflow
- **Document project-specific conventions** that affect rule application

## Implementation Notes

These structural templates form the foundation of the rules system and should be implemented first, before customizing content templates or setting up tool adapters.
