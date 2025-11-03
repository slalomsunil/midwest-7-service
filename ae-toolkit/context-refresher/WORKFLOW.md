# Context Refresher Workflow

This document describes the step-by-step process for updating stale AI context documentation by analyzing git history and code changes.

## Overview

The Context Refresher uses a five-phase approach to systematically identify and update outdated AI context documentation:

1. **Current State Assessment** - Inventory what exists now
2. **Git History Analysis** - Understand changes via commit history  
3. **Deep Diff Analysis** - Examine specific code changes
4. **Update Planning** - Create actionable update plan
5. **Plan Execution** - Apply approved updates (if needed)

Each phase produces a concrete output document that builds toward either updating documentation or confirming it's already current.

## Phase 1: Current State Assessment

### 1.1 Context File Discovery
- **Objective**: Find all AI context documentation files and related project documentation
- **Actions**:
  - Search for primary context files: CLAUDE.md, .cursorrules, .github/copilot-instructions.md
  - Check for tool-specific configurations
  - Identify any custom context documentation
  - **Extract documentation references**: Read context files to identify files they reference as essential reading
  - **Search for project documentation**: Find broader project docs that serve as AI context (README files, docs/ directory, architecture documentation)
  - Note file locations and sizes for ALL identified documentation

### 1.2 Last Update Analysis
- **Objective**: Determine when each AI-relevant documentation file was last modified
- **Actions**:
  - Use `git log -1 --format="%ai" -- [filename]` for ALL identified files (context files AND referenced documentation)
  - Record last modification dates for primary context files, referenced documentation, and project documentation
  - Identify which files are oldest/newest across all categories
  - **Cross-reference analysis**: Compare update dates between context files and the documentation they reference
  - Note any files not tracked by git

### 1.3 Current Content Review
- **Objective**: Understand what's currently documented across all AI-relevant files
- **Actions**:
  - Read each primary context file
  - Read key referenced documentation files
  - **Analyze documentation hierarchy**: Understand how context files point to and rely on other documentation
  - Summarize key rules and patterns documented across all files
  - Note technology stack references
  - **Identify synchronization issues**: Look for cases where context files reference documentation that may be outdated
  - Identify any obviously outdated content in any category of documentation

### 1.4 Create Current State Inventory
- **Objective**: Document comprehensive findings for user review
- **Actions**:
  - Create `build/CURRENT_STATE_INVENTORY.md` using the mandatory template
  - List all primary context files, referenced documentation, and project documentation with last update dates
  - **Document the documentation hierarchy**: Show which context files reference which other documentation
  - **Analyze age discrepancies**: Highlight cases where context files and their referenced documentation have significant update time differences
  - Summarize current documentation coverage across all AI-relevant files
  - Flag any immediate concerns, especially sync issues between interdependent documentation

**CRITICAL**: User must review and acknowledge the inventory before proceeding to Phase 2.

## Phase 2: Git History Analysis

### 2.1 Establish Time Range
- **Objective**: Define the analysis period
- **Actions**:
  - Use oldest context file modification date as starting point
  - Use current date as end point
  - Calculate time span (e.g., "6 months")
  - Document the analysis range

### 2.2 Extract Commit History
- **Objective**: Get high-level view of changes
- **Actions**:
  - Run: `git log --oneline --since="[date]" --format="%h %ai %s"`
  - Filter for meaningful commits (exclude routine updates)
  - Group commits by topic/feature
  - Identify major milestones or refactors

### 2.3 Identify Key Patterns
- **Objective**: Find patterns in commit messages
- **Actions**:
  - Search for keywords: "migrate", "refactor", "deprecate", "add", "remove"
  - Look for framework/library changes
  - Note architectural shifts
  - Identify new features or capabilities

### 2.4 Create Commit History Analysis
- **Objective**: Document timeline of changes
- **Actions**:
  - Create `build/COMMIT_HISTORY_ANALYSIS.md` using the mandatory template
  - Organize changes chronologically
  - Highlight significant patterns
  - Summarize key evolution points

**CRITICAL**: This provides the rough timeline that guides Phase 3's detailed analysis.

## Phase 3: Deep Diff Analysis

### 3.1 Identify Critical Files
- **Objective**: Determine which files to analyze in detail
- **Actions**:
  - Based on Phase 2, identify files/directories with significant changes
  - Focus on: configuration files, main application files, test structures
  - Prioritize files mentioned in current context documentation
  - Create list of files for deep analysis

### 3.2 Perform Targeted Diffs
- **Objective**: Understand specific changes
- **Actions**:
  - For each critical file: `git diff [last-update-date] HEAD -- [file]`
  - Analyze package.json/requirements.txt for dependency changes
  - Review configuration file changes
  - Examine architectural file modifications

### 3.3 Extract Pattern Changes
- **Objective**: Identify what needs documentation updates
- **Actions**:
  - Note new patterns introduced
  - Identify deprecated patterns still documented
  - Find technology stack changes
  - Discover new conventions or standards

### 3.4 Create Diff Analysis Document
- **Objective**: Document specific changes found
- **Actions**:
  - Create `build/DIFF_ANALYSIS.md` using the mandatory template
  - Organize by impact area (deps, patterns, architecture)
  - Include relevant diff snippets
  - Map changes to current documentation gaps

**CRITICAL**: This analysis directly informs what updates are needed (if any).

### 3.5 Documentation Coverage Check
- **Objective**: Verify identified code additions are covered in AI context documentation
- **Actions**:
  - For each significant addition found in git diffs:
    - Check if it's mentioned in current AI context docs (CLAUDE.md, .cursorrules, etc.)
    - Determine what type of documentation it should have based on project patterns
  - Identify project's documentation patterns:
    - How are similar features documented in AI context?
    - What level of detail is typically included?
    - Where in the docs are different types of information placed?
  - Flag gaps where identified functionality lacks appropriate AI context documentation

