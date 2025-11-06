# Architecture Overview

## Architecture Documentation

This document provides an overview of the system architecture. For detailed views at different levels, see:

- **[C1 - System Context](./c1-system-context.md)** - High-level view of the system and external interactions
- **[C2 - Container Diagram](./c2-container.md)** - Major containers and their relationships
- **[C3 - Component Diagram](./c3-component.md)** - Internal components within containers
- **[C4 - Code Diagram](./c4-code.md)** - Detailed code-level patterns

### C4 Model Overview

The C4 model provides a hierarchical way to visualize software architecture:

1. **Level 1 - System Context**: Shows how the system fits into the world (users, external systems)
2. **Level 2 - Containers**: Shows the high-level technical building blocks (apps, databases)
3. **Level 3 - Components**: Shows how containers are made up of components
4. **Level 4 - Code**: Shows how components are implemented (code patterns and structures)

**Navigation**: Start with C1 for high-level understanding, then drill down to C2, C3, and C4 as needed for implementation details.

---

## System Structure

### Application Type
Express.js web service following standard MVC patterns with conventional Node.js structure.

### Directory Organization

```
/
├── app.js                 # Application factory - configures Express app with middleware
├── bin/www               # Server entry point - creates HTTP server and starts listening
├── routes/               # Route handlers - RESTful endpoint definitions
│   ├── index.js          # Root route handler
│   └── users.js          # User-related routes
├── public/               # Static assets - served directly by Express
│   ├── index.html        # Default HTML page
│   └── stylesheets/      # CSS files
├── package.json          # Project metadata and dependencies
└── docs/                 # AI development documentation (this directory)
```

### Key Architectural Patterns

**Express Application Factory Pattern**
- `app.js` exports configured Express application
- Middleware stack: morgan (logging), express.json, cookie-parser
- Route mounting: `'/'` → indexRouter, `'/users'` → usersRouter

**Route Module Pattern** 
- Separate router modules in `routes/` directory
- Each router handles specific URL namespace
- Standard Express router creation and export pattern

**Static File Serving**
- `public/` directory served at root path
- Standard Express static middleware configuration

## Architectural Decisions

### Technology Stack Rationale
- **Express.js 4.16.1**: Mature, stable web framework with extensive middleware ecosystem
- **CommonJS Modules**: Standard Node.js module system (var/require pattern)
- **Standard Middleware**: Industry-standard logging, parsing, and cookie handling

### Complexity Assessment
- **Standard Complexity**: Follows conventional Express.js patterns without advanced architectural abstractions
- **Domain Baseline**: Typical three-tier Express structure (routes, middleware, static assets)
- **No Advanced Patterns**: No dependency injection, complex domain modeling, or distributed system patterns

### Integration Points
- **Current Development**: Azure integration work in progress on feature/azure-integration branch
- **Future Considerations**: AI development enhancements for productivity and code consistency

### Data Storage
- **In-Memory Database**: Levarage an in-memory database to store and retrieve all application data

## API Endpoints

### User Presence & Online Status

**GET /api/users/online**

Returns a list of currently online users, excluding the requesting user.

**Query Parameters:**
- `excludeUserId` (optional, integer): User ID to exclude from results (typically the current user)

**Response:**
```json
{
  "success": true,
  "users": [
    {
      "id": 1,
      "username": "alice",
      "display_name": "Alice Smith",
      "bio": "User bio",
      "profile_image": "url",
      "last_active": "2025-11-04T12:00:00Z"
    }
  ]
}
```

**Headers:**
- `Cache-Control: public, max-age=3` - Allows caching for 3 seconds to optimize polling

**Implementation Notes:**
- Uses database index on `is_online` column for efficient queries
- Users are marked online/offline via auth endpoints (login/logout)
- Designed for polling with recommended interval of 5 seconds
- Automatic exponential backoff on client side for error handling

### Authentication Flow

**POST /api/auth/login**
- Marks user as online (`is_online=1`) upon successful login
- Updates `last_active` timestamp

**POST /api/auth/logout** 
- Marks user as offline (`is_online=0`)
- Requires `userId` or `username` in request body

## Key Constraints for AI Development

### Preserve Existing Patterns
- Maintain Express.js conventional structure and naming
- Continue using CommonJS module pattern (var/require)
- Respect existing middleware configuration approach

### Azure Integration Context
- Current feature branch work involves Azure service integration  
- AI suggestions should be compatible with Azure SDK patterns
- Consider Azure deployment and configuration requirements

### Team Collaboration
- 3-person development team using Git feature branch workflow
- AI-generated code should follow team's established patterns
- Maintain consistency with existing code style and organization
