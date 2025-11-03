# Example: Updates Required Scenario

This example demonstrates a Context Refresher workflow that identifies needed documentation updates.

## Scenario
A team's CLAUDE.md file hasn't been updated in 6 months. During that time, they migrated from Redux to Zustand and adopted React Query for data fetching.

---

# Update Plan - 2024-03-15

## Plan Summary
**Updates Required**: Yes
**Files to Update**: 1 (CLAUDE.md)
**Estimated Scope**: Moderate

## Proposed Updates by File

### CLAUDE.md
**Current State**: Documents Redux patterns, class components, and Axios for data fetching
**Issues Found**:
- References deprecated Redux and redux-thunk
- Missing documentation for Zustand state management
- No mention of React Query for data fetching
- Still documents class component patterns

**Proposed Changes**:

#### Addition 1: Zustand State Management
**Location**: After "State Management" heading
**Content**:
```markdown
## State Management

We use Zustand for state management. Create stores using the following pattern:

\`\`\`typescript
import { create } from 'zustand';

interface StoreState {
  // state properties
  // actions
}

export const useStore = create<StoreState>((set) => ({
  // implementation
}));
\`\`\`

NO Redux patterns - we migrated to Zustand in January 2024.
```
**Rationale**: Team now uses Zustand exclusively, AI needs to know this pattern

#### Removal 1: Redux Documentation
**Location**: State Management section
**Current Content**:
```markdown
## State Management

Use Redux with redux-thunk for async actions:
- Store configuration in store/index.js
- Reducers in store/reducers/
- Actions in store/actions/
```
**Rationale**: Redux was completely removed from the codebase

#### Update 1: Data Fetching Patterns
**Location**: API Integration section
**Current**:
```markdown
Use Axios for API calls with interceptors for auth handling.
```
**Updated**:
```markdown
Use React Query for data fetching:
- Queries for GET requests using useQuery
- Mutations for POST/PUT/DELETE using useMutation
- Configure React Query client in App.tsx
- NO direct Axios usage - React Query handles all API calls
```
**Rationale**: React Query is now the standard for all data fetching

#### Addition 2: Component Patterns
**Location**: Replace "Component Guidelines" section
**Content**:
```markdown
## Component Guidelines

Use functional components with TypeScript and hooks:
- NO class components (migrated January 2024)
- Use custom hooks for shared logic
- Prefer composition over inheritance
```
**Rationale**: Class components are no longer used anywhere in the codebase

## Priority Order
1. **Critical**: Remove Redux documentation (causes confusion and errors)
2. **Critical**: Add Zustand patterns (core state management approach)
3. **High**: Update data fetching to React Query
4. **High**: Remove class component references

## Implementation Notes
- Preserve existing formatting style
- Keep examples concise and practical
- Ensure TypeScript examples throughout

## Risk Assessment
**If Not Updated**:
- AI will suggest Redux patterns that no longer work
- Developers may try to use removed dependencies
- Confusion about current state management approach

**Update Benefits**:
- AI suggestions align with Zustand patterns
- Correct data fetching recommendations
- No more class component suggestions

## Approval Request
Please review this update plan. Upon approval, Phase 5 will:
1. Back up current files
2. Apply updates in priority order
3. Validate changes
4. Create execution log

**Type 'approved' to proceed with updates or provide feedback for plan revision.**

---
**IMPORTANT**: No changes will be made until you explicitly approve this plan.