# Project Analysis Template

This template is **MANDATORY** for all AI agents performing Phase 1 project assessment. Following this template structure is **REQUIRED**. Deviating from this template structure will result in termination of the agent.

## Template Structure

Use this exact template structure when creating project analysis documents:

```markdown
# Project Analysis - [Date]

## Codebase Analysis

### Project Structure
[Directory structure and file organization findings]

### Technology Stack
[Primary programming languages and frameworks identified]

### Architectural Complexity Assessment
[Assessment of architectural sophistication: Standard/Moderate/High complexity using pattern recognition and domain context. Include domain baseline identification and specific evidence of advanced patterns if present.]

### Architectural Evidence
[Specific evidence found for complexity elevation beyond domain baseline - list concrete patterns, frameworks, or architectural boundaries discovered. If standard complexity, note what domain-typical patterns were observed.]

### Documentation Quality
[Current documentation coverage and quality assessment]

## AI Infrastructure Detection

### Existing Context Files
[Inventory of CLAUDE.md, .cursorrules, .github/copilot-instructions.md, etc.]

### AI Tool Configurations
[Current AI development tool configurations found]

### AI Context Organization
[Existing AI context organization documentation discovered]

### Code Quality Standards
[Current code review and quality standards in place]

## Development Workflow Assessment

### Build and Test Processes
[Current build and testing infrastructure analysis]

### Code Review Procedures
[Existing code review practices and tools]

### Documentation Practices
[How documentation is currently maintained]

### Team Collaboration
[Current collaboration patterns and tools identified]

## Summary

### Key Findings
[Top 3-5 most important discoveries about the project]

### Technical Characteristics
[Essential technical details that will inform implementation decisions]

### Current State Assessment
[Overall readiness for AI development enhancement]

---
**IMPORTANT**: This analysis must be reviewed and confirmed by the user before proceeding to Phase 2. 

**CRITICAL**: After user confirms this analysis, the workflow MUST continue to Phase 2 (Gap Analysis and Recommendations). Do not proceed without explicit user approval of this assessment.
```

## Critical Requirements

### Content Requirements
- **Codebase Analysis**: Must include specific findings about project structure, technology stack, scale, and documentation
- **AI Infrastructure Detection**: Must inventory existing AI development tools and configurations
- **Development Workflow Assessment**: Must evaluate current development practices and processes
- **Summary**: Must provide clear key findings and technical characteristics

### Content Guidance
When creating the assessment document, ensure you:
- **Provide clear summary** of project structure, technology stack, and development patterns discovered
- **Present findings** about existing AI infrastructure and context files
- **Summarize current development workflow** observations
- **Request user verification** of assessment accuracy

### Format Requirements
- Use exact markdown structure as shown above
- Include the date in the title
- Include all mandatory sections
- Include the footer note about user confirmation requirement
- Maintain consistent section headers and formatting

### File Naming Convention
Save project analysis documents as:
`${INITIALIZER_MODULE_DIR}/build/PROJECT_ANALYSIS.md`

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
- The project analysis is created in Phase 1.4
- User must explicitly approve the analysis before proceeding to Phase 2
- This template enforces mandatory compliance for consistent documentation