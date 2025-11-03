# Initialize AI Tooling

**Recommended Mode**: Agent Mode (for creating files and directories)

Set up Cursor configuration in a new or existing project.

## Workflow

### Step 1: Verify Project Root

Confirm this is the project root by checking for:
- `package.json`, `requirements.txt`, `.git/`, `.csproj`, `go.mod`, or similar

Use @code to understand the project structure.

Check if `.cursorrules` already exists:
- If exists: Ask if user wants to append or replace
- If not: Proceed with creation

### Step 2: Detect Project Characteristics

Analyze @code to determine:

**Technologies**:
- Languages: TypeScript, Python, C#, Go, etc.
- Frameworks: React, Django, .NET, etc.
- Tools: Jest, pytest, Docker, etc.

**Project Type**:
- Frontend application
- Backend API
- Full-stack application
- Library/package
- CLI tool

Report findings to user and confirm.

### Step 3: Create Directory Structure

Create these directories:

```
.cursor/
└── commands/  # Custom command files
```

### Step 4: Create .cursorrules File

Generate `.cursorrules` with project-specific guidance:

```markdown
# [Project Name] - Cursor Rules

You are helping with a [detected technologies] project.

## Project Overview
[Brief description based on project structure]

## Technologies
- [List detected technologies]

## Code Style
- [Language-specific conventions]
- Follow existing patterns in the codebase
- Maintain consistency

## Testing
- Framework: [detected test framework]
- Run tests: [command from package.json or similar]
- Write tests for new features

## Git Workflow
- Use conventional commit format
- Branch naming: <type>/<description>
- Create descriptive PRs

## File Organization
[Brief overview of main directories and their purposes]
```

### Step 5: Suggest Custom Commands

Based on project type, recommend installing these commands from the toolkit:

**Essential** (all projects):
- `commit-workflow.md` - Conventional commits
- `review-changes.md` - Code quality checks

**Recommended** (team projects):
- `pr-creation.md` - PR creation with descriptions
- `branch-management.md` - Branch operations

**Optional** (large/complex projects):
- `analyze-complexity.md` - Technical debt analysis

Provide paths to copy from `ae-toolkit/examples/commands/cursor/` if available.

### Step 6: Configure Cursor Settings (Optional)

Suggest creating `.cursor/settings.json` for workspace-specific settings:

```json
{
  "ai": {
    "contextWindow": "large"
  },
  "features": {
    "codebaseIndexing": true
  }
}
```

### Step 7: Provide Summary

Show what was created:

```
✅ Cursor AI Tooling Initialized

Created:
- .cursorrules (project AI guidance)
- .cursor/commands/ (for custom commands)

Next Steps:
1. Review and customize .cursorrules for your team
2. Copy recommended commands from toolkit
3. Test AI assistance with a simple task
4. Share setup with team (commit to git)

Quick Test:
Try asking: "Review the project structure and suggest improvements"
```
