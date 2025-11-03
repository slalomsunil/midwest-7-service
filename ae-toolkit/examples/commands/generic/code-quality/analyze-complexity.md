---
description: Identify complex code needing refactoring
---

# Analyze Code Complexity

Follow each step below in order:

## Step 1: Determine Scope

Identify what to analyze:
- If user specified files with `@` references, analyze those files
- If user specified a directory, analyze all code files in that directory
- If no scope provided, ask user what to analyze (file, directory, or entire codebase)

**Important**: For large codebases, recommend starting with a specific directory or high-change-frequency areas.

## Step 2: Read and Examine Code

For each file in scope:
1. Read the file contents
2. Analyze structure and identify areas of complexity
3. Note files that may need deeper analysis

## Step 3: Identify Complexity Indicators

Look for these complexity signals:

### Function/Method Length
- **Green** (<30 lines): Easy to understand and test
- **Yellow** (30-50 lines): Moderate complexity, consider refactoring
- **Red** (>50 lines): High complexity, should be broken down

### Cyclomatic Complexity
Estimate by counting decision points (if, for, while, case, &&, ||, ?, catch):
- **Green** (1-5): Simple, easy to test
- **Yellow** (6-10): Moderate complexity, needs good tests
- **Red** (>10): High complexity, difficult to test thoroughly

### Nesting Depth
Count levels of indentation:
- **Green** (0-2 levels): Clear control flow
- **Yellow** (3 levels): Getting hard to follow
- **Red** (>3 levels): Very difficult to understand

### File Length
- **Green** (<200 lines): Well-scoped file
- **Yellow** (200-300 lines): Large file, might need splitting
- **Red** (>300 lines): Very large, likely doing too much

### Code Duplication
- Similar code blocks appearing multiple times
- Copy-paste patterns with minor variations
- Opportunities for abstraction

### Other Signals
- Long parameter lists (>4 parameters)
- God classes/functions (doing too many things)
- Tight coupling between components
- Lack of abstraction (hardcoded values, repeated patterns)

## Step 4: Rank by Priority

For each complex area found, assign a priority based on:

**High Priority** (Fix soon):
- High complexity AND high change frequency
- High complexity AND lacks tests
- High complexity in critical paths (auth, payments, data integrity)
- Security-sensitive code with high complexity

**Medium Priority** (Plan to fix):
- High complexity AND medium change frequency
- Medium complexity AND high change frequency
- Large files that are growing

**Low Priority** (Fix if convenient):
- High complexity AND low change frequency (if well-tested)
- Medium complexity in stable areas
- Minor code duplication

## Step 5: Provide Detailed Analysis

For each complex area, provide:

### Location
- File path and line numbers
- Function/class/method name

### Complexity Metrics
- Function length: X lines
- Estimated cyclomatic complexity: Y
- Nesting depth: Z levels
- File length: W lines

### Why It's Complex
- What makes this code hard to understand?
- What makes it hard to test?
- What makes it risky to change?

### Impact
- How often does this code change? (if you can tell from git history)
- How critical is this code path?
- What's the risk if this has bugs?

### Refactoring Suggestions
Be specific about how to improve:
- "Extract these 3 operations into separate functions"
- "Move this validation logic into a dedicated validator class"
- "Use early returns to reduce nesting"
- "Extract this repeated pattern into a shared utility"

## Step 6: Summarize Findings

Provide an executive summary:

```
Complexity Analysis Summary
===========================

Scope: [Files/directories analyzed]

Complexity Distribution:
- High complexity: X functions/files
- Medium complexity: Y functions/files
- Low complexity: Z functions/files

Priority Breakdown:
🔴 High Priority: A items requiring attention
🟡 Medium Priority: B items to plan for
🟢 Low Priority: C items to consider

Top 3 Refactoring Opportunities:
1. [Most impactful refactoring]
2. [Second most impactful]
3. [Third most impactful]

Recommended Next Steps:
- [Immediate action item]
- [Short-term plan]
- [Long-term strategy]
```

## Step 7: Offer Detailed Breakdowns

For each high-priority item, provide a detailed breakdown including:
- Current structure
- Proposed refactored structure
- Benefits of refactoring
- Estimated effort (small/medium/large)
- Testing strategy

---

## Example Output Structure

```
🔴 High Priority

File: src/services/payment-processor.ts
Function: processPayment (lines 45-156)
Metrics:
- Length: 112 lines
- Cyclomatic Complexity: ~18
- Nesting Depth: 5 levels

Why It's Complex:
- Handles multiple payment types in one function
- Nested conditionals for different validation rules
- Error handling mixed with business logic
- Direct database calls mixed with API calls

Impact:
- Changed 12 times in last 3 months
- Critical path (payment processing)
- Lacks comprehensive tests

Refactoring Suggestions:
1. Extract payment type strategies into separate classes
2. Move validation into dedicated validator
3. Separate error handling layer
4. Extract database and API calls into repository pattern
5. Add integration tests for each payment type

Estimated Effort: Medium (2-3 days with tests)

---

🟡 Medium Priority

[Similar format for medium priority items]

---

🟢 Low Priority

[Similar format for low priority items]
```

---

**Notes**:
- Focus on actionable insights, not just metrics
- Consider project context (startup MVP vs. mature product)
- Complexity isn't always bad if code is well-tested and stable
- Prioritize based on risk and change frequency, not just metrics
- Some complex code may need complexity (don't over-simplify)
