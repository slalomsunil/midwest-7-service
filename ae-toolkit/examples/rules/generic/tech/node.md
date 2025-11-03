# Node.js and npm

<!-- Rule Metadata -->
**Tool:** Claude Code, OpenCode
**Version:** 2025-01
**Category:** Technology-Specific Rules
**Related:** See `./copilot/node.md` for GitHub Copilot version, `./cursor/node.md` for Cursor version, `./typescript.md` for TypeScript patterns, `./react.md` for React patterns

## Purpose

Establish Node.js and npm-specific conventions and patterns for effective backend development, package management, and tooling.

## Package Management

### package.json Best Practices

Structure your package.json clearly:

```json
{
  "name": "my-app",
  "version": "1.0.0",
  "description": "A brief description",
  "main": "dist/index.js",
  "type": "module",
  "scripts": {
    "dev": "nodemon src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js",
    "test": "jest",
    "lint": "eslint src",
    "format": "prettier --write src"
  },
  "keywords": ["api", "backend"],
  "author": "Your Name",
  "license": "MIT",
  "dependencies": {
    "express": "^4.18.0"
  },
  "devDependencies": {
    "typescript": "^5.0.0",
    "nodemon": "^3.0.0"
  },
  "engines": {
    "node": ">=18.0.0",
    "npm": ">=9.0.0"
  }
}
```

### Dependency Management

**Use specific version ranges:**
```json
{
  "dependencies": {
    "express": "^4.18.0",  // Minor updates allowed
    "lodash": "~4.17.21",  // Patch updates only
    "exact-lib": "1.0.0"   // Exact version (rare)
  }
}
```

**Separate dev dependencies:**
```bash
# Production dependencies
npm install express

# Development dependencies
npm install --save-dev typescript @types/node
```

**Lock files:**
- Commit `package-lock.json` or `yarn.lock`
- Use `npm ci` in CI/CD (faster, consistent)
- Don't commit `node_modules/`

### Scripts Best Practices

Define common scripts:
```json
{
  "scripts": {
    "dev": "nodemon --exec ts-node src/index.ts",
    "build": "tsc && tsc-alias",
    "start": "node dist/index.js",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage",
    "lint": "eslint . --ext .ts",
    "lint:fix": "eslint . --ext .ts --fix",
    "format": "prettier --write \"src/**/*.ts\"",
    "typecheck": "tsc --noEmit",
    "clean": "rm -rf dist",
    "prebuild": "npm run clean"
  }
}
```

## Module System

### ESM vs CommonJS

**Prefer ESM (ECMAScript Modules):**

```typescript
// package.json
{
  "type": "module"
}

// Import
import express from 'express';
import { readFile } from 'fs/promises';

// Export
export function myFunction() { }
export default MyClass;
```

**CommonJS (legacy):**
```javascript
// Require
const express = require('express');
const { readFile } = require('fs').promises;

// Export
module.exports = { myFunction };
exports.myFunction = myFunction;
```

### Import Patterns

```typescript
// Named imports
import { Router, Request, Response } from 'express';

// Default import
import express from 'express';

// Namespace import
import * as fs from 'fs/promises';

// Side effects only
import './config/env';

// Dynamic imports
const module = await import('./dynamic-module');
```

## File System Operations

### Use Async File Operations

**Good:**
```typescript
import { readFile, writeFile } from 'fs/promises';

async function loadConfig() {
  const data = await readFile('config.json', 'utf-8');
  return JSON.parse(data);
}

async function saveConfig(config: Config) {
  await writeFile('config.json', JSON.stringify(config, null, 2));
}
```

**Avoid sync operations in async code:**
```typescript
// Bad - blocks event loop
const data = fs.readFileSync('config.json', 'utf-8');
```

### Path Handling

```typescript
import { join, resolve, dirname } from 'path';
import { fileURLToPath } from 'url';

// Get current directory (ESM)
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Join paths
const configPath = join(__dirname, 'config', 'database.json');

// Resolve absolute paths
const absolutePath = resolve('./relative/path');
```

## Environment Configuration

### Use dotenv

