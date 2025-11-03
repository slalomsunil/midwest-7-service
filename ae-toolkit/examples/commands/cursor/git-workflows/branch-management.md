# Branch Management

**Recommended Mode**: Agent Mode (for git access)

Create, switch, and manage branches following naming conventions.

## Determine User's Need

Ask what the user wants to do:
1. Create a new branch
2. Switch to an existing branch
3. Delete a branch
4. List branches

## Creating a New Branch

### Get Information

Ask user:
- **Work type**: feature, fix, docs, refactor, test, chore, or hotfix
- **Brief description**: 2-4 words (will be converted to kebab-case)

**Branch naming convention**: `<type>/<description-in-kebab-case>`

Examples:
- `feature/user-authentication`
- `fix/login-validation-bug`
- `docs/api-documentation`
- `refactor/payment-processing`
- `hotfix/security-vulnerability`

### Check Current State

Run these commands:
- `git branch --show-current` - See current branch
- `git status` - Check for uncommitted changes

If uncommitted changes exist, offer to:
- Commit them first
- Stash them: `git stash`
- Bring them along to new branch

### Create Branch from Updated Base

```bash
git checkout main  # or master
git pull origin main
git checkout -b <type>/<description>
```

### Confirm

Show new branch name and remind user to push when ready:
```bash
git push -u origin <branch-name>
```

## Switching to Existing Branch

### Check for Uncommitted Changes

Run `git status`. If changes exist, offer to: commit, stash, or discard.

### List Available Branches

Show all branches:
```bash
git branch -a
```

### Switch

For local branch:
```bash
git checkout <branch-name>
```

For remote-only branch:
```bash
git checkout -b <branch-name> origin/<branch-name>
```

### Confirm

Show current branch and recent commits:
```bash
git log --oneline -5
```

## Deleting a Branch

### Safety Check

Verify branch is merged:
```bash
git branch --merged
```

Ask user to confirm the branch name and that it's safe to delete.

### Delete Local Branch

If merged:
```bash
git branch -d <branch-name>
```

If NOT merged but user confirms:
```bash
git branch -D <branch-name>
```

### Delete Remote Branch (Optional)

If user wants to delete from remote:
```bash
git push origin --delete <branch-name>
```

### Confirm

Show current branch and confirm deletion.

## Listing Branches

Show branches with details:
```bash
git branch -vv
```

Show recent branches:
```bash
git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short) - %(committerdate:relative)' | head -10
```
