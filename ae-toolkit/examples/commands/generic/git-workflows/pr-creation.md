---
description: Create a PR with generated description
allowed-tools: Bash(git:*, gh:*)
argument-hint: [optional status notes]
---

# Pull Request Creation

Follow each step below in order:

## Step 1: Verify Prerequisites

Check that:
1. Current branch is not main/master: `git branch --show-current`
2. GitHub CLI is available: `gh --version` (if not, will need to create PR manually)
3. Branch is pushed to remote: `git status` shows "Your branch is up to date with 'origin/[branch]'" or can be pushed

If branch isn't pushed, push it first: `git push -u origin $(git branch --show-current)`

## Step 2: Analyze Branch Changes

Determine the base branch (usually main or master):
1. Run `git remote show origin | grep "HEAD branch"` to find default branch
2. Let's call this `<base-branch>`

Get the full context of changes:
1. Run `git log <base-branch>..HEAD --oneline` to see all commits in this branch
2. Run `git diff <base-branch>...HEAD --stat` to see file change summary
3. Review key files changed with `git diff <base-branch>...HEAD` (focus on important changes, not full diff if too large)

## Step 3: Generate PR Description

Based on the analysis, create a PR description with this format:

```markdown
## Summary

[2-3 sentences explaining what this PR does and why]

## Changes

- [Bullet point for each significant change or feature]
- [Include file references when helpful]
- [Focus on WHAT changed, not implementation details]

## Test Plan

- [ ] [How to verify the changes work]
- [ ] [Steps to test the feature/fix]
- [ ] [Any manual testing performed]
- [ ] [Automated tests added/updated]

## Related Issues

[If applicable: Closes #123, Fixes #456, Related to #789]

$ARGUMENTS
```

**Guidelines**:
- Summary should be clear to someone who hasn't seen the code
- Changes should be concrete and specific
- Test plan should be actionable checklist
- Include $ARGUMENTS at the end if user provided status notes

## Step 4: Determine PR Title

Create a concise PR title (50-70 chars) that summarizes the change:
- If single commit, can use the commit message
- If multiple commits, create unified title that covers all changes
- Use conventional commit format if appropriate: `feat: Add user authentication`

## Step 5: Create PR

Use the GitHub CLI to create the PR:

```bash
gh pr create --title "PR Title Here" --body "$(cat <<'EOF'
[Full PR description here]
EOF
)"
```

**Important**:
- Use the heredoc format shown above for multi-line descriptions
- Include all sections from Step 3
- Don't forget to include $ARGUMENTS if provided

## Step 6: Confirm Success

After creating the PR:
1. Show the PR URL returned by `gh pr create`
2. Remind user to:
   - Add reviewers if not auto-assigned
   - Check that CI/CD passes
   - Link any related issues manually if needed
   - Respond to review feedback when ready

---

**Notes**:
- If `gh` is not installed, generate the PR description and instruct user to create PR manually via GitHub web interface
- If there's a PR template in `.github/PULL_REQUEST_TEMPLATE.md`, consider incorporating its structure
- Don't create the PR if there are no commits ahead of base branch