```typescript
// Load environment variables
import 'dotenv/config';

// Access variables
const port = process.env.PORT || 3000;
const dbUrl = process.env.DATABASE_URL;

if (!dbUrl) {
  throw new Error('DATABASE_URL is required');
}
```

### Environment Files

```
.env              # Default
.env.local        # Local overrides (gitignored)
.env.development  # Development
.env.production   # Production
.env.test         # Testing
```

### Type-Safe Configuration

```typescript
interface Config {
  port: number;
  databaseUrl: string;
  nodeEnv: 'development' | 'production' | 'test';
}

function loadConfig(): Config {
  const port = parseInt(process.env.PORT || '3000', 10);
  const databaseUrl = process.env.DATABASE_URL;
  const nodeEnv = process.env.NODE_ENV || 'development';

  if (!databaseUrl) {
    throw new Error('DATABASE_URL is required');
  }

  if (nodeEnv !== 'development' && nodeEnv !== 'production' && nodeEnv !== 'test') {
    throw new Error('Invalid NODE_ENV');
  }

  return { port, databaseUrl, nodeEnv };
}

export const config = loadConfig();
```

## Express.js Patterns

### Application Structure

```typescript
import express from 'express';
import { userRouter } from './routes/users';
import { errorHandler } from './middleware/error-handler';

const app = express();

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Routes
app.use('/api/users', userRouter);

// Error handling
app.use(errorHandler);

export { app };
```

### Router Pattern

```typescript
import { Router } from 'express';
import { getUsers, createUser } from '../controllers/user-controller';
import { authenticate } from '../middleware/auth';

const router = Router();

router.get('/', authenticate, getUsers);
router.post('/', authenticate, createUser);

export { router as userRouter };
```

### Type-Safe Controllers

```typescript
import { Request, Response, NextFunction } from 'express';

interface CreateUserBody {
  name: string;
  email: string;
}

export async function createUser(
  req: Request<{}, {}, CreateUserBody>,
  res: Response,
  next: NextFunction
) {
  try {
    const { name, email } = req.body;
    const user = await userService.create({ name, email });
    res.status(201).json(user);
  } catch (error) {
    next(error);
  }
}
```

### Error Handling Middleware

```typescript
import { Request, Response, NextFunction } from 'express';

export function errorHandler(
  err: Error,
  req: Request,
  res: Response,
  next: NextFunction
) {
  console.error(err);

  if (err instanceof ValidationError) {
    return res.status(400).json({ error: err.message });
  }

  if (err instanceof NotFoundError) {
    return res.status(404).json({ error: err.message });
  }

  res.status(500).json({ error: 'Internal server error' });
}
```

## Async Patterns

### Async/Await

```typescript
// Good - clear error handling
async function processData() {
  try {
    const data = await fetchData();
    const processed = await transformData(data);
    await saveData(processed);
    return processed;
  } catch (error) {
    console.error('Processing failed:', error);
    throw error;
  }
}
```

### Parallel Operations

```typescript
// Sequential (slower)
const user = await fetchUser(id);
const posts = await fetchPosts(id);
const comments = await fetchComments(id);

// Parallel (faster)
const [user, posts, comments] = await Promise.all([
  fetchUser(id),
  fetchPosts(id),
  fetchComments(id)
]);

// With error handling
const results = await Promise.allSettled([
  fetchUser(id),
  fetchPosts(id),
  fetchComments(id)
]);

results.forEach((result, index) => {
  if (result.status === 'rejected') {
    console.error(`Operation ${index} failed:`, result.reason);
  }
});
```

## Logging

### Structured Logging

```typescript
import winston from 'winston';

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.json(),
  transports: [
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' })
  ]
});

if (process.env.NODE_ENV !== 'production') {
  logger.add(new winston.transports.Console({
    format: winston.format.simple()
  }));
}

export { logger };

// Usage
logger.info('User created', { userId: user.id });
logger.error('Failed to process payment', { error, userId });
```

## Testing

### Jest Configuration

```typescript
// jest.config.js
export default {
  preset: 'ts-jest',
  testEnvironment: 'node',
  roots: ['<rootDir>/src'],
  testMatch: ['**/__tests__/**/*.ts', '**/?(*.)+(spec|test).ts'],
  collectCoverageFrom: [
    'src/**/*.ts',
    '!src/**/*.d.ts',
    '!src/**/__tests__/**'
  ]
};
```

