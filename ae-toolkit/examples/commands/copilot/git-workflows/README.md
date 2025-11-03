# Git Workflow Prompt Files

This directory contains GitHub Copilot prompt files for common git operations and workflows. These commands help maintain consistency in commit messages, PR descriptions, and branch management.

## Prompt Files in This Category

### commit-workflow.prompt.md

**Purpose**: Guide through creating well-formatted commits following conventional commit standards.

**Mode**: `agent` - Multi-step workflow requiring analysis and generation

**Tools**: `@terminal` for git operations, `@workspace` for context

**When to use**:
- Creating commits after making code changes
- Need help writing clear, conventional commit messages
- Want consistent commit formatting across the team

**Example invocation**:
```
/commit-workflow
```

---

### pr-creation.prompt.md

**Purpose**: Analyze changes in the current branch and create a pull request with a well-structured description.

**Mode**: `agent` - Complex workflow involving git analysis and PR creation

**Tools**: `@terminal` for git operations, `@workspace` for change analysis

**When to use**:
- Ready to create a PR for your feature branch
- Need help summarizing branch changes into a PR description
- Want consistent PR formatting

**Example invocation**:
```
/pr-creation
```

---

### branch-management.prompt.md

**Purpose**: Create, switch, and manage branches following naming conventions.

**Mode**: `agent` - Interactive workflow for branch operations

**Tools**: `@terminal` for git commands

**When to use**:
- Starting work on a new feature or bug fix
- Need help with branch naming conventions
- Want consistent branch management across the team

**Example invocation**:
```
/branch-management
```

---

## Differences from Generic Commands

Copilot prompt files differ from Claude Code slash commands:

| Aspect | Copilot Prompt Files | Generic Slash Commands |
|--------|---------------------|----------------------|
| Git execution | Via @terminal participant | Direct `` !`git command` `` |
| Context | @workspace for full project | `@file/path` references |
| Output format | Integrated with VS Code UI | Text-based responses |
| User interaction | VS Code input prompts | Chat-based Q&A |

## Usage Tips

### Before Running Commands

**Commit Workflow**:
- Stage your changes with `git add` or VS Code source control
- Review changes in VS Code diff view
- Ensure changes represent a single logical unit

**PR Creation**:
- Commit and push all changes to your branch
- Run tests and verify build passes
- Check that branch is up-to-date with main/master

**Branch Management**:
- Commit or stash any uncommitted changes
- Know what type of work you're starting (feature, fix, etc.)
- Be on the base branch (main/master) for new branches

### Leveraging VS Code Integration

Copilot commands integrate with VS Code features:

- **Source Control panel**: See git status visually
- **Git Graph extensions**: Visualize branch structure
- **Terminal integration**: See command output inline
- **Quick Pick prompts**: Select from options interactively

### Combining with Chat Modes

For extended git workflows, consider combining with chat modes:

1. Use `/branch-management` to create a branch
2. Work on your feature with normal coding
3. Use `/commit-workflow` for individual commits
4. Switch to a `code-reviewer` chat mode for pre-PR review
5. Use `/pr-creation` to create the PR

## Customization Examples

### Organization-Specific Commit Format

Modify `commit-workflow.prompt.md`:

```markdown
---
description: Create commit with our team's format
mode: agent
tools:
  - terminal
  - workspace
---

# Commit Workflow

Use @terminal to check git status and diff.

Generate a commit message in our format:
[TICKET-123] Type: Description

Body:
- Change details
- Impact notes

Include ticket number from branch name if present.
```

### PR Template Integration

Modify `pr-creation.prompt.md` to use your GitHub PR template:

```markdown
---
description: Create PR using team template
mode: agent
tools:
  - terminal
  - workspace
---

# PR Creation

Analyze changes using @terminal git commands and @workspace context.

Generate PR description matching our template:

## Summary
[High-level overview]

## Changes
- [Specific changes]

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests pass
- [ ] Manual testing completed

## Screenshots
(if applicable)

## Deployment Notes
(if applicable)
```

### Interactive Branch Naming

Modify `branch-management.prompt.md` for interactive selection:

```markdown
---
description: Create branch interactively
mode: agent
tools:
  - terminal
---

# Branch Management

Ask user to choose:
1. Work type: feature / fix / docs / refactor / hotfix
2. Brief description (2-4 words)

Use @terminal to create branch: <type>/<description-in-kebab-case>

If ticket tracking is used, ask for ticket number:
<type>/<ticket>-<description>
```

## Integration with Copilot Instructions

These commands work best when combined with project-level instructions:

**`.github/copilot-instructions.md`**:
```markdown
# Git Workflow Standards

## Commits
- Follow conventional commit format
- Keep commits focused and atomic
- Write clear, descriptive messages

## Branches
- Use kebab-case naming
- Include ticket numbers when applicable
- Create from up-to-date main/master

## Pull Requests
- Provide clear summary of changes
- Include testing information
- Link related issues
```

The prompt files will follow these standards automatically.

## Common Issues

### @terminal Not Working

**Cause**: Terminal participant not enabled or not working in Copilot

**Solution**:
- Ensure Copilot Chat has terminal access enabled
- Try running git commands directly in VS Code terminal first
- Use VS Code's built-in source control as fallback

### Command Creates Incorrect Commit

**Cause**: Command doesn't understand staging area state

**Solution**:
- Explicitly stage changes before running `/commit-workflow`
- Use VS Code source control panel to verify staged changes
- Run `git status` manually to check state

### PR Creation Fails

**Possible causes**:
- GitHub CLI not installed or authenticated
- Branch not pushed to remote
- No changes relative to base branch

**Solutions**:
- Install GitHub CLI: `gh auth login`
- Push branch: `git push -u origin branch-name`
- Verify changes exist: `git log origin/main..HEAD`

## Version Information

**Last Updated**: 2025-10-14
**Toolkit Version**: Part of AE Toolkit best practices library

See `../../generic/git-workflows/` for Claude Code equivalents.
