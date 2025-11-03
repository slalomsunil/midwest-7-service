# Current State Inventory Template

This template is **MANDATORY** for Phase 1 of the Context Refresher workflow. Following this template structure is **REQUIRED**.

## Template Structure

Use this exact template structure when creating the current state inventory:

```markdown
# Current State Inventory - [Date]

## Context Files Found

### Primary Context Documentation
| File | Location | Last Updated | Size |
|------|----------|--------------|------|
| CLAUDE.md | /path/to/file | 2024-01-15 14:32:10 | 3.2 KB |
| .cursorrules | /path/to/file | 2024-02-20 09:15:22 | 1.8 KB |
| [other files...] | | | |

### Referenced Documentation
*Documentation explicitly mentioned in context files as essential reading*
| File | Location | Last Updated | Size | Referenced By |
|------|----------|--------------|------|---------------|
| README.md | / | 2024-01-10 10:30:00 | 2.1 KB | CLAUDE.md |
| docs/README.md | /docs/ | 2024-01-12 15:45:00 | 4.5 KB | CLAUDE.md |
| [other files...] | | | | |

### Project Documentation
*Broader documentation that serves as AI context*
| File | Location | Last Updated | Size | Type |
|------|----------|--------------|------|------|
| docs/toolkit-architecture.md | /docs/ | 2024-01-08 09:20:00 | 6.8 KB | Architecture |
| docs/module-anatomy.md | /docs/ | 2024-01-09 11:15:00 | 3.2 KB | Development Guide |
| [other files...] | | | | |

### Tool Configurations
[List any tool-specific configuration files found]

## Documentation Coverage Summary

### Currently Documented
- **Technology Stack**: [Key technologies mentioned in docs]
- **Development Patterns**: [Main patterns documented]
- **AI Instructions**: [Types of rules/guidelines present]
- **Project-Specific Context**: [Custom rules or constraints]

### Documentation Age Analysis
- **Oldest File**: [filename] - last updated [date] ([X months/days] ago)
- **Newest File**: [filename] - last updated [date] ([X months/days] ago)
- **Average Age**: [X months/days]

### Documentation Hierarchy Analysis
**Reference Patterns**:
- Context files reference [X] project documentation files
- [X] files are marked as "essential reading" 
- [X] files are mentioned as "ALWAYS read"

**Age Discrepancies**:
- Context files newer than referenced docs: [list any]
- Referenced docs newer than context files: [list any]
- Potential sync issues: [note any significant gaps]

## Initial Observations

### Potential Concerns
[Any immediately obvious issues, such as:]
- Very old documentation (>6 months)
- References to deprecated tools/frameworks
- Inconsistencies between files
- Missing expected documentation

### Documentation Completeness
- [ ] Project overview/context present
- [ ] Technology stack documented
- [ ] Development patterns included
- [ ] Testing approach mentioned
- [ ] Team conventions documented

## Next Steps
Based on this inventory, the next phase will analyze git history from [oldest update date] to present to understand what has changed in the codebase.

---
**IMPORTANT**: Please review this inventory for accuracy before proceeding to Phase 2 (Git History Analysis).
```

## Critical Requirements

### Content Requirements
- **Primary Context Files**: Must list ALL traditional AI context documentation files (CLAUDE.md, .cursorrules, etc.)
- **Referenced Documentation**: Must extract and list files explicitly mentioned in context files as essential reading
- **Project Documentation**: Must identify broader project docs that serve as AI context (README, architecture docs, etc.)
- **Last Updated**: Must use git to get accurate last modification dates for ALL identified files
- **Documentation Hierarchy**: Must analyze how context files reference other documentation
- **Coverage Analysis**: Must summarize what's currently documented across all AI-relevant files
- **Age Discrepancies**: Must identify sync issues between context files and referenced docs

### Accuracy Requirements
- Use `git log -1 --format="%ai"` for accurate timestamps
- Include file paths relative to project root
- Note files not tracked by git separately
- Calculate accurate time spans since last update

### Format Requirements
- Use exact markdown structure as shown above
- Include the date in the title
- Include all mandatory sections
- Use table format for file listings
- Include footer about proceeding to Phase 2

## Usage Notes

- Save to: `build/CURRENT_STATE_INVENTORY.md`
- Created in: Phase 1.4 of the workflow
- Purpose: Establish baseline before analyzing changes
- User must review before proceeding