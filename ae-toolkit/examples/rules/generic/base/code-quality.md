# Code Quality

<!-- Rule Metadata -->
**Tool:** Claude Code, OpenCode
**Version:** 2025-01
**Category:** Base Rules
**Related:** See `./copilot/code-quality.md` for GitHub Copilot version, `./cursor/code-quality.md` for Cursor version

## Purpose

Establish standards for code quality, testing, and review practices that ensure maintainable, reliable, and well-documented code.

## Core Principles

### Prefer Editing Over Creating

- **ALWAYS** prefer editing existing files to creating new ones
- **NEVER** create files unless absolutely necessary for achieving the goal
- This includes documentation files, README files, and markdown files
- Only create new files when:
  - Implementing genuinely new features or modules
  - User explicitly requests file creation
  - Test files are needed for new functionality
  - Configuration files are required for new tooling

### Code Review Standards

When reviewing or writing code:

**Correctness**
- Verify logic handles edge cases and error conditions
- Check for off-by-one errors, null/undefined handling
- Ensure type safety (in typed languages)
- Validate input and output contracts

**Maintainability**
- Use clear, descriptive names for variables, functions, and classes
- Keep functions focused on single responsibilities
- Avoid deep nesting (prefer early returns, guard clauses)
- Extract complex logic into well-named helper functions
- Remove dead code and unused imports

**Consistency**
- Follow existing code patterns in the project
- Match the indentation, naming, and formatting conventions already in use
- Use the same error handling patterns as the rest of the codebase
- Align with established architectural patterns

**Performance**
- Avoid premature optimization
- Address obvious performance issues (e.g., N+1 queries, unnecessary loops)
- Consider algorithmic complexity for data-intensive operations
- Don't sacrifice readability for minor performance gains

## Testing Standards

### When to Write Tests

Write tests for:
- New features and functionality
- Bug fixes (test should fail before fix, pass after)
- Complex business logic
- Public APIs and interfaces
- Critical paths (authentication, payment, data integrity)

Don't automatically write tests for:
- Trivial getters/setters
- Simple configuration files
- Prototypes or spike work (unless requested)

### Test Quality

Good tests are:
- **Focused** - Test one thing at a time
- **Independent** - Can run in any order
- **Readable** - Clear what's being tested and why
- **Fast** - Run quickly to encourage frequent execution
- **Deterministic** - Same input always produces same output

Avoid:
- Tests that depend on external services without mocking
- Tests that modify global state
- Tests that are fragile to implementation details
- Tests that serve as documentation better than actual tests

### Test Coverage

- Aim for high coverage of critical paths
- Don't chase 100% coverage at the expense of test quality
- Focus on meaningful tests over coverage metrics
- Use coverage reports to identify untested critical code

## Documentation Standards

### When to Document

Document:
- Public APIs and interfaces
- Complex algorithms or non-obvious logic
- "Why" something is done a certain way (when not obvious)
- Workarounds for known issues or limitations
- Configuration and setup requirements

Don't document:
- Obvious code that's self-explanatory
- Implementation details that are clear from the code
- Redundant information already in the code

### Documentation Quality

Good documentation:
- Explains WHY, not just WHAT
- Provides usage examples for non-trivial code
- Stays close to the code it documents
- Is maintained when code changes

Avoid:
- Comments that restate the code
- Obsolete comments that don't match current code
- Large comment blocks that should be documentation
- Using comments to hide bad code (refactor instead)

## Formatting and Style

### General Guidelines

- Follow the project's existing style guide
- Use automated formatters when available (Prettier, Black, gofmt, etc.)
- Be consistent with spacing, indentation, and line breaks
- Keep line length reasonable (typically 80-120 characters)

### Blank Lines

When creating blank lines:
- **NEVER** include trailing spaces or tabs
- Use blank lines to separate logical sections
- Don't use excessive blank lines (usually 1 is enough)

### Language-Specific Conventions

Follow established conventions for the language:
- TypeScript/JavaScript: semicolons, const/let, async/await patterns
- Python: PEP 8 style, type hints, docstrings
- C#: naming conventions, using statements, async patterns
- Go: gofmt, error handling, defer patterns

## Error Handling

### Best Practices

- Handle errors at the appropriate level
- Provide useful error messages for debugging
- Don't swallow errors silently
- Log errors with sufficient context
- Validate inputs early
- Fail fast when encountering invalid state

### Anti-Patterns to Avoid

- Empty catch blocks
- Catching generic exceptions when specific ones are appropriate
- Using exceptions for control flow
- Returning error codes in languages with exceptions
- Ignoring returned errors (in languages like Go)

## Security Considerations

### Basic Security Hygiene

- Never commit secrets, API keys, or credentials
- Validate and sanitize user input
- Use parameterized queries to prevent SQL injection
- Escape output to prevent XSS
- Use HTTPS for sensitive data transmission
- Follow principle of least privilege

### Security Review Triggers

Flag for additional review when code:
- Handles authentication or authorization
- Processes sensitive user data
- Performs cryptographic operations
- Constructs dynamic queries
- Accepts file uploads
- Makes external API calls with user-controlled input

## Refactoring Guidelines

### When to Refactor

Refactor when:
- Adding new functionality reveals poor abstractions
- Code is difficult to understand or modify
- Duplicated logic appears in multiple places
- Functions or files have grown too large
- Tests are difficult to write or maintain

### Safe Refactoring

- Make small, incremental changes
- Keep tests passing (green → green refactoring)
- Don't mix refactoring with feature work
- Use automated refactoring tools when available
- Review diffs carefully to catch unintended changes

## Integration with Other Rules

Code quality intersects with:
- **Session Management** - Plan time for testing and review
- **Source Control** - Commit clean, working code
- **Collaboration** - Write code others can understand
- **Technology-Specific Rules** - Apply language-specific best practices

## Customization Notes

Teams may want to adjust:
- Test coverage requirements
- Documentation verbosity preferences
- Specific style guide choices
- Performance optimization thresholds
- Security review processes
