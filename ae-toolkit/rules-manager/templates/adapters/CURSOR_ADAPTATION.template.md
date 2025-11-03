# Cursor Tool Adaptation Template

This template shows how to adapt the router-based rules system for Cursor using its specific rule syntax and features.

**Cursor:**
- Use `.cursorrules` file that incorporates router logic and rule loading
- Follow Cursor rule syntax while maintaining router-based architecture
- Support Cursor-specific features with technology detection from router
- Enable intelligent rule switching based on file context

## Cursor Rules File Format

```
# Cursor Rules
# This file configures Cursor IDE behavior for this project

# Router-Based Rule System
# All rules are managed through .ai-rules/ directory
# Refer to .ai-rules/router.md for complete routing logic

# Base Rules (Always Applied)
# Load these from .ai-rules/rules/base/:
# - core.md: Communication style & behavior
# - session.md: Session & plan management  
# - regression.md: Regression prevention
# - collaboration.md: Team collaboration
# - context.md: Context management
# - source-control.md: Git practices

# Context-Dependent Rules
# Router automatically applies based on:
# - File extensions (.js -> node.md, .jsx -> react.md)
# - Project structure (package.json -> node.md)
# - User intent (SDLC phase detection)

# Core Behavior
# Reference: .ai-rules/rules/base/core.md
# Apply all base communication and behavior rules from the core module
# Including: professional competence, direct communication, task focus, conservative file management
```

## Router Integration

**Automatic Rule Loading:**
```
# Router-Based Context Detection
# When editing files, automatically apply rules from .ai-rules/rules/tech/ based on:
.js, .mjs, .cjs -> Apply node.md rules
.jsx -> Apply react.md rules  
.ts, .tsx -> Apply typescript.md rules
package.json -> Apply node.md rules
lerna.json, nx.json -> Apply monorepo.md rules

# SDLC Phase Detection
# Apply rules from .ai-rules/rules/sdlc/ based on context:
__tests__/ or spec/ directories -> Apply test.md rules
docs/ directory -> Apply define.md rules
"deploy" or "release" in user intent -> Apply deploy.md rules
Implementation tasks -> Apply develop.md rules
```

## Language-Specific Rules

# Language-Specific Rule References
# Apply technology-specific rules from .ai-rules/rules/tech/ based on file context:
# - JavaScript/Node.js: Reference .ai-rules/rules/tech/node.md
# - React: Reference .ai-rules/rules/tech/react.md  
# - TypeScript: Reference .ai-rules/rules/tech/typescript.md
# - Python: Reference .ai-rules/rules/tech/python.md

## Tool-Specific Features

# Cursor-Specific Enhancements
# These enhance base rules with Cursor IDE-specific features:

**Code Completion Enhancement:**
```
# Code completion preferences (Cursor-specific)
- Suggest context-aware imports based on project structure
- Prioritize project patterns over generic solutions  
- Consider existing code style and conventions
- Offer multiple alternatives when appropriate

# Auto-completion behavior
- Complete function signatures based on project patterns
- Suggest variable names that match project conventions
- Recommend imports from project dependencies
- Provide contextual code snippets
```

**Cursor Command Integration:**
```
# IDE-specific behavior (enhances .ai-rules/rules/base/session.md)
- Use project's linting and formatting rules
- Respect existing editor configuration
- Follow git workflow and branch patterns from .ai-rules/rules/base/source-control.md
- Consider CI/CD pipeline requirements

# Code suggestions should:
- Pass existing linting rules
- Match project formatting style
- Work with existing build tools
- Maintain test coverage per .ai-rules/rules/base/regression.md
```

## Error Handling and Debugging

## Error Handling and Debugging (Cursor-Specific)

**Cursor-Specific Error Handling (enhances base regression prevention):**
```
# Error handling approach (references .ai-rules/rules/base/regression.md)
When errors occur:
- Analyze the specific error message with Cursor's diagnostics
- Consider project-specific error patterns  
- Suggest fixes that align with project architecture
- Provide debugging steps appropriate for the tech stack

# Cursor debugging assistance:
- Use project's logging patterns
- Suggest appropriate debugging tools available in Cursor
- Consider existing error tracking systems
- Provide step-by-step troubleshooting with Cursor features
```

## Project Integration (Cursor-Specific)

**Build System Integration (enhances base rules):**
```
# Build and deployment (references base collaboration and session rules)
- Understand project build tools (webpack, vite, etc.)
- Respect module resolution patterns
- Consider bundle size for web projects
- Follow deployment pipeline requirements

# Dependencies (follows .ai-rules/rules/base/core.md conservative principles):
- Use existing package manager (npm, yarn, pip, etc.)
- Consider version constraints
- Prefer project dependencies over new ones
- Document new dependency requirements
```

