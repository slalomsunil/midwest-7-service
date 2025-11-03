---
description: Create and manage branches with conventions
allowed-tools: Bash(git:*)
argument-hint: [work type] [description]
---

# Branch Management

Follow the appropriate workflow based on user's request:

## If User Wants to Create a New Branch

### Step 1: Determine Branch Name

If arguments are provided (`$ARGUMENTS`), use them to construct the branch name.
Otherwise, ask the user:
- What type of work? (feature, fix, docs, refactor, test, chore, hotfix)
- Brief description? (2-4 words, will be kebab-cased)

**Branch naming convention**:
```
<type>/<description-in-kebab-case>

Examples:
feature/user-authentication
fix/login-validation-bug
docs/api-documentation
refactor/payment-processing
hotfix/security-vulnerability
```

### Step 2: Verify Starting Point

1. Check current branch: `git branch --show-current`
2. Check for uncommitted changes: `git status`
3. If on main/master and no uncommitted changes, proceed
4. If uncommitted changes exist, offer to:
   - Commit them first (run `/commit-workflow`)
   - Stash them (`git stash`)
   - Create branch anyway (bring changes along)
5. If not on main/master, ask if user wants to:
   - Switch to main/master first
   - Branch from current location

### Step 3: Update Base Branch (Recommended)

If branching from main/master:
```bash
git checkout main  # or master
git pull origin main  # ensure latest changes
```

### Step 4: Create and Switch to New Branch

```bash
git checkout -b <type>/<description>
```

### Step 5: Confirm Success

Show:
- New branch name
- Base branch it was created from
- Current status
- Remind user to push branch when ready: `git push -u origin <branch-name>`

---

## If User Wants to Switch Branches

### Step 1: Check Current State

1. Run `git status` to see uncommitted changes
2. If uncommitted changes exist, offer to:
   - Commit them first
   - Stash them
   - Discard them (if user confirms)

### Step 2: Show Available Branches

List branches with:
```bash
git branch -a  # show all branches including remotes
```

### Step 3: Switch to Branch

If user specifies branch name:
```bash
git checkout <branch-name>
```

If branch exists on remote but not locally:
```bash
git checkout -b <branch-name> origin/<branch-name>
```

### Step 4: Confirm Success

Show:
- Current branch
- Recent commits: `git log --oneline -5`
- Status: `git status`

---

## If User Wants to Delete a Branch

### Step 1: Verify Safety

Ask user to confirm:
- Branch name to delete
- Whether it's been merged/no longer needed

### Step 2: Check Merge Status

```bash
git branch --merged  # show merged branches
```

### Step 3: Delete Branch

If branch is merged:
```bash
git branch -d <branch-name>  # safe delete
```

If branch is NOT merged but user confirms:
```bash
git branch -D <branch-name>  # force delete
```

### Step 4: Delete Remote Branch (if applicable)

If user wants to delete from remote too:
```bash
git push origin --delete <branch-name>
```

### Step 5: Confirm Success

Show:
- Which branch was deleted
- Whether remote was also deleted
- Current branch: `git branch --show-current`

---

## If User Wants to List Branches

Show branches with context:

```bash
git branch -vv  # show local branches with tracking info
```

Also show:
- Current branch (highlighted)
- Recent branches: `git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short) - %(committerdate:relative)' | head -10`
- Stale branches that might need cleanup

---

## General Guidelines

**Branch naming best practices**:
- Use lowercase with hyphens (kebab-case)
- Be descriptive but concise (2-5 words)
- Include ticket/issue number if applicable: `fix/issue-123-login-bug`
- Avoid special characters except hyphens and slashes

**Workflow tips**:
- Always branch from up-to-date main/master
- Keep branches focused on single feature/fix
- Delete branches after merging to keep repo clean
- Use descriptive names so others understand purpose

**When to create vs. switch**:
- Create new branch: Starting new work
- Switch to existing: Continuing work, reviewing someone's branch
- Delete branch: After PR is merged, abandoned work

---

**Notes**:
- Commands shown use standard Git syntax
- Customize branch naming convention to match your team's standards
- Consider using ticket numbers if your team tracks work in an issue system
