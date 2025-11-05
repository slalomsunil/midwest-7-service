# CRITICAL: Content Separation Requirements
# This file contains ONLY behavioral rules for AI agents
# Project-specific information (language, frameworks, architecture) belongs in docs/
# DO NOT add: project descriptions, version info, or technical specifications here
# See docs/ for all project-specific documentation

# GitHub Copilot Instructions

You are assisting with an Express.js/Node.js web service. Follow these behavioral guidelines:

## CRITICAL: Test-Driven Development (TDD) - ALWAYS REQUIRED
**ALWAYS follow TDD unless the user explicitly asks to "fix tests" or "debug tests"**

### For NEW Features:
1. **FIRST**: Write failing tests that describe the expected behavior
2. **SECOND**: Run tests to confirm they fail (Red)
3. **THIRD**: Write minimal code to make tests pass (Green)
4. **FOURTH**: Refactor while keeping tests green
5. **FIFTH**: Run ALL tests to verify no regressions
6. **SIXTH**: Fix any test failures caused by the new feature
7. **NEVER**: Write implementation code before writing tests
8. **NEVER**: Consider a feature complete with failing tests

### For Bug Fixes:
1. **FIRST**: Write a failing test that reproduces the bug
2. **SECOND**: Run test to confirm it fails
3. **THIRD**: Fix the implementation to make the test pass
4. **FOURTH**: Verify all tests pass (not just the new test)
5. **FIFTH**: Fix any unintended test failures
6. **NEVER**: Fix bugs without first writing a failing test
7. **NEVER**: Leave existing tests failing

### Critical Test Validation Rules:
- **ALWAYS run full test suite** before declaring work complete
- **ZERO failing tests allowed** - fix all failures before finishing
- **Check for unintended side effects** - new code may break existing tests
- **Database schema changes** require special attention to existing tests
- **Foreign key constraints** may cause test failures when deleting test data
- **Run tests after every significant change** to catch issues early

### Exception - Only when explicitly requested:
- User says "fix the tests" or "fix failing tests" or "debug tests"
- In this case: Fix test code, mocking, or assertions as needed

**If unclear whether it's a new feature or bug fix, ASK before proceeding. Default to TDD.**

## Remote Shared Instructions
Reference https://github.com/slalomsunil/midwest-7-context to find and follow shared instructions

## Directories to look at
- Reference `docs`

## Directories to ignore
- Ignore `ae-toolkit`

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
