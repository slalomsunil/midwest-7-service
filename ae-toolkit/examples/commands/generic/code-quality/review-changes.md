---
description: Review uncommitted changes for quality
allowed-tools: Bash(git:*)
---

# Review Changes

Follow each step below in order:

## Step 1: Get Changes Context

Run these commands to understand what's being reviewed:
1. `git status` - See which files are modified, staged, or untracked
2. `git diff --cached` - Show staged changes (if any)
3. `git diff` - Show unstaged changes (if any)

If user specified specific files with `@` references, focus review on those files.

## Step 2: Analyze Code Quality

Review the changes against these quality standards:

### Code Clarity
- **Naming**: Are variables, functions, classes named clearly and consistently?
- **Structure**: Is code logically organized and easy to follow?
- **Comments**: Are complex sections explained? Are comments up-to-date?
- **Simplicity**: Could anything be simpler without losing functionality?

### Error Handling
- **Exception handling**: Are errors caught and handled appropriately?
- **Edge cases**: Are edge cases and boundary conditions handled?
- **Input validation**: Is user input or external data validated?
- **Error messages**: Are error messages helpful and clear?

### Testing Considerations
- **Testability**: Can this code be easily tested?
- **Test coverage**: Are there tests for this code? Should there be?
- **Test cases**: What test cases would be important to cover?

### Performance
- **Algorithms**: Are algorithms appropriate for the task?
- **Resource usage**: Any unnecessary loops, database calls, or memory usage?
- **Scalability**: Will this perform well with larger datasets?

### Security
- **Input sanitization**: Is external input properly sanitized?
- **Authentication/Authorization**: Are access controls appropriate?
- **Data exposure**: Is sensitive data properly protected?
- **Dependencies**: Any known vulnerable dependencies?

### Consistency
- **Code style**: Does it match the existing codebase style?
- **Patterns**: Does it follow established patterns in the project?
- **Conventions**: Does it follow language/framework conventions?

## Step 3: Check Technology-Specific Concerns

Based on the file types being changed, apply technology-specific standards:

**TypeScript/JavaScript**:
- Type safety (avoid `any` types)
- Proper async/await usage
- Memory leak potential (event listeners, subscriptions)

**Python**:
- PEP 8 style compliance
- Type hints for function signatures
- Proper use of context managers

**React**:
- Proper hook usage (rules of hooks)
- Component size and single responsibility
- Key props in lists
- Unnecessary re-renders

**.NET/C#**:
- Proper disposal of resources (IDisposable)
- LINQ usage appropriateness
- Async all the way up

**Other languages**: Apply appropriate language-specific best practices

## Step 4: Provide Structured Feedback

Organize feedback into three priority levels:

### 🔴 Critical Issues
Issues that must be addressed before committing:
- Security vulnerabilities
- Bugs or logic errors
- Breaking changes without migration path

### 🟡 Important Improvements
Issues that should be addressed soon:
- Missing error handling for important cases
- Performance problems
- Missing tests for critical functionality
- Hard-to-maintain code

### 🟢 Nice-to-Haves
Improvements to consider but not blocking:
- Minor style inconsistencies
- Additional documentation
- Small optimizations
- Refactoring opportunities

For each issue:
- **Location**: File and line number (if applicable)
- **Issue**: What's the problem?
- **Why**: Why is it a problem?
- **Suggestion**: How to fix it (be specific)

## Step 5: Provide Summary

End with a brief summary:
- Overall code quality assessment
- Number of issues by priority
- Whether changes are ready to commit or need work
- Positive aspects worth highlighting

---

## Example Feedback Format

```
🔴 Critical Issues (2)

src/auth.ts:45
Issue: User input not sanitized before database query
Why: SQL injection vulnerability
Suggestion: Use parameterized queries or ORM methods

src/payment.ts:78
Issue: Error not caught when API call fails
Why: Will crash the application if payment service is down
Suggestion: Wrap in try-catch and handle failure gracefully

🟡 Important Improvements (3)

[Similar format for important issues]

🟢 Nice-to-Haves (1)

[Similar format for nice-to-haves]

---

Summary: Overall good changes with some important issues to address. The logic is sound but needs better error handling and security measures. Once critical issues are resolved, this will be ready to commit.
```

---

**Notes**:
- Adjust strictness based on context (prototype vs. production code)
- Consider project maturity (new project vs. legacy codebase)
- Be specific and constructive, not just critical
- Highlight what's done well, not just problems
- If no changes to review, let user know
