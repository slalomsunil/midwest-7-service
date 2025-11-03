# TypeScript

<!-- Rule Metadata -->
**Tool:** Claude Code, OpenCode
**Version:** 2025-01
**Category:** Technology-Specific Rules
**Related:** See `./copilot/typescript.md` for GitHub Copilot version, `./cursor/typescript.md` for Cursor version, `./react.md` for React-specific patterns, `./node.md` for Node.js patterns

## Purpose

Establish TypeScript-specific conventions and patterns that promote type safety, maintainability, and effective use of TypeScript's features.

## Type Safety

### Use Strict Mode

Enable strict mode in `tsconfig.json`:
```json
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true
  }
}
```

### Avoid `any`

- Use `unknown` instead of `any` when type is truly unknown
- Use specific types or type unions when possible
- Use `never` for functions that never return
- Add `// @ts-expect-error` with explanation if `any` is unavoidable

**Good:**
```typescript
function parseJSON(json: string): unknown {
  return JSON.parse(json);
}

function processValue(value: unknown): string {
  if (typeof value === 'string') {
    return value;
  }
  return String(value);
}
```

**Avoid:**
```typescript
function parseJSON(json: string): any {
  return JSON.parse(json);
}
```

### Prefer Type Inference

Let TypeScript infer types when obvious:

**Good:**
```typescript
const count = 5; // inferred as number
const items = ['a', 'b', 'c']; // inferred as string[]
const user = { name: 'Alice', age: 30 }; // inferred object type
```

**Unnecessary:**
```typescript
const count: number = 5;
const items: string[] = ['a', 'b', 'c'];
```

Do provide explicit types when:
- Function parameters and return types
- Public API boundaries
- Complex type inference would be unclear
- Exported constants and variables

## Interfaces vs Types

### When to Use Each

**Use `interface` for:**
- Object shapes that might be extended
- Public APIs and contracts
- Class implementations
- When you want declaration merging

**Use `type` for:**
- Unions and intersections
- Mapped types and conditional types
- Tuples and primitives
- Type aliases for complex types

**Examples:**
```typescript
// Interface - can be extended
interface User {
  id: string;
  name: string;
}

interface AdminUser extends User {
  permissions: string[];
}

// Type - for unions and complex types
type Status = 'pending' | 'active' | 'inactive';
type Result<T> = { success: true; data: T } | { success: false; error: string };
```

## Null and Undefined Handling

### Explicit Null Checks

Handle null/undefined explicitly:

**Good:**
```typescript
function getUserName(user: User | null): string {
  if (!user) {
    return 'Guest';
  }
  return user.name;
}

// Or use optional chaining
function getUserEmail(user: User | null): string | undefined {
  return user?.email;
}

// Or use nullish coalescing
function getDisplayName(user: User | null): string {
  return user?.name ?? 'Unknown User';
}
```

### Optional vs Undefined

Be consistent with optional properties:

**Prefer:**
```typescript
interface Config {
  port?: number; // optional property
  host: string;
}
```

**Over:**
```typescript
interface Config {
  port: number | undefined; // must be present but can be undefined
  host: string;
}
```

## Functions

### Function Signatures

Always type function parameters and return types:

**Good:**
```typescript
function calculateTotal(items: Item[], taxRate: number): number {
  const subtotal = items.reduce((sum, item) => sum + item.price, 0);
  return subtotal * (1 + taxRate);
}

const formatCurrency = (amount: number): string => {
  return `$${amount.toFixed(2)}`;
};
```

### Generic Functions

Use generics for reusable type-safe functions:

```typescript
function first<T>(array: T[]): T | undefined {
  return array[0];
}

function map<T, U>(array: T[], fn: (item: T) => U): U[] {
  return array.map(fn);
}

// Constrain generics when needed
function getProperty<T, K extends keyof T>(obj: T, key: K): T[K] {
  return obj[key];
}
```

### Function Overloads

Use overloads for functions with different call signatures:

```typescript
function parse(value: string): object;
function parse(value: string, reviver: (key: string, value: any) => any): object;
function parse(value: string, reviver?: (key: string, value: any) => any): object {
  return JSON.parse(value, reviver);
}
```

## Enums vs Union Types

### Prefer Const Objects or Union Types

**Prefer:**
```typescript
// Union type
type Status = 'pending' | 'active' | 'inactive';

// Const object (runtime + compile-time)
const Status = {
  Pending: 'pending',
  Active: 'active',
  Inactive: 'inactive',
} as const;

type Status = typeof Status[keyof typeof Status];
```

**Over:**
```typescript
enum Status {
  Pending = 'pending',
  Active = 'active',
  Inactive = 'inactive',
}
```

Enums are acceptable for:
- Numeric flags or bit fields
- When you need reverse mapping
- Legacy code compatibility

## Async/Await

### Prefer Async/Await Over Promises

**Good:**
```typescript
async function fetchUser(id: string): Promise<User> {
  try {
    const response = await fetch(`/api/users/${id}`);
    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }
    return await response.json();
  } catch (error) {
    console.error('Failed to fetch user:', error);
    throw error;
  }
}
```

