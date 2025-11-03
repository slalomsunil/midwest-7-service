# Rules Manager Workflow

This document outlines the complete step-by-step process for implementing a modular rules system across AI development tools. Read and understand each phase before implementing. Do not skip any instructions or steps

## Overview

The Rules Manager workflow consists of 5 phases:
1. **Assessment** - Analyze current rules and tool usage
2. **Design** - Create modular rule architecture  
3. **Implementation** - Generate base modules and tool configurations
4. **Validation** - Test rules work correctly with target tools
5. **Documentation** - Create maintenance guidance and team handoff

## Phase 1: Assessment

### 1.1 Project Analysis
**Scan for existing AI tool configurations:**
- Look for `CLAUDE.md`, `.claude/instructions.md`
- Look for `.cursorrules` file
- Look for `.github/copilot-instructions.md`
- Check for other AI-related configuration files
- Identify any existing rule patterns or structures

**Document findings in CURRENT_RULES_INVENTORY.md:**
```markdown
# Current Rules Inventory

## Existing Configuration Files
- [List found files with last modified dates]

## Current Rule Patterns
- [Summarize existing rule styles and content]

## Identified Tool Usage
- [List AI tools currently configured or mentioned]
```

### 1.2 User Consultation
**Required questions to ask the user:**
- Which AI development tools does your team currently use?
- Which AI tools would you like to support in the future?
- Are there existing rules or patterns you want to preserve?
- Do you have team-specific standards or requirements?
- Are there any constraints or preferences for file organization?
- What problems are you trying to solve with better rule management?

**Document responses in USER_REQUIREMENTS.md**

### 1.3 Gap Analysis
**Analyze the gap between current state and desired modular system:**
- Identify rule duplication across tools
- Note inconsistencies in rule content or style
- Assess maintenance pain points
- Evaluate tool-specific features being underutilized

**Document in GAP_ANALYSIS.md**

## Phase 2: Design

### 2.1 Rule Module Architecture
**Design the modular structure based on assessment:**

**Core Directory Structure:**
```
.ai-rules/
├── router.md                  # Main entry point with routing logic
├── rules/
│   ├── base/                 # Core rules (always applied)
│   │   ├── core.md          # Communication style & behavior
│   │   ├── session.md       # Session & plan management
│   │   ├── regression.md    # Regression prevention
│   │   ├── collaboration.md # Team collaboration
│   │   ├── context.md       # Context management
│   │   ├── source-control.md # Git practices
│   │   └── rule-evolution.md # Rule creation & maintenance
│   ├── sdlc/                 # Software development lifecycle rules
│   │   ├── define.md        # Requirements & design
│   │   ├── develop.md       # Implementation
│   │   ├── test.md          # Testing & QA
│   │   └── deploy.md        # Deployment & release
│   ├── tech/                 # Technology-specific rules
│   │   ├── node.md          # Node.js patterns
│   │   ├── react.md         # React best practices
│   │   ├── typescript.md    # TypeScript conventions
│   │   └── monorepo.md      # Monorepo management
│   └── user/                 # Personal preferences (gitignored)
│       └── preferences.md   # User-specific overrides
└── drafts/                   # Proposed new rules
```

**Architecture Principles:**
- **Router-based**: Main router.md file determines which rules apply based on context
- **Hierarchical**: Base rules always apply, others apply conditionally
- **Modular**: Each rule file focuses on a single domain
- **Extensible**: Easy to add new technology or SDLC rules
- **Personal**: User-specific overrides without affecting team rules

### 2.2 Tool Configuration Strategy
**Plan tool-specific adaptations:** ALWAYS Identify and READ the template to use for each AI tool based on the assessment and user requirements.

**For GitHub Copilot:**
- Apply `templates/adapters/COPILOT_ADAPTATION.template.md`

**For Claude:**
- Apply `templates/adapters/CLAUDE_ADAPTATION.template.md`

**For Cursor:**
- Apply `templates/adapters/CURSOR_ADAPTATION.template.md`

### 2.3 Get User Approval
**Present the design to the user:**
- Show proposed module structure
- Explain tool configuration strategy
- ALWAYS verify what tool specific template will be used
- Get explicit approval before proceeding to implementation

**Document approved design in ARCHITECTURE_PLAN.md**

