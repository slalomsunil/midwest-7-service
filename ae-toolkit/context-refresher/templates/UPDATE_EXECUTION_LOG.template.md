# Update Execution Log Template

This template is **MANDATORY** for Phase 5 of the Context Refresher workflow. Following this template structure is **REQUIRED**.

## Template Structure

Use this exact template structure when documenting update execution:

```markdown
# Update Execution Log - [Date]

## Execution Summary
- **Start Time**: [timestamp]
- **End Time**: [timestamp]
- **Files Updated**: [number]
- **Updates Applied**: [number]
- **Status**: ✅ Completed Successfully / ⚠️ Completed with Issues / ❌ Failed

## Pre-Execution Checklist
- [x] User approval received on [date/time]
- [x] Update plan reviewed
- [x] No conflicts detected


## Updates Applied

### File: CLAUDE.md
**Update 1**: [Description from plan]
- **Type**: Addition/Removal/Modification
- **Location**: [Section/Line]
- **Status**: ✅ Applied
- **Verification**: Content added successfully at line [X]

**Update 2**: [Description from plan]
- **Type**: Addition/Removal/Modification
- **Location**: [Section/Line]
- **Status**: ✅ Applied
- **Verification**: Old content removed, new content in place

### File: .cursorrules
[Repeat for each file updated]

## Validation Results

### Content Validation
- [x] All additions properly formatted
- [x] All removals completed cleanly
- [x] No unintended changes made
- [x] File syntax valid
- [x] Tool-specific formatting preserved

### Spot Checks
**Check 1**: [Specific validation performed]
- Expected: [what should be there]
- Actual: [what is there]
- Result: ✅ Pass

**Check 2**: [Another validation]
- Expected: [what should be there]
- Actual: [what is there]
- Result: ✅ Pass

## Issues Encountered
[If none, state "No issues encountered"]

### Issue 1: [Title]
- **Description**: [What happened]
- **Resolution**: [How it was resolved]
- **Impact**: [Any impact on the updates]

## Post-Update Verification

### File States
| File | Original Size | New Size | Last Modified |
|------|---------------|----------|---------------|
| CLAUDE.md | [size] | [size] | [timestamp] |
| .cursorrules | [size] | [size] | [timestamp] |

### Git Status
```bash
$ git status
[Include actual git status output showing modified files]
```

## Rollback Information
If rollback needed, use git to revert:
1. `git diff HEAD~1` - Review changes made
2. `git checkout HEAD~1 -- [filename]` - Revert specific file
3. `git reset --hard HEAD~1` - Revert all changes (if committed)

## Completion Checklist
- [x] All planned updates applied
- [x] No unplanned changes made
- [x] Files validated
- [x] Documentation updated

## Next Steps
1. **Test with AI tools**: Try sample prompts to verify improvements
2. **Commit changes**: `git add [files] && git commit -m "Update AI context documentation"`
3. **Team notification**: Share updated documentation with team
4. **Schedule next review**: Recommend reviewing again in [3-6] months

---
**EXECUTION COMPLETE**: All updates have been applied successfully.
```

## Critical Requirements

### Content Requirements
- **Execution Summary**: Must include timing and overall status
- **Updates Applied**: Must list each update with verification
- **Validation**: Must show updates were correctly applied
- **Issues**: Must document any problems encountered

### Accuracy Requirements
- Include actual timestamps
- Show real file sizes
- Include git status output
- Verify each update individually

### Format Requirements
- Use exact markdown structure as shown above
- Include the date in the title
- Use tables for structured data
- Include completion status indicators
- Provide rollback instructions

## Usage Notes

- Save to: `build/UPDATE_EXECUTION_LOG.md`
- Created in: Phase 5.4 of the workflow
- Purpose: Document what was done for audit trail
- Only created if updates were actually made