# Rules Manager

**A modular rules engine for AI development tools with tool-agnostic base rules and tool-specific adaptations.**

The Rules Manager provides a structured approach to organizing and deploying AI development rules across different tools (Claude, Cursor, Copilot, etc.) while maintaining consistency and avoiding duplication.

## The Solution

A router-based modular rules architecture that:
1. **Routes intelligently** - Main router determines which rules apply based on context
2. **Separates concerns** - Base rules, SDLC phases, technology, and user preferences
3. **Enables composition** - Automatic rule loading based on file types and project structure
4. **Supports tool conventions** - Adapts router system to each tool's format and features
5. **Promotes reusability** - Rules can be shared across projects and teams
6. **Simplifies maintenance** - Update router logic once, affects all tool configurations

## Quick Start

> **Not sure if this module is right for your situation?** Check the [Getting Started Guide](../getting-started/README.md) for guidance on when to use each toolkit module.

### 1. Activate the Rules Manager

# Rules Manager Activation Prompt

Copy and paste this prompt to activate the Rules Manager in any AI chat interface:

---

**I need to set up a modular rules system for my project that works across different AI development tools. Please load the Rules Manager system prompt from `ae-toolkit/rules-manager/RULES_MANAGER_PROMPT.md` and activate Rules-Manager mode to help me organize and deploy consistent rules.**

**Project Context:**
- If available, project context should be sourced from "ae-toolkit/ai-initializer/build/PROJECT_ANALYSIS.md"

- My project uses: [DESCRIBE YOUR PROJECT TYPE AND TECH STACK]
- Current AI tools: [LIST CURRENT AI TOOLS LIKE COPILOT, CLAUDE, CURSOR]
- Team size: [NUMBER OF DEVELOPERS]
- Main challenges: [DESCRIBE CURRENT RULE MANAGEMENT PROBLEMS]

**Desired Outcome:**
- [ ] Router-based rules system with intelligent context detection
- [ ] Base rules that always apply across all interactions
- [ ] SDLC and technology rules that apply based on context
- [ ] Tool-specific configurations that leverage each tool's features  
- [ ] User preference overrides without affecting team rules
- [ ] Easy maintenance and team collaboration
- [ ] Future portability between tools

**Constraints:**
- [LIST ANY SPECIFIC REQUIREMENTS OR LIMITATIONS]
- [MENTION EXISTING RULES TO PRESERVE]
- [NOTE TEAM PREFERENCES OR STANDARDS]

Please start by analyzing my current setup and guiding me through the Rules Manager workflow to create a router-based modular rules system with intelligent context detection.

---

### 2. Follow the Setup Process

The manager will guide you through:
- **Assessment**: Review your project and current AI tool usage
- **Rule Selection**: Design router-based rule architecture for your needs
- **Implementation**: Create router, base rules, and context-specific modules
- **Tool Configuration**: Generate tool-specific configuration files that reference the router
- **Validation**: Test rules work correctly with your chosen tools
- **Documentation**: Create maintenance and team guidance

### 3. Generated Outputs

The process creates:
- `.ai-rules/router.md` - Main entry point with intelligent routing logic
- `.ai-rules/rules/base/` - Foundational rules that always apply
- `.ai-rules/rules/sdlc/` - Development phase-specific rules
- `.ai-rules/rules/tech/` - Technology and framework-specific rules
- `.ai-rules/rules/user/` - Personal preference overrides (gitignored)
- Tool-specific configurations that reference the router system
- `RULES_MANIFEST.md` - Documentation of router logic and active rules
- `DEPLOYMENT_GUIDE.md` - Instructions for team members and CI/CD

## Key Features

- **Router-Based Intelligence**: Central router determines which rules apply based on context
- **Automatic Context Detection**: File types, project structure, and user intent trigger appropriate rules
- **Hierarchical Rule Loading**: Base rules always apply, others apply conditionally with clear precedence
- **Smart Tool Adaptation**: Each tool references the router while leveraging tool-specific features
- **Version Control Friendly**: Clear `.ai-rules/` structure for tracking rule changes
- **Team Collaboration**: Shared router system with individual preference overrides

## Rule Module Types

**Router System:**
- `router.md` - Main entry point with intelligent routing and context detection
- Context detection based on file types, project structure, and user intent
- Rule precedence management and conflict resolution

**Base Rules (Always Applied):**
- `core.md` - Communication style and fundamental behavior
- `session.md` - Session planning and management
- `regression.md` - Quality assurance and regression prevention
- `collaboration.md` - Team collaboration patterns
- `context.md` - Context management and documentation
- `source-control.md` - Git practices and version control
- `rule-evolution.md` - Rule maintenance and evolution

> **Looking for ready-to-use rules?** Check the [Rules Library](../examples/rules/README.md) for a curated collection of base and technology-specific rules that you can use directly or adapt for your router architecture.

**SDLC Phase Rules (Context-Dependent):**
- `define.md` - Requirements gathering and design phase
- `develop.md` - Implementation and coding phase
- `test.md` - Testing and quality assurance phase
- `deploy.md` - Deployment and release management phase

