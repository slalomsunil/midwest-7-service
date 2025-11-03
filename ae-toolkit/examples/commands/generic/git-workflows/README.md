# Git Workflow Commands

This directory contains slash commands that assist with common git operations and workflows. These commands help maintain consistency in commit messages, PR descriptions, and branch management.

## Commands in This Category

### commit-workflow.md

**Purpose**: Guide through creating well-formatted commits following conventional commit standards.

**When to use**:
- Creating commits after making code changes
- Need help writing clear, conventional commit messages
- Want consistent commit formatting across the team

**What it does**:
1. Reviews uncommitted changes with `git status` and `git diff`
2. Analyzes the nature of the changes (feature, fix, refactor, etc.)
3. Generates a conventional commit message
4. Creates the commit with the generated message
5. Confirms the commit was successful

**Example invocation**:
```
/commit-workflow
```

**Related rules**: Communication standards, source control best practices

---

### pr-creation.md

**Purpose**: Analyze changes in the current branch and create a pull request with a well-structured description.

**When to use**:
- Ready to create a PR for your feature branch
- Need help summarizing branch changes into a PR description
- Want consistent PR formatting

**What it does**:
1. Analyzes all commits in the branch since it diverged from main
2. Reviews the full diff between the branch and base branch
3. Generates a PR title and description with summary, changes, and test plan
4. Creates the PR using `gh pr create`
5. Returns the PR URL

**Example invocation**:
```
/pr-creation
/pr-creation Ready for review
```

**Related rules**: Communication standards, source control best practices, collaboration patterns

---

### branch-management.md

**Purpose**: Create, switch, and manage branches following naming conventions.

**When to use**:
- Starting work on a new feature or bug fix
- Need help with branch naming conventions
- Want consistent branch management across the team

**What it does**:
1. Helps determine appropriate branch name based on work type
2. Creates branch with proper naming convention
3. Provides guidance on branch lifecycle (creation, switching, cleanup)

**Example invocation**:
```
/branch-management
/branch-management feature Add user authentication
```

**Related rules**: Source control best practices

---

## Design Patterns

### Conventional Commits

Commands in this category follow [Conventional Commits](https://www.conventionalcommits.org/) format:

```
<type>(<scope>): <description>

<body>

<footer>
```

Common types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `refactor`: Code restructuring without behavior change
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

### Branch Naming Conventions

Recommended patterns (customize for your team):

```
feature/short-description
fix/issue-number-short-description
refactor/component-name
docs/topic
```

### PR Description Format

Commands generate PR descriptions with:

1. **Summary**: High-level overview of changes (2-3 sentences)
2. **Changes**: Bulleted list of specific modifications
3. **Test Plan**: How to verify the changes work
4. **Related Issues**: Links to issues or tickets (if applicable)

## Usage Tips

### Commit Workflow

**Before committing**:
- Ensure you've staged the changes you want to commit (`git add`)
- Review your changes to make sure they represent a single logical unit
- Consider if changes should be split into multiple commits

**After committing**:
- Verify the commit with `git log -1` or `git show`
- Push to remote when ready

### PR Creation

**Before creating a PR**:
- Ensure all commits are pushed to the remote branch
- Run tests and verify the build passes
- Review the full diff to make sure nothing unexpected is included
- Consider if branch needs rebasing on latest main

**After creating a PR**:
- Add reviewers if not automatically assigned
- Link related issues if the command didn't capture them
- Respond to CI/CD feedback

### Branch Management

**Good practices**:
- Keep branches focused on single features or fixes
- Create branches from up-to-date main/master
- Delete branches after PRs are merged
- Use descriptive names that indicate the work being done

## Customization Examples

### Custom Commit Format

If your team uses a different commit format, modify `commit-workflow.md`:

```markdown
Generate a commit message in this format:

[TICKET-123] Type: Description

Detailed explanation of changes.
```

### Custom PR Template

Add organization-specific sections to `pr-creation.md`:

```markdown
## Screenshots
(if applicable)

## Performance Impact
(describe any performance considerations)

## Security Considerations
(describe any security implications)
```

### Custom Branch Naming

Modify `branch-management.md` to use your conventions:

```markdown
Use this branch naming pattern:
- Feature: [initials]/feature/[ticket]-[description]
- Bugfix: [initials]/bugfix/[ticket]-[description]
- Hotfix: [initials]/hotfix/[ticket]-[description]
```

## Integration with Rules

These commands work best when combined with rules from the rules library:

- **Communication rules** (`../../rules/generic/base/communication.md`): Defines tone and style for commit messages and PR descriptions
- **Source control rules** (`../../rules/generic/base/source-control.md`): Git best practices and conventions
- **Collaboration rules** (`../../rules/generic/base/collaboration.md`): Team workflow patterns

Reference these rules in your `.claude/` directory to ensure commands follow your team's standards.

## Common Issues

### Command Fails to Create Commit

**Possible causes**:
- No changes staged for commit
- Merge conflict in progress
- Git hooks preventing commit

**Solution**: Review `git status` output and resolve any issues before retrying

### PR Creation Requires GitHub CLI

**Requirement**: Commands use `gh pr create` which requires:
1. GitHub CLI installed (`brew install gh` or equivalent)
2. Authenticated with GitHub (`gh auth login`)
3. Repository has a remote on GitHub

**Alternative**: Use command to generate PR description, then create PR manually via web interface

### Branch Already Exists

**Solution**: Use `git checkout existing-branch` or choose a different branch name

## Version Information

**Last Updated**: 2025-10-14
**Toolkit Version**: Part of AE Toolkit best practices library

See `../` for other command categories and `../../copilot/git-workflows/` for Copilot equivalents.
