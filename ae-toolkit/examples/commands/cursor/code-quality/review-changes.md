# Review Changes

**Recommended Mode**: Ask Mode (for read-only analysis) or Agent Mode (to suggest fixes)

Review uncommitted changes for quality issues before committing.

## Workflow

### Step 1: Get Changes Context

Run these commands:
- `git status` - See modified, staged, and untracked files
- `git diff --cached` - Show staged changes
- `git diff` - Show unstaged changes

### Step 2: Analyze Code Quality

Use @code context to review changes against these standards:

#### Code Clarity
- Clear naming for variables, functions, and classes
- Logical code organization
- Appropriate comments for complex logic
- Simplicity over cleverness

#### Error Handling
- Proper exception/error handling
- Edge cases covered
- Input validation present
- Clear, helpful error messages

#### Testing
- Code is testable
- Consider test coverage needs
- Important test cases identified

#### Performance
- Efficient algorithms
- No unnecessary operations
- Reasonable resource usage
- Scalable approach

#### Security
- Input properly sanitized
- Access controls appropriate
- Sensitive data protected
- No known vulnerable patterns

#### Consistency
- Matches existing codebase style
- Follows established patterns
- Uses language/framework conventions correctly

### Step 3: Technology-Specific Checks

Based on file types, apply language-specific standards:

**TypeScript/JavaScript**: Type safety, async/await, memory management
**Python**: PEP 8, type hints, context managers
**React**: Hook rules, component size, proper keys
**.NET/C#**: Resource disposal, LINQ usage, async patterns
**Other languages**: Apply appropriate conventions

### Step 4: Provide Structured Feedback

Organize issues by priority:

#### 🔴 Critical Issues (Must Fix)
- Security vulnerabilities
- Bugs or logic errors
- Breaking changes without migration

For each issue:
- **Location**: File and line number
- **Issue**: What's wrong
- **Why**: Why it matters
- **Suggestion**: Specific fix

#### 🟡 Important Improvements (Should Fix)
- Missing error handling for key scenarios
- Performance problems
- Missing tests for critical functionality
- Hard-to-maintain code patterns

#### 🟢 Nice-to-Haves (Consider)
- Minor style inconsistencies
- Additional documentation
- Small optimizations
- Refactoring opportunities

### Step 5: Provide Summary

End with:
- Overall code quality assessment
- Count of issues by priority
- Whether ready to commit or needs work
- Positive aspects worth noting

**Example Summary**:
```
Overall: Good changes with 2 critical issues to address.

Issues Found:
🔴 Critical: 2
🟡 Important: 4
🟢 Nice-to-have: 1

Status: Address critical issues before committing. Important issues can be addressed now or in follow-up work.

Positive: Well-structured code with clear naming and good organization.
```
