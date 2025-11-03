# Architecture Overview

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
