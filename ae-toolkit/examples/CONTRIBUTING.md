# Contributing to the Best Practices Libraries

This guide covers contribution conventions for all four best practice libraries: rules, agents, chat modes, and commands.

## General Principles

1. **Keep it practical** - Focus on battle-tested patterns, not theoretical ideals
2. **Be tool-specific** - Leverage each tool's native capabilities rather than forcing uniformity
3. **Document context** - Include metadata about when and why to use each artifact
4. **Maintain coherence** - Cross-reference related artifacts across libraries
5. **Update all versions** - When changing shared concepts, update corresponding tool-specific versions

## Naming Conventions

### Rules
- **Format**: `{concept-name}.md` or `{concept-name}.instructions.md` (Copilot) or `{concept-name}.mdc` (Cursor)
- **Examples**: `communication.md`, `typescript.instructions.md`, `react.mdc`
- **Guidelines**:
  - Use descriptive, lowercase names with hyphens
  - Base rules: Named after the concept (communication, session-management)
  - Tech rules: Named after the technology (typescript, react, dotnet)

### Agents
- **Format**: `{task-description}.md`
- **Examples**: `code-reviewer.md`, `test-generator.md`, `api-documenter.md`
- **Guidelines**:
  - Use descriptive, action-oriented names
  - Indicate the task the agent performs
  - Avoid tool names in filename (these are all for Claude Code/OpenCode)

