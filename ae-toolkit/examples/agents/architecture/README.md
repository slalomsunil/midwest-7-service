# Architecture Agents

Agents in this category focus on reviewing architectural decisions, analyzing system design, and assessing dependencies and coupling.

## Available Agents

### architecture-reviewer
**Purpose**: Review architectural decisions and provide feedback on system design

**When to use**:
- When designing new features or systems
- Before making significant architectural changes
- To validate proposed designs against best practices
- When refactoring system boundaries

**When NOT to use**:
- For code-level design (use code-reviewer)
- For immediate bug fixes
- When architecture is already well-established and stable

### dependency-analyzer
**Purpose**: Analyze dependencies, coupling, and module boundaries

**When to use**:
- When planning system modularization
- To identify circular dependencies
- Before extracting microservices or libraries
- When investigating tight coupling issues

**When NOT to use**:
- For package/library version management
- For code-level refactoring (use refactoring-advisor)
- When dependency structure is already clear

## Common Patterns

All architecture agents:

- Consider trade-offs and context, not just ideals
- Focus on maintainability and evolvability
- Identify coupling and cohesion issues
- Balance abstraction with simplicity
- Document architectural decisions

## Usage Examples

### Architecture Reviewer
```
@architecture-reviewer Review my design for the new notification system.
It uses a message queue to handle high volume and supports multiple channels.
```

### Dependency Analyzer
```
@dependency-analyzer Our frontend is tightly coupled to the API.
How can we improve the separation of concerns?
```

## Architecture Review Focus Areas

### System Design
- Component boundaries and responsibilities
- Communication patterns between components
- Data flow and state management
- Scalability and performance considerations
- Error handling and resilience

### Dependencies
- Dependency direction (high-level -> low-level)
- Circular dependencies
- Inappropriate coupling
- Missing abstractions
- External service dependencies

### Quality Attributes
- Maintainability and changeability
- Testability
- Scalability and performance
- Security and reliability
- Observability and monitoring

## Customization Tips

- **System type**: Adjust focus for monoliths vs. microservices vs. serverless
- **Scale**: Different concerns for small apps vs. high-scale systems
- **Domain**: Include industry-specific architectural patterns
- **Technology**: Consider technology-specific patterns and constraints
- **Team size**: Adapt complexity based on team's ability to maintain it

## Related Resources

- **Rules**: `../../rules/base/code-quality.md` - Design standards
- **Commands**: `../../commands/generic/architecture/` - Architecture workflow commands
- **Chat Modes**: For Copilot/Cursor equivalents, see `../../chat-modes/`

## Contributing

When adding architecture agents:

- Include examples for different architectural styles
- Show how to balance ideals with pragmatism
- Provide patterns for common architectural decisions
- Address trade-offs explicitly
- Include guidance for different system scales
