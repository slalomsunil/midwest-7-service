# Claude Tool Adaptation Template

This template shows how to adapt the router-based rules system for Claude Code using progressive disclosure and context management.

## File Header and Router Integration

```markdown
# Claude Instructions

This file provides guidance to Claude Code when working with code in this repository.

**Claude Code:**
- Use `CLAUDE.md` that references `.ai-rules/router.md` as primary source
- Follow Claude's markdown formatting with router-based navigation
- Structure for progressive disclosure through the rule hierarchy
- Include context management that leverages router intelligence

## Primary Rules Source

All rules are managed through the `.ai-rules/` system. Start here:

**Main Entry Point:** `.ai-rules/router.md`
- Contains intelligent routing logic for rule loading
- Determines which rules apply based on current context
- Provides rule precedence and conflict resolution

## Essential Reading Order

ALWAYS read these files in order:
1. `.ai-rules/router.md` - Rule loading and context detection
2. `.ai-rules/rules/base/core.md` - Fundamental communication and behavior
3. Context-specific rules as determined by router logic

## Quick Navigation

- [Router Logic](#router-logic)
- [Base Rules](#base-rules)
- [Context Detection](#context-detection)
- [Rule Precedence](#rule-precedence)
```

## Progressive Disclosure Structure

**High-Level Router Integration:**
```markdown
## Router-Based Rule Loading

The `.ai-rules/router.md` file determines which rules to apply based on:
- Current file being edited (technology detection)
- Project structure analysis (architecture patterns)
- User stated intent (SDLC phase detection)
- Personal preferences (user overrides)

### Base Rules (Always Applied)
Load these foundational rules for all interactions:
- `.ai-rules/rules/base/core.md` - Communication style & behavior
- `.ai-rules/rules/base/session.md` - Session & plan management  
- `.ai-rules/rules/base/regression.md` - Regression prevention
- `.ai-rules/rules/base/collaboration.md` - Team collaboration
- `.ai-rules/rules/base/context.md` - Context management
- `.ai-rules/rules/base/source-control.md` - Git practices

### Conditional Rules (Context-Dependent)
Apply additional rules based on router detection:
- SDLC Phase: `.ai-rules/rules/sdlc/[phase].md`
- Technology: `.ai-rules/rules/tech/[technology].md`
- User Preferences: `.ai-rules/rules/user/preferences.md`
```

## Context Management Features

**File References:**
```markdown
## Essential Reading

For detailed information about this project:
- `docs/development-guide.md` - Development workflow and standards
- `docs/api-documentation.md` - API endpoints and usage
- `src/types/` - TypeScript type definitions
- `tests/` - Test examples and patterns

When working with specific features, also review:
- `src/[feature]/README.md` - Feature-specific guidance
- `docs/[feature]-architecture.md` - Feature architecture details
```

**Context Prioritization:**
```markdown
## Rule Precedence

When rules conflict, follow this order:
1. User's explicit instructions
2. Project-specific rules (this file)
3. General development best practices
4. Ask for clarification if still unclear
```

## Claude-Specific Enhancements

**Code Analysis (enhances base rules):**
- Leverage Claude's analytical capabilities for deep code understanding
- Reference base rules from `.ai-rules/rules/base/context.md` for context management
- Apply regression prevention rules from `.ai-rules/rules/base/regression.md`
- Use session management patterns from `.ai-rules/rules/base/session.md`

**Multi-File Awareness (enhances base collaboration):**
- Reference `.ai-rules/rules/base/collaboration.md` for team workflow patterns
- Apply source control practices from `.ai-rules/rules/base/source-control.md`
- Use conservative file management from `.ai-rules/rules/base/core.md`

**Documentation Integration (follows base patterns):**
- Apply context management rules from `.ai-rules/rules/base/context.md`
- Follow communication style from `.ai-rules/rules/base/core.md`

## Claude-Specific Optimizations

**Long Context Handling:**
```markdown
## Working with Large Codebases

When analyzing large projects:
1. Start with high-level architecture understanding
2. Focus on the specific area of change
3. Identify key dependencies and interfaces
4. Review related test files for behavior understanding
5. Consider broader impact before making changes
```

