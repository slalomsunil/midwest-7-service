# AI Gap Analysis Template

This template is **MANDATORY** for all AI agents performing Phase 2 gap analysis. Following this template structure is **REQUIRED**. Deviating from this template structure will result in termination of the agent.

## Template Structure

Use this exact template structure when creating AI gap analysis documents:

```markdown
# AI Gap Analysis - [Date]

## Context Infrastructure Gap Analysis

### Missing Context Files
[Identification of missing context files for any AI tools (examples: CLAUDE.md, .cursorrules, .github/copilot-instructions.md)]

### Context File Quality Assessment
[If context files exist, assessment of quality and completeness]

### Context Infrastructure Recommendations
[Specific recommendations for creating or improving context documentation]

## Context Organization Gap Analysis

### Missing Context Organization Documentation
[Assessment of missing AI context organization approach based on project size]

### Existing Context Organization Evaluation
[If context organization approach exists, evaluation of current effectiveness]

### Context Organization Recommendations
[Specific recommendations for context organization implementation or enhancement]

## Rules and Standards Gap Analysis

### Missing AI Rules
[Identification of missing AI development rules and guidelines]

### Existing Rules Audit
[If rules exist, audit of current rules for completeness]

### Rules and Standards Recommendations
[Specific recommendations for rule sets and quality standards]

## Prioritized Recommendations

### High Priority
[Most critical gaps that need immediate attention]

### Medium Priority
[Important gaps that should be addressed]

### Low Priority
[Nice-to-have improvements for future consideration]

## Implementation Impact Assessment

### Expected Benefits
[Anticipated improvements from addressing identified gaps]

### Resource Requirements
[Estimation of effort needed for implementation]

### Risk Assessment
[Potential challenges or risks in implementing recommendations]

---
**IMPORTANT**: This gap analysis must be reviewed and confirmed by the user before proceeding to Phase 3. 

**CRITICAL**: After user confirms this analysis, the workflow MUST continue to Phase 3 (User Interaction and Customization). Do not proceed without explicit user approval of this gap analysis.
```

## Critical Requirements

### Content Requirements
- **Context Infrastructure Gap Analysis**: Must identify missing or inadequate context files and configurations
- **Context Organization Gap Analysis**: Must assess context organization documentation needs based on project characteristics
- **Rules and Standards Gap Analysis**: Must evaluate AI development rules and quality standards
- **Prioritized Recommendations**: Must provide clear prioritization of identified gaps

### Content Guidance
When creating the gap analysis document, ensure you:
- **Provide clear summary** of identified gaps in AI infrastructure, context organization, and rules
- **Present prioritized recommendations** based on project assessment
- **Explain rationale** for each recommendation and its expected impact
- **Request user verification** of gap analysis accuracy and recommendation priorities

### Format Requirements
- Use exact markdown structure as shown above
- Include the date in the title
- Include all mandatory sections
- Include the footer note about user confirmation requirement
- Maintain consistent section headers and formatting

### File Naming Convention
Save AI gap analysis documents as:
`${INITIALIZER_MODULE_DIR}/build/AI_GAP_ANALYSIS.md`

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
- The AI gap analysis is created in Phase 2.4
- User must explicitly approve the analysis before proceeding to Phase 3
- This template enforces mandatory compliance for consistent documentation