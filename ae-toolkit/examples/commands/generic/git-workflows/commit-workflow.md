---
description: Create a commit with conventional format
allowed-tools: Bash(git:*)
---

# Commit Workflow

Follow each step below in order:

## Step 1: Review Changes

Run these commands to understand what will be committed:
- `git status` to see staged and unstaged files
- `git diff --cached` to see staged changes (if any)
- `git diff` to see unstaged changes (if any)

## Step 2: Analyze Changes

Based on the diff output, determine:
- **Type of change**: feat (new feature), fix (bug fix), docs (documentation), refactor (code restructuring), test (add/update tests), chore (maintenance)
- **Scope**: Which component, module, or area is affected (optional but recommended)
- **Breaking changes**: Are there any breaking changes? (important for versioning)

## Step 3: Generate Commit Message

Create a commit message following conventional commit format:

```
<type>(<scope>): <short description>

<optional body with more details>

<optional footer with breaking changes or issue references>
```

**Guidelines**:
- Short description should be concise (<50 chars), lowercase, no period
- Body should explain WHAT changed and WHY (not how - that's in the code)
- Use present tense ("add feature" not "added feature")
- Reference issues if applicable (e.g., "Closes #123")

**Examples**:
```
feat(auth): add password reset functionality

fix(api): handle null response from user service

docs(readme): update installation instructions

refactor(utils): simplify date formatting logic
```

## Step 4: Create Commit

Once the commit message is drafted:
1. If there are unstaged changes that should be included, ask the user if they want to stage them first
2. If everything is ready, create the commit using the generated message
3. Use `git commit -m "message"` for simple commits or `git commit` with multi-line message if body/footer is needed

## Step 5: Confirm Success

After committing:
- Run `git log -1 --oneline` to show the commit that was just created
- Confirm the commit SHA and message
- Remind user they can push when ready with `git push`

---

**Notes**:
- If there are no changes to commit, inform the user
- If there are merge conflicts or other git issues, provide clear guidance on resolving them
- Don't push automatically - let the user decide when to push
