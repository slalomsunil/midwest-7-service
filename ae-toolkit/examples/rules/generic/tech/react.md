# React

<!-- Rule Metadata -->
**Tool:** Claude Code, OpenCode
**Version:** 2025-01
**Category:** Technology-Specific Rules
**Related:** See `./copilot/react.md` for GitHub Copilot version, `./cursor/react.md` for Cursor version, `./typescript.md` for TypeScript patterns, `./node.md` for Node.js patterns

## Purpose

Establish React-specific conventions and patterns that promote component reusability, maintainability, and alignment with modern React practices.

## Component Structure

### Functional Components

Use functional components with hooks:

**Good:**
```typescript
interface UserCardProps {
  user: User;
  onEdit: (user: User) => void;
}

export function UserCard({ user, onEdit }: UserCardProps) {
  const [isExpanded, setIsExpanded] = useState(false);

  return (
    <div className="user-card">
      <h3>{user.name}</h3>
      <button onClick={() => setIsExpanded(!isExpanded)}>
        {isExpanded ? 'Collapse' : 'Expand'}
      </button>
    </div>
  );
}
```

**Avoid class components** unless working with legacy code:
```typescript
// Avoid new class components
class UserCard extends React.Component { }
```

### Component File Organization

One component per file:
```
components/
  UserCard/
    UserCard.tsx
    UserCard.test.tsx
    UserCard.module.css (or styles.ts for CSS-in-JS)
    index.ts (export { UserCard } from './UserCard')
```

## TypeScript with React

### Type Component Props

Always type props explicitly:

```typescript
interface ButtonProps {
  label: string;
  onClick: () => void;
  variant?: 'primary' | 'secondary';
  disabled?: boolean;
}

export function Button({ label, onClick, variant = 'primary', disabled }: ButtonProps) {
  return (
    <button onClick={onClick} disabled={disabled} className={variant}>
      {label}
    </button>
  );
}
```

### Type Children

```typescript
interface CardProps {
  children: React.ReactNode;
  title: string;
}

export function Card({ children, title }: CardProps) {
  return (
    <div>
      <h2>{title}</h2>
      {children}
    </div>
  );
}
```

### Type Events

```typescript
interface FormProps {
  onSubmit: (data: FormData) => void;
}

export function Form({ onSubmit }: FormProps) {
  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    // ...
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    // ...
  };

  return <form onSubmit={handleSubmit}>...</form>;
}
```

## Hooks

### useState

```typescript
// Simple state
const [count, setCount] = useState(0);

// Object state
const [user, setUser] = useState<User | null>(null);

// Lazy initialization for expensive calculations
const [data, setData] = useState(() => expensiveComputation());

// Functional updates when depending on previous state
setCount(prevCount => prevCount + 1);
```

### useEffect

```typescript
// Run once on mount
useEffect(() => {
  loadData();
}, []);

// Run when dependencies change
useEffect(() => {
  if (userId) {
    loadUser(userId);
  }
}, [userId]);

// Cleanup
useEffect(() => {
  const subscription = subscribe();
  return () => subscription.unsubscribe();
}, []);

// Avoid missing dependencies
useEffect(() => {
  fetchData(id); // Include all dependencies
}, [id, fetchData]); // Or use useCallback for fetchData
```

### useCallback

Memoize callbacks to prevent unnecessary re-renders:

```typescript
const handleClick = useCallback(() => {
  doSomething(id);
}, [id]);

// Pass to child components
<ChildComponent onClick={handleClick} />
```

### useMemo

Memoize expensive computations:

```typescript
const expensiveValue = useMemo(() => {
  return computeExpensiveValue(data);
}, [data]);

// Don't overuse - only for actual performance issues
// Bad: useMemo for simple operations
const doubled = useMemo(() => count * 2, [count]); // Unnecessary
```

### useRef

```typescript
// DOM references
const inputRef = useRef<HTMLInputElement>(null);
useEffect(() => {
  inputRef.current?.focus();
}, []);

// Mutable values that don't trigger re-renders
const renderCount = useRef(0);
renderCount.current += 1;
```

### Custom Hooks

Extract reusable logic:

