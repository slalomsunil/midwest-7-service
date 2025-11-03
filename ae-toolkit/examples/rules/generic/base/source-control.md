# Source Control

<!-- Rule Metadata -->
**Tool:** Claude Code, OpenCode
**Version:** 2025-01
**Category:** Base Rules
**Related:** See `./copilot/source-control.md` for GitHub Copilot version, `./cursor/source-control.md` for Cursor version

## Purpose

Establish best practices for using Git and source control systems effectively, including commit hygiene, branching strategies, and safety protocols.

## Commit Best Practices

### When to Commit

Create commits:
- When implementing a complete, logical unit of work
- After finishing a subtask that leaves the code in a working state
- Before making risky or experimental changes
- At natural checkpoints during complex work
- When explicitly requested by the user

Don't create commits:
- Unless the user explicitly requests it
- With failing tests (unless specifically documenting a failing test)
- With broken or non-compiling code (except work-in-progress branches)
- That mix unrelated changes

### Commit Messages

Good commit messages:
- Start with a concise summary (50-72 characters)
- Use imperative mood ("Add feature" not "Added feature")
- Focus on WHY rather than WHAT (code shows what changed)
- Include context that's not obvious from the diff
- Reference related issues or tickets when relevant

Example structure:
```
Add user authentication middleware

- Verify JWT tokens on protected routes
- Extract user info and attach to request context
- Return 401 for missing or invalid tokens

Fixes #123
```

### Commit Safety Protocol

**NEVER:**
- Update git config without user permission
- Run destructive/irreversible commands (force push, hard reset) unless explicitly requested
- Skip hooks (--no-verify, --no-gpg-sign) unless explicitly requested
- Force push to main/master branches (warn user if requested)
- Commit files that likely contain secrets (.env, credentials.json, etc.)

**ALWAYS:**
- Check git status before committing
- Review git diff to understand what's being committed
- Run tests before committing (if project has tests)
- Check authorship before amending commits
- Verify commits aren't already pushed before amending

### Amending Commits

Use `git commit --amend` ONLY when:
1. User explicitly requests amending, OR
2. Adding edits from pre-commit hooks

Before amending:
- Check authorship: `git log -1 --format='%an %ae'`
- Verify not pushed: `git status` shows "Your branch is ahead"
- Never amend other developers' commits

## Branching

### Branch Naming

Use descriptive branch names:
- Feature work: `feature/user-authentication`, `feat/dark-mode`
- Bug fixes: `fix/login-timeout`, `bugfix/null-pointer`
- Experiments: `experiment/new-caching-strategy`
- Refactoring: `refactor/extract-auth-logic`

Avoid:
- Generic names like `temp`, `test`, `wip`
- Names without context like `branch1`, `new-feature`

### Working with Branches

**Creating branches:**
- Branch from the appropriate base (usually main/master)
- Keep branches focused on single features or fixes
- Delete branches after merging

**Switching branches:**
- Commit or stash changes before switching
- Verify clean working directory
- Pull latest changes after switching

**Merging branches:**
- Keep feature branches up to date with main
- Resolve conflicts carefully
- Test after merging
- Delete feature branch after successful merge

## Pull Requests

### Creating Pull Requests

Only create PRs when explicitly requested by the user.

When creating a PR:

1. **Understand the full scope:**
   - Run `git log` to see ALL commits (not just the latest)
   - Run `git diff [base-branch]...HEAD` to see all changes since branch diverged
   - Check if branch is up to date with remote

2. **Write a comprehensive description:**
   ```markdown
   ## Summary
   - Bullet points of key changes
   - Context on why changes were made

   ## Test plan
   - How to verify the changes work
   - What to test manually
   - Which automated tests cover this

   🤖 Generated with [Claude Code](https://claude.com/claude-code)
   ```

3. **Push and create:**
   - Push with `-u` flag if needed
   - Use `gh pr create` for GitHub repositories
   - Provide PR URL when done

### PR Description Best Practices

Good PR descriptions:
- Summarize ALL changes in the branch, not just recent commits
- Explain the "why" and "what" clearly
- Include testing instructions
- Reference related issues or tickets
- Note any breaking changes or migrations needed
- Call out areas that need special review

## Working with Remotes

### Pulling Changes

- Pull before starting new work
- Use `git pull --rebase` to maintain linear history (if team prefers)
- Resolve conflicts immediately, don't let them accumulate

### Pushing Changes

- Push regularly to share work and create backups
- Don't push directly to protected branches
- Use `--force-with-lease` instead of `--force` if you must force push
- Never force push to shared branches without team coordination

### Remote Branch Management

- Fetch regularly to see others' work
- Prune deleted remote branches: `git fetch --prune`
- Track remote branches explicitly when needed

## Handling Common Scenarios

### Merge Conflicts

When conflicts occur:
1. Understand both sides of the conflict
2. Decide which changes to keep (don't blindly accept one side)
3. Test the resolution
4. Complete the merge
5. Run tests to ensure nothing broke

### Undoing Changes

Use the right tool for the situation:
- **Unstage files:** `git reset HEAD <file>`
- **Discard local changes:** `git checkout -- <file>` or `git restore <file>`
- **Undo last commit (keep changes):** `git reset --soft HEAD~1`
- **Undo last commit (discard changes):** `git reset --hard HEAD~1` (dangerous!)
- **Revert a commit:** `git revert <commit>` (preferred for shared branches)

### Recovering from Mistakes

- Use `git reflog` to find lost commits
- Create a backup branch before risky operations
- Ask for help before running destructive commands
- Remember: almost nothing is truly lost in Git

## Git Workflow Patterns

### Feature Branch Workflow

1. Create branch from main: `git checkout -b feature/new-thing`
2. Make changes and commit regularly
3. Keep branch updated: regularly merge/rebase main
4. Create PR when feature is complete
5. Address review feedback
6. Merge to main
7. Delete feature branch

### Commit Early, Commit Often

- Make small, frequent commits while working
- Each commit should be a logical unit
- Can squash commits before merging if team prefers
- Easier to undo small commits than large ones

## Integration with GitHub/GitLab

### Using gh CLI

Use `gh` command for GitHub operations:
- `gh pr create` - Create pull requests
- `gh pr list` - View open PRs
- `gh pr view <number>` - See PR details
- `gh issue list` - View issues
- `gh pr checks` - See CI/CD status

### CI/CD Integration

- Wait for CI checks before merging
- Fix failing tests promptly
- Don't merge with failing checks (unless exceptional circumstances)
- Use draft PRs for work-in-progress

## .gitignore Best Practices

### What to Ignore

Always ignore:
- Build artifacts and compiled code
- Dependency directories (node_modules, vendor, etc.)
- IDE and editor files (.vscode, .idea, etc.)
- OS files (.DS_Store, Thumbs.db)
- Environment files with secrets (.env.local, etc.)
- Log files and temporary files
- Coverage reports and test artifacts

### .gitignore Tips

- Use comments to explain non-obvious entries
- Use negation (!) sparingly and carefully
- Check global gitignore for personal preferences
- Test patterns with `git check-ignore -v <file>`

## Integration with Other Rules

Source control works with:
- **Code Quality** - Commit clean, tested code
- **Collaboration** - Clear history helps team understanding
- **Session Management** - Include commit tasks in planning
- **Communication** - Write clear messages for teammates

## Customization Notes

Teams may want to adjust:
- Commit message format (conventional commits, etc.)
- Branching strategy (GitFlow, trunk-based, etc.)
- Merge vs. rebase preferences
- Required commit signatures
- PR approval requirements
- Protected branch policies
