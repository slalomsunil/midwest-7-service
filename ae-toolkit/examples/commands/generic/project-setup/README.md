# Project Setup Commands

This directory contains slash commands that help bootstrap AI assistance in new or existing projects. These commands guide through configuration, rule selection, and initial setup.

## Commands in This Category

### initialize-ai.md

**Purpose**: Set up AI tool configuration in a new or existing project, creating necessary directories and starter files.

**When to use**:
- Starting a new project that will use AI-assisted development
- Adding AI tooling to an existing project for the first time
- Resetting AI configuration after major project changes
- Helping team members get started with AI tools

**What it does**:
1. Detects project type and technology stack
2. Creates `.claude/` directory structure if using Claude Code
3. Offers to install base rules from the rules library
4. Creates starter `CLAUDE.md` with project-specific instructions
5. Suggests relevant agents or commands based on project type
6. Provides guidance on next steps

**Example invocation**:
```
/initialize-ai
/initialize-ai --reset
```

**Related rules**: All base rules, technology-specific rules matching the project

---

### configure-rules.md

**Purpose**: Browse and install rules from the rules library, helping teams select appropriate standards and conventions.

**When to use**:
- After initializing AI tooling in a project
- Adding new technology to existing project (e.g., adding React to Node.js project)
- Updating rules to match evolved team practices
- Helping team members understand available rules

**What it does**:
1. Shows available rules from the rules library:
   - Base rules (communication, code quality, source control, etc.)
   - Technology rules (TypeScript, React, Python, .NET, etc.)
2. Explains what each rule provides
3. Recommends rules based on project type
4. Copies selected rules to `.claude/rules/` or appropriate location
5. Updates router configuration if using rules-manager

**Example invocation**:
```
/configure-rules
/configure-rules --show-all
/configure-rules typescript react
```

**Related rules**: Rules-manager architecture, all available rules

---

## Design Patterns

### Project Detection

Commands detect project characteristics by examining:

- **Package files**: `package.json`, `requirements.txt`, `*.csproj`, `Gemfile`, `go.mod`
- **Configuration files**: `.eslintrc`, `tsconfig.json`, `pytest.ini`, `.gitignore`
- **Directory structure**: `src/`, `test/`, `app/`, common patterns
- **File extensions**: `.ts`, `.py`, `.cs`, `.rb`, `.go`

### Progressive Setup

Setup follows a progressive approach:

1. **Essential**: Directory structure and base rules
2. **Recommended**: Technology rules and common agents
3. **Optional**: Specialized agents, custom commands, advanced configuration

Users can choose minimal setup or comprehensive configuration.

### Rule Selection

Commands help select rules based on:

- **Project type**: Web app, API, CLI tool, library
- **Technologies**: Languages, frameworks, tools detected
- **Team preferences**: Strict vs. flexible, comprehensive vs. minimal
- **Existing conventions**: Respect project's established patterns

## Usage Tips

### Initialize AI

**Before running**:
- Ensure you're in the project root directory
- Commit any pending changes (command creates new files)
- Review any existing `.claude/` directory (command may warn about overwriting)

**During setup**:
- Answer questions about project type and preferences
- Review suggested rules before installing
- Consider starting minimal and adding more later

**After setup**:
- Review generated `CLAUDE.md` and customize for your project
- Test AI assistance with a simple task
- Share setup with team members
- Document any project-specific customizations

### Configure Rules

**Selecting rules**:
- Start with all base rules (communication, code quality, source control, collaboration)
- Add technology rules for your stack
- Add session management if doing complex, multi-step work
- Skip rules that conflict with established project patterns

**Rule customization**:
- Copy rules to `.claude/rules/` and modify as needed
- Keep original filename pattern for easy updates
- Document customizations in comments at the top
- Consider contributing useful modifications back to the library

**Rule organization**:
- Use rules-manager router architecture for complex projects
- Group related rules in subdirectories
- Use frontmatter to control when rules apply (file types, directories)

## Customization Examples