**Avoid:**
```typescript
function fetchUser(id: string): Promise<User> {
  return fetch(`/api/users/${id}`)
    .then(response => {
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
      }
      return response.json();
    })
    .catch(error => {
      console.error('Failed to fetch user:', error);
      throw error;
    });
}
```

### Type Async Functions Properly

```typescript
// Return type includes Promise
async function loadData(): Promise<Data> {
  const response = await fetch('/api/data');
  return response.json();
}

// Can return Promise directly
async function getData(): Promise<Data> {
  return fetch('/api/data').then(r => r.json());
}
```

## Array and Object Operations

### Use Array Methods

Prefer built-in array methods over loops:

**Good:**
```typescript
const activeUsers = users.filter(u => u.status === 'active');
const names = users.map(u => u.name);
const total = items.reduce((sum, item) => sum + item.price, 0);
const hasAdmin = users.some(u => u.role === 'admin');
```

### Immutable Updates

Use spread operator for immutable updates:

```typescript
// Objects
const updatedUser = { ...user, name: 'New Name' };

// Arrays
const newItems = [...items, newItem];
const filteredItems = items.filter(item => item.id !== removeId);

// Nested updates
const updatedState = {
  ...state,
  user: {
    ...state.user,
    profile: { ...state.user.profile, name: 'New Name' }
  }
};
```

## Error Handling

### Type-Safe Error Handling

```typescript
class AppError extends Error {
  constructor(
    message: string,
    public code: string,
    public statusCode: number = 500
  ) {
    super(message);
    this.name = 'AppError';
  }
}

function handleError(error: unknown): void {
  if (error instanceof AppError) {
    console.error(`AppError [${error.code}]:`, error.message);
  } else if (error instanceof Error) {
    console.error('Error:', error.message);
  } else {
    console.error('Unknown error:', error);
  }
}
```

### Result Types

Consider result types for expected failures:

```typescript
type Result<T, E = Error> =
  | { success: true; data: T }
  | { success: false; error: E };

async function fetchData(url: string): Promise<Result<Data>> {
  try {
    const response = await fetch(url);
    const data = await response.json();
    return { success: true, data };
  } catch (error) {
    return { success: false, error: error as Error };
  }
}

// Usage
const result = await fetchData('/api/data');
if (result.success) {
  console.log(result.data); // TypeScript knows data exists
} else {
  console.error(result.error); // TypeScript knows error exists
}
```

## Utility Types

### Use Built-in Utility Types

TypeScript provides many useful utility types:

```typescript
// Pick specific properties
type UserPreview = Pick<User, 'id' | 'name'>;

// Omit properties
type UserWithoutPassword = Omit<User, 'password'>;

// Make all properties optional
type PartialUser = Partial<User>;

// Make all properties required
type RequiredUser = Required<User>;

// Make all properties readonly
type ImmutableUser = Readonly<User>;

// Record type
type UserMap = Record<string, User>;

// Extract from union
type SuccessStatus = Extract<Status, 'active' | 'complete'>;

// Exclude from union
type NonErrorStatus = Exclude<Status, 'error'>;
```

## Module Organization

### Imports and Exports

Use named exports for better refactoring:

**Good:**
```typescript
// user.ts
export interface User {
  id: string;
  name: string;
}

export function createUser(name: string): User {
  return { id: generateId(), name };
}

// Import
import { User, createUser } from './user';
```

**Avoid default exports unless:**
- Exporting a single React component
- Following framework conventions (Next.js pages)

### Barrel Exports

Use index files for clean imports:

```typescript
// components/index.ts
export { Button } from './Button';
export { Input } from './Input';
export { Modal } from './Modal';

// Usage
import { Button, Input, Modal } from './components';
```

## Code Style

### Variable Declarations

- Use `const` by default
- Use `let` when reassignment is needed
- Never use `var`

### Semicolons

Be consistent (team preference):
- Use semicolons consistently, OR
- Omit semicolons consistently
- Configure Prettier/ESLint to enforce choice

### Naming Conventions

- **Variables/Functions:** `camelCase`
- **Classes/Interfaces/Types:** `PascalCase`
- **Constants:** `UPPER_SNAKE_CASE` or `camelCase` (team preference)
- **Private fields:** `#privateField` or `_privateField`
- **Type parameters:** Single uppercase letter (`T`, `K`, `V`) or descriptive (`TUser`, `TKey`)

## Integration with Other Rules

TypeScript rules work with:
- **Code Quality** - Type safety improves code quality
- **React** - See `./react.md` for React-specific TypeScript patterns
- **Node.js** - See `./node.md` for Node.js TypeScript patterns
- **Testing** - Type-safe tests prevent runtime errors

## Customization Notes

Teams may want to adjust:
- Strictness level in tsconfig.json
- Preference for interfaces vs types
- Naming conventions
- Whether to use semicolons
- Import organization rules
- Specific ESLint rules for TypeScript
