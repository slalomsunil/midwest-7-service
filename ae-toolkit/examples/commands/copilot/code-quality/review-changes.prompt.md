---
description: Review uncommitted changes for quality
mode: agent
tools:
  - terminal
  - workspace
---

# Review Changes

## Step 1: Get Changes

Use @terminal to see what's being reviewed:
- `git status` - Modified, staged, untracked files
- `git diff --cached` - Staged changes
- `git diff` - Unstaged changes

## Step 2: Analyze Quality

Use @workspace context to review changes against these standards:

**Code Clarity**:
- Clear naming (variables, functions, classes)
- Logical organization
- Appropriate comments
- Simplicity

**Error Handling**:
- Proper exception handling
- Edge case handling
- Input validation
- Clear error messages

**Testing**:
- Code testability
- Test coverage needs
- Important test cases

**Performance**:
- Algorithm efficiency
- Unnecessary operations
- Resource usage
- Scalability

**Security**:
- Input sanitization
- Access controls
- Data protection
- Dependency vulnerabilities

**Consistency**:
- Matches codebase style
- Follows established patterns
- Uses language/framework conventions

## Step 3: Technology-Specific Checks

Apply language-specific standards based on file types detected.

## Step 4: Provide Feedback

Organize feedback by priority:

### 🔴 Critical Issues
Must be addressed:
- Security vulnerabilities
- Bugs or logic errors
- Breaking changes

### 🟡 Important Improvements
Should be addressed:
- Missing error handling
- Performance problems
- Missing critical tests

### 🟢 Nice-to-Haves
Consider but not blocking:
- Style inconsistencies
- Additional documentation
- Small optimizations

For each issue provide:
- **Location**: File and line
- **Issue**: What's wrong
- **Why**: Why it matters
- **Suggestion**: How to fix (be specific)

## Step 5: Summary

Provide:
- Overall quality assessment
- Issue count by priority
- Ready to commit or needs work
- Positive aspects worth noting
