---
applyTo: "**/*.ts,**/*.tsx"
---

# TypeScript Instructions

**Tool:** GitHub Copilot
**Version:** 2025-01
**Category:** Technology-Specific Rules
**Related:** See `../../generic/tech/typescript.md` for detailed patterns, `../../cursor/tech/typescript.mdc` for Cursor version

> This file follows GitHub Copilot's custom instructions format and can be placed in `.github/instructions/` for path-specific TypeScript guidance.

---

Enable strict mode in tsconfig.json. Use strict: true, noUncheckedIndexedAccess: true, noImplicitReturns: true.

Avoid `any`. Use `unknown` instead when type is truly unknown. Use specific types or unions when possible.

Let TypeScript infer types when obvious, but always explicitly type function parameters and return types.

Use `interface` for object shapes that might be extended. Use `type` for unions, intersections, mapped types, and tuples.

Handle null/undefined explicitly with optional chaining (`?.`) and nullish coalescing (`??`).

Always type function parameters and return values:
```typescript
function calculateTotal(items: Item[], taxRate: number): number {
  return items.reduce((sum, item) => sum + item.price, 0) * (1 + taxRate);
}
```

Use generics for reusable type-safe functions:
```typescript
function first<T>(array: T[]): T | undefined {
  return array[0];
}
```

Prefer const objects or union types over enums:
```typescript
const Status = { Pending: 'pending', Active: 'active' } as const;
type Status = typeof Status[keyof typeof Status];
```

Prefer async/await over promise chains for better readability.

Use array methods (filter, map, reduce) over loops when transforming data.

Use spread operator for immutable updates of objects and arrays.

Create custom error classes extending Error. Handle errors with specific types, not bare `catch`.

Use built-in utility types: Pick, Omit, Partial, Required, Readonly, Record, Extract, Exclude.

Use named exports over default exports for better refactoring.

Use const by default, let when reassignment needed. Never use var.

Follow consistent semicolon usage (present or absent, not mixed).

Use PascalCase for classes/interfaces/types, camelCase for variables/functions, UPPER_SNAKE_CASE for constants.