## Phase 3: Implementation

### 3.1 Create Rule Architecture

**Create `.ai-rules/` directory structure: defined in `WORKFLOW.md` Phase 2.1**

**Generate rule content using templates:**
- If one of the templates below does not exist or is empty create an empty rule file with a comment explaining the purpose of the file.
- **Router**: Copy content from `templates/structure/ROUTER.template.md` to create `.ai-rules/router.md`
- **Base Rules**: Copy content from the following templates for base rule modules from `templates/content/`. If a template file doesn't exist, create an empty file with a comment explaining the purpose of the file:
  - `templates/content/BASE_CORE.template.md` → `rules/base/core.md`
  - `templates/content/BASE_SESSION.template.md` → `rules/base/session.md`
  - `templates/content/BASE_REGRESSION.template.md` → `rules/base/regression.md`
  - `templates/content/BASE_COLLABORATION.template.md` → `rules/base/collaboration.md`
  - `templates/content/BASE_CONTEXT.template.md` → `rules/base/context.md`
  - `templates/content/BASE_SOURCE_CONTROL.template.md` → `rules/base/source-control.md`
  - `templates/content/BASE_RULE_EVOLUTION.template.md` → `rules/base/rule-evolution.md`
- **SDLC Rules**: Copy content from SDLC templates based on project needs from `templates/content/`. If a template file doesn't exist, create an empty file with a comment noting the missing template:
  - `templates/content/SDLC_DEFINE.template.md` → `rules/sdlc/define.md`
  - `templates/content/SDLC_DEVELOP.template.md` → `rules/sdlc/develop.md`
  - `templates/content/SDLC_TEST.template.md` → `rules/sdlc/test.md`
  - `templates/content/SDLC_DEPLOY.template.md` → `rules/sdlc/deploy.md`
- **Technology Rules**: Create technology rules based on project stack, for example `rules/tech/react.md` for React projects, `rules/tech/typescript.md` for TypeScript projects, etc.
- **User Preferences**: Copy content from `templates/structure/PROJECT_CONTEXT.template.md` as starting point for user customizations

**Router Implementation:**
- Main entry point that determines which rule modules to apply
- Context-aware routing based on file types, project structure, and user intent
- Provides rule precedence and conflict resolution
- Includes rule discovery and loading logic

**Base Rules (Always Applied):**
- Core communication and behavior patterns
- Session management and planning approaches
- Regression prevention and quality assurance
- Team collaboration and context management
- Git practices and rule evolution guidelines

**Conditional Rules:**
- SDLC rules applied based on development phase context
- Technology rules applied based on file extensions and project structure
- User preferences override team rules when appropriate

### 3.2 Generate Tool Configurations

**CRITICAL: This step is MANDATORY and cannot be skipped.**

#### 3.2.1 Tool Adaptation Template Selection
**Before implementing any tool configuration, you MUST:**
1. **Read the complete adaptation template** for the target tool from `templates/adapters/`
2. **Verify with the user which template is being used** 
3. **Create a checklist** from the template requirements before starting
4. **Confirm all template sections** are understood before proceeding

#### 3.2.2 Template Compliance Verification
**After reading the adaptation template, you MUST:**
1. **Document all required files and directories** from the template
2. **Identify all mandatory front matter fields** and their formats
3. **Note all validation requirements** specified in the template
4. **Create implementation order** based on template dependencies

#### 3.2.3 Implementation Execution
**For each target tool:**
1. **Start with base rule content** (never duplicate base rules in tool configurations)
2. **Apply the specific adaptation template** following ALL requirements exactly
3. **Create directory structure** as specified in the template
4. **Generate individual files** with proper front matter and formatting
5. **Add tool-specific enhancements** while maintaining semantic equivalence
6. **Reference base rules** through links, never duplicate content
7. **Follow tool documentation** and established best practices

#### 3.2.4 Mandatory Template Compliance Check
**Before proceeding to validation, verify:**
- ✅ **All required directories** from the template are created
- ✅ **All required files** from the template are generated
- ✅ **All front matter fields** are included with correct formats
- ✅ **All applyTo patterns** (for Copilot) target correct file types
- ✅ **All base rule references** are links, not duplicated content
- ✅ **All validation requirements** from the template are addressed