**Example Coverage Checks**:
- New API endpoint added → Is it mentioned in AI context docs?
- New utility function created → Does AI know when to use it?
- New configuration option → Is it documented for AI to suggest correctly?
- New project structure → Does AI understand the organization?

## Phase 4: Update Planning

### 4.1 Map Changes to Documentation
- **Objective**: Connect findings to needed updates
- **Actions**:
  - For each change found, determine if it needs documentation
  - Check if current docs already cover the change
  - Identify outdated content that needs removal
  - Note new content that needs addition
  - Identify which code additions need AI context documentation

### 4.2 Prioritize Updates
- **Objective**: Order updates by importance
- **Actions**:
  - Critical: Deprecated patterns still documented
  - High: New major patterns not documented
  - Medium: Minor pattern updates
  - Low: Clarifications or minor adjustments

### 4.3 Draft Update Content
- **Objective**: Create specific update proposals
- **Actions**:
  - Write specific additions needed
  - Mark specific deletions needed
  - Suggest reformatting where helpful
  - Maintain consistency with existing style

### 4.4 Create Update Plan
- **Objective**: Present plan for user approval
- **Actions**:
  - Create `build/UPDATE_PLAN.md` using the mandatory template
  - List each proposed change with rationale
  - Group by context file affected
  - **MAY CONCLUDE**: "No changes required" with evidence

**CRITICAL DECISION POINT**: 
- If changes needed → User approves → Proceed to Phase 5
- If no changes needed → Document this → Workflow complete

## Phase 5: Plan Execution (CONDITIONAL)

**PREREQUISITE**: This phase ONLY executes if Phase 4 identified needed changes AND user approved the plan.

### 5.1 Apply Updates
- **Objective**: Execute the approved plan
- **Actions**:
  - Apply each update from the plan in order
  - Maintain formatting consistency
  - Preserve any tool-specific requirements
  - Track each change made

### 5.2 Validate Updates
- **Objective**: Ensure updates are correct
- **Actions**:
  - Review updated files for completeness
  - Check no accidental changes were made
  - Verify tool-specific formats maintained
  - Confirm all planned updates applied

### 5.3 Create Execution Log
- **Objective**: Document what was done
- **Actions**:
  - Create `build/UPDATE_EXECUTION_LOG.md` using the mandatory template
  - List each file modified
  - Document specific changes made
  - Include validation results
  - Note any issues encountered

**COMPLETION**: Updated context documentation is now current with codebase state.

## Success Outcomes

### Outcome 1: Updates Required and Executed
- Analysis revealed documentation was stale
- Specific updates were identified
- User approved the update plan
- Updates were successfully applied
- Documentation now matches current codebase

### Outcome 2: No Updates Required
- Analysis revealed documentation is current
- No significant gaps identified
- Update plan states "No changes required"
- User gains confidence in documentation accuracy
- No execution phase needed

Both outcomes represent successful completion of the workflow.

## Example Outputs

For detailed examples of Context Refresher outputs, see the `examples/` directory:

- `examples/updates-required.md` - Complete workflow example showing a team migrating from Redux to Zustand, including specific update plan with additions, removals, and priority ordering
- `examples/no-changes-needed.md` - Complete workflow example showing analysis that concludes documentation is already current, with supporting evidence

These examples demonstrate both possible outcomes and show the structure and detail level expected in each phase's output documents.

## Common Scenarios

### Scenario: Major Framework Migration
**Example**: React class components → hooks (see `examples/updates-required.md` for Redux → Zustand migration)
- Phase 2 reveals migration commits over time
- Phase 3 shows specific pattern changes
- Phase 4 plans removal of class component docs, addition of hooks docs
- Phase 5 executes the updates

### Scenario: Gradual Evolution
**Example**: Incremental TypeScript adoption
- Phase 2 shows gradual TS file additions
- Phase 3 reveals mixed JS/TS patterns
- Phase 4 plans docs for hybrid approach
- Phase 5 updates to reflect current state

### Scenario: Documentation Is Current
**Example**: Recently updated docs (see `examples/no-changes-needed.md` for complete analysis)
- Phase 2 shows only minor commits
- Phase 3 reveals no pattern changes
- Phase 4 concludes "No changes required"
- Phase 5 skipped entirely

## Git Commands Reference

Essential git commands used throughout the workflow:

```bash
# Get last modification date of a file
git log -1 --format="%ai" -- CLAUDE.md

# Get commit history since date
git log --oneline --since="2024-01-01" --format="%h %ai %s"

# Get detailed diff since date
git diff $(git rev-list -1 --before="2024-01-01" HEAD) HEAD -- src/

# Find when file was last modified
git log -1 --format="%h %ai %an" -- .cursorrules

# Search commits for keywords
git log --grep="migrate\|refactor\|deprecate" --since="6 months ago"
```

## Troubleshooting

### Issue: Cannot determine last update date
**Solution**: Ask user for approximate date or use a reasonable default (6 months)

### Issue: Too many changes to analyze
**Solution**: Focus on most significant changes, group similar updates

### Issue: Git history is incomplete
**Solution**: Document limitation, do best-effort analysis with available data

### Issue: Conflicting changes detected
**Solution**: Document conflicts in plan, let user decide resolution

## Next Steps

After workflow completion:
1. If updates were made, suggest testing with AI tools
2. Recommend setting a regular review schedule
3. Consider documenting the update process decisions
4. Share learnings with team