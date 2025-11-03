---
applyTo: "**/*"
---

# Collaboration Instructions

**Tool:** GitHub Copilot
**Version:** 2025-01
**Category:** Base Rules
**Related:** See `../generic/collaboration.md` for generic version, `../cursor/` for Cursor version

> This file follows GitHub Copilot's custom instructions format and can be placed in `.github/instructions/` for path-specific instructions or incorporated into `.github/copilot-instructions.md` for repository-wide instructions.

---

Generate code that communicates intent clearly for the next developer who will read it. Use meaningful names that reveal purpose.

Structure generated code to highlight important logic. Extract complex expressions into well-named functions.

Add comments for surprising or unintuitive code, but not for obvious operations.

When generating code, match existing patterns in the project: follow the same code structure and organization, use the same naming conventions, follow the same error handling patterns, and align with established architectural decisions.

Don't introduce new patterns, libraries, or architectural approaches without discussion. Consistency with existing codebase is more valuable than introducing "better" patterns.

Write code that is easy to review: keep changes focused and scoped, ensure generated code works correctly before suggesting, and include appropriate tests.

When generating documentation, write for the team: include architecture decisions and rationale, document non-obvious dependencies or constraints, explain workarounds and why they're necessary, and note future improvements or tech debt.

For shared code and APIs, prioritize clarity and maintainability over cleverness or brevity.

When generating error handling code, provide error messages that include enough context for debugging.

In generated code comments, reference related documentation, issues, or discussions when adding workarounds or non-standard implementations.

Generate code that is testable: avoid tight coupling to external services, use dependency injection patterns, keep functions pure when possible, and separate business logic from infrastructure concerns.

When suggesting code that affects multiple team members or system boundaries, add comments explaining the impact and considerations.
