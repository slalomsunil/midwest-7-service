---
description: Set up AI tooling in a project
mode: agent
tools:
  - workspace
  - terminal
---

# Initialize AI Tooling

## Step 1: Verify Location

Use @workspace to confirm this is the project root.

Check if `.github/` directory exists. If `.github/copilot-instructions.md` exists, ask if user wants to:
- Merge with existing setup
- Review existing setup first
- Create backup and start fresh

## Step 2: Detect Project

Analyze @workspace to determine:
- Technologies (Node.js, Python, .NET, etc.)
- Frameworks (React, Django, etc.)
- Project type (frontend, backend, library, CLI)

Report findings and confirm with user.

## Step 3: Create Structure

Propose creating:
```
.github/
├── copilot-instructions.md  # Project AI instructions
└── prompts/                  # Custom prompt files
```

Also suggest:
```
.vscode/
└── settings.json  # Enable prompt files
```

## Step 4: Create copilot-instructions.md

Generate content:
```markdown
# [Project Name] - Copilot Instructions

## Project Overview
[Brief description]

## Technologies
[Detected technologies]

## Development Guidelines

### Code Standards
- Follow [language] conventions
- Maintain consistency with existing patterns
- Ensure appropriate tests

### Testing
- Framework: [detected]
- Run: [command from package.json]

### Git Workflow
- Conventional commits
- Branch naming: [suggest pattern]

## Resources
- See `.github/prompts/` for custom commands
```

## Step 5: Configure VS Code Settings

Suggest adding to `.vscode/settings.json`:
```json
{
  "github.copilot.chat.promptFiles": true,
  "github.copilot.enable": { "*": true }
}
```

## Step 6: Recommend Prompt Files

Based on project type, suggest installing:
- `/commit-workflow` - For all projects
- `/review-changes` - For all projects
- `/pr-creation` - For team projects
- `/analyze-complexity` - For large projects

Provide paths to copy from ae-toolkit if available.

## Step 7: Summary

Show what was created and next steps:
- Review and customize `copilot-instructions.md`
- Copy recommended prompt files
- Test with simple task
- Share setup with team
