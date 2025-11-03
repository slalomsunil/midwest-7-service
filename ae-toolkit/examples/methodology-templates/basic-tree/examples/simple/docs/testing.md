# Testing Guide

## Test Framework

Uses Jest and React Testing Library for unit and integration tests.

## Running Tests

- Run all tests: `npm test`
- Run tests in watch mode: `npm test -- --watch`
- Run tests with coverage: `npm test -- --coverage`

## Test Patterns

- Test component behavior, not implementation
- Use descriptive test names
- Follow arrange-act-assert pattern
- Mock external dependencies

## Example Test Structure

```typescript
describe('TodoItem', () => {
  it('should display todo text', () => {
    // arrange
    const todo = { id: '1', text: 'Test todo', completed: false };
    
    // act
    render(<TodoItem todo={todo} />);
    
    // assert
    expect(screen.getByText('Test todo')).toBeInTheDocument();
  });
});
```

## Test Location

Place tests in `src/__tests__/` directory with `.test.tsx` extension.