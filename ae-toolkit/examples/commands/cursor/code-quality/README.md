# Code Quality Commands

Cursor commands for code review, analysis, and quality improvement.

## Commands

### review-changes.md
Review uncommitted changes against quality standards.
- **Best Mode**: Ask Mode (read-only) or Agent Mode (with fixes)
- **Use**: Before committing code

### analyze-complexity.md
Identify complex code needing refactoring.
- **Best Mode**: Ask Mode (analysis) or Agent Mode (with refactoring)
- **Use**: Technical debt assessment, refactoring planning

## Cursor Features

Commands leverage:
- **@code context**: Full codebase awareness
- **Semantic search**: Find patterns across project
- **Inline edits (Cmd+K)**: Quick fixes identified during review

## Customization

Modify commands to reference your team's specific quality standards, complexity thresholds, and review checklists.

See `../../generic/code-quality/` for Claude Code equivalents.
