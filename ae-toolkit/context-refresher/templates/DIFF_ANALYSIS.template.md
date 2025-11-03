# Diff Analysis Template

This template is **MANDATORY** for Phase 3 of the Context Refresher workflow. Following this template structure is **REQUIRED**.

## Template Structure

Use this exact template structure when creating the diff analysis:

```markdown
# Diff Analysis - [Date]

## Analysis Scope
- **Base Point**: [Last documentation update date/commit]
- **Comparison Point**: Current HEAD
- **Files Analyzed**: [Number]
- **Key Paths**: [List main directories/files examined]

## Configuration Changes

### Package Dependencies
**Added Dependencies**:
```json
{
  "zustand": "^4.0.0",
  "react-query": "^3.39.0",
  "@typescript-eslint/parser": "^5.0.0"
}
```

**Removed Dependencies**:
```json
{
  "redux": "^4.0.0",
  "redux-thunk": "^2.3.0"
}
```

### Configuration Files
**[config file name]**:
- Added: [key additions]
- Removed: [key removals]
- Modified: [key changes]

## Pattern Changes

### New Patterns Introduced
**[Pattern Name]**
- **Description**: [What the pattern is]
- **Example**:
```[language]
// Example of new pattern
[code snippet]
```
- **Documentation Needed**: [What should be documented]

### Deprecated Patterns Found
**[Pattern Name]**
- **Description**: [What was deprecated]
- **Still Documented?**: [Yes/No - check current docs]
- **Example of Old Pattern**:
```[language]
// This pattern is no longer used
[code snippet]
```

## Architectural Changes

### Structure Changes
- **Before**: [Description of old structure]
- **After**: [Description of new structure]
- **Impact**: [What this means for AI assistance]

### File Organization
[Note any significant reorganization]
- Moved: [files/directories moved]
- Created: [new directories/structure]
- Removed: [deleted structure]

## Code Convention Evolution

### Naming Conventions
- **Old**: [previous naming pattern]
- **New**: [current naming pattern]
- **Examples**: [specific examples]

### Testing Patterns
- **Old Approach**: [previous testing style]
- **New Approach**: [current testing style]
- **Key Differences**: [what changed]

## Technology-Specific Changes

### [Technology/Framework 1]
- Version: [old] → [new]
- Breaking Changes: [list any]
- New Features Used: [list any]

### [Technology/Framework 2]
- Version: [old] → [new]
- Breaking Changes: [list any]
- New Features Used: [list any]

## Documentation Gap Analysis

### Currently Documented but Outdated
**Primary Context Files**:
1. **[Topic]**: CLAUDE.md says [X], code shows [Y]
2. **[Topic]**: .cursorrules references [old pattern], now using [new pattern]

**Referenced Documentation**:
1. **[Topic]**: docs/README.md describes [X], current implementation is [Y]
2. **[Topic]**: Architecture docs reference [old structure], now organized as [new structure]

### Not Documented but Should Be
**Missing from Context Files**:
1. **[Topic]**: New pattern needs documentation in CLAUDE.md
2. **[Topic]**: Important convention not mentioned in .cursorrules

**Missing from Referenced Documentation**:
1. **[Topic]**: New architecture not reflected in docs/architecture.md
2. **[Topic]**: Updated module structure not documented in docs/module-anatomy.md

### Can Be Removed from Documentation
**From Context Files**:
1. **[Topic]**: No longer relevant in CLAUDE.md
2. **[Topic]**: Deprecated pattern still mentioned in .cursorrules

**From Referenced Documentation**:
1. **[Topic]**: Outdated information in project README
2. **[Topic]**: Deprecated approach still documented in architecture files

## Documentation Coverage Check

### Identified Additions Requiring Documentation
**From Git Analysis** (changes since [baseline date]):

1. **[Feature/Component Name]**
   - Type: [API/Function/Config/Structure]
   - Added: [Date/Commit]
   - Current AI Context Coverage: [None/Partial/Complete]
   - Documentation Needed: [What should be added to CLAUDE.md/.cursorrules]

2. **[Feature/Component Name]**
   - Type: [What kind of addition]
   - Added: [When]
   - Current AI Context Coverage: [Status]
   - Documentation Needed: [Specific guidance AI needs]

### Project Documentation Patterns
**How This Project Documents for AI**:
- Pattern: [e.g., "New APIs are described in CLAUDE.md with usage examples"]
- Pattern: [e.g., "File structure changes go in the Architecture section"]
- Pattern: [e.g., "New conventions are added as rules in .cursorrules"]

### Missing Documentation by Category
- **Undocumented Features**: [List features AI doesn't know about]
- **Undocumented Conventions**: [List patterns AI should follow but doesn't know]
- **Undocumented Structure**: [List organizational changes AI isn't aware of]

## Specific File Diffs

### [Critical File 1]
**Significant Changes**:
```diff
- old code line
+ new code line
```
**Impact**: [What this means for documentation]

### [Critical File 2]
**Significant Changes**:
```diff
- old pattern
+ new pattern
```
**Impact**: [What this means for documentation]

## Summary

### Critical Documentation Updates Needed
1. **Remove**: References to [deprecated technology/pattern]
2. **Add**: Documentation for [new technology/pattern]
3. **Update**: [Existing topic] to reflect [change]

### Risk Assessment
- **High Risk**: [Outdated patterns that could cause errors]
- **Medium Risk**: [Patterns that might confuse]
- **Low Risk**: [Minor inconsistencies]

---
**NOTE**: This analysis examined actual code changes. Phase 4 will create a specific update plan based on these findings.
```

## Critical Requirements

### Content Requirements
- **Configuration Changes**: Must analyze dependency and config file changes
- **Pattern Changes**: Must identify new vs deprecated patterns with examples
- **Architecture**: Must note structural changes
- **Gap Analysis**: Must map findings to documentation needs across ALL AI-relevant files (context files AND referenced documentation)
- **Documentation Coverage**: Must check if code changes require updates to referenced documentation files
- **Cross-File Analysis**: Must identify when changes impact multiple documentation files
- **Specific Diffs**: Must include relevant code diff examples

### Git Command Usage
Required git commands for detailed analysis:
```bash
# Get full diff since date
git diff $(git rev-list -1 --before="[date]" HEAD) HEAD

# Diff specific files
git diff [old-commit] HEAD -- package.json

# Show file at old version
git show [old-commit]:path/to/file
```

### Format Requirements
- Use exact markdown structure as shown above
- Include actual code examples and diffs
- Group by type of change
- Use diff format for code changes
- Include summary linking to documentation needs

## Usage Notes

- Save to: `build/DIFF_ANALYSIS.md`
- Created in: Phase 3.4 of the workflow
- Purpose: Understand specific code changes
- Directly informs Phase 4's update plan