**Conversation Memory:**
```markdown
## Conversation Context

Throughout our conversation:
- Remember previous decisions and their reasoning
- Build on earlier context rather than starting over
- Reference earlier parts of our discussion when relevant
- Maintain consistency with previous recommendations
```

## Error Handling Enhancement

**Claude-Specific Error Recovery:**
```markdown
## When Things Go Wrong

If I make mistakes or you're not satisfied:
1. Point out the specific issue clearly
2. I'll analyze what went wrong and why
3. I'll provide a corrected approach with explanation
4. We'll validate the fix works before proceeding

If I repeatedly fail at the same task:
- I'll suggest updating these instructions
- I'll ask for additional context or examples  
- I'll recommend involving other resources if needed
```

## Integration with Claude Features (Claude-Specific Extensions)

**Code Generation (enhances base core rules):**
- Apply task focus principles from `.ai-rules/rules/base/core.md`
- Use conservative file management patterns
- Follow regression prevention guidelines from `.ai-rules/rules/base/regression.md`

**Code Review (leverages Claude's analytical strengths):**
- Apply quality standards from `.ai-rules/rules/base/regression.md`
- Reference collaboration patterns from `.ai-rules/rules/base/collaboration.md`

**Debugging Assistance (enhances base support):**
- Use systematic approach from `.ai-rules/rules/base/session.md`
- Apply regression prevention strategies

## Markdown Optimization

**Structured Information:**
```markdown
## Quick Reference

### Common Commands
- `npm start` - Start development server
- `npm test` - Run test suite  
- `npm run build` - Create production build

### Key Files
- `src/main.js` - Application entry point
- `src/config/` - Configuration files
- `tests/setup.js` - Test setup and utilities

### Important Patterns
- All components use hooks-based approach
- State management via [STATE_SOLUTION]
- API calls through centralized service layer
```

## Claude-Specific Implementation Strategy

### Main Configuration File
Generate `CLAUDE.md` that:
- References `.ai-rules/router.md` as primary source
- Uses progressive disclosure for large context management
- Structures content for Claude's long-context capabilities
- Provides clear navigation paths to specific rule categories

### Progressive Disclosure Structure
Structure content for optimal Claude consumption:
- High-level overview linking to router
- Essential reading order with file references
- Context-specific rule loading instructions
- Detailed navigation and quick reference sections

### Directory Structure Integration
```
CLAUDE.md                    # Main Claude instructions file
├── References router.md as primary entry point
├── Provides progressive disclosure navigation
├── Leverages Claude's long-context capabilities
└── Includes project-specific quick reference
```

### Tool Differences from Base Rules

#### Claude-Specific Advantages
1. **Long Context**: Can handle entire rule system in single conversation
2. **Progressive Disclosure**: Excellent at managing complex hierarchical information
3. **Analysis**: Superior code analysis and architectural reasoning
4. **Conversation Memory**: Maintains context across long development sessions
5. **Documentation**: Strong at generating comprehensive documentation

#### Syntax Adaptations
- Use standard Markdown without special headers
- Implement clear section hierarchy and navigation
- Structure for sequential reading and reference
- Include explicit file paths for context loading

#### Behavioral Differences
- More analytical and explanatory responses
- Better at architectural discussions and planning
- Enhanced ability to work with large codebases
- Superior at maintaining context across complex conversations
- More thorough in documentation and explanation generation

### Implementation Details
The Claude adaptation focuses on:
- **Context Management**: Leveraging Claude's ability to maintain large amounts of context
- **Progressive Navigation**: Clear pathways through the rule hierarchy
- **Analysis Integration**: Using Claude's analytical strengths for code review and architecture
- **Documentation Excellence**: Taking advantage of Claude's superior documentation capabilities

The base rule content remains unchanged, while the presentation is optimized for Claude's specific strengths and interaction patterns.

## Adaptation Notes

This template demonstrates Claude-specific optimizations:

1. **Progressive Disclosure**: Start with high-level rules, then provide detailed context
2. **Navigation**: Clear table of contents and section linking
3. **Context Management**: Explicit file references and reading order
4. **Long Context**: Optimized for Claude's ability to handle large amounts of context
5. **Conversation Continuity**: Leverage Claude's conversation memory capabilities

The base rule content is enhanced with Claude's strengths in analysis, context understanding, and detailed explanations.
