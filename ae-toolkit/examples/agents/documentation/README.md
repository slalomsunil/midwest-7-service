# Documentation Agents

Agents in this category focus on creating and maintaining high-quality documentation at various levels, from inline comments to comprehensive API documentation.

## Available Agents

### api-documenter
**Purpose**: Generate comprehensive API documentation including usage examples and edge cases

**When to use**:
- When creating new APIs or public interfaces
- To document existing APIs that lack documentation
- Before major releases to ensure API clarity
- When onboarding developers who will consume your API

**When NOT to use**:
- For internal implementation details (use code-commenter)
- For high-level architecture (use architecture agents)
- When auto-generated docs (OpenAPI, JSDoc) are sufficient

### readme-generator
**Purpose**: Create or improve project README files with setup, usage, and contribution guidance

**When to use**:
- Starting new projects
- When README is outdated or missing
- Before open-sourcing a project
- When onboarding becomes difficult due to poor documentation

**When NOT to use**:
- For API documentation (use api-documenter)
- For architectural decisions (use ADRs)
- When README just needs minor updates (edit directly)

### code-commenter
**Purpose**: Add inline documentation for complex code that isn't self-explanatory

**When to use**:
- For complex algorithms or business logic
- When code intent isn't obvious from reading
- For non-obvious edge case handling
- When documenting "why" something was done a certain way

**When NOT to use**:
- For self-explanatory code
- When better naming would eliminate need for comments
- For API documentation (use api-documenter)
- When code should be refactored instead of commented

## Common Patterns

All documentation agents:

- Write for the intended audience (developers, users, contributors)
- Keep documentation close to the code it describes
- Update documentation when code changes
- Provide examples that demonstrate usage
- Explain "why" not just "what"

## Usage Examples

### API Documenter
```
@api-documenter Generate API documentation for the UserService class.
Include authentication requirements, rate limits, and error responses.
```

### README Generator
```
@readme-generator Create a README for this Express API project.
It uses PostgreSQL, requires Node 18+, and has a Docker setup.
```

### Code Commenter
```
@code-commenter Add comments explaining this sorting algorithm.
It's not obvious why we're using this approach instead of the standard library.
```

## Documentation Best Practices

### API Documentation
- Document all public methods and interfaces
- Include parameter types and constraints
- Provide example requests and responses
- Document error conditions and codes
- Explain authentication and authorization
- Note any rate limits or quotas

### README Files
- Quick start that works in <5 minutes
- Clear prerequisites and dependencies
- Installation instructions that actually work
- Basic usage examples
- Link to detailed documentation
- Contribution guidelines
- License information

### Inline Comments
- Explain "why" not "what" (code shows what)
- Document non-obvious decisions
- Call out edge cases and gotchas
- Reference relevant tickets or discussions
- Keep comments close to code they describe
- Update comments when code changes

## Customization Tips

- **Audience**: Adjust documentation depth based on audience expertise
- **Format**: Use your team's documentation standards (JSDoc, XML docs, docstrings)
- **Tooling**: Configure for your documentation generators (TypeDoc, Sphinx, Swagger)
- **Examples**: Include examples relevant to your domain
- **Language**: Match your team's documentation style (formal vs. conversational)

## Related Resources

- **Rules**: `../../rules/base/code-quality.md` - Documentation standards
- **Commands**: `../../commands/generic/documentation/` - Documentation workflow commands
- **Chat Modes**: For Copilot/Cursor equivalents, see `../../chat-modes/`

## Contributing

When adding documentation agents:

- Include examples for different documentation types
- Show how to maintain documentation as code changes
- Provide templates for common documentation structures
- Address documentation for different audiences
- Demonstrate handling complex or unclear requirements
