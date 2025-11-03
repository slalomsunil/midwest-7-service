---
applyTo: "**/*"
---

# Session Management Instructions

**Tool:** GitHub Copilot
**Version:** 2025-01
**Category:** Base Rules
**Related:** See `../generic/session-management.md` for generic version, `../cursor/` for Cursor version

> This file follows GitHub Copilot's custom instructions format and can be placed in `.github/instructions/` for path-specific instructions or incorporated into `.github/copilot-instructions.md` for repository-wide instructions.

---

When generating code for complex multi-step operations, structure it to enable clear progress tracking and error recovery.

Break complex functions into smaller, well-named functions that represent logical steps in the process.

Add clear logging or status updates at major checkpoints in generated workflows:
```typescript
logger.info('Starting data migration');
const users = await loadUsers();
logger.info(`Loaded ${users.length} users`);

const transformed = transformUsers(users);
logger.info('Transformation complete');

await saveUsers(transformed);
logger.info('Migration complete');
```

Generate error handling that preserves context about which step failed:
```typescript
try {
  await step1();
  await step2();
  await step3();
} catch (error) {
  logger.error('Failed during step2', { error, context });
  throw error;
}
```

When generating code with multiple operations, structure it so partial progress can be recovered:
```typescript
// Good - can resume from checkpoint
const processedIds = await loadCheckpoint();
const remaining = items.filter(item => !processedIds.has(item.id));

for (const item of remaining) {
  await processItem(item);
  await saveCheckpoint(item.id);
}
```

Don't generate long, monolithic functions that perform many unrelated operations. Break them into focused functions.

When generating async operations, make dependencies clear:
```typescript
// Clear that these must happen in sequence
const user = await fetchUser(id);
const posts = await fetchUserPosts(user.id);
const comments = await fetchPostComments(posts.map(p => p.id));

// Clear that these can happen in parallel
const [user, settings, preferences] = await Promise.all([
  fetchUser(id),
  fetchSettings(id),
  fetchPreferences(id)
]);
```

Generate code that validates prerequisites before starting work:
```typescript
function processData(data: Data[]) {
  if (!data || data.length === 0) {
    throw new Error('No data to process');
  }
  // Continue with processing
}
```

Add comments in generated code when the order of operations is critical but not obvious:
```typescript
// Must load config before initializing database connection
await loadConfig();
await initDatabase();
```
