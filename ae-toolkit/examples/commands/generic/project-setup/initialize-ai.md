---
description: Set up AI tooling in a project
argument-hint: [--reset] [--minimal]
---

# Initialize AI Tooling

Follow each step below in order:

## Step 1: Verify Project Root

Confirm you're in the project root directory by checking for indicators:
- `package.json`, `requirements.txt`, `.git/`, `.csproj`, `go.mod`, or similar
- If not in project root, warn and ask user to confirm or navigate there

Check if `.claude/` directory already exists:
- If exists and no `--reset` flag, warn user and ask if they want to:
  - Continue and merge with existing setup
  - Stop and manually review existing setup
  - Backup existing and start fresh
- If `--reset` flag provided, backup existing `.claude/` to `.claude.backup-[timestamp]/`

## Step 2: Detect Project Characteristics

Analyze the project to understand what rules and agents might be helpful:

### Package/Config Files
Look for these files to determine technologies:
- `package.json` → Node.js/JavaScript/TypeScript
- `tsconfig.json` → TypeScript
- `requirements.txt`, `setup.py`, `pyproject.toml` → Python
- `*.csproj`, `*.sln` → .NET/C#
- `Gemfile` → Ruby
- `go.mod` → Go
- `.eslintrc`, `prettier.config` → JavaScript/TypeScript with tooling

### Framework Detection
Look in package.json or imports for:
- `react`, `next`, `gatsby` → React
- `vue` → Vue
- `@angular` → Angular
- `express`, `fastify`, `koa` → Node.js backend
- `django`, `flask` → Python backend

### Project Type
Based on directory structure and files:
- `src/components/`, `public/` → Frontend application
- `src/api/`, `src/routes/` → Backend API
- `src/`, `test/`, `docs/` → Library
- `cmd/`, `main.go` → CLI tool

Report findings to user and confirm detected technologies are correct.

## Step 3: Create Directory Structure

Create the following structure (unless `--minimal` flag is set):

```
.claude/
├── rules/
│   ├── base/
│   └── tech/
├── agents/
├── commands/
└── lib/
```

For minimal setup (if `--minimal` flag):
```
.claude/
└── rules/
    └── base/
```

## Step 4: Create CLAUDE.md

Create `.claude/CLAUDE.md` with project-specific instructions:

```markdown
# [Project Name] - AI Assistant Instructions

## Project Overview

[Brief description of what this project does - infer from README.md if it exists]

## Technologies

[List detected technologies: TypeScript, React, Node.js, etc.]

## Project Structure

[Brief overview of main directories and their purposes]

## Development Guidelines

### Code Standards
- Follow [language] conventions
- Maintain consistency with existing patterns
- Ensure all changes have appropriate tests

### Testing
- [Test framework]: [location of tests]
- Run tests with: [command from package.json or common pattern]

### Git Workflow
- Branch naming: [suggest based on project or use defaults]
- Commit format: Conventional commits
- PR process: [infer from CONTRIBUTING.md if exists, otherwise suggest standard process]

## AI Tool Configuration

This project uses AI-assisted development with:
- Rules in `.claude/rules/` for code standards and conventions
- [If not minimal] Agents in `.claude/agents/` for specialized tasks
- [If not minimal] Commands in `.claude/commands/` for common workflows

See each directory's README for details on available rules, agents, and commands.

## Getting Started

[Include relevant setup steps from README.md if it exists]

---

Last updated: [current date]
```

Customize based on detected project characteristics.

## Step 5: Offer to Install Base Rules

Ask user if they want to install base rules from the rules library:

**Recommended base rules** (for all projects):
- `communication.md` - Professional communication style
- `code-quality.md` - Code review and quality standards
- `source-control.md` - Git best practices

**Additional base rules** (offer based on project size/complexity):
- `collaboration.md` - Team collaboration patterns
- `session-management.md` - Planning and execution for complex tasks

If user agrees, explain that they can find these rules in the toolkit's rules library and should copy them to `.claude/rules/base/`.

