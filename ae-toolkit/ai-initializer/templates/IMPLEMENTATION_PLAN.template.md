# Implementation Plan Template

This template is **MANDATORY** for all AI agents performing initialization processes. Following this template structure is **REQUIRED**. Deviating from this template structure will result in termination of the agent.

## Template Structure

Use this exact template structure when creating implementation plan documents:

```markdown
# Implementation Plan - [Date]

## Assessment Summary
[Key findings from project analysis]

## User Requirements
[Confirmed preferences, tools, constraints]

### Critical Constraints Validation
[Verify all HARD REQUIREMENTS from USER_PREFERENCES.md are reflected in this plan:
- List each critical constraint and how it's being addressed
- Confirm no default recommendations conflict with user's hard requirements
- Note any adjustments made to accommodate user preferences]

## Implementation Steps
[Specific Phase 5 actions based on WORKFLOW.md]

## File System Battle Map
**MANDATORY: Complete visualization of all planned file operations**

```
[Repository Root]/
├── .github/copilot-instructions.md      [CREATE/MODIFY] - Behavioral rules only
├── docs/                                [CREATE]
│   ├── README.md                        [CREATE] - Navigation hub
│   ├── architecture.md                  [CREATE] - System architecture
│   └── development-guide.md             [CREATE] - Development patterns
├── [Framework1]/docs/                   [CREATE] (if modular approach)
│   └── framework-specific.md            [CREATE] - Framework documentation
└── [Framework2]/docs/                   [CREATE] (if modular approach)
    └── framework-specific.md            [CREATE] - Framework documentation
```

**Legend:**
- [CREATE] - New file/directory to be created
- [MODIFY] - Existing file to be edited
- [DELETE] - File to be removed

## Documentation Planning
[Specific documentation requirements and approach]

### Context Documentation Requirements
[What documentation files need to be created in docs/ directory]

### Base Rules File Requirements
[What base rules file(s) need to be created and where]

### Documentation Integration Strategy
[How new documentation will integrate with existing project structure]

### Interaction Documentation Plan
[Plan for creating the interaction log at the end of Phase 5]

---
**IMPORTANT**: This plan must be interpreted in the context of WORKFLOW.md Phase 5. 
The Phase 5 steps provide the detailed approach for executing this plan.

**CRITICAL**: After implementing this plan, the workflow is complete. Phase 5 includes both technical implementation and interaction documentation creation.
```

## Critical Requirements

### Content Requirements
- **Assessment Summary**: Must include key findings from project analysis performed in Phase 1
- **User Requirements**: Must capture confirmed preferences, tools, and constraints from Phase 3 consultation
- **Implementation Steps**: Must reference specific Phase 5 actions from WORKFLOW.md
- **File System Battle Map**: Must provide complete tree visualization of all planned file operations with clear CREATE/MODIFY/DELETE indicators

### Format Requirements
- Use exact markdown structure as shown above
- Include the date in the title
- Include the footer note about WORKFLOW.md Phase 5 context
- Maintain consistent section headers and formatting

### File Naming Convention
Save implementation plans as:
`${INITIALIZER_MODULE_DIR}/build/IMPLEMENTATION_PLAN.md`

## Mandatory Compliance

This template structure is **NON-NEGOTIABLE**. Agents must:
1. Follow the exact section structure
2. Include all required sections
3. Maintain consistent formatting
4. Include the contextual footer note
5. Use the specified file naming convention

**Failure to comply with this template will result in agent termination.**

## Usage Notes

- This template works in conjunction with the interaction log template
- Both documents should be placed in `${INITIALIZER_MODULE_DIR}/build/`
- The implementation plan is created in Phase 4, the interaction log in Phase 5.4
- Both templates enforce mandatory compliance for consistent documentation