```typescript
function useUser(userId: string) {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    setLoading(true);
    fetchUser(userId)
      .then(setUser)
      .catch(setError)
      .finally(() => setLoading(false));
  }, [userId]);

  return { user, loading, error };
}

// Usage
function UserProfile({ userId }: { userId: string }) {
  const { user, loading, error } = useUser(userId);

  if (loading) return <Spinner />;
  if (error) return <Error message={error.message} />;
  if (!user) return <NotFound />;

  return <div>{user.name}</div>;
}
```

## State Management

### Local State First

Start with local state, lift up when needed:

```typescript
// Local state
function Counter() {
  const [count, setCount] = useState(0);
  return <button onClick={() => setCount(count + 1)}>{count}</button>;
}

// Lifted state
function Parent() {
  const [count, setCount] = useState(0);
  return (
    <>
      <Display count={count} />
      <Controls onIncrement={() => setCount(count + 1)} />
    </>
  );
}
```

### Context for Global State

Use Context for truly global state:

```typescript
interface ThemeContextValue {
  theme: 'light' | 'dark';
  toggleTheme: () => void;
}

const ThemeContext = createContext<ThemeContextValue | undefined>(undefined);

export function ThemeProvider({ children }: { children: React.ReactNode }) {
  const [theme, setTheme] = useState<'light' | 'dark'>('light');

  const toggleTheme = useCallback(() => {
    setTheme(prev => prev === 'light' ? 'dark' : 'light');
  }, []);

  return (
    <ThemeContext.Provider value={{ theme, toggleTheme }}>
      {children}
    </ThemeContext.Provider>
  );
}

export function useTheme() {
  const context = useContext(ThemeContext);
  if (!context) {
    throw new Error('useTheme must be used within ThemeProvider');
  }
  return context;
}
```

### External State Management

For complex apps, consider:
- **Zustand** - Lightweight and simple
- **Redux Toolkit** - Full-featured, established
- **Jotai** - Atomic state management
- **TanStack Query** - Server state management

## Performance Optimization

### Avoid Premature Optimization

Optimize only when needed:
1. Measure performance first
2. Identify actual bottlenecks
3. Apply targeted optimizations

### React.memo

Prevent re-renders for expensive components:

```typescript
const ExpensiveComponent = React.memo(({ data }: { data: Data }) => {
  return <div>{/* Expensive rendering */}</div>;
});

// With custom comparison
const ExpensiveComponent = React.memo(
  ({ data }: { data: Data }) => {
    return <div>{data.name}</div>;
  },
  (prevProps, nextProps) => prevProps.data.id === nextProps.data.id
);
```

### Key Props

Use stable, unique keys for lists:

**Good:**
```typescript
{users.map(user => (
  <UserCard key={user.id} user={user} />
))}
```

**Avoid:**
```typescript
{users.map((user, index) => (
  <UserCard key={index} user={user} /> // Causes issues with reordering
))}
```

### Code Splitting

Use lazy loading for route-level code splitting:

```typescript
const Dashboard = lazy(() => import('./Dashboard'));
const Profile = lazy(() => import('./Profile'));

function App() {
  return (
    <Suspense fallback={<Loading />}>
      <Routes>
        <Route path="/dashboard" element={<Dashboard />} />
        <Route path="/profile" element={<Profile />} />
      </Routes>
    </Suspense>
  );
}
```

## Styling

### CSS Modules

```typescript
import styles from './Button.module.css';

export function Button({ label }: { label: string }) {
  return <button className={styles.button}>{label}</button>;
}
```

### CSS-in-JS (styled-components, emotion)

```typescript
import styled from 'styled-components';

const StyledButton = styled.button<{ variant: 'primary' | 'secondary' }>`
  padding: 8px 16px;
  background: ${props => props.variant === 'primary' ? 'blue' : 'gray'};
`;

export function Button({ label, variant }: ButtonProps) {
  return <StyledButton variant={variant}>{label}</StyledButton>;
}
```

### Tailwind CSS

```typescript
export function Button({ label, variant }: ButtonProps) {
  const baseStyles = 'px-4 py-2 rounded';
  const variantStyles = variant === 'primary'
    ? 'bg-blue-500 text-white'
    : 'bg-gray-200 text-black';

  return (
    <button className={`${baseStyles} ${variantStyles}`}>
      {label}
    </button>
  );
}
```

## Forms

### Controlled Components

