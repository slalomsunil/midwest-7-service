# Monolithic Implementation Pattern

## Detection Signals

IMPORTANT! These signals are exemplary, not exhaustive or constraints.

- [User behavior] Opening prompt lacks explicit validation checkpoints or phases
- [Agent behavior] Implements complete features end-to-end without intermediate validation
- [Agent behavior] Builds multiple layers of functionality before testing foundation works
- [Agent behavior] Creates entire systems before verifying prerequisites exist (e.g., TypeScript setup, required dependencies)
- [Agent behavior] Implements complex workflows without testing individual steps
- [User behavior] Discovers fundamental issues only after extensive implementation
- [Agent behavior] Proceeds with implementation despite unverified assumptions
- [Agent behavior] Pattern of "I'll implement everything then we can test" approaches

## Root Cause
User hasn't provided explicit checkpoints or validation requirements, allowing the agent's natural tendency toward comprehensive solutions to proceed unchecked. Agents are designed to be helpful by completing tasks thoroughly - without user-imposed boundaries, they will implement complete solutions before pausing. This behavior requires user guidance through explicit staging, checkpoints, or incremental validation requests.

## Impact
- Difficult troubleshooting when implementations fail
- User cannot validate approach before significant effort invested
- High regression risk when modifying complex implementations
- Reduced learning opportunities for user to understand implementation
- All-or-nothing deployment risk
- Wasted effort when foundational assumptions are incorrect
- User frustration from having to redo large amounts of work

## Common Scenarios
- **Framework conversions**: Converting entire codebases to TypeScript/new framework without checking setup
- **Feature implementations**: Building complete CRUD systems before testing basic create works
- **Refactoring operations**: Refactoring patterns across entire codebase without validating the pattern
- **Dependency updates**: Updating code for new library versions without confirming versions installed
- **Architecture changes**: Implementing new architecture patterns everywhere before proving concept

## Improvement Strategies

### For Users
- Request proof of concept first: "Show me one working example before implementing all"
- Validate prerequisites: "Check if TypeScript is set up before converting files"
- Use staged implementation: "Let's implement and test the first component, then proceed"
- Require assumption validation: "Verify this approach works before implementing everywhere"
- Set explicit checkpoints: "Stop after the first file conversion so we can test"

### For Documentation
- Add "Prerequisites Check" section to implementation workflows
- Document incremental implementation patterns
- Include "Validate Foundation First" principle in methodology
- Create templates showing staged feature development
- Add explicit "assumption validation" steps before large implementations
- Document when to pause for user validation

