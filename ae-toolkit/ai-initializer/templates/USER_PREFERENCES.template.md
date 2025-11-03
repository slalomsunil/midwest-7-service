# User Preferences Template

This template is **MANDATORY** for all AI agents performing Phase 3 user preferences documentation. Following this template structure is **REQUIRED**. Deviating from this template structure will result in termination of the agent.

## Template Structure

Use this exact template structure when creating user preferences documents:

```markdown
# User Preferences - [Date]

## AI Development Tools and Configurations

### Primary AI Tools
[AI development tools confirmed by user (Claude Code, Cursor, GitHub Copilot, etc.)]

### Tool-Specific Preferences
[User preferences for specific tool configurations and setups]

### Configuration Requirements
[Specific configuration needs or constraints provided by user]

## Team Collaboration Preferences

### Team Size and Structure
[Confirmed team size, roles, and collaboration patterns]

### Development Workflow Preferences
[User preferences for development processes and practices]

### Communication and Documentation Preferences
[How the team prefers to handle documentation and communication]

## Implementation Approach Preferences

### Implementation Strategy
[User preference for gradual vs comprehensive implementation approach]

### Priority Areas
[User-identified priority areas for AI development enhancement]

### Timeline and Resource Constraints
[Any timeline or resource constraints provided by user]

## Project-Specific Requirements

### Context Organization Requirements
[For large projects: user-provided context organization approach or context organization requirements]

### Custom Constraints
[Any project-specific constraints or requirements not apparent from codebase]

### Integration Requirements
[Specific integration needs with existing tools or workflows]

### Critical Implementation Constraints
**HARD REQUIREMENTS** (These MUST be followed exactly):
[Document any non-negotiable user requirements, such as:
- Content separation requirements (e.g., "base rules file must contain ONLY behavioral rules")
- File placement preferences (e.g., "use ai-docs/ instead of docs/")
- Documentation structure preferences (e.g., "modular documentation per framework")
- Any other inflexible requirements that override default recommendations]

## User Concerns and Pain Points

### Current Challenges
[Pain points and workflow challenges identified by user]

### Success Criteria
[What the user considers success for this initialization]

### Risk Tolerance
[User's comfort level with changes and new implementations]

## Validation and Assumptions

### Confirmed Assumptions
[Assessment assumptions validated by user consultation]

### Corrected Assumptions
[Any assessment assumptions corrected during consultation]

### Open Questions Resolved
[Previously unknown information now clarified by user]

---
**IMPORTANT**: These preferences must be reviewed and confirmed by the user before proceeding to Phase 4. 

**CRITICAL**: After user confirms these preferences, the workflow MUST continue to Phase 4 (Implementation Planning). Do not proceed without explicit user approval of these documented preferences.
```

## Critical Requirements

### Content Requirements
- **AI Development Tools and Configurations**: Must capture confirmed AI tools and specific configuration preferences
- **Team Collaboration Preferences**: Must document team structure, workflow, and communication preferences
- **Implementation Approach Preferences**: Must record user's preferred implementation strategy and priorities
- **Project-Specific Requirements**: Must include context organization requirements and custom constraints

### Content Guidance
When creating the user preferences document, ensure you:
- **Document exact user responses** to consultation questions from Phase 3.1
- **Capture specific preferences** not assumptions or inferences
- **Include user-provided constraints** and requirements
- **Request user verification** of documented preferences accuracy

### Format Requirements
- Use exact markdown structure as shown above
- Include the date in the title
- Include all mandatory sections
- Include the footer note about user confirmation requirement
- Maintain consistent section headers and formatting

### File Naming Convention
Save user preferences documents as:
`${INITIALIZER_MODULE_DIR}/build/USER_PREFERENCES.md`

## Mandatory Compliance

This template structure is **NON-NEGOTIABLE**. Agents must:
1. Follow the exact section structure
2. Include all required sections
3. Maintain consistent formatting
4. Include the contextual footer note
5. Use the specified file naming convention

**Failure to comply with this template will result in agent termination.**

## Usage Notes

- This document should be placed in `${INITIALIZER_MODULE_DIR}/build/`
- The user preferences are created in Phase 3.3
- User must explicitly approve the preferences before proceeding to Phase 4
- This template enforces mandatory compliance for consistent documentation