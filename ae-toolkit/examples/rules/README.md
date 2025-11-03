# Rules Library

A curated collection of best practice rules for AI-assisted development. These rules demonstrate proven patterns for guiding AI coding assistants (Claude Code, GitHub Copilot, Cursor, OpenCode) to produce high-quality code that aligns with team standards.

## Structure

The rules library is organized by tool, then by category:

```
rules/
  generic/          # Claude Code, OpenCode, and tool-agnostic rules
    base/           # Foundation rules (communication, code quality, etc.)
    tech/           # Technology-specific rules (TypeScript, React, Python, etc.)
  copilot/          # GitHub Copilot specific with YAML frontmatter
    base/           # Base rules with applyTo: "**/*"
    tech/           # Tech rules with applyTo: "**/*.ts", etc.
  cursor/           # Cursor specific with MDC format
    base/           # Base rules with alwaysApply: true
    tech/           # Tech rules with globs: ["**/*.ts"]
```

### Base Rules

Foundation rules applicable to all projects:
- **communication** - Professional communication style
- **session-management** - Planning and execution patterns
- **code-quality** - Code review and testing standards
- **collaboration** - Team collaboration patterns
- **source-control** - Git best practices

### Tech Rules

Technology-specific rules that auto-attach based on file type:
- **typescript** - TypeScript conventions (applies to .ts/.tsx)
- **react** - React patterns (applies to .tsx/.jsx)
- **python** - Python conventions (applies to .py)
- **dotnet** - .NET and C# patterns (generic only)
- **node** - Node.js and npm patterns (generic only)

## How to Use

### For Claude Code / OpenCode

Use generic rules from `./generic/`:

**Base rules:**
```markdown
# In your project CLAUDE.md
@ae-toolkit/examples/rules/generic/base/communication.md
@ae-toolkit/examples/rules/generic/base/code-quality.md
@ae-toolkit/examples/rules/generic/base/source-control.md
```

**Tech rules:**
```markdown
@ae-toolkit/examples/rules/generic/tech/typescript.md
@ae-toolkit/examples/rules/generic/tech/react.md
@ae-toolkit/examples/rules/generic/tech/python.md
```

### For GitHub Copilot

Copy `.instructions.md` files into your project's `.github/instructions/` directory:

**Base rules** (apply to all files):
- `copilot/base/communication.instructions.md`
- `copilot/base/code-quality.instructions.md`
- `copilot/base/source-control.instructions.md`
- `copilot/base/collaboration.instructions.md`
- `copilot/base/session-management.instructions.md`

**Tech rules** (auto-apply to specific file types):
- `copilot/tech/typescript.instructions.md` - TypeScript files (*.ts, *.tsx)
- `copilot/tech/react.instructions.md` - React files (*.tsx, *.jsx)
- `copilot/tech/python.instructions.md` - Python files (*.py)

The frontmatter `applyTo` property uses glob patterns to target specific files:
```yaml
---
applyTo: "**/*.ts,**/*.tsx"
---
```

### For Cursor

Copy `.mdc` files into your project's `.cursor/rules/` directory:

**Base rules** (always active):
- `cursor/base/communication.mdc`
- `cursor/base/code-quality.mdc`
- `cursor/base/source-control.mdc`
- `cursor/base/collaboration.mdc`
- `cursor/base/session-management.mdc`

**Tech rules** (auto-attach to specific file types):
- `cursor/tech/typescript.mdc` - TypeScript files
- `cursor/tech/react.mdc` - React files
- `cursor/tech/python.mdc` - Python files

The frontmatter `globs` property uses file patterns for auto-attachment:
```yaml
---
description: TypeScript conventions
globs: ["**/*.ts", "**/*.tsx"]
alwaysApply: false
---
```

## Integration with Rules-Manager

If you're using the `ae-toolkit/rules-manager` module with Claude Code or OpenCode:

```markdown
# In your project root CLAUDE.md
@ae-toolkit/rules-manager/router.md

# Base rules active for all contexts
@ae-toolkit/examples/rules/generic/base/communication.md
@ae-toolkit/examples/rules/generic/base/code-quality.md

# Technology rules activated by file type
@ae-toolkit/examples/rules/generic/tech/typescript.md
@ae-toolkit/examples/rules/generic/tech/react.md
```

See `../../rules-manager/README.md` for complete router architecture details.

## Examples by Project Type

### Web Application (TypeScript + React) - Claude Code
```
generic/base/communication.md
generic/base/session-management.md
generic/base/code-quality.md
generic/base/source-control.md
generic/tech/typescript.md
generic/tech/react.md
generic/tech/node.md
```

### Web Application (TypeScript + React) - GitHub Copilot
```
Place in .github/instructions/:
copilot/base/communication.instructions.md
copilot/base/code-quality.instructions.md
copilot/base/source-control.instructions.md
copilot/tech/typescript.instructions.md  # Auto-applies to .ts/.tsx
copilot/tech/react.instructions.md       # Auto-applies to .tsx/.jsx
```

### Web Application (TypeScript + React) - Cursor
```
Place in .cursor/rules/:
cursor/base/communication.mdc
cursor/base/code-quality.mdc
cursor/base/source-control.mdc
cursor/tech/typescript.mdc  # Auto-attaches to .ts/.tsx
cursor/tech/react.mdc        # Auto-attaches to .tsx/.jsx
```

### Python Data Pipeline - GitHub Copilot
```
Place in .github/instructions/:
copilot/base/communication.instructions.md
copilot/base/code-quality.instructions.md
copilot/base/source-control.instructions.md
copilot/tech/python.instructions.md  # Auto-applies to .py
```

## Contributing

When contributing new rules or updating existing ones:

1. **Follow the structure** - Place in appropriate tool/category directory
2. **Use correct format** - `.md` for generic, `.instructions.md` for Copilot, `.mdc` for Cursor
3. **Add proper frontmatter** - Include `applyTo` (Copilot) or `globs` (Cursor) for tech rules
4. **Maintain cross-references** - Link to versions in other tools
5. **Keep it focused** - One rule per file, addressing a specific aspect

### Frontmatter Examples

**Copilot base rule:**
```yaml
---
applyTo: "**/*"
---
```

**Copilot tech rule:**
```yaml
---
applyTo: "**/*.ts,**/*.tsx"
---
```

**Cursor base rule:**
```yaml
---
description: Professional communication style
globs: ["**/*"]
alwaysApply: true
---
```

**Cursor tech rule:**
```yaml
---
description: TypeScript conventions
globs: ["**/*.ts", "**/*.tsx"]
alwaysApply: false
---
```

## Rule Design Principles

Good rules are:
- **Specific** - Clear guidance, not vague suggestions
- **Actionable** - AI can apply them directly to code
- **Justified** - Explain the "why" behind the guidance
- **Consistent** - Work well with other rules in the library
- **Tool-aware** - Leverage file-type targeting in Copilot and Cursor

## Related Libraries

- **Agents Library** (`../agents/`) - Pre-built agent definitions for specialized tasks
- **Commands Library** (`../commands/`) - Reusable slash commands and prompt files for common workflows

These libraries work together: agents can reference rules for context, and commands can invoke agents that follow specific rule sets.
