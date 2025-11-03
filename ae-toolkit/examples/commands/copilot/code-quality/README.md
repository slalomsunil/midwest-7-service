# Code Quality Prompt Files

GitHub Copilot prompt files for code review, analysis, and quality improvement.

## Prompt Files

### review-changes.prompt.md
Review uncommitted changes against quality standards.
- **Mode**: `agent`
- **Tools**: `@terminal` for git diff, `@workspace` for context
- **Use**: Before committing code

### analyze-complexity.prompt.md
Identify complex code needing refactoring.
- **Mode**: `agent`
- **Tools**: `@workspace` for file analysis
- **Use**: Technical debt assessment, refactoring planning

## Usage with VS Code

Copilot integrates with VS Code features:
- **Problems panel**: See issues inline
- **Source Control**: View changes being reviewed
- **File Explorer**: Navigate to flagged files
- **Diff view**: Compare before/after

## Customization

Adapt commands for your team's quality standards by modifying frontmatter and prompt content to reference your specific coding guidelines and review checklists.

See `../../generic/code-quality/` for Claude Code equivalents.