### Organization-Specific Initialization

Modify `initialize-ai.md` to include company standards:

```markdown
Create `.claude/` directory with our standard structure:

.claude/
├── CLAUDE.md           # Project instructions
├── rules/
│   ├── base/           # Base rules from library
│   ├── tech/           # Technology rules from library
│   └── custom/         # Organization-specific rules
├── agents/             # Custom agents
└── commands/           # Custom commands

Install these required rules:
- Base: communication, code-quality, source-control, collaboration
- Custom: [ORG]-security-standards.md
- Custom: [ORG]-code-review-checklist.md
```

### Technology-Specific Setup

Create specialized initialization commands:

```markdown
---
description: Initialize AI for React + TypeScript projects
---

Set up AI tooling for a React + TypeScript project:

1. Create `.claude/` directory structure
2. Install base rules: communication, code-quality, source-control
3. Install tech rules: typescript, react, node
4. Install agents: code-reviewer, test-generator
5. Create starter CLAUDE.md with React-specific guidance
6. Set up ESLint and Prettier integration notes
```

### Rule Bundle Presets

Modify `configure-rules.md` to offer presets:

```markdown
Available rule bundles:

1. **Minimal** (communication, code-quality)
   - For small projects or teams new to AI assistance

2. **Standard** (minimal + source-control, collaboration, session-management)
   - For most projects

3. **Comprehensive** (standard + all applicable tech rules)
   - For large projects or strict quality requirements

Select a bundle or choose individual rules.
```

## Integration with Rules Library

These commands directly integrate with:

- **Rules library** (`../../rules/`): Source of all installable rules
- **Rules-manager** (`../../../rules-manager/`): Architecture for organizing installed rules

**Workflow**:
1. Commands help discover rules from the library
2. Selected rules are copied to project's `.claude/rules/`
3. Rules-manager router (if used) determines which rules apply in which contexts

## Integration with Other Libraries

Setup commands can reference:

- **Agents library** (`../../agents/`): Suggest relevant agents during setup
- **Commands library** (`../`): Offer to install useful commands
- **Methodology templates** (`../../methodology-templates/`): Suggest workflow approaches

**Progressive enhancement**: Start with rules, add agents and commands as team matures in AI usage.

## Common Issues

### Permission Denied

**Cause**: Insufficient permissions to create `.claude/` directory

**Solution**: Ensure you have write permissions in the project root, or run with appropriate permissions

### Directory Already Exists

**Cause**: `.claude/` directory already present

**Solution**:
- Review existing configuration before reinitializing
- Use `--reset` flag if you want to start fresh (backs up existing configuration)
- Manually merge new rules with existing setup

### Can't Detect Project Type

**Cause**: Project structure doesn't match common patterns

**Solution**:
- Manually specify project type when running command
- Add project type indicators (package.json, etc.)
- Use minimal setup and add rules manually

### Rules Don't Apply

**Cause**: Rules-manager router not configured, or incorrect frontmatter

**Solution**:
- Verify `.claude/rules/router.md` exists and references installed rules
- Check rule frontmatter (globs, applyTo, alwaysApply)
- Test rules with simple prompts to verify they're active

## Team Adoption

### Rolling Out AI Tooling

**Approach**:
1. Start with one project as a pilot
2. Use `initialize-ai` to set up consistently
3. Document team-specific customizations
4. Create organization-specific fork of setup commands
5. Share learnings and refine configuration

**Training**:
- Walk through setup process together
- Demonstrate using installed rules and agents
- Show how to verify rules are working
- Establish feedback loop for improvements

### Maintaining Configuration

**Best practices**:
- Version control `.claude/` directory
- Document customizations in README or CLAUDE.md
- Periodically review rules for updates from library
- Share successful patterns across projects
- Keep setup commands updated with org preferences

## Version Information

**Last Updated**: 2025-10-14
**Toolkit Version**: Part of AE Toolkit best practices library

See `../` for other command categories and `../../copilot/project-setup/` for Copilot equivalents.
