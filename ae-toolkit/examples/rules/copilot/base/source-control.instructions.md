---
applyTo: "**/*"
---

# Source Control Instructions

**Tool:** GitHub Copilot
**Version:** 2025-01
**Category:** Base Rules
**Related:** See `../generic/source-control.md` for generic version, `../cursor/` for Cursor version

> This file follows GitHub Copilot's custom instructions format and can be placed in `.github/instructions/` for path-specific instructions or incorporated into `.github/copilot-instructions.md` for repository-wide instructions.

---

When generating commit messages, use this structure: brief summary line (under 72 characters) in imperative mood, optional detailed explanation focusing on "why" not "what", and references to related issues.

Example commit message format:
```
Add user authentication middleware

Verify JWT tokens on protected routes and extract user
information to attach to request context.

Fixes #123
```

Start commit summaries with imperative verbs: "Add feature" not "Added feature" or "Adds feature."

In the commit body, explain why the change was made and include context not visible from the diff. Reference related issues or tickets.

Never suggest committing files that contain secrets, API keys, credentials, .env files with sensitive data, build artifacts, dependency directories (node_modules, vendor), or log files.

Suggest descriptive branch names like `feature/user-authentication`, `fix/login-timeout`, or `refactor/database-layer`. Avoid generic names like `temp`, `test`, or `new-branch`.

When generating PR descriptions, include: summary of changes, why changes were made, how to test the changes, breaking changes or migration notes, and related issues.

When generating code that uses Git APIs, include safety checks: verify clean working directory before operations, check branch existence, and validate state before destructive operations.

In .gitignore suggestions, always include: dependencies (node_modules/, vendor/), build outputs (dist/, build/), environment files (.env, .env.local), IDE files (.vscode/, .idea/), OS files (.DS_Store, Thumbs.db), logs (*.log), and test coverage (coverage/).

Never generate code that updates git config, runs destructive git commands (force push, hard reset) without explicit safety checks, or skips git hooks unless specifically required.

When generating git workflow code, add comments explaining non-obvious safety measures or timing considerations, not obvious operations like "create branch."
