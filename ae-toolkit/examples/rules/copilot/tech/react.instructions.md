---
applyTo: "**/*.tsx,**/*.jsx"
---

# React Instructions

**Tool:** GitHub Copilot
**Version:** 2025-01
**Category:** Technology-Specific Rules
**Related:** See `../../generic/tech/react.md` for detailed patterns, `../../cursor/tech/react.mdc` for Cursor version

> This file follows GitHub Copilot's custom instructions format and can be placed in `.github/instructions/` for path-specific React guidance.

---

Use functional components with hooks. Avoid class components unless working with legacy code.

Type all component props explicitly with TypeScript interfaces:
```typescript
interface ButtonProps {
  label: string;
  onClick: () => void;
  variant?: 'primary' | 'secondary';
}

export function Button({ label, onClick, variant = 'primary' }: ButtonProps) {
  return <button onClick={onClick} className={variant}>{label}</button>;
}
```

Type children as `React.ReactNode`. Type events properly (e.g., `React.FormEvent<HTMLFormElement>`, `React.ChangeEvent<HTMLInputElement>`).

Use `useState` with proper typing. Use functional updates when depending on previous state.

Use `useEffect` with dependency arrays. Include all dependencies or use useCallback/useMemo for functions.

Use `useCallback` to memoize callbacks passed to child components. Use `useMemo` only for expensive computations, not simple operations.

Use `useRef` for DOM references and mutable values that don't trigger re-renders.

Extract reusable logic into custom hooks with clear names starting with `use`.

Start with local state. Lift state up when needed by multiple components. Use Context for truly global state.

Only use React.memo for expensive components after measuring performance. Don't prematurely optimize.

Use stable, unique keys for lists. Use item IDs, not array indices.

Use lazy loading and Suspense for route-level code splitting.

For forms, prefer React Hook Form or similar libraries over manual state management for complex forms.

Use Error Boundaries to catch rendering errors in child components.

Test components with React Testing Library. Test behavior, not implementation details.

Keep components focused on single responsibilities. Extract complex logic into helper functions.

One component per file. Organize as ComponentName/ComponentName.tsx with co-located tests and styles.

Use descriptive prop names that reveal purpose. Avoid generic names like `data` or `props`.

Prefer composition over prop drilling. Use Context or state management for deeply nested data.
