# Development Guide

## Coding Patterns and Standards

### Node.js/Express Conventions

**Module Pattern**
```javascript
// Use var and require (existing project convention)
var express = require('express');
var router = express.Router();

// Export pattern
module.exports = router;
```

**Route Handler Pattern**
```javascript
// Standard Express route handler structure
router.get('/', function(req, res, next) {
  // Handler logic
  res.send('respond with a resource');
});
```

**Middleware Configuration**
```javascript
// Follow existing app.js middleware stack order:
// 1. Logging (morgan)
// 2. Body parsing (express.json, express.urlencoded) 
// 3. Cookie parsing
// 4. Static files
// 5. Route mounting
```

### Code Quality Standards

**Consistency Requirements**
- Use existing variable naming conventions (camelCase)
- Follow existing function declaration style (function declarations, not arrow functions)
- Maintain existing indentation and spacing patterns
- Keep route organization consistent with existing structure

**Error Handling**
- Include `next` parameter in route handlers for error propagation
- Use Express error handling middleware patterns
- Maintain consistency with existing error response formats

### File Organization Guidelines

**Adding New Routes**
- Create new router files in `routes/` directory
- Follow naming convention: `routes/[resource].js`
- Mount routes in `app.js` following existing pattern
- Use descriptive route paths and HTTP methods

**Static Assets**
- Place client-side files in `public/` directory
- Maintain existing subdirectory structure (`stylesheets/`, etc.)
- Follow existing naming conventions

**Configuration Files**
- Keep configuration at root level alongside `package.json`
- Use standard Node.js configuration patterns
- Maintain separation of concerns between app logic and configuration

## Development Workflow Integration

### Git Branch Strategy
- Continue using feature branch workflow: `feature/[name]` → `main`
- Current branch: `feature/azure-integration` for POC development
- Merge to main after POC completion and testing

### AI-Assisted Development Guidelines

**Code Generation Expectations**
- AI-generated code should match existing patterns exactly
- Maintain consistency with project's CommonJS module approach  
- Follow established Express.js middleware and routing patterns
- Respect existing error handling and response formatting

**Context Awareness**
- Consider Azure integration context when suggesting code
- Maintain compatibility with 3-person team collaboration patterns
- Ensure suggestions support ongoing POC development work

### Quality Assurance

**Code Review Standards**
- New code should integrate seamlessly with existing codebase
- Maintain architectural consistency with current Express.js patterns
- Ensure Azure integration compatibility where relevant
- Validate that changes support feature branch development workflow

**Testing Considerations**
- Follow project conventions for any testing implementation
- Consider Azure service integration testing requirements
- Maintain compatibility with existing development environment

## Azure Integration Context

### Development Considerations
- Current POC work involves Azure service integration
- AI suggestions should consider Azure SDK patterns and best practices
- Maintain compatibility with Azure deployment requirements
- Support environment configuration for Azure services

### Team Collaboration
- 3-person team working on shared feature branch
- AI assistance should enhance team productivity without disrupting workflow
- Code suggestions should support collaborative development patterns
- Maintain consistent code style across team contributions