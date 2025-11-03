# Project Setup Prompt Files

GitHub Copilot prompt files for bootstrapping AI assistance in projects.

## Prompt Files

### initialize-ai.prompt.md
Set up AI tool configuration in a new or existing project.
- **Mode**: `agent`
- **Tools**: `@workspace` for project detection, `@terminal` for file creation
- **Use**: First-time AI setup in a project

### configure-rules.prompt.md
Browse and install rules from the rules library.
- **Mode**: `agent`
- **Tools**: `@workspace` for project analysis
- **Use**: Adding or updating coding standards and conventions

## VS Code Integration

These commands leverage:
- **Workspace folders**: Detect project structure
- **File system**: Create `.github/` directories
- **Extensions**: Detect installed tools and frameworks

## Customization

Customize for your organization by:
- Adding company-specific rules to installation options
- Modifying directory structures to match your conventions
- Including organization-specific AI tool configurations

See `../../generic/project-setup/` for Claude Code equivalents.
