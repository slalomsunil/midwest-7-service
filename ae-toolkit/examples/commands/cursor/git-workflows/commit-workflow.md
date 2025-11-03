# Commit Workflow

**Recommended Mode**: Agent Mode (for terminal access)

Create a well-formatted conventional commit.

## Workflow

### Step 1: Review Changes

Check what will be committed:
- Run `git status` to see staged and unstaged files
- Run `git diff --cached` for staged changes
- Run `git diff` for unstaged changes

### Step 2: Analyze Changes

Use @code context to understand the full impact of changes.

Determine:
- **Type**: feat, fix, docs, refactor, test, or chore
- **Scope**: Component or module affected (optional)
- **Breaking changes**: Any breaking changes? (important)

### Step 3: Generate Commit Message

Create a conventional commit message:

```
<type>(<scope>): <short description>

<optional body explaining what and why>

<optional footer with breaking changes or issue references>
```

**Guidelines**:
- Short description: <50 chars, lowercase, no period
- Body: Explain WHAT changed and WHY (not how)
- Use present tense: "add feature" not "added feature"
- Reference issues: "Closes #123" if applicable

**Examples**:
```
feat(auth): add password reset functionality
fix(api): handle null response from user service
docs(readme): update installation instructions
refactor(utils): simplify date formatting logic
```

### Step 4: Create Commit

If unstaged changes should be included, stage them first with `git add`.

Create the commit:
```bash
git commit -m "type(scope): description"
```

For multi-line messages:
```bash
git commit -m "type(scope): description" -m "Body here" -m "Footer here"
```

### Step 5: Verify

Confirm the commit was created successfully:
```bash
git log -1 --oneline
```

Show the commit SHA and message. Remind user they can push with `git push` when ready.
