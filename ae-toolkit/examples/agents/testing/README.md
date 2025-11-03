# Testing Agents

Agents in this category focus on creating, analyzing, and improving tests to ensure code quality and reliability.

## Available Agents

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

All testing agents:

- Write tests that verify behavior, not implementation details
- Follow the Arrange-Act-Assert (AAA) pattern
- Use meaningful test names that describe what's being tested
- Create independent tests that don't rely on execution order
- Prefer clear assertions over complex test logic
- Consider edge cases and error conditions

## Usage Examples

### Test Generator
```
@test-generator Generate unit tests for the UserAuthenticationService class.
Include happy path, error cases, and edge cases.
```

### Coverage Analyzer
```
@coverage-analyzer Review test coverage for the payment processing module.
What are the highest-risk gaps?
```

### Test Improver
```
@test-improver These integration tests are flaky and fail randomly.
How can I make them more reliable?
```

## Testing Best Practices

### Unit Tests
- Test one thing per test
- Mock external dependencies
- Fast execution (milliseconds)
- Comprehensive edge cases
- Clear failure messages

### Integration Tests
- Test component interactions
- Use real dependencies where practical
- Verify end-to-end workflows
- Balance thoroughness with speed
- Isolate from external systems when possible

### Test Organization
- Group related tests together
- Use descriptive test file names
- Follow consistent naming conventions
- Keep test code as clean as production code
- Separate unit, integration, and e2e tests

## Customization Tips

- **Frameworks**: Configure agents to use your testing frameworks (Jest, pytest, xUnit)
- **Conventions**: Match your team's test naming and structure patterns
- **Coverage goals**: Adjust what "good coverage" means for your context
- **Test types**: Emphasize unit vs. integration vs. e2e based on your needs
- **Speed requirements**: Configure agents to optimize for test suite performance

## Related Resources

- **Rules**: `../../rules/base/code-quality.md` - Testing quality standards
- **Commands**: `../../commands/generic/testing/` - Testing workflow commands
- **Chat Modes**: For Copilot/Cursor equivalents, see `../../chat-modes/`

## Contributing

When adding testing agents:

- Include examples for multiple testing frameworks
- Show test generation for different code patterns
- Demonstrate handling async code and external dependencies
- Provide guidance on test maintainability
- Address common testing anti-patterns