### 3.3 Create Rule Manifest
**Generate `RULES_MANIFEST.md`:**
```markdown
# Rules Manifest

## Router Configuration
- Primary entry point: `.ai-rules/router.md`
- Rule discovery mechanism: [automated/manual]
- Context detection: [file-based/project-based/user-input]

## Active Rule Categories
### Base Rules (Always Applied)
- [List base rule modules with descriptions]

### SDLC Rules (Context-Dependent)
- [List SDLC rule modules and trigger conditions]

### Technology Rules (File/Project-Dependent)
- [List technology rule modules and detection patterns]

### User Preferences
- [Document user override capabilities]

## Tool Integrations
- [List generated tool configuration files and their routing]

## Rule Precedence
1. User preferences (highest priority)
2. Technology-specific rules
3. SDLC phase rules
4. Base rules (always applied)

## Last Updated
- [Date and description of last update]
```

## Phase 4: Validation

### 4.1 Test Tool Recognition
**For each generated configuration:**
- Verify the AI tool recognizes the configuration file
- Test that rules are being applied correctly
- Check for any syntax errors or format issues
- Confirm tool-specific features work as expected

**Tool-Specific Validation:**
For each tool, follow validation requirements specified in the corresponding adaptation template:
- **Copilot**: Verify VS Code recognition, `applyTo` pattern functionality, and `.ai-rules/` accessibility
- **Claude**: Test progressive disclosure navigation and context loading
- **Cursor**: Validate plain text format and command-style rule application

### 4.2 Cross-Tool Consistency
**Validate consistency across tools:**
- Compare behavior across different AI tools
- Ensure semantic equivalence of base rules
- Verify no contradictory instructions between tools
- Test edge cases and error scenarios

### 4.3 User Acceptance Testing
**Get user confirmation:**
- Demo the working rule system
- Show how rules appear in each tool
- Validate behavior meets user expectations
- Get approval to proceed with documentation

**Document test results in VALIDATION_REPORT.md**

## Phase 5: Documentation

### 5.1 Create Deployment Guide
**Generate `DEPLOYMENT_GUIDE.md`:**
```markdown
# Rules Deployment Guide

## Quick Setup
[Instructions for new team members]

## File Locations
[Where each configuration file should be placed]

## Tool-Specific Setup
[Setup instructions for each AI tool]

## Troubleshooting
[Common issues and solutions]
```

### 5.2 Create Maintenance Guide
**Generate `MAINTENANCE_GUIDE.md`:**
```markdown
# Rules Maintenance Guide

## Adding New Rules
[How to extend the system]

## Updating Existing Rules
[How to modify base modules and regenerate configurations]

## Tool Updates
[How to adapt when AI tools change]

## Team Coordination
[How teams should collaborate on rule changes]
```

### 5.3 Final Handoff
**Provide complete handoff to user:**
- Summary of what was implemented
- Documentation of the modular architecture
- Instructions for ongoing maintenance
- Contact information for support (if applicable)

**Create final summary in IMPLEMENTATION_SUMMARY.md**

## Build Artifacts

All workflow artifacts should be saved to `${RULES_MANAGER_MODULE_DIR}/build/` directory:
- `CURRENT_RULES_INVENTORY.md`
- `USER_REQUIREMENTS.md`  
- `GAP_ANALYSIS.md`
- `ARCHITECTURE_PLAN.md`
- `VALIDATION_REPORT.md`
- `IMPLEMENTATION_SUMMARY.md`

## Error Handling

**If user requirements change mid-workflow:**
- Stop current phase
- Update requirements documentation
- Adjust design as needed
- Get user approval before proceeding

**If tool configuration fails validation:**
- Document specific issues
- Research tool documentation
- Adjust configuration approach
- Re-test before proceeding

**If user is unsatisfied with results:**
- Pause implementation
- Gather specific feedback
- Revise approach as needed
- Get approval before continuing

## Success Metrics

Refer to the complete success criteria in `RULES_MANAGER_PROMPT.md`. The workflow is successful when all success criteria are met, particularly:
- ✅ All target AI tools recognize and use generated configurations
- ✅ Rules are consistent across tools while leveraging tool-specific features
- ✅ User approves the final implementation and architecture
- ✅ Documentation enables team maintenance and extension
- ✅ Router system provides intelligent context-aware rule loading