```typescript
function LoginForm() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    login(email, password);
  };

  return (
    <form onSubmit={handleSubmit}>
      <input
        type="email"
        value={email}
        onChange={e => setEmail(e.target.value)}
      />
      <input
        type="password"
        value={password}
        onChange={e => setPassword(e.target.value)}
      />
      <button type="submit">Login</button>
    </form>
  );
}
```

### Form Libraries

For complex forms, use libraries:
- **React Hook Form** - Performance-focused
- **Formik** - Full-featured
- **TanStack Form** - Type-safe

```typescript
import { useForm } from 'react-hook-form';

interface FormData {
  email: string;
  password: string;
}

function LoginForm() {
  const { register, handleSubmit, formState: { errors } } = useForm<FormData>();

  const onSubmit = (data: FormData) => {
    login(data.email, data.password);
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <input {...register('email', { required: true })} />
      {errors.email && <span>Email is required</span>}

      <input {...register('password', { required: true })} type="password" />
      {errors.password && <span>Password is required</span>}

      <button type="submit">Login</button>
    </form>
  );
}
```

## Error Boundaries

```typescript
class ErrorBoundary extends React.Component<
  { children: React.ReactNode },
  { hasError: boolean }
> {
  state = { hasError: false };

  static getDerivedStateFromError() {
    return { hasError: true };
  }

  componentDidCatch(error: Error, errorInfo: React.ErrorInfo) {
    console.error('Error caught:', error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      return <h1>Something went wrong.</h1>;
    }
    return this.props.children;
  }
}

// Usage
<ErrorBoundary>
  <App />
</ErrorBoundary>
```

## Testing

### Component Tests

```typescript
import { render, screen, fireEvent } from '@testing-library/react';
import { Counter } from './Counter';

describe('Counter', () => {
  it('increments count when button is clicked', () => {
    render(<Counter />);

    const button = screen.getByRole('button');
    expect(screen.getByText('Count: 0')).toBeInTheDocument();

    fireEvent.click(button);
    expect(screen.getByText('Count: 1')).toBeInTheDocument();
  });
});
```

### Hook Tests

```typescript
import { renderHook, act } from '@testing-library/react';
import { useCounter } from './useCounter';

describe('useCounter', () => {
  it('increments count', () => {
    const { result } = renderHook(() => useCounter());

    expect(result.current.count).toBe(0);

    act(() => {
      result.current.increment();
    });

    expect(result.current.count).toBe(1);
  });
});
```

## Common Patterns

### Compound Components

```typescript
const Tabs = ({ children }: { children: React.ReactNode }) => {
  const [activeIndex, setActiveIndex] = useState(0);
  return (
    <TabsContext.Provider value={{ activeIndex, setActiveIndex }}>
      {children}
    </TabsContext.Provider>
  );
};

Tabs.List = ({ children }: { children: React.ReactNode }) => (
  <div role="tablist">{children}</div>
);

Tabs.Tab = ({ index, children }: { index: number; children: React.ReactNode }) => {
  const { activeIndex, setActiveIndex } = useTabsContext();
  return (
    <button onClick={() => setActiveIndex(index)}>
      {children}
    </button>
  );
};

// Usage
<Tabs>
  <Tabs.List>
    <Tabs.Tab index={0}>Tab 1</Tabs.Tab>
    <Tabs.Tab index={1}>Tab 2</Tabs.Tab>
  </Tabs.List>
</Tabs>
```

### Render Props

```typescript
interface MouseTrackerProps {
  children: (position: { x: number; y: number }) => React.ReactNode;
}

function MouseTracker({ children }: MouseTrackerProps) {
  const [position, setPosition] = useState({ x: 0, y: 0 });

  return (
    <div onMouseMove={e => setPosition({ x: e.clientX, y: e.clientY })}>
      {children(position)}
    </div>
  );
}

// Usage
<MouseTracker>
  {({ x, y }) => <p>Mouse at {x}, {y}</p>}
</MouseTracker>
```

## Integration with Other Rules

React rules work with:
- **TypeScript** - Type-safe React components
- **Code Quality** - Component testing and review
- **Node.js** - Next.js, Remix, or Create React App tooling

## Customization Notes

Teams may want to adjust:
- Component file structure (co-location vs separation)
- Styling approach (CSS Modules, CSS-in-JS, Tailwind)
- State management library choice
- Form handling approach
- Testing library preferences (React Testing Library vs Enzyme)
- Build tool (Vite, Next.js, Create React App)