**Technology Rules (File/Project-Dependent):**
- `node.md` - Node.js and JavaScript patterns
- `react.md` - React component and application patterns
- `typescript.md` - TypeScript conventions and practices
- `monorepo.md` - Monorepo management and coordination

> **Looking for more technology rules?** The [Rules Library](../examples/rules/README.md) includes ready-to-use rules for TypeScript, React, .NET, Python, and more, available for all major AI tools.

**User Preferences (Highest Priority):**
- `preferences.md` - Individual developer overrides and customizations

## Success Outcomes

The Rules Manager supports multiple successful outcomes:

1. **Intelligent Multi-Tool Setup**: Router-based rules deployed across all AI tools with context-aware loading
2. **Single Tool with Future Portability**: Enhanced rules for preferred tool using router architecture
3. **Team Standardization**: Shared router system adopted across team projects with individual customization
4. **Migration Support**: Easy transition between tools using router-based architecture

## Files Overview

- `README.md` - This file
- `RULES_MANAGER_PROMPT.md` - AI agent instructions for consistent behavior
- `WORKFLOW.md` - Detailed step-by-step setup and maintenance process
- `templates/` - Structured templates for router, base rules, and tool adaptations
- `examples/` - Example router implementations and generated configurations
- `build/` - Directory where generated configurations and workflow artifacts are saved

## Generated Files

During the workflow execution, the following files are created in the build directory:

### Assessment Phase
- `CURRENT_RULES_INVENTORY.md` - Existing AI tool configurations found
- `USER_REQUIREMENTS.md` - User preferences and tool choices
- `GAP_ANALYSIS.md` - Analysis of current vs. desired state

### Design Phase  
- `ARCHITECTURE_PLAN.md` - Approved modular rule design
- `TOOL_CONFIGURATION_STRATEGY.md` - Plan for tool-specific adaptations

### Implementation Phase
- `RULES_MANIFEST.md` - Documentation of created rule modules
- `GENERATED_CONFIGURATIONS.md` - List of tool config files created

### Validation Phase
- `VALIDATION_REPORT.md` - Test results for generated configurations
- `TOOL_COMPATIBILITY_MATRIX.md` - Compatibility across different tools

### Documentation Phase
- `DEPLOYMENT_GUIDE.md` - Instructions for team setup
- `MAINTENANCE_GUIDE.md` - Ongoing maintenance procedures
- `IMPLEMENTATION_SUMMARY.md` - Final summary and handoff

## Getting Started

1. Identify which AI development tools your team uses
2. Review your existing rule files (CLAUDE.md, .cursorrules, copilot-instructions.md)
3. Browse the [Rules Library](../examples/rules/README.md) for ready-to-use rules to include
4. Copy the activation prompt and start with your AI assistant
5. Follow the guided workflow to assess, select, and deploy rules
6. Test generated configurations with your tools

## Tips for Success

**Be Specific**: Provide concrete details about your project, tools, and requirements

**Have Examples Ready**: Share existing rule files or problematic patterns you want to improve

**Think About Your Team**: Consider how other developers will use and maintain the rules

**Plan for Growth**: Consider future tool adoption or project evolution

**Test Thoroughly**: Validate generated configurations work with your actual development workflow

The Rules Manager helps you maintain consistent AI behavior across tools while taking advantage of each tool's unique capabilities and conventions.

## Testing Status

| AI Tool | LLM | Windows | MacOS |
|---------|-----|---------|-------|
| **GitHub Copilot** | | | |
| | GPT-4.1 | ❌ Not Tested | ❌ Not Tested |
| | Claude Sonnet 4 | ✅ Fully Tested | ✅ Fully Tested |
| | o3-mini | ❌ Not Tested | ❌ Not Tested |
| | Gemini 2.5 Pro | ❌ Not Tested | ❌ Not Tested |
| | GPT-5 | ❌ Not Tested | ❌ Not Tested |
| **Cursor** | | | |
| | GPT-4.1 | ❌ Not Tested | ❌ Not Tested |
| | Claude Sonnet 4 | ❌ Not Tested | ❌ Not Tested |
| | o3-mini | ❌ Not Tested | ❌ Not Tested |
| | Gemini 2.5 Pro | ❌ Not Tested | ❌ Not Tested |
| | GPT-5 | ❌ Not Tested | ❌ Not Tested |
| **Claude** | | | |
| | GPT-4.1 | ❌ Not Tested | ❌ Not Tested |
| | Claude Sonnet 4 | ❌ Not Tested | ❌ Not Tested |
| | o3-mini | ❌ Not Tested | ❌ Not Tested |
| | Gemini 2.5 Pro | ❌ Not Tested | ❌ Not Tested |
| | GPT-5 | ❌ Not Tested | ❌ Not Tested |

**Legend:**
- ✅ Fully Tested - All functionality verified to work correctly
- ⚠️ Partially Tested - Basic functionality tested, some edge cases or **known issues** may exist
- ❌ Not Tested - No testing completed on this platform/LLM combination, or **significant issues** were found