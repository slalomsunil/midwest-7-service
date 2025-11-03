# Commit History Analysis Template

This template is **MANDATORY** for Phase 2 of the Context Refresher workflow. Following this template structure is **REQUIRED**.

## Template Structure

Use this exact template structure when creating the commit history analysis:

```markdown
# Commit History Analysis - [Date]

## Analysis Period
- **Start Date**: [Last documentation update date from Phase 1]
- **End Date**: [Current date]
- **Time Span**: [X months/days]
- **Total Commits**: [Number analyzed]

## Major Changes Timeline

### [Month/Year]
**Key Changes**:
- [Significant commit or pattern]
- [Another significant change]

**Example Commits**:
```
abc1234 2024-01-15 Migrate from Redux to Zustand
def5678 2024-01-20 Remove Redux dependencies
```

### [Month/Year]
**Key Changes**:
- [Continue chronologically...]

## Pattern Analysis

### New Technologies/Frameworks Introduced
- **[Technology]**: First seen [date], [X] commits
  - Key commits: [list 2-3 most significant]
- **[Technology]**: First seen [date], [X] commits
  - Key commits: [list 2-3 most significant]

### Deprecated/Removed Technologies
- **[Technology]**: Last seen [date], removed in [commit]
- **[Technology]**: Deprecation started [date]

### Major Refactoring Patterns
[Identify significant refactoring efforts]
- **[Pattern Name]**: [Date range], [Description]
  - Example: "Component restructuring": Jan-Feb 2024, Moved from class to functional components

### Feature Additions
[New capabilities that might need documentation]
- **[Feature]**: Added [date], [brief description]
- **[Feature]**: Added [date], [brief description]

## Keyword Frequency Analysis
Based on commit messages:
- "migrate/migration": [X] occurrences
- "refactor": [X] occurrences  
- "deprecated/remove": [X] occurrences
- "add/new": [X] occurrences
- "update/upgrade": [X] occurrences

## Areas of Significant Activity
Directories/files with most changes:
1. **[path]**: [X] commits - [type of changes]
2. **[path]**: [X] commits - [type of changes]
3. **[path]**: [X] commits - [type of changes]

## Summary of Evolution

### High-Level Changes
[2-3 bullet points summarizing the major evolution]
- Migrated from [X] to [Y] architecture
- Adopted [new technology/pattern]
- Removed legacy [system/pattern]

### Documentation Impact Assessment
Based on commit history, these areas likely need documentation updates:
- [ ] Technology stack changes
- [ ] New patterns/conventions
- [ ] Deprecated patterns to remove
- [ ] New features/capabilities
- [ ] Testing approach changes

## Next Steps
Phase 3 will perform detailed diff analysis on:
- [Key file/directory 1]
- [Key file/directory 2]
- [Key file/directory 3]

---
**NOTE**: This analysis is based on commit messages and high-level patterns. Phase 3 will examine actual code changes in detail.
```

## Critical Requirements

### Content Requirements
- **Analysis Period**: Must clearly state the time range analyzed
- **Timeline**: Must organize changes chronologically
- **Pattern Analysis**: Must identify technology/framework changes
- **Keyword Analysis**: Must quantify change-related keywords
- **Impact Assessment**: Must link findings to documentation needs

### Git Command Usage
Required git commands for accurate analysis:
```bash
# Get all commits in date range
git log --since="[date]" --format="%h %ai %s"

# Search for specific keywords
git log --grep="migrate\|refactor" --since="[date]"

# Count commits by path
git log --since="[date]" --format="" --name-only | sort | uniq -c
```

### Format Requirements
- Use exact markdown structure as shown above
- Include the date in the title
- Group changes by time period
- Use code blocks for commit examples
- Include summary and next steps sections

## Usage Notes

- Save to: `build/COMMIT_HISTORY_ANALYSIS.md`
- Created in: Phase 2.4 of the workflow
- Purpose: Understand what changed at a high level
- Guides Phase 3's detailed analysis