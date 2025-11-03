# Documentation Chat Modes

Chat modes in this category focus on creating and maintaining high-quality documentation for APIs, projects, and code.

## Available Chat Modes

### api-documenter
**Purpose**: Generate comprehensive API documentation with usage examples and error handling

**When to use**:
- Creating or updating API endpoint documentation
- Documenting library functions or SDK methods
- Writing integration guides for external developers
- Explaining authentication and authorization flows

**When NOT to use**:
- For general project documentation (use readme-generator instead)
- For inline code comments (use code-commenter instead)
- For architectural documentation (use standard documentation modes)

### readme-generator
**Purpose**: Create comprehensive project README files with setup instructions and contribution guidelines

**When to use**:
- Starting a new project that needs a README
- Updating outdated README for existing project
- Creating quick start guides for new developers
- Documenting installation and setup procedures

**When NOT to use**:
- For API reference documentation (use api-documenter instead)
- For detailed architectural docs (create separate docs)
- For inline code explanations (use code-commenter instead)

### code-commenter
**Purpose**: Add clear, helpful inline documentation for complex logic and non-obvious decisions

**When to use**:
- Documenting complex algorithms or business logic
- Explaining non-obvious workarounds or optimizations
- Adding context for edge cases and gotchas
- Clarifying why specific approaches were chosen

**When NOT to use**:
- For obvious, self-documenting code
- For API documentation (use api-documenter instead)
- When code should be refactored instead of commented
- For every single line (avoid over-commenting)

## Common Patterns

All documentation chat modes:

- Reference rules from `../../../rules/copilot/base/` for consistent standards
- Prioritize developer experience and clarity
- Include practical, working examples
- Keep documentation synchronized with code
- Balance completeness with readability

## Usage Examples

### API Documenter
1. Switch to api-documenter mode via mode selector
2. Ask: "Document the POST /api/users endpoint including authentication, validation, and error responses"
3. Mode provides comprehensive API documentation

### README Generator
1. Switch to readme-generator mode
2. Ask: "Create a README for this Express API project with PostgreSQL backend"
3. Mode generates complete README with quick start, installation, and usage

### Code Commenter
1. Switch to code-commenter mode
2. Ask: "Add comments explaining this complex sorting algorithm and why we use it instead of Array.sort()"
3. Mode adds appropriate inline comments without over-commenting

## Customization Tips

- **Documentation format**: Adapt for OpenAPI, Markdown, JSDoc, or language-specific formats
- **Audience**: Adjust technical level for your users (beginners vs. experts)
- **Examples**: Configure preferred example languages or frameworks
- **Style**: Match your organization's documentation standards
- **Tools**: Add `search` tool if modes should research documentation best practices

## Related Resources

- **Rules**: `../../../rules/copilot/base/` - Base documentation standards
- **Commands**: `../../../commands/copilot/documentation/` - Prompt files for specific workflows
- **Agents**: `../../../agents/documentation/` - Claude Code/OpenCode equivalents

## File Locations

To use these modes, copy `.chatmode.md` files to:

```
your-project/
└── .github/
    └── chatmodes/
        ├── api-documenter.chatmode.md
        ├── readme-generator.chatmode.md
        └── code-commenter.chatmode.md
```

## Version Information

**Last Updated**: 2025-10-14
**Toolkit Version**: Part of AE Toolkit best practices library
