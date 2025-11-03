---
description: Browse and install Copilot instructions
mode: agent
tools:
  - workspace
---

# Configure Copilot Instructions

**Note**: GitHub Copilot uses `.github/copilot-instructions.md` for project-level guidance, not separate rule files like Claude Code. This command helps you create or enhance that file with standards from the toolkit's rules library.

## Step 1: Check Existing Setup

Use @workspace to check if `.github/copilot-instructions.md` exists.
- If exists: Offer to append new sections
- If not: Offer to create it

## Step 2: Detect Project

Analyze @workspace to determine what instruction types would be helpful:
- Base instructions (communication, code quality, source control)
- Technology instructions (TypeScript, React, Python, .NET, etc.)

## Step 3: Show Available Instructions

### Base Instructions (Recommended for All)

**Communication**:
- Professional, concise style
- Clear technical explanations
- No unnecessary emojis

**Code Quality**:
- Review standards
- Testing requirements
- Documentation practices

**Source Control**:
- Conventional commits
- Branch naming
- PR guidelines

**Collaboration**:
- Code review practices
- Team workflows
- PR review standards

### Technology Instructions

Based on detected stack, offer:
- **TypeScript**: Type safety, interfaces, async patterns
- **React**: Components, hooks, state management
- **Python**: PEP 8, type hints, pythonic patterns
- **.NET**: C# conventions, async/await, DI patterns
- **Node.js**: Module patterns, error handling

## Step 4: Generate Instructions

Based on user selection, generate or append to `copilot-instructions.md`:

```markdown
# Project Copilot Instructions

## Communication Style
[Selected communication standards]

## Code Quality Standards
[Selected quality standards]

## Technology Conventions

### [Technology]
[Selected tech-specific standards]

## Git Workflow
[Selected source control standards]

## Testing
[Testing standards from selections]
```

## Step 5: Installation

Explain that these instructions are now active for Copilot in this project.

Unlike Claude Code's separate rule files, all instructions are in one file that Copilot reads automatically.

## Step 6: Next Steps

Suggest:
- Review and customize for team
- Add project-specific guidelines
- Install custom prompt files (`/initialize-ai`)
- Test Copilot with new instructions active
- Share with team (commit to git)

**Tip**: Keep instructions focused. Copilot works best with clear, concise guidelines rather than exhaustive documentation.
