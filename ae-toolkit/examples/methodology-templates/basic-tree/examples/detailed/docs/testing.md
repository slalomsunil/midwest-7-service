# Testing Guide

## Test Framework

Uses Jest, React Testing Library, and Cypress for comprehensive testing.

## Test Structure

- **Unit tests**: Individual component and function testing
- **Integration tests**: Feature interaction testing
- **E2E tests**: Full user journey testing
- **Performance tests**: Load and stress testing

## Running Tests

- Run all tests: `npm test`
- Run unit tests: `npm run test:unit`
- Run integration tests: `npm run test:integration`
- Run E2E tests: `npm run test:e2e`
- Run with coverage: `npm run test:coverage`

## Feature Testing

Each feature has its own test suite:

- `time-travel-debug/__tests__/` - Debug mode tests
- `ai-code-poet/__tests__/` - AI poetry tests
- `rubber-duck-simulator/__tests__/` - Simulator tests

## Test Patterns

- Use descriptive test names
- Follow arrange-act-assert pattern
- Mock external dependencies
- Test behavior, not implementation
- Include edge cases and error scenarios

## Continuous Integration

- All tests run on PR creation
- Coverage reports generated automatically
- Performance benchmarks tracked
- Cross-browser compatibility verified