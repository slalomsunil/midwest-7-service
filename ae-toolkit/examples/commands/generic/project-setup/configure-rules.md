---
description: Browse and install rules from library
argument-hint: [rule names or --show-all]
---

# Configure Rules

Follow each step below in order:

## Step 1: Verify Setup

Check that `.claude/` directory exists:
- If not, suggest running `/initialize-ai` first
- If exists, proceed with rule configuration

Check if `.claude/rules/` directory exists:
- If not, create it with `base/` and `tech/` subdirectories

## Step 2: Determine Rules Location

Try to locate the AE Toolkit rules library:

**Search in these locations** (in order):
1. `./ae-toolkit/examples/rules/generic/` (if this is the toolkit repo)
2. `../ae-toolkit/examples/rules/generic/` (if adjacent to project)
3. `~/ae-toolkit/examples/rules/generic/` (if in home directory)
4. Check if TOOLKIT_PATH environment variable is set

If found, use that path for copying rules.
If not found, provide instructions for manual installation from online repository.

## Step 3: Detect Project Technologies

If no arguments provided (`$ARGUMENTS` is empty), analyze project to suggest relevant rules:

**Look for**:
- `package.json` + `typescript` dependency → TypeScript rule
- `react` in dependencies → React rule
- `requirements.txt` or `.py` files → Python rule
- `.csproj` or `.cs` files → .NET rule
- `node_modules/` or `package.json` → Node.js rule

Report detected technologies to user.

## Step 4: Show Available Rules

If `--show-all` flag or no arguments provided, show all available rules organized by category:

### Base Rules (Recommended for All Projects)

**Core rules** (strongly recommended):
- `communication.md` - Professional communication style and tone
  - Use when: Always
  - Ensures clear, concise, professional interaction

- `code-quality.md` - Code review and testing standards
  - Use when: Always
  - Maintains consistent quality standards

- `source-control.md` - Git best practices and commit conventions
  - Use when: Always
  - Ensures clean git history and good commit messages

**Additional base rules**:
- `collaboration.md` - Team collaboration patterns and PR reviews
  - Use when: Working on team projects
  - Helps with code review and team workflows

- `session-management.md` - Planning and execution for complex tasks
  - Use when: Large projects or complex features
  - Helps AI plan and track multi-step work

### Technology Rules (Based on Your Stack)

**TypeScript** (`typescript.md`):
- Type safety and inference
- Interface vs. type usage
- Async/await patterns
- Use when: Project uses TypeScript

**React** (`react.md`):
- Component patterns and composition
- Hook usage and rules
- State management approaches
- Use when: Project uses React

**Python** (`python.md`):
- PEP 8 style compliance
- Type hints and documentation
- Pythonic patterns
- Use when: Project uses Python

**.NET** (`dotnet.md`):
- C# conventions and patterns
- Async/await and Task usage
- Dependency injection patterns
- Use when: Project uses .NET/C#

**Node.js** (`node.md`):
- Module patterns and organization
- Package.json management
- Error handling in async code
- Use when: Project uses Node.js

## Step 5: Get User Selection

If arguments provided (`$ARGUMENTS`), parse them as rule names:
- Examples: `typescript react`, `python`, `--show-all`

Otherwise, ask user which rules to install:
- "Which rules would you like to install?"
- "Type 'all-base' for all base rules"
- "Type 'recommended' for base rules + detected tech rules"
- "Type specific rule names separated by spaces"
- "Type 'none' to skip installation"

## Step 6: Copy Selected Rules

For each selected rule:

### If toolkit is available locally:

1. Locate source file in `[toolkit-path]/ae-toolkit/examples/rules/generic/`
   - Base rules are in `base/` subdirectory
   - Tech rules are in `tech/` subdirectory

2. Copy to appropriate location:
   - Base rules → `.claude/rules/base/`
   - Tech rules → `.claude/rules/tech/`

3. Confirm each file copied successfully

### If toolkit is NOT available locally:

Provide instructions for manual installation:

```
Rules not found locally. To install rules manually:

1. Visit: https://github.com/[org]/ae-toolkit/tree/main/examples/rules/generic

2. For each rule you want:
   - Navigate to base/ or tech/ directory
   - Open the rule file (e.g., communication.md)
   - Copy the raw content
   - Create file in .claude/rules/base/ or .claude/rules/tech/
   - Paste content and save

Selected rules to install:
- [List of selected rules with paths]

Alternatively, clone the ae-toolkit repository:
```bash
git clone https://github.com/[org]/ae-toolkit.git
```

Then run this command again.
```

## Step 7: Verify Installation

List installed rules:
```
Installed Rules:

Base Rules:
✓ .claude/rules/base/communication.md
✓ .claude/rules/base/code-quality.md
✓ .claude/rules/base/source-control.md
[etc.]

Technology Rules:
✓ .claude/rules/tech/typescript.md
✓ .claude/rules/tech/react.md
[etc.]
```

## Step 8: Check for Rules Manager

Look for `.claude/rules/router.md` or similar rules-manager setup:
- If found, ask if user wants to update router to include new rules
- If not found, ask if user wants to set up rules-manager architecture
- Provide brief explanation of rules-manager benefits for complex projects

## Step 9: Test Rules

Suggest testing the rules:

```
To verify rules are working:

1. Try a test prompt that should trigger a rule:
   "Write a function that fetches user data from an API"

   Expected: AI should follow code-quality and tech-specific patterns

2. Check communication style in responses
   Expected: Professional, concise, no unnecessary emojis

3. Review git-related suggestions
   Expected: Should follow conventional commit format

If rules don't seem active:
- Verify files are in correct locations
- Check file extensions are .md
- Restart Claude Code if needed
- Check for conflicts in CLAUDE.md
```

## Step 10: Provide Next Steps

```
✅ Rules Configured

Installed:
- [Number] base rules
- [Number] technology rules

Next Steps:

1. **Customize Rules** (Optional)
   - Edit rules in .claude/rules/ to match your team's style
   - Add project-specific guidelines
   - Document customizations for team

2. **Add More Rules** (As Needed)
   - Run /configure-rules again to add more
   - Browse ae-toolkit/examples/rules/ for full catalog
   - Create custom rules for project-specific patterns

3. **Set Up Agents and Commands** (Recommended)
   - Install useful agents: /initialize-ai
   - Add commands like /commit-workflow, /review-changes
   - See ae-toolkit/examples/ for available options

4. **Share with Team**
   - Commit .claude/ directory to git
   - Document setup in README or CONTRIBUTING.md
   - Help team members understand available rules

5. **Verify and Iterate**
   - Test AI assistance with rules active
   - Refine rules based on team feedback
   - Update rules as project evolves
```

---

**Notes**:
- Rules in `.claude/rules/` are automatically loaded by Claude Code
- Rules can reference other files with `@` syntax
- Consider using rules-manager for complex rule architectures
- Rules are team-specific - customize to match your preferences
- Keep rules in version control so whole team benefits
