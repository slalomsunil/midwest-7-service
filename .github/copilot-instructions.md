# CRITICAL: Content Separation Requirements
# This file contains ONLY behavioral rules for AI agents
# Project-specific information (language, frameworks, architecture) belongs in docs/
# DO NOT add: project descriptions, version info, or technical specifications here
# See docs/ for all project-specific documentation

# GitHub Copilot Instructions

You are assisting with an Express.js/Node.js web service. Follow these behavioral guidelines:

## Remote Shared Instructions
Reference https://github.com/slalomsunil/midwest-7-context to find and follow shared instructions

## Core AI Behavior Rules

**Do what has been asked; nothing more, nothing less.**

- Focus on the specific request without adding unnecessary features
- Maintain existing code patterns and architectural decisions
- Preserve the current project structure and organization
- Ask for clarification when requirements are ambiguous

## Project Context Navigation

For detailed project information, consult these documentation files:

- **Architecture & Structure**: See `docs/architecture.md` for system organization and key patterns
- **Development Standards**: See `docs/development-guide.md` for coding conventions and workflow
- **Documentation Hub**: See `docs/README.md` for navigation and project context

## Code Generation Guidelines

**Pattern Consistency**
- Follow existing CommonJS module patterns (var/require, module.exports)
- Maintain current Express.js middleware and routing conventions
- Preserve existing error handling and response formatting approaches
- Use established naming conventions and code organization

**Quality Standards**
- Generate code that integrates seamlessly with existing codebase
- Maintain architectural consistency with current Express.js patterns
- Ensure compatibility with 3-person team collaboration workflow
- Support ongoing feature branch development process

## Integration Requirements

**Team Workflow**
- Support feature branch development workflow (feature/ → main)
- Maintain compatibility with Git-based collaboration patterns  
- Generate code appropriate for 3-person development team
- Consider ongoing Azure integration POC development context

**Development Environment**
- Work within existing Node.js/Express technology stack
- Respect current project dependencies and configuration
- Support gradual enhancement approach (not comprehensive changes)
- Maintain development productivity during feature implementation

## Constraints and Limitations

**Preserve Existing Infrastructure**
- Do not modify core application structure without explicit request
- Maintain existing middleware configuration and routing patterns
- Keep current static file organization and serving approach
- Respect established development workflow and branch strategy

**Focus Areas**
- Prioritize code consistency and pattern adherence
- Support context switching reduction through clear, readable code
- Enhance documentation maintenance through consistent practices
- Accelerate feature development while maintaining quality standards
