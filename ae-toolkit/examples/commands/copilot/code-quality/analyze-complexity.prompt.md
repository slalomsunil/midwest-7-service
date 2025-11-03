---
description: Identify complex code needing refactoring
mode: agent
tools:
  - workspace
---

# Analyze Code Complexity

## Step 1: Determine Scope

Ask user what to analyze (file, directory, or entire workspace).

For large codebases, recommend starting with specific areas.

## Step 2: Examine Code

Use @workspace to read and analyze files in scope.

## Step 3: Identify Complexity

Look for:

**Function/Method Length**:
- Green (<30 lines): Easy to understand
- Yellow (30-50 lines): Moderate, consider refactoring
- Red (>50 lines): Should be broken down

**Cyclomatic Complexity** (count decision points):
- Green (1-5): Simple, easy to test
- Yellow (6-10): Moderate, needs good tests
- Red (>10): High complexity, hard to test

**Nesting Depth**:
- Green (0-2 levels): Clear control flow
- Yellow (3 levels): Getting hard to follow
- Red (>3 levels): Very difficult

**File Length**:
- Green (<200 lines): Well-scoped
- Yellow (200-300 lines): Large, might need splitting
- Red (>300 lines): Very large, doing too much

**Code Duplication**:
- Similar blocks appearing multiple times
- Copy-paste patterns
- Abstraction opportunities

**Other Signals**:
- Long parameter lists (>4)
- God classes/functions
- Tight coupling
- Hardcoded values

## Step 4: Rank by Priority

**High Priority** (fix soon):
- High complexity + high change frequency
- High complexity + lacks tests
- High complexity in critical paths

**Medium Priority** (plan to fix):
- High complexity + medium change frequency
- Medium complexity + high change frequency

**Low Priority** (fix if convenient):
- High complexity + low change frequency (if tested)
- Medium complexity in stable areas

## Step 5: Detailed Analysis

For each complex area:
- Location and metrics
- Why it's complex
- Impact and risk
- Specific refactoring suggestions

## Step 6: Summary

Provide:
- Scope analyzed
- Complexity distribution
- Priority breakdown
- Top 3 refactoring opportunities
- Recommended next steps
