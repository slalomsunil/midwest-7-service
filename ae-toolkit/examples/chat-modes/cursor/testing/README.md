# Testing Custom Modes

Custom modes in this category focus on creating, analyzing, and improving tests to ensure code quality and reliability.

## Available Custom Modes

### test-generator
**Purpose**: Generate comprehensive test suites with good coverage and meaningful assertions

**When to use**:
- When adding tests for new features
- To create missing tests for existing code
- When you want comprehensive test coverage quickly
- For generating test structure you'll customize later

**When NOT to use**:
- For complex business logic requiring deep domain knowledge (write these yourself)
- When tests already exist and just need updates (use test-improver)
- For exploratory testing or manual test scenarios

### coverage-analyzer
**Purpose**: Identify coverage gaps and suggest high-value tests to write

**When to use**:
- When reviewing test coverage before release
- To prioritize which areas need tests most urgently
- For understanding risk from untested code
- When deciding where to invest testing effort

**When NOT to use**:
- When you already know which tests to write
- For detailed test case design (use test-generator)
- When coverage is already comprehensive

### test-improver
**Purpose**: Improve existing tests to be more maintainable, comprehensive, or reliable

**When to use**:
- When tests are flaky or unreliable
- To make tests more readable and maintainable
- For improving assertion quality
- When reducing test suite execution time

**When NOT to use**:
- When tests don't exist yet (use test-generator)
- For identifying what's not tested (use coverage-analyzer)
- When tests are already well-written

## Common Patterns

All testing custom modes:

- Write tests that verify behavior, not implementation details
- Follow the Arrange-Act-Assert (AAA) pattern
- Use meaningful test names that describe what's being tested
- Create independent tests that don't rely on execution order
- Prefer clear assertions over complex test logic
- Consider edge cases and error conditions

## Usage Examples

### Test Generator
1. Switch to test-generator mode via `Cmd+.` (Mac) / `Ctrl+.` (Windows/Linux)
2. Ask: "Generate unit tests for the UserAuthenticationService class. Include happy path, error cases, and edge cases"
3. Mode provides comprehensive test suite

### Coverage Analyzer
1. Switch to coverage-analyzer mode
2. Ask: "Review test coverage for the payment processing module. What are the highest-risk gaps?"
3. Mode provides prioritized gap analysis with recommendations

### Test Improver
1. Switch to test-improver mode
2. Ask: "These integration tests are flaky and fail randomly. How can I make them more reliable?"
3. Mode provides specific improvements with before/after examples

## Customization Tips

- **Frameworks**: Configure modes to use your testing frameworks (Jest, pytest, xUnit)
- **Conventions**: Match your team's test naming and structure patterns
- **Coverage goals**: Adjust what "good coverage" means for your context
- **Test types**: Emphasize unit vs. integration vs. e2e based on your needs
- **Speed requirements**: Configure modes to optimize for test suite performance

## Related Resources

- **Rules**: `../../../rules/cursor/base/` - Testing quality standards
- **Commands**: `../../../commands/cursor/testing/` - Commands for specific workflows
- **Agents**: `../../../agents/testing/` - Claude Code/OpenCode equivalents

## Mode Configuration

Each mode is configured via Cursor Settings → Chat → Custom Modes. Copy the instructions from each `.md` file in this directory into the UI.

To configure:
1. Open Cursor Settings
2. Navigate to Chat → Custom Modes
3. Enable "Custom Modes (Beta)"
4. Create a new mode for each configuration file
5. Copy the instructions from the "Configuration" section of each file

## Version Information

**Last Updated**: 2025-10-14
**Toolkit Version**: Part of AE Toolkit best practices library