**Testing Integration (references regression prevention):**
```
# Testing approach (enhances .ai-rules/rules/base/regression.md)
- Follow existing test patterns and frameworks
- Use Cursor's testing integrations where available
- Include both unit and integration tests
- Use project's testing utilities and helpers

# Test file organization:
- Place tests according to project structure
- Use consistent test naming
- Include setup and teardown as needed
- Mock external dependencies appropriately
```

## Performance and Quality

**Code Quality Rules:**
```
# Performance considerations
- Write efficient algorithms for the use case
- Consider memory usage for large datasets
- Use appropriate caching strategies
- Follow security best practices

# Code maintainability:
- Prefer readable code over clever code
- Use meaningful names for variables and functions
- Break complex functions into smaller pieces
- Include appropriate comments and documentation
```

## Adaptation Features

**Cursor-Specific Optimizations:**
```
# Cursor IDE features
- Leverage multi-cursor editing for repetitive changes
- Use command palette for quick navigation
- Take advantage of symbol search across project
- Utilize integrated terminal for testing changes

# Workspace awareness:
- Understand project structure and file relationships
- Consider open tabs and recent files for context
- Use project-wide search for understanding patterns
- Reference related files when making changes
```

## Cursor-Specific Implementation Strategy

### Main Configuration File
Generate `.cursorrules` that:
- References `.ai-rules/router.md` as primary source
- Uses Cursor's specific rule syntax and conventions
- Incorporates router logic for context-aware rule application
- Follows Cursor's plain text format requirements

### Syntax Adaptation
Transform rule content for Cursor's format:
- Convert Markdown rules to plain text commands
- Use direct imperative statements rather than descriptions
- Integrate routing logic directly into the rules file
- Follow Cursor's comment syntax for organization

### Directory Structure Integration
```
.cursorrules                 # Main Cursor rules file
├── Incorporates router logic for context detection
├── References .ai-rules/ system for detailed rules
├── Uses plain text format with embedded routing
└── Includes technology detection patterns
```

### Tool Differences from Base Rules

#### Cursor-Specific Advantages
1. **IDE Integration**: Deep integration with Cursor IDE features and workspace
2. **Performance Focus**: Optimized for fast code completion and editing
3. **Multi-Cursor Support**: Enhanced support for bulk editing operations
4. **Symbol Navigation**: Advanced project-wide symbol search and navigation
5. **Command Integration**: Direct integration with Cursor's command palette

#### Syntax Adaptations
- Use plain text format instead of Markdown
- Write rules as direct commands rather than descriptions
- Include inline context detection logic
- Use comment-style organization and headers

#### Behavioral Differences
- More focused on immediate editing tasks and code completion
- Enhanced performance for large projects and files
- Better integration with Cursor's specific editing features
- Emphasis on efficient coding workflows and editor performance
- Direct command-style rule presentation

### Context Detection Implementation
```
# Router-Based Context Detection
# When editing files, automatically apply rules from .ai-rules/rules/tech/ based on:
.js, .mjs, .cjs -> Apply node.md rules
.jsx -> Apply react.md rules  
.ts, .tsx -> Apply typescript.md rules
package.json -> Apply node.md rules
lerna.json, nx.json -> Apply monorepo.md rules

# SDLC phase detection:
test files, spec files -> Apply .ai-rules/rules/sdlc/test.md
build files, deploy files -> Apply .ai-rules/rules/sdlc/deploy.md
documentation files -> Apply .ai-rules/rules/sdlc/define.md
implementation files -> Apply .ai-rules/rules/sdlc/develop.md
```

### Implementation Details
The Cursor adaptation focuses on:
- **Direct Commands**: Converting rule guidance into actionable commands
- **Performance**: Optimizing for Cursor's fast editing and completion features
- **IDE Features**: Leveraging Cursor-specific functionality and workspace awareness
- **Efficiency**: Streamlined rule presentation for quick reference and application

The base rule content is transformed into Cursor's command-style format while maintaining semantic equivalence and adding tool-specific optimizations.

## Format Notes

This template demonstrates Cursor-specific adaptations:

1. **Plain Text Format**: Cursor rules use a simple text format rather than markdown
2. **Direct Instructions**: Rules are written as direct commands rather than descriptions
3. **Tool Integration**: Leverage Cursor's IDE features and workspace awareness
4. **Performance Focus**: Emphasis on efficient coding and editor performance
5. **Command-Style**: Rules written as actionable commands for the AI

The base rule content is adapted to Cursor's command-style format while maintaining the same semantic meaning and adding tool-specific enhancements.
