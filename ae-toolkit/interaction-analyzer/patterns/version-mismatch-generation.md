# Version Mismatch Generation Pattern

## Detection Signals

IMPORTANT! These signals are exemplary, not exhaustive or constraints.

- Agent generates code using deprecated APIs or outdated syntax
- Import statements reference old package names or paths
- Uses component APIs that have changed between major versions
- Mixes syntax from different framework versions in same implementation
- User reports "that API doesn't exist anymore" or "that's the old way"
- Generated code fails with version-specific errors
- Agent using patterns from training data that predate current versions

## Root Cause
Agent generates code based on outdated documentation or training data that doesn't match the actual versions installed in the project. This occurs when project dependencies have been updated but the agent lacks awareness of version-specific changes, or when documentation doesn't specify which version is being used.

## Impact
- Generated code doesn't compile or run
- Subtle bugs from mixing version-incompatible patterns
- User must manually update all generated code
- Confusion about which documentation to trust
- Time wasted debugging version-specific issues
- Loss of confidence in agent suggestions

## Common Scenarios
- **React class components vs hooks**: Generating class components when project uses modern React
- **Material-UI versions**: Using v4 syntax when project has MUI v5 installed
- **Node.js APIs**: Using callback patterns when project uses modern async/await
- **Testing libraries**: Enzyme patterns when project uses React Testing Library
- **TypeScript versions**: Using old type syntax incompatible with strict mode
- **Build tool configs**: Webpack 4 patterns in Webpack 5 projects

## Improvement Strategies

### For Users
- Specify versions explicitly: "We're using React 18 with MUI v5"
- Add version information to documentation: "This project uses Node 18+"
- Create version specification file listing all major dependencies
- Include example imports showing current syntax
- Document any version-specific patterns being used
- Add rules file specifying "use modern React hooks, no class components"

### For Documentation
- Create a VERSIONS.md file listing all critical dependency versions
- Add version constraints to code examples in documentation
- Include migration notes when updating major versions
- Document which patterns are deprecated and their replacements
- Add "minimum version requirements" to README
- Include version-specific setup instructions

### For Agent Behavior
- Check package.json for actual installed versions
- Look for version specifications in documentation
- When uncertain, ask about version before generating code
- Prefer modern patterns unless explicitly told otherwise
- Note when generated code assumes specific versions
- Suggest version checks when patterns might be version-dependent