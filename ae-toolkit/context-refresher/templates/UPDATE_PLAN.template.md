# Update Plan Template

This template is **MANDATORY** for Phase 4 of the Context Refresher workflow. Following this template structure is **REQUIRED**.

## Template Structure for Updates Needed

Use this structure when updates are required:

```markdown
# Update Plan - [Date]

## Plan Summary
**Updates Required**: Yes
**Files to Update**: [number]
**Estimated Scope**: [Minor/Moderate/Major]

## Table of Contents
- [File System Battle Map](#file-system-battle-map)
- [Executive Summary](#executive-summary) 
- [Priority Order](#priority-order)
- [Proposed Updates by File](#proposed-updates-by-file)
- [Implementation Notes](#implementation-notes)
- [Risk Assessment](#risk-assessment)

## File System Battle Map
**MANDATORY: Complete visualization of all planned file operations**

```
[Repository Root]/
├── [File1]                             [MODIFY] CRITICAL - Remove deprecated patterns, add current tech
├── [File2]                             [MODIFY] HIGH - Add framework-specific rules  
├── [File3]                             [MODIFY] MEDIUM - Minor coding standard updates
├── [File4]                             [MODIFY] HIGH - Update architecture references
└── [File5]                             [CREATE] MEDIUM - Document current system design
```

**Legend:**
- [CREATE] - New file/directory to be created
- [MODIFY] - Existing file to be edited  
- [DELETE] - File to be removed

## Executive Summary
**Quick scan of all planned changes organized by priority and type**

### Critical Changes
- **[File1]** → Remove deprecated Redux patterns, add Zustand state management
- **[File4]** → Update architecture section for new framework stack

### High Priority Changes  
- **[File2]** → Add new framework-specific rules for current tech stack
- **[File5]** → Create comprehensive architecture documentation

### Summary Statistics
- **Files Modified**: [X] files
- **Additions**: [Y] new sections/patterns
- **Removals**: [Z] deprecated sections
- **Updates**: [W] modified sections

## Priority Order
1. **Critical**: [Updates that could cause errors if not fixed]
2. **High**: [Updates that significantly improve accuracy] 
3. **Medium**: [Updates that enhance clarity]
4. **Low**: [Minor improvements]

## Proposed Updates by File

### [File1]
- [Update] [Description of what needs to change from current state to desired state]
- [Remove] [Description of content/section that should be removed and why]
- [Add] [Description of new content/section that needs to be added]

### [File2]  
- [Update] [Description of what needs to change from current state to desired state]
- [Add] [Description of new content/section that needs to be added]

### [File3]
- [Remove] [Description of content/section that should be removed and why]
- [Update] [Description of what needs to change from current state to desired state]

## Implementation Notes
- Preserve existing formatting style
- Maintain tool-specific requirements
- Keep documentation concise and actionable
- Test with actual AI tools after updates

## Risk Assessment
**If Not Updated**:
- AI will continue suggesting [deprecated pattern]
- Developers may use outdated [technology]
- Confusion about current [practice]

**Update Benefits**:
- AI suggestions align with current codebase
- Reduced incorrect recommendations
- Clearer guidance for new developers

## Approval Request
Please review this update plan. Upon approval, Phase 5 will:
1. Apply updates in priority order
2. Validate changes
3. Create execution log

**Type 'approved' to proceed with updates or provide feedback for plan revision.**

---
**IMPORTANT**: No changes will be made until you explicitly approve this plan.
```

## Template Structure for No Updates Needed

Use this structure when NO updates are required:

```markdown
# Update Plan - [Date]

## Plan Summary
**Updates Required**: No
**Assessment Result**: Documentation is current

## File System Battle Map
**Files Analyzed (No Changes Required)**

```
[Repository Root]/
├── [File1]                             [ANALYZED] - Current and accurate
├── [File2]                             [ANALYZED] - Matches codebase patterns
├── [File3]                             [ANALYZED] - Rules still valid
└── [File4]                             [ANALYZED] - Documentation current
```

**Legend:**
- [ANALYZED] - File was reviewed and found to be current

## Analysis Summary  
**Why no changes are required**

### What Was Checked
- Analyzed [X] months of git history
- Reviewed [Y] commits
- Examined changes to [list key areas]
- Compared current docs against codebase state

### Why No Updates Needed

#### Technology Stack
**Documented**: [What docs say]
**Current Reality**: [What code shows]
**Status**: ✅ Matches current implementation

#### Development Patterns
**Documented**: [What docs say]
**Current Reality**: [What code shows]
**Status**: ✅ Accurately documented

#### Best Practices
**Documented**: [What docs say]
**Current Reality**: [What code shows]
**Status**: ✅ Still current and valid

### Supporting Evidence
1. **No Major Framework Changes**: 
   - Last major change was [date], already documented
   
2. **Patterns Remain Consistent**:
   - Coding patterns from [date] still in use
   - No deprecations found

3. **Dependencies Stable**:
   - Minor version updates only
   - No breaking changes requiring doc updates

## Minor Observations
[Note any minor items that don't warrant updates]
- [Small inconsistency that doesn't impact usage]
- [Potential future consideration]

## Recommendation
Current documentation accurately reflects the codebase state. No updates required at this time.

**Next Review**: Recommend reviewing again in [3-6] months or after next major feature/refactor.

---
**RESULT**: Documentation is current. No Phase 5 execution needed.
```

## Critical Requirements

### Content Requirements for Updates
- **Comprehensive Coverage**: Must address ALL types of AI-relevant documentation (primary context files, referenced documentation, project documentation)
- **Specific Changes**: Must provide exact content to add/remove/update for each file type
- **Location**: Must specify where in each file
- **Rationale**: Must explain why each change is needed
- **Cross-File Dependencies**: Must identify when updates to one file require changes to referenced files
- **Priority**: Must organize by importance across all documentation types

### Content Requirements for No Updates
- **Evidence**: Must provide evidence documentation is current
- **Comparison**: Must show docs match reality
- **Next Steps**: Must suggest when to review again

### Format Requirements
- Use appropriate template based on outcome
- Include the date in the title
- Be specific about proposed changes
- Include code/content blocks
- Clear approval request or conclusion

## Usage Notes

- Save to: `build/UPDATE_PLAN.md`
- Created in: Phase 4.4 of the workflow
- Purpose: Get user approval before making changes
- Determines if Phase 5 executes