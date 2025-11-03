# Pull Request Creation

**Recommended Mode**: Agent Mode (for git and gh CLI access)

Analyze branch changes and create a pull request with generated description.

## Workflow

### Step 1: Verify Prerequisites

Check:
- Current branch: `git branch --show-current` (should not be main/master)
- Branch is pushed: `git status`
- GitHub CLI available: `gh --version`

If branch not pushed:
```bash
git push -u origin $(git branch --show-current)
```

### Step 2: Analyze Changes

Find base branch (usually main or master):
```bash
git remote show origin | grep "HEAD branch"
```

Get change context:
- `git log main..HEAD --oneline` - All commits in this branch
- `git diff main...HEAD --stat` - File changes summary

Use @code to understand the full context of changes in the project.

### Step 3: Generate PR Description

Create description in this format:

```markdown
## Summary
[2-3 sentences explaining what this PR does and why it's needed]

## Changes
- [Bullet for each significant change or feature]
- [Include file references when helpful]
- [Focus on WHAT changed, not implementation details]

## Test Plan
- [ ] [How to verify the changes work]
- [ ] [Steps to test the feature/fix]
- [ ] [Automated tests added/updated]

## Related Issues
[Closes #123, Fixes #456, Related to #789]
```

### Step 4: Determine PR Title

Create a concise title (50-70 chars) that summarizes the changes:
- If single commit, use that commit message
- If multiple commits, create unified title covering all changes
- Use conventional commit format: `feat: Add user authentication`

### Step 5: Create PR

Use GitHub CLI to create the PR:
```bash
gh pr create --title "PR Title Here" --body "Full description here"
```

### Step 6: Confirm

Show the PR URL returned by gh CLI.

Remind user to:
- Add reviewers if not auto-assigned
- Check that CI/CD passes
- Link related issues manually if needed
- Respond to review feedback when ready
