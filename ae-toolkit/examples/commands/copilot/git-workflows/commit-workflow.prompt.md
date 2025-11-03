---
description: Create a commit with conventional format
mode: agent
tools:
  - terminal
  - workspace
---

# Commit Workflow

Follow these steps in order to create a well-formatted commit:

## Step 1: Review Changes

Use @terminal to run:
- `git status` - See staged and unstaged files
- `git diff --cached` - See staged changes
- `git diff` - See unstaged changes

Analyze the output to understand what will be committed.

## Step 2: Determine Commit Type

Based on the changes, identify:
- **Type**: feat, fix, docs, refactor, test, or chore
- **Scope**: Component or module affected (optional but recommended)
- **Breaking changes**: Any breaking changes? (important)

## Step 3: Generate Commit Message

Create a conventional commit message:

```
<type>(<scope>): <short description>

<optional body explaining what and why>

<optional footer with breaking changes or issue references>
```

**Guidelines**:
- Short description: <50 chars, lowercase, no period
- Body: Explain WHAT changed and WHY (not how)
- Use present tense ("add feature" not "added feature")
- Reference issues: "Closes #123"

## Step 4: Create Commit

If unstaged changes should be included, ask user to stage them first.

Once ready, create the commit using @terminal:
```bash
git commit -m "type(scope): description"
```

For multi-line messages, use:
```bash
git commit -m "type(scope): description" -m "Body text here"
```

## Step 5: Confirm Success

Use @terminal to verify:
```bash
git log -1 --oneline
```

Show the commit SHA and message. Remind user they can push with `git push`.
