---
applyTo: "**/*"
---

# Code Quality Instructions

**Tool:** GitHub Copilot
**Version:** 2025-01
**Category:** Base Rules
**Related:** See `../generic/code-quality.md` for generic version, `../cursor/` for Cursor version

> This file follows GitHub Copilot's custom instructions format and can be placed in `.github/instructions/` for path-specific instructions or incorporated into `.github/copilot-instructions.md` for repository-wide instructions.

---

Always prefer editing existing files over creating new ones. Only suggest new files when implementing genuinely new features, creating required test files, or adding necessary configuration files.

Never create documentation files unless explicitly requested.

Generate code that handles edge cases and error conditions. Include null/undefined checks where appropriate.

Use clear, descriptive names for variables, functions, and classes. Keep functions focused on single responsibilities.

Match existing code patterns in the project. Follow the same naming conventions, error handling patterns, and architectural decisions already in use.

Avoid deep nesting in generated code. Prefer early returns and guard clauses.

Extract complex logic into well-named helper functions rather than inline complexity.

Remove unused code and imports from suggestions.

Don't prematurely optimize. Address obvious performance issues like N+1 queries or unnecessary loops, but don't sacrifice readability for minor gains.

When suggesting tests, ensure they are focused, independent, readable, fast, and deterministic. Avoid tests that depend on external services without mocking or modify global state.

Suggest tests for new features, bug fixes, complex logic, public APIs, and critical paths. Don't automatically generate tests for trivial getters/setters.

Add documentation for public APIs, complex algorithms, non-obvious implementation choices, and workarounds. Skip documentation that restates obvious code.

Follow the project's existing style guide. Use automated formatters when available.

Never include trailing spaces or tabs in blank lines.

Handle errors at the appropriate level. Provide useful error messages. Don't swallow errors silently. Validate inputs early and fail fast for invalid state.

Never include secrets, API keys, or credentials in generated code. Validate and sanitize user input. Use parameterized queries to prevent SQL injection.

When refactoring, make small incremental changes. Don't mix refactoring with feature work.
