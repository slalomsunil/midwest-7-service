# Analyze Code Complexity

**Recommended Mode**: Ask Mode (for analysis) or Agent Mode (for refactoring suggestions with examples)

Identify complex code that may need refactoring or additional documentation.

## Workflow

### Step 1: Determine Scope

Ask user what to analyze:
- Specific file
- Directory
- Entire codebase

For large codebases, recommend starting with high-change areas or specific modules.

### Step 2: Examine Code

Use @code context to read and analyze files in scope.

### Step 3: Identify Complexity Indicators

Look for these signals:

#### Function/Method Length
- **Green** (<30 lines): Easy to understand and test
- **Yellow** (30-50 lines): Moderate, consider refactoring
- **Red** (>50 lines): Should be broken down

#### Cyclomatic Complexity
Count decision points (if, for, while, case, &&, ||, ?, catch):
- **Green** (1-5): Simple, easy to test
- **Yellow** (6-10): Moderate, needs good test coverage
- **Red** (>10): High complexity, difficult to test thoroughly

#### Nesting Depth
Count levels of indentation:
- **Green** (0-2 levels): Clear control flow
- **Yellow** (3 levels): Getting hard to follow
- **Red** (>3 levels): Very difficult to understand

#### File Length
- **Green** (<200 lines): Well-scoped
- **Yellow** (200-300 lines): Large, might need splitting
- **Red** (>300 lines): Very large, likely doing too much

#### Code Duplication
- Similar blocks appearing multiple times
- Copy-paste patterns with minor variations
- Opportunities for abstraction

#### Other Signals
- Long parameter lists (>4 parameters)
- God classes/functions (doing too many things)
- Tight coupling between components
- Hardcoded values, repeated patterns

### Step 4: Rank by Priority

#### High Priority (Fix Soon)
- High complexity + high change frequency
- High complexity + lacks tests
- High complexity in critical paths (auth, payments, data processing)
- Security-sensitive code with high complexity

#### Medium Priority (Plan to Fix)
- High complexity + medium change frequency
- Medium complexity + high change frequency
- Large files that continue growing

#### Low Priority (Fix if Convenient)
- High complexity + low change frequency (if well-tested and stable)
- Medium complexity in stable areas
- Minor code duplication

### Step 5: Provide Detailed Analysis

For each complex area found, provide:

**Location and Metrics**:
- File path and line numbers
- Function/class/method name
- Complexity measurements

**Why It's Complex**:
- What makes this code hard to understand
- What makes it hard to test
- What makes it risky to change

**Impact Assessment**:
- How often does this code change
- How critical is this code path
- Risk if bugs are introduced

**Refactoring Suggestions**:
- "Extract these 3 operations into separate functions"
- "Move validation logic into dedicated validator class"
- "Use early returns to reduce nesting"
- "Extract repeated pattern into shared utility"
- Provide specific, actionable recommendations

### Step 6: Provide Summary

```
Complexity Analysis Summary
===========================

Scope Analyzed: [files/directories analyzed]

Complexity Distribution:
- High complexity: X functions/files
- Medium complexity: Y functions/files
- Low complexity: Z functions/files

Priority Breakdown:
🔴 High Priority: A items requiring attention
🟡 Medium Priority: B items to plan for
🟢 Low Priority: C items to consider

Top 3 Refactoring Opportunities:
1. [Most impactful refactoring with estimated effort]
2. [Second most impactful]
3. [Third most impactful]

Recommended Next Steps:
- [Immediate action item]
- [Short-term plan]
- [Long-term strategy]
```

## Notes

- Focus on actionable insights, not just metrics
- Consider project context (startup MVP vs. mature product)
- Complexity isn't always bad if code is well-tested and stable
- Prioritize based on risk and change frequency
- Some complex code may genuinely need complexity
