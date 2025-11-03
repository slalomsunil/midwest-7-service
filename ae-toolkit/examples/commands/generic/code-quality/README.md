# Code Quality Commands

This directory contains slash commands that assist with code review, analysis, and quality improvement. These commands help identify issues, maintain standards, and improve code maintainability.

## Commands in This Category

### review-changes.md

**Purpose**: Review uncommitted changes against quality standards before committing.

**When to use**:
- Before creating a commit
- Want feedback on code quality
- Need to verify changes meet team standards
- Looking for potential issues before code review

**What it does**:
1. Reviews uncommitted changes with `git diff`
2. Analyzes code against quality standards:
   - Code clarity and readability
   - Proper error handling
   - Test coverage considerations
   - Performance implications
   - Security concerns
   - Consistency with codebase patterns
3. Provides specific feedback on issues found
4. Suggests improvements where appropriate

**Example invocation**:
```
/review-changes
/review-changes @src/auth.ts
```

**Related rules**: Code quality standards, technology-specific conventions

---

### analyze-complexity.md

**Purpose**: Identify complex code that may need refactoring or additional documentation.

**When to use**:
- Reviewing existing code for technical debt
- Planning refactoring work
- Identifying areas that need better documentation or tests
- Understanding which parts of the codebase are high-risk

**What it does**:
1. Analyzes specified files or directories for complexity indicators:
   - Long functions or methods (>50 lines)
   - High cyclomatic complexity (many branches/conditions)
   - Deeply nested code (>3 levels)
   - Large files (>300 lines)
   - Duplicate or similar code patterns
2. Ranks areas by complexity/risk level
3. Provides specific recommendations for improvement
4. Suggests refactoring approaches

**Example invocation**:
```
/analyze-complexity @src/
/analyze-complexity @src/services/payment-processor.ts
```

**Related rules**: Code quality standards, refactoring best practices

---

## Design Patterns

### Quality Standards

Commands in this category check for:

**Code Clarity**:
- Clear variable and function names
- Appropriate comments and documentation
- Logical code organization
- Consistent formatting

**Error Handling**:
- Proper try-catch blocks
- Error message quality
- Graceful degradation
- Input validation

**Testing**:
- Test coverage considerations
- Testability of code
- Edge cases handling

**Performance**:
- Inefficient algorithms
- Unnecessary loops or iterations
- Resource management

**Security**:
- Input sanitization
- Authentication/authorization
- Data exposure risks
- Dependency vulnerabilities

**Consistency**:
- Follows codebase patterns
- Matches team conventions
- Consistent with technology best practices

### Complexity Metrics

**Function Length**:
- **Green**: <30 lines
- **Yellow**: 30-50 lines
- **Red**: >50 lines

**Cyclomatic Complexity**:
- **Green**: 1-5 (simple, easy to test)
- **Yellow**: 6-10 (moderate complexity)
- **Red**: >10 (high complexity, hard to test)

**Nesting Depth**:
- **Green**: 0-2 levels
- **Yellow**: 3 levels
- **Red**: >3 levels

**File Length**:
- **Green**: <200 lines
- **Yellow**: 200-300 lines
- **Red**: >300 lines

## Usage Tips

### Review Changes

**When to use**:
- Run before every commit to catch issues early
- Use after completing a feature to do a self-review
- Run before pushing to catch issues before CI/CD

**What to look for in feedback**:
- **Critical issues**: Security problems, bugs, breaking changes
- **Important improvements**: Error handling, edge cases, performance
- **Nice-to-haves**: Code clarity, documentation, minor optimizations

**After review**:
- Address critical and important issues before committing
- Consider nice-to-haves but don't let perfect be the enemy of good
- If many issues found, consider breaking work into smaller commits

### Analyze Complexity

**When to use**:
- During sprint planning to identify refactoring candidates
- Before adding features to understand existing code
- Periodically (monthly/quarterly) to track technical debt
- When onboarding new team members to highlight risk areas

**What to do with results**:
- **High complexity + high change frequency**: Prioritize for refactoring
- **High complexity + low change frequency**: Document well, refactor if time permits
- **Low complexity**: Maintain current standards

**Refactoring priorities**:
1. High-complexity code that changes frequently
2. High-complexity code that lacks tests
3. High-complexity code in critical paths (auth, payments, data processing)
4. Code that causes frequent bugs

## Customization Examples

### Custom Quality Standards

Modify `review-changes.md` to enforce organization-specific standards:

```markdown
---
description: Review changes against our quality standards
---

Review the uncommitted changes against these standards:

1. **Our Documentation Standard**: All public functions must have JSDoc comments with @param and @return
2. **Our Error Handling Standard**: All async functions must have try-catch blocks
3. **Our Testing Standard**: All business logic must have unit tests in the same commit
4. **Our Security Standard**: All user input must be validated with our validation library

Provide specific feedback on any violations.
```

### Technology-Specific Analysis

Add language-specific checks:

```markdown
For TypeScript code, also check:
- Proper type annotations (no `any` types without justification)
- Interface definitions for complex objects
- Proper async/await usage (no unhandled promises)

For React code, also check:
- Proper hook usage (following rules of hooks)
- Component size (<200 lines)
- Prop types or TypeScript interfaces
- Key props in lists
```

### Complexity Thresholds

Adjust complexity thresholds in `analyze-complexity.md`:

```markdown
Use these thresholds for our team:
- Function length: Warn at 40 lines, flag at 75 lines
- Cyclomatic complexity: Warn at 8, flag at 15
- File length: Warn at 250 lines, flag at 400 lines
```

## Integration with Rules

These commands work best when combined with rules from the rules library:

- **Code quality rules** (`../../rules/generic/base/code-quality.md`): General quality standards
- **Technology rules** (`../../rules/generic/tech/`): Language-specific conventions (TypeScript, Python, React, etc.)

Reference these rules in your `.claude/` directory to ensure commands check against your team's standards.

## Integration with Agents

For more thorough analysis, consider using specialized agents:

- **Code Review Agent** (`../../agents/code-quality/code-reviewer.md`): Extended review session with back-and-forth
- **Refactoring Agent** (`../../agents/code-quality/refactoring-advisor.md`): Interactive refactoring guidance
- **Tech Debt Agent** (`../../agents/code-quality/tech-debt-analyzer.md`): Comprehensive technical debt assessment

**Pattern**: Use commands for quick checks, agents for in-depth analysis.

## Common Issues

### Review Finds Too Many Issues

**Possible causes**:
- Code doesn't follow established patterns
- Rules are too strict for the project
- Large changeset with multiple concerns

**Solutions**:
- Customize commands to match project maturity level
- Break changes into smaller, focused commits
- Address critical issues first, plan time for improvements

### Complexity Analysis Overwhelming

**Possible causes**:
- Legacy codebase with accumulated technical debt
- Unrealistic complexity thresholds

**Solutions**:
- Focus on high-change-frequency files first
- Adjust thresholds to match codebase reality
- Track complexity over time (aim to decrease, not eliminate)
- Create refactoring backlog, prioritize systematically

### Commands Too Slow

**Possible causes**:
- Large diff or many files to analyze
- Complex rules consuming context

**Solutions**:
- Target specific files with `@file/path`
- Split large changes into smaller commits
- Simplify command prompts

## Version Information

**Last Updated**: 2025-10-14
**Toolkit Version**: Part of AE Toolkit best practices library

See `../` for other command categories and `../../copilot/code-quality/` for Copilot equivalents.
