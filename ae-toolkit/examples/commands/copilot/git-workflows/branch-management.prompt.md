---
description: Create and manage branches with conventions
mode: agent
tools:
  - terminal
---

# Branch Management

Determine what the user wants to do:

## Creating a New Branch

Ask user:
- Work type? (feature, fix, docs, refactor, test, chore, hotfix)
- Brief description? (2-4 words, will be kebab-cased)

**Branch naming**: `<type>/<description-in-kebab-case>`

Check current state using @terminal:
- `git branch --show-current`
- `git status`

If uncommitted changes, offer to: commit, stash, or bring them along.

Create branch from updated main/master:
```bash
git checkout main
git pull origin main
git checkout -b <type>/<description>
```

## Switching Branches

Check for uncommitted changes: `git status`

List available branches: `git branch -a`

Switch to branch:
```bash
git checkout <branch-name>
```

If branch is remote-only:
```bash
git checkout -b <branch-name> origin/<branch-name>
```

## Deleting a Branch

Verify branch is merged: `git branch --merged`

Delete local branch:
```bash
git branch -d <branch-name>  # Safe delete
git branch -D <branch-name>  # Force delete (if unmerged)
```

Delete remote branch:
```bash
git push origin --delete <branch-name>
```

## Listing Branches

Show branches with details:
```bash
git branch -vv
```

Show recent branches:
```bash
git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short) - %(committerdate:relative)' | head -10
```
