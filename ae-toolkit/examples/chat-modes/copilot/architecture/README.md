# Architecture Chat Modes

Chat modes in this category focus on reviewing architectural decisions, analyzing system design, and assessing dependencies and coupling.

## Available Chat Modes

### architecture-reviewer
**Purpose**: Review architectural decisions with focus on maintainability, scalability, and design trade-offs

**When to use**:
- When designing new features or systems
- Before making significant architectural changes
- To validate proposed designs against best practices
- When evaluating trade-offs in design decisions
- For feedback on component boundaries and responsibilities

**When NOT to use**:
- For code-level design (use code-reviewer)
- For immediate bug fixes
- When architecture is already well-established and stable
- For trivial implementation details

### dependency-analyzer
**Purpose**: Analyze dependencies, coupling, and module boundaries to improve system modularity

**When to use**:
- When planning system modularization
- To identify circular dependencies
- Before extracting microservices or libraries
- When investigating tight coupling issues
- To assess dependency direction and layering

**When NOT to use**:
- For package/library version management
- For code-level refactoring (use refactoring-advisor)
- When dependency structure is already clear
- For build or deployment dependency issues

## Common Patterns

All architecture chat modes:

- Consider trade-offs and context, not just ideals
- Focus on maintainability and evolvability
- Identify coupling and cohesion issues
- Balance abstraction with simplicity
- Document architectural decisions (ADRs)

## Usage Examples

### Architecture Reviewer
1. Switch to architecture-reviewer mode via mode selector
2. Ask: "Review my design for the new notification system using event-driven architecture with a message queue"
3. Mode provides structured review with strengths, concerns, recommendations, and trade-offs

### Dependency Analyzer
1. Switch to dependency-analyzer mode
2. Ask: "Analyze the dependencies in our frontend. We have circular dependencies causing build issues"
3. Mode identifies cycles, assesses coupling, and recommends specific improvements

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
- **Domain**: Include industry-specific architectural patterns (fintech, gaming, e-commerce)
- **Technology**: Consider technology-specific patterns and constraints
- **Team size**: Adapt complexity based on team's ability to maintain it
- **Decision documentation**: Integrate with team's ADR or RFC process

## Related Resources

- **Rules**: `../../../rules/copilot/base/` - Base design standards
- **Commands**: `../../../commands/copilot/architecture/` - Prompt files for specific workflows
- **Agents**: `../../../agents/architecture/` - Claude Code/OpenCode equivalents

## File Locations

To use these modes, copy `.chatmode.md` files to:

```
your-project/
└── .github/
    └── chatmodes/
        ├── architecture-reviewer.chatmode.md
        └── dependency-analyzer.chatmode.md
```

## Version Information

**Last Updated**: 2025-10-14
**Toolkit Version**: Part of AE Toolkit best practices library
