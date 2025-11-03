# Configure Rules

**Recommended Mode**: Agent Mode (for creating/editing .cursorrules)

Create or enhance `.cursorrules` with standards from the toolkit's rules library.

**Note**: Cursor uses `.cursorrules` for project-level guidance (not separate rule files like Claude Code). This command helps you create or enhance that file with best practices.

## Workflow

### Step 1: Check Existing Setup

Check if `.cursorrules` exists:
- **If exists**: Offer to append new sections
- **If not**: Offer to create it

### Step 2: Detect Project Needs

Use @code to analyze the project and determine what guidance would be helpful:

**Base Guidance** (recommended for all projects):
- Communication style
- Code quality standards
- Source control practices

**Technology Guidance** (based on detected stack):
- TypeScript conventions
- React patterns
- Python best practices
- .NET standards
- Node.js patterns

### Step 3: Show Available Rules

#### Base Rules (Recommended for All)

**Communication**:
- Professional, concise style
- Clear technical explanations
- Focus on facts over opinions

**Code Quality**:
- Review standards and checklists
- Testing requirements
- Documentation practices
- Refactoring guidelines

**Source Control**:
- Conventional commit format
- Branch naming conventions
- PR description standards
- Git workflow practices

**Collaboration**:
- Code review expectations
- PR review process
- Team communication patterns

#### Technology-Specific Rules

Based on detected technologies, offer:

**TypeScript**:
- Type safety practices
- Interface vs type usage
- Async/await patterns
- Module organization

**React**:
- Component patterns (functional with hooks)
- State management approaches
- Hook usage rules
- Performance considerations

**Python**:
- PEP 8 style compliance
- Type hints and documentation
- Pythonic patterns
- Virtual environment usage

**.NET/C#**:
- C# conventions and naming
- Async/await and Task usage
- Dependency injection patterns
- Resource disposal

**Node.js**:
- Module patterns and organization
- Error handling in async code
- Package.json management

### Step 4: Generate or Enhance .cursorrules

Based on user selection, create or append to `.cursorrules`:

```markdown
# Project Cursor Rules

[If appending, add a new section with separator]

## [Selected Category - e.g., Communication Style]

[Content from selected rules]

### Key Points
- [Important guideline 1]
- [Important guideline 2]
- [Important guideline 3]

## [Next Category - e.g., Code Quality]

[Content from selected rules]

## Technology Conventions

### [Technology Name - e.g., TypeScript]
[Technology-specific standards]

## Testing Standards
[Testing guidance from selections]

## Git Workflow
[Source control standards from selections]
```

**Important**: Keep `.cursorrules` focused and concise. Cursor works best with clear, actionable guidelines rather than exhaustive documentation.

### Step 5: Explain Integration

Explain that:
- `.cursorrules` is automatically loaded by Cursor for this project
- All Cursor interactions will follow these guidelines
- Rules apply to chat, inline edits (Cmd+K), and Composer
- No additional setup needed - rules are active immediately

### Step 6: Provide Next Steps

```
✅ Rules Configured

Updated: .cursorrules

Active Guidance:
- [List categories that were added/updated]

Next Steps:
1. Review .cursorrules and customize for your team
2. Test Cursor with new rules active
3. Add project-specific guidelines as needed
4. Share with team (commit .cursorrules to git)
5. Install custom commands (/initialize-ai)

Quick Test:
Try: "Write a function that fetches user data"
Expected: Should follow the standards you just configured
```

## Tips

- **Start minimal**: Add base rules first, add more as needed
- **Be specific**: Clear guidelines work better than general advice
- **Update regularly**: Evolve rules as team practices mature
- **Team alignment**: Get team buy-in on standards
- **Document changes**: Note customizations in comments
