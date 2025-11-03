# Router Template

This template creates the main entry point for the AI rules system with intelligent routing logic.

## Router Structure

# AI Rules Router

This is the main entry point for AI development rules in this project.

## Rule Loading Order

### 1. Base Rules (MANDATORY - Always Applied First)
**CRITICAL**: These foundational rules are ALWAYS loaded and applied regardless of context, file type, or user intent. They form the non-negotiable foundation for all AI interactions:
- `rules/base/core.md` - Communication style & behavior
- `rules/base/session.md` - Session & plan management  
- `rules/base/regression.md` - Regression prevention
- `rules/base/collaboration.md` - Team collaboration
- `rules/base/context.md` - Context management
- `rules/base/source-control.md` - Git practices & version control
- `rules/base/rule-evolution.md` - Rule creation & maintenance

**Implementation Note**: Base rules are loaded at the start of every interaction and can only be disabled, overridden, or skipped by user preferences.

### 2. SDLC Rules (Context-Dependent, does not override Base Rules)
Apply based on development phase or user intent:
- `rules/sdlc/define.md` - Requirements & design phase
- `rules/sdlc/develop.md` - Implementation phase
- `rules/sdlc/test.md` - Testing & QA phase
- `rules/sdlc/deploy.md` - Deployment & release phase

### 3. Technology Rules (File/Project-Dependent, does not override Base Rules)
Apply based on file extensions and project structure:
- `rules/tech/node.md` - For .js, package.json, Node.js projects
- `rules/tech/react.md` - For .jsx, .tsx files with React
- `rules/tech/typescript.md` - For .ts, .tsx files
- `rules/tech/monorepo.md` - For multi-package projects

### 4. User Preferences (Highest Priority)
Personal overrides that take precedence:
- `rules/user/preferences.md` - User-specific customizations

## Context Detection

### File-Based Detection
```
.js, .mjs, .cjs -> Apply rules/tech/node.md
.jsx -> Apply rules/tech/react.md
.ts, .tsx -> Apply rules/tech/typescript.md
package.json -> Apply rules/tech/node.md
lerna.json, nx.json, rush.json -> Apply rules/tech/monorepo.md
```

### Project Structure Detection
```
src/components/ -> Apply rules/tech/react.md
__tests__/ or spec/ -> Apply rules/sdlc/test.md
docs/ -> Apply rules/sdlc/define.md
scripts/deploy -> Apply rules/sdlc/deploy.md
```

### User Intent Detection
```
"write tests" -> Apply rules/sdlc/test.md
"deploy" or "release" -> Apply rules/sdlc/deploy.md
"requirements" or "design" -> Apply rules/sdlc/define.md
"implement" or "code" -> Apply rules/sdlc/develop.md
```

## Rule Precedence

When rules conflict, apply in this order (highest to lowest priority):
1. **User Preferences** - rules/user/preferences.md
2. **Technology Rules** - rules/tech/*.md  
3. **SDLC Rules** - rules/sdlc/*.md
4. **Base Rules** - rules/base/*.md

## Rule Discovery

### Automatic Discovery
The router automatically detects and applies rules based on:
- Current file being edited
- Project structure analysis
- Recent files accessed
- User's stated intent

### Manual Override
Users can explicitly request specific rule sets:
- "Apply React rules" -> Load rules/tech/react.md
- "Focus on testing" -> Load rules/sdlc/test.md  
- "Use my preferences" -> Prioritize rules/user/preferences.md

## Integration Points

### Tool-Specific Loading
Different AI tools load this router through their configuration files:
- **GitHub Copilot**: `.github/copilot-instructions.md` imports this router
- **Claude**: `CLAUDE.md` references this router as primary source
- **Cursor**: `.cursorrules` incorporates this router logic

### Rule Compilation
For tools that need single files, the router compiles applicable rules:
1. **FIRST**: Load base rules (MANDATORY - always applied)
2. Identify context (C# file, API endpoint, test file, etc.)
3. Load applicable rule modules in precedence order
4. Merge rules with conflict resolution ensuring base rules remain immutable
5. Present unified rule set to GitHub Copilot

## Maintenance

### Adding New Rules
1. Create rule file in appropriate directory (base/, sdlc/, tech/)
2. Update router discovery logic if needed
3. Update rule precedence if conflicts arise
4. Test with target AI tools

### Updating Existing Rules
1. Modify rule files directly
2. Router automatically picks up changes
3. Test integration with AI tools
4. Update RULES_MANIFEST.md if structure changes

### User Customization
Users can create `rules/user/preferences.md` to override team rules without affecting others.

## Router Implementation Notes

**Context Awareness**: The router makes decisions based on current context rather than applying all rules indiscriminately.

**Performance**: Only loads applicable rules to avoid overwhelming AI tools with irrelevant information.

**Maintainability**: Clear separation of concerns makes it easy to update specific rule categories.

**Flexibility**: Supports both automatic rule discovery and manual user override.

**Tool Agnostic**: Works with any AI tool that can reference external files or import rule content.