### Unit Tests

```typescript
import { calculateTotal } from './cart';

describe('calculateTotal', () => {
  it('calculates total with tax', () => {
    const items = [
      { price: 10, quantity: 2 },
      { price: 5, quantity: 1 }
    ];

    const total = calculateTotal(items, 0.1);

    expect(total).toBe(27.5); // (20 + 5) * 1.1
  });
});
```

### Integration Tests

```typescript
import request from 'supertest';
import { app } from '../app';

describe('POST /api/users', () => {
  it('creates a new user', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({ name: 'Alice', email: 'alice@example.com' })
      .expect(201);

    expect(response.body).toMatchObject({
      name: 'Alice',
      email: 'alice@example.com'
    });
  });
});
```

## Performance

### Avoid Blocking the Event Loop

**Good:**
```typescript
// Async operations
await readFile('large-file.txt');

// CPU-intensive work in worker threads
import { Worker } from 'worker_threads';

function runWorker(data: any) {
  return new Promise((resolve, reject) => {
    const worker = new Worker('./worker.js', { workerData: data });
    worker.on('message', resolve);
    worker.on('error', reject);
  });
}
```

**Avoid:**
```typescript
// Blocking sync operations
const data = fs.readFileSync('large-file.txt');

// Long-running loops
for (let i = 0; i < 1000000000; i++) {
  // Blocks event loop
}
```

### Connection Pooling

```typescript
import { Pool } from 'pg';

const pool = new Pool({
  host: config.dbHost,
  port: config.dbPort,
  database: config.dbName,
  max: 20, // Maximum connections
  idleTimeoutMillis: 30000
});

export async function query(text: string, params?: any[]) {
  const client = await pool.connect();
  try {
    return await client.query(text, params);
  } finally {
    client.release();
  }
}
```

### Caching

```typescript
import NodeCache from 'node-cache';

const cache = new NodeCache({ stdTTL: 600 }); // 10 minutes

export async function getCachedUser(id: string): Promise<User> {
  const cached = cache.get<User>(id);
  if (cached) {
    return cached;
  }

  const user = await fetchUser(id);
  cache.set(id, user);
  return user;
}
```

## Security

### Input Validation

```typescript
import { z } from 'zod';

const CreateUserSchema = z.object({
  name: z.string().min(1).max(100),
  email: z.string().email(),
  age: z.number().int().min(0).max(150)
});

export async function createUser(req: Request, res: Response) {
  const result = CreateUserSchema.safeParse(req.body);

  if (!result.success) {
    return res.status(400).json({ errors: result.error.issues });
  }

  const user = await userService.create(result.data);
  res.status(201).json(user);
}
```

### Helmet for Security Headers

```typescript
import helmet from 'helmet';

app.use(helmet());
```

### Rate Limiting

```typescript
import rateLimit from 'express-rate-limit';

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // Limit each IP to 100 requests per windowMs
});

app.use('/api/', limiter);
```

## Process Management

### Graceful Shutdown

```typescript
import { Server } from 'http';

let server: Server;

async function start() {
  server = app.listen(config.port, () => {
    console.log(`Server running on port ${config.port}`);
  });
}

async function shutdown() {
  console.log('Shutting down gracefully...');

  server.close(() => {
    console.log('HTTP server closed');
  });

  // Close database connections
  await pool.end();

  process.exit(0);
}

process.on('SIGTERM', shutdown);
process.on('SIGINT', shutdown);

start();
```

## Integration with Other Rules

Node.js rules work with:
- **TypeScript** - Type-safe Node.js applications
- **React** - SSR with Next.js or Remix
- **Testing** - Jest, Vitest, or Mocha for testing
- **Database** - Prisma, TypeORM, or Sequelize

## Customization Notes

Teams may want to adjust:
- Module system (ESM vs CommonJS)
- Framework choice (Express, Fastify, Koa)
- Testing framework (Jest, Vitest, Mocha)
- Logging library (Winston, Pino, Bunyan)
- Validation library (Zod, Yup, Joi)
- ORM/database library