Provide the path to the rules library if this command is being run from a project that has the toolkit:
- Look for `ae-toolkit/examples/rules/generic/base/` relative to project root or in common locations

## Step 6: Suggest Technology-Specific Rules

Based on detected technologies, recommend relevant tech rules:

**If TypeScript detected**:
- `typescript.md` - TypeScript conventions and patterns

**If React detected**:
- `react.md` - React component and state management patterns

**If Python detected**:
- `python.md` - Python conventions and best practices

**If .NET detected**:
- `dotnet.md` - .NET and C# best practices

**If Node.js detected**:
- `node.md` - Node.js and npm patterns

Guide user to copy these from `ae-toolkit/examples/rules/generic/tech/` if available.

## Step 7: Suggest Useful Agents (if not --minimal)

Based on project type, suggest relevant agents:

**For all projects**:
- `code-reviewer.md` - Thorough code review
- `test-generator.md` - Generate comprehensive tests

**For large projects**:
- `tech-debt-analyzer.md` - Technical debt identification
- `refactoring-advisor.md` - Safe refactoring suggestions

**For new projects**:
- `architecture-reviewer.md` - Review architectural decisions

Guide user to copy these from `ae-toolkit/examples/agents/` if available.

## Step 8: Suggest Useful Commands (if not --minimal)

Recommend commands that will be immediately useful:

**Essential commands**:
- `commit-workflow.md` - Guided commit creation
- `review-changes.md` - Quick code review before commit

**Additional commands**:
- `pr-creation.md` - PR analysis and creation
- `branch-management.md` - Branch operations

Guide user to copy these from `ae-toolkit/examples/commands/generic/` if available.

## Step 9: Create Getting Started Guide

Create `.claude/README.md` with guidance on using the AI tooling:

```markdown
# AI Tooling Guide for [Project Name]

## Quick Start

1. **Rules** are automatically applied based on file types and context
   - See `.claude/rules/` for all available rules
   - Modify rules to match your team's preferences

2. **Agents** provide specialized assistance for focused tasks
   - Invoke with `@agent-name` in Claude Code
   - See `.claude/agents/` for available agents

3. **Commands** trigger common workflows
   - Invoke with `/command-name` in Claude Code
   - See `.claude/commands/` for available commands

## Recommended Workflows

### Before Every Commit
1. Run `/review-changes` to check code quality
2. Run `/commit-workflow` to create well-formatted commit

### Creating a Pull Request
1. Ensure all changes are committed
2. Run `/pr-creation` to generate PR with good description

### Starting New Work
1. Run `/branch-management` to create properly named branch
2. Code with AI assistance following project rules
3. Use agents for specialized tasks (review, testing, etc.)

## Customization

Feel free to:
- Modify rules in `.claude/rules/` to match your style
- Add custom agents in `.claude/agents/`
- Create custom commands in `.claude/commands/`
- Update `CLAUDE.md` with project-specific guidance

## Resources

- AE Toolkit documentation: [link if available]
- Claude Code documentation: https://docs.claude.com/claude-code
- Project-specific guidelines: See `CLAUDE.md`
```

## Step 10: Summarize Setup

Provide a summary of what was created and next steps:

```
✅ AI Tooling Initialized

Created:
- .claude/ directory structure
- CLAUDE.md with project-specific instructions
- README.md with usage guidance
- [Any other created files]

Recommended Next Steps:
1. Review and customize CLAUDE.md for your project
2. Copy recommended rules from ae-toolkit/examples/rules/
3. [If not --minimal] Copy useful agents from ae-toolkit/examples/agents/
4. [If not --minimal] Copy useful commands from ae-toolkit/examples/commands/
5. Run /configure-rules to interactively install rules
6. Test AI assistance with a simple task
7. Share setup with your team

Quick Test:
Try asking: "Review the structure of this project and suggest improvements"
```

---

**Notes**:
- If toolkit is not available locally, provide links to online repository
- Respect existing configuration if present
- Make setup as automated as possible but give user control
- Provide clear paths to copy from if toolkit is available
- Consider creating this as an interactive workflow with confirmations
