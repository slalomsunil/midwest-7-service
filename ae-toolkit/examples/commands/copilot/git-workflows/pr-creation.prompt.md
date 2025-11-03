---
description: Create a PR with generated description
mode: agent
tools:
  - terminal
  - workspace
---

# Pull Request Creation

## Step 1: Verify Prerequisites

Use @terminal to check:
- Current branch: `git branch --show-current`
- Branch is pushed: `git status`
- GitHub CLI available: `gh --version`

If branch not pushed: `git push -u origin $(git branch --show-current)`

## Step 2: Analyze Changes

Determine base branch (usually main/master):
```bash
git remote show origin | grep "HEAD branch"
```

Get change context:
- `git log main..HEAD --oneline` - All commits in branch
- `git diff main...HEAD --stat` - File changes summary

Use @workspace to understand the full context of changes.

## Step 3: Generate PR Description

Create description in this format:

```markdown
## Summary
[2-3 sentences explaining what this PR does and why]

## Changes
- [Bullet for each significant change]
- [Include file references when helpful]

## Test Plan
- [ ] [How to verify the changes work]
- [ ] [Steps to test]
- [ ] [Automated tests added/updated]

## Related Issues
[Closes #123, Fixes #456]
```

## Step 4: Create PR

Determine concise title (50-70 chars) covering all changes.

Use @terminal to create PR:
```bash
gh pr create --title "PR Title" --body "Description here"
```

## Step 5: Confirm

Show PR URL and remind user to:
- Add reviewers if not auto-assigned
- Check CI/CD passes
- Link issues if needed