### Chat Modes
- **Copilot Format**: `{task-description}.chatmode.md`
- **Cursor Format**: `{task-description}.md`
- **Examples**: `code-reviewer.chatmode.md`, `test-generator.md`
- **Guidelines**:
  - Match corresponding agent names for consistency
  - Include `.chatmode.md` extension for Copilot files
  - Use plain `.md` for Cursor (they're UI configurations)

### Commands
- **Format**: `{workflow-name}.md`
- **Examples**: `commit-workflow.md`, `pr-creation.md`, `review-changes.md`
- **Guidelines**:
  - Use descriptive, workflow-oriented names
  - Focus on the action/workflow, not the tool
  - Keep names consistent across tool-specific versions

## Directory Structure

### Rules Library
```
rules/
├── README.md
├── generic/              # Claude Code / generic tool rules
│   ├── base/            # Always-applicable rules
│   └── tech/            # Technology-specific rules
├── copilot/             # GitHub Copilot rules
│   ├── base/            # Always-applicable rules
│   └── tech/            # Technology-specific rules
└── cursor/              # Cursor rules
    ├── base/            # Always-applicable rules
    └── tech/            # Technology-specific rules
```

### Agents Library
```
agents/
├── README.md
├── code-quality/        # Code quality agents
│   └── README.md
├── testing/             # Testing agents
│   └── README.md
├── documentation/       # Documentation agents
│   └── README.md
└── architecture/        # Architecture agents
    └── README.md
```

### Chat Modes Library
```
chat-modes/
├── README.md
├── copilot/             # Copilot chat modes
│   ├── README.md
│   ├── code-quality/
│   ├── testing/
│   ├── documentation/
│   └── architecture/
└── cursor/              # Cursor custom modes
    ├── README.md
    ├── code-quality/
    ├── testing/
    ├── documentation/
    └── architecture/
```

### Commands Library
```
commands/
├── README.md
├── generic/             # Claude Code / OpenCode commands
│   ├── README.md
│   ├── git-workflows/
│   ├── code-quality/
│   └── project-setup/
├── copilot/             # Copilot prompt files
│   ├── README.md
│   ├── git-workflows/
│   ├── code-quality/
│   └── project-setup/
└── cursor/              # Cursor commands
    ├── README.md
    ├── git-workflows/
    ├── code-quality/
    └── project-setup/
```

## Metadata Requirements

### All Artifacts
Every artifact should include at minimum:
- **Description**: Brief summary of purpose (1-2 sentences)
- **When to use**: Clear guidance on appropriate usage contexts
- **Version/Date**: When the artifact was created or last updated

### Rules
```markdown
# Rule Name

**Description:** Brief description of what this rule does

**When to apply:** Context where this rule is useful

**Related rules:** Links to complementary or alternative rules

[Rule content]
```

### Copilot Rules (YAML Frontmatter)
```markdown
---
description: Brief description
applyTo: "**/*.ts,**/*.tsx"  # For tech-specific rules
---

[Rule content]
```

### Cursor Rules (Frontmatter)
```markdown
---
description: Brief description
globs: ["**/*.ts", "**/*.tsx"]  # For tech-specific rules
alwaysApply: true  # For base rules only
---

[Rule content]
```

### Agents
```markdown
# Agent Name

**Purpose:** What this agent does

**Best for:** Types of tasks this agent excels at

**When to use:** Situations where you should invoke this agent

**System prompt:**

[Agent system prompt content]
```

### Copilot Chat Modes
```markdown
---
description: Brief description
tools: [read, edit, create, run]
model: claude-sonnet-4.5  # Optional
---

[Chat mode instructions]
```

### Commands
```markdown
# Command Name

**Purpose:** What this command does

**Usage:** How to invoke this command

**When to use:** Situations where this command is helpful

**Command content:**

[Command/prompt content]
```

## Cross-Reference Patterns

### Between Libraries
When artifacts relate across libraries, use relative paths:
- From command to rule: `../../rules/generic/base/communication.md`
- From agent to rule: `../../rules/generic/tech/typescript.md`
- From chat mode to rule: `../../../rules/copilot/base/communication.instructions.md`

### Within Libraries
Use relative paths within the same library:
- Between rules: `../base/communication.md` (from tech to base)
- Between commands: `../git-workflows/commit-workflow.md`

### Tool-Specific Versions
When referencing equivalent artifacts across tools:
- Generic to Copilot: `../../copilot/{category}/{artifact}.instructions.md`
- Generic to Cursor: `../../cursor/{category}/{artifact}.mdc`

## README Hierarchy

### Library-Level READMEs
Each library should have a top-level README that covers:
- **Purpose**: What the library provides
- **Structure**: How artifacts are organized
- **Usage**: How to use artifacts from this library
- **Tool support**: Which tools are supported and any tool-specific notes
- **Navigation**: Links to category-level READMEs

### Category-Level READMEs
Each category directory should have a README that covers:
- **Purpose**: What artifacts in this category do
- **When to use**: Guidance on choosing artifacts in this category
- **Available artifacts**: List with brief descriptions
- **Common patterns**: Shared concepts or approaches
- **Cross-references**: Related categories or libraries

## Templates for New Contributions

### Generic Rule Template
```markdown
# {Rule Name}

**Description:** Brief description of what this rule does (1-2 sentences)

**When to apply:** Describe the context where this rule is useful

**Related rules:**
- Link to complementary rules
- Link to alternative approaches

---

## {Rule Section}

{Rule content describing expected behavior}

### {Subsection}

{Specific guidance}

## Examples

{Practical examples demonstrating the rule in action}
```

### Copilot Rule Template
```markdown
---
description: Brief description of what this rule does
applyTo: "**/*.{ext}"  # Only for tech-specific rules
---

# {Rule Name}

**When to apply:** Describe the context where this rule is useful

**Related rules:**
- Link to complementary rules
- Link to alternative approaches

---

{Rule content}
```

### Cursor Rule Template
```markdown
---
description: Brief description of what this rule does
globs: ["**/*.{ext}"]  # Only for tech-specific rules
alwaysApply: true  # Only for base rules
---

# {Rule Name}

**When to apply:** Describe the context where this rule is useful

**Related rules:**
- Link to complementary rules
- Link to alternative approaches

---

{Rule content}
```

### Agent Template
```markdown
# {Agent Name}

**Purpose:** Single sentence describing what this agent does

**Best for:** Types of tasks this agent excels at (bulleted list)

**When to use:**
- Situation 1
- Situation 2
- Situation 3

**Related resources:**
- Links to relevant rules or other agents
- External documentation if applicable

---

## System Prompt

{Detailed system prompt defining the agent's behavior, capabilities, and constraints}
```

### Copilot Chat Mode Template
```markdown
---
description: Brief description of what this chat mode does
tools: [read, edit, create, run]  # Customize based on needs
model: claude-sonnet-4.5  # Optional - specify if needed
---

# {Chat Mode Name}

**When to use:**
- Situation 1
- Situation 2

**Related modes:**
- Link to related chat modes

---

{Chat mode instructions defining specialized behavior}
```

### Cursor Custom Mode Template
```markdown
# {Mode Name}

**Purpose:** Single sentence describing what this mode does

**When to use:**
- Situation 1
- Situation 2

**Configuration:**

To set up this custom mode in Cursor:

1. Open Cursor settings (Cmd/Ctrl + ,)
2. Navigate to "Features" → "Custom Modes"
3. Create a new mode with:
   - **Name**: {Mode Name}
   - **Shortcut**: {Suggested shortcut, e.g., Cmd+Shift+R}
   - **Tools**: {List tools: Chat, Edit, Generate}
   - **Instructions**: (Copy the content below)

**Related modes:**
- Link to related modes

---

## Mode Instructions

{Mode instruction content}
```

### Command Template
```markdown
# {Command Name}

**Purpose:** Single sentence describing what this command does

**Usage:**
- For generic (slash command): `/{command-name}`
- For Copilot (prompt): Copy to `.github/prompts/{command-name}.md`
- For Cursor (command): Describe how to invoke

**When to use:**
- Situation 1
- Situation 2

**Related commands:**
- Link to related commands

---

## Command Content

{Command/prompt content}
```

## Contribution Workflow

1. **Identify the need**: Determine which library and category fits your contribution
2. **Check for duplicates**: Search existing artifacts to avoid duplication
3. **Create tool-specific versions**: If applicable, create versions for all relevant tools
4. **Add metadata**: Include all required metadata per the templates above
5. **Cross-reference**: Link to related artifacts in other libraries
6. **Update category README**: Add your artifact to the category's README
7. **Test**: Verify the artifact works with the target tool(s)
8. **Document context**: Explain why this pattern is recommended

## Quality Guidelines

### Content Quality
- **Practical over theoretical**: Focus on patterns that work in real projects
- **Clear and concise**: Use simple language and avoid jargon where possible
- **Actionable guidance**: Provide specific, actionable instructions
- **Examples included**: Include concrete examples where helpful

### Technical Quality
- **Tool-appropriate**: Use each tool's native capabilities and conventions
- **Tested**: Verify the artifact works as intended
- **Up-to-date**: Reflect current tool versions and best practices
- **Accurate**: Ensure technical details are correct

### Documentation Quality
- **Complete metadata**: All required fields filled in
- **Cross-referenced**: Links to related artifacts
- **Contextual**: Explains when and why to use the artifact
- **Maintained**: Keep documentation current with changes

## Maintenance Guidelines

### Updating Existing Artifacts
When updating an artifact:
1. Update the version/date metadata
2. Document what changed and why
3. Check cross-references are still valid
4. Update related tool-specific versions
5. Update category README if needed

### Deprecating Artifacts
When deprecating an artifact:
1. Add a deprecation notice at the top
2. Link to the replacement artifact
3. Explain why it's deprecated
4. Keep the file for historical reference
5. Update category README to mark as deprecated

### Version Management
- Use dates for version metadata (e.g., "Last updated: 2025-01-15")
- Include tool version compatibility when relevant (e.g., "Claude Code 1.2+")
- Document breaking changes clearly
- Maintain backward compatibility where possible

## Examples to Follow

Good examples of each artifact type:
- **Rule**: `rules/generic/base/communication.md`
- **Agent**: `agents/code-quality/code-reviewer.md`
- **Chat Mode (Copilot)**: `chat-modes/copilot/code-quality/code-reviewer.chatmode.md`
- **Chat Mode (Cursor)**: `chat-modes/cursor/code-quality/code-reviewer.md`
- **Command (Generic)**: `commands/generic/git-workflows/commit-workflow.md`

## Questions?

If you're unsure about:
- **Which library** to add to: Check the library purpose in each README
- **Naming conventions**: Review existing artifacts in the category
- **Metadata requirements**: See the templates section above
- **Tool-specific conventions**: Check the tool-specific README in that library
- **Cross-referencing**: Look at how existing artifacts link to each other
