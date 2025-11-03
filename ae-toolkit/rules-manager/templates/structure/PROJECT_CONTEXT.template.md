# Project Context Template

This template provides project-specific context that should be populated by the router implementation.

## Router Integration

**This file should be referenced by `.ai-rules/router.md` when project-specific context is needed.**

Projects should customize this template with their specific details and place it in the appropriate location based on their architecture.

## Project Overview

**Project Type**: [WEB_APPLICATION | LIBRARY | CLI_TOOL | MICROSERVICE | MONOREPO | OTHER]

**Primary Technologies**: [List main programming languages, frameworks, and tools]

**Architecture Pattern**: [MONOLITHIC | MICROSERVICES | SERVERLESS | JAM_STACK | OTHER]

**Team Structure**: [Team size, roles, and collaboration patterns]

**Development Stage**: [EARLY_DEVELOPMENT | ACTIVE_DEVELOPMENT | MAINTENANCE | LEGACY]

## Router Context References

**Base Rules Always Applied**: 
- Communication, session, regression, collaboration, context, source control rules

**Technology Rules Applied Based On**:
```
File Extensions -> Technology Rules:
.js, .mjs, .cjs -> rules/tech/node.md
.jsx, .tsx -> rules/tech/react.md  
.ts -> rules/tech/typescript.md
package.json -> rules/tech/node.md
[Add project-specific mappings]
```

**SDLC Rules Applied Based On**:
```
Context Triggers -> SDLC Rules:
__tests__/, spec/ -> rules/sdlc/test.md
docs/ -> rules/sdlc/define.md
"deploy", "release" -> rules/sdlc/deploy.md
[Add project-specific triggers]
```
- Example: `docs/` - Project documentation
- Example: `config/` - Configuration files

**File Organization Patterns**: [How files are organized within directories]
- Example: Feature-based organization in `src/features/`
- Example: Layer-based organization with `controllers/`, `services/`, `models/`

**Configuration Locations**: [Where configuration files are expected]
- Example: Environment configs in `config/environments/`
- Example: Tool configurations in project root or `.config/`

## Development Workflow

**Branch Strategy**: [Git workflow and branching patterns]
- Example: Feature branches from `main`
- Example: Release branches for production deployments

**Code Review Process**: [How code reviews are conducted]
- Example: All changes require PR review
- Example: Automated checks must pass before merge

**Testing Strategy**: [Testing approach and requirements]
- Example: Unit tests required for new features
- Example: Integration tests for API endpoints
- Example: End-to-end tests for critical user flows

**Deployment Process**: [How deployments work]
- Example: Automatic deployment from `main` branch
- Example: Manual deployment approval process

## Technical Constraints

**Language/Framework Versions**: [Specific version requirements]
- Example: Node.js 18+ required
- Example: Python 3.9+ with specific library versions

**Platform Requirements**: [Target platforms and environments]
- Example: Must support modern browsers (Chrome, Firefox, Safari)
- Example: Deployed on AWS using containerization

**Performance Requirements**: [Performance expectations and constraints]
- Example: API responses under 200ms
- Example: Bundle size under 500KB

**Security Requirements**: [Security considerations and requirements]
- Example: All data encrypted in transit and at rest
- Example: Authentication required for all API endpoints

## Business Context

**Domain Knowledge**: [Key business concepts and terminology]
- Example: E-commerce platform with products, orders, customers
- Example: Financial application with accounts, transactions, reporting

**User Base**: [Information about users and usage patterns]
- Example: Internal tool used by 50+ employees
- Example: Public-facing application with 10K+ daily users

**Success Metrics**: [How success is measured]
- Example: User engagement and task completion rates
- Example: System uptime and performance metrics

## Team Preferences

**Coding Style**: [Team preferences for code organization and style]
- Example: Functional programming patterns preferred
- Example: Explicit over implicit, verbose over clever

**Tool Preferences**: [Preferred development tools and practices]
- Example: TypeScript for type safety
- Example: ESLint and Prettier for code formatting
- Example: Jest for testing

**Communication Patterns**: [How the team communicates about technical decisions]
- Example: Technical discussions in dedicated Slack channels
- Example: Architecture decisions documented in ADRs

## Common Patterns

**Recurring Solutions**: [Common patterns used throughout the project]
- Example: Repository pattern for data access
- Example: Factory pattern for creating domain objects
- Example: Observer pattern for event handling

**Error Handling**: [Project-specific error handling patterns]
- Example: Centralized error handling with custom error types
- Example: Graceful degradation for non-critical features

**Data Management**: [How data is handled throughout the application]
- Example: Immutable data structures
- Example: State management with Redux/Vuex/etc.
- Example: Database migrations and schema changes

## Integration Points

**External Services**: [Third-party services and APIs used]
- Example: Payment processing with Stripe
- Example: Email delivery with SendGrid
- Example: Analytics with Google Analytics

**Internal Services**: [Other internal systems this project integrates with]
- Example: User authentication service
- Example: Logging and monitoring systems
- Example: CI/CD pipeline integration

## Troubleshooting

**Common Issues**: [Frequent problems and their solutions]
- Example: Database connection issues in development
- Example: Build failures due to dependency conflicts
- Example: Environment variable configuration problems

**Debug Resources**: [Tools and techniques for debugging]
- Example: Application logs location and format
- Example: Debug endpoints and development tools
- Example: Performance profiling tools and techniques
