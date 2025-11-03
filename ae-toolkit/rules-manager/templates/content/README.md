# Content Templates

These templates contain actual rule content that should be copied and customized for your project's specific rules.

## Available Templates

### Base Templates (Always Applied)
- `BASE_CORE.template.md` - Fundamental communication style and behavior
- `BASE_RULE_EVOLUTION.template.md` - Guidelines for evolving and maintaining rules

**Note**: The Rules Manager uses a modular architecture where additional base rule templates (collaboration, context, session, regression, source-control) and technology-specific templates are generated based on project needs during the workflow execution.

## How to Use

1. **Copy the template** to your project's rules directory
2. **Rename** removing `.template` from the filename
3. **Customize** the content for your project's specific needs
4. **Reference** from your router or main rules file

During the Rules Manager workflow, additional templates for collaboration, context management, session planning, technology-specific rules, and SDLC phase rules are generated based on your project requirements.

## Customization Guidelines

- Preserve the overall structure but adapt content to your team's standards
- Add project-specific examples and patterns
- Remove sections that don't apply to your project
- Add additional rules as needed within the established categories
- Use the Rules Manager workflow to generate additional template categories as needed
