# Midwest 7 Service

Social Media POC API - Express.js service with SQLite persistent storage for Azure App Service deployment.

## Overview

This is a Node.js/Express.js web service that provides RESTful APIs for a social media application. It uses SQLite for persistent data storage and is optimized for deployment on Azure App Service.

## Features

- 🚀 RESTful API for user management
- 💾 SQLite persistent storage (Azure-compatible)
- 📚 Swagger API documentation (development only)
- ✅ Comprehensive test coverage
- 🔄 CommonJS module pattern
- 🌐 Azure App Service ready

## Prerequisites

- Node.js (v14 or higher)
- npm (v6 or higher)

## Installation

```bash
npm install
```

## Running the Application

### Development Mode

```bash
npm start
```

The application will start on port **8081** by default.

**Console output:**
```
============================================================
🚀 Server is running!
============================================================

📍 Port: 8081
🌐 API URL: http://localhost:8081
📚 Swagger Documentation: http://localhost:8081/api-docs

============================================================
```

### Environment Variables

- `PORT` - Server port (default: 8081)
- `NODE_ENV` - Environment mode (development/production)
- `WEBSITE_INSTANCE_ID` - Azure App Service identifier (auto-set by Azure)

## API Documentation

### Swagger UI

In **local development** only, interactive API documentation is available at:

**http://localhost:8081/api-docs**

> 🔒 **Note:** Swagger is automatically disabled in production and Azure deployments for security.

### Available Endpoints

#### Users

- **GET /users** - Retrieve all users
- **GET /users/:id** - Get user by ID
- **POST /users** - Create new user
- **PUT /users/:id** - Update user

For detailed request/response schemas, see the Swagger documentation.

## Testing

This project uses **Jest** for testing and **Supertest** for API endpoint testing.

### Run All Tests

```bash
npm test
```

### Run Tests with Coverage

```bash
npm run test:coverage
```

This will:
- Run all test suites
- Generate coverage reports in the `coverage/` directory
- Display coverage summary in the console

**Coverage thresholds:** 80% for branches, functions, lines, and statements

### Run Tests in Watch Mode

```bash
npm run test:watch
```

Automatically re-runs tests when files change (useful during development).

### Run Tests with Verbose Output

```bash
npm run test:verbose
```

Shows detailed information about each test case.

### Coverage Reports

After running `npm run test:coverage`, you can view detailed coverage reports:

**HTML Report:**
```bash
open coverage/index.html
```

**Console Report:**
Coverage summary is displayed automatically in the terminal.

### Test Structure

```
__tests__/
├── db/
│   └── users.test.js       # Database layer tests
└── routes/
    └── users.test.js       # API endpoint tests
```

**Test Coverage Includes:**
- ✅ All user API endpoints (GET, POST, PUT)
- ✅ Database CRUD operations
- ✅ Error handling and validation
- ✅ Edge cases and boundary conditions

## Database

### SQLite Storage

The application uses SQLite for persistent data storage.

**Local Development:**
- Database file: `db/cache.db`

**Azure App Service:**
- Database file: `/home/data/cache.db` (persistent storage)

### Database Schema

**Users Table:**
```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT UNIQUE NOT NULL,
  display_name TEXT,
  bio TEXT,
  profile_image TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

**Posts Table:**
```sql
CREATE TABLE posts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  content TEXT NOT NULL,
  image_url TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);
```

## Project Structure

```
.
├── app.js                  # Express application setup
├── bin/
│   └── www                 # Server startup script
├── config/
│   └── swagger.js          # Swagger configuration
├── db/
│   ├── init.js            # Database initialization
│   ├── users.js           # User database operations
│   └── posts.js           # Post database operations
├── routes/
│   ├── index.js           # Root routes
│   └── users.js           # User API routes
├── __tests__/             # Test files
├── public/                # Static files
├── package.json           # Dependencies and scripts
└── jest.config.js         # Jest configuration

```

## Development Guidelines

### Code Patterns

- **Module System:** CommonJS (var/require, module.exports)
- **Async Handling:** Callbacks and try/catch blocks
- **Naming:** Camelcase for variables, descriptive function names
- **Error Handling:** Consistent error response format

### Adding New Features

1. Create database operations in `db/` directory
2. Add route handlers in `routes/` directory
3. Document endpoints with Swagger JSDoc comments
4. Write tests in `__tests__/` directory
5. Ensure test coverage meets 80% threshold

## Deployment

### Azure App Service

The application is configured for Azure App Service deployment:

1. **Database:** Automatically uses `/home/data/` for persistent storage
2. **Swagger:** Disabled in production (auto-detected)
3. **Port:** Respects `PORT` environment variable

### Deploy to Azure

```bash
# Azure CLI deployment example
az webapp up --name your-app-name --resource-group your-rg
```

## Contributing

This project follows a feature branch workflow:

1. Create feature branch: `git checkout -b feature/your-feature`
2. Make changes and commit
3. Push to origin: `git push origin feature/your-feature`
4. Create pull request to `main` branch

## Team

- 3-person development team
- Current branch: `feature/azure-integration`

## License

Private project for Midwest 7 social media POC.
