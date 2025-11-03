# GitHub Copilot Tool Adaptation Template

This template shows how to adapt the router-based rules system for GitHub Copilot using tool-specific features and conventions.

## File Header and Router Integration


# GitHub Copilot Instructions

This file configures GitHub Copilot behavior for this project.

## Copilot-Specific Implementation Strategy

### Directory Structure Created
```
.github/
├── copilot-instructions.md          # Main instructions file referencing router and core rules
├── instructions/
│    ├── node.instructions.md         # Node.js specific rules with applyTo header
│    ├── react.instructions.md        # React specific rules with applyTo header  
│    └── typescript.instructions.md   # TypeScript specific rules with applyTo header
└── chatmodes/
     ├── define.chatmode.md           # Requirements and Design chat mode instructions
     ├── develop.chatmode.md          # Coding-specific chat mode instructions
     ├── test.chatmode.md             # Testing-specific chat mode instructions
     └── deploy.chatmode.md           # Deployment-specific chat mode instructions

```
### Main Instructions File
Generate `.github/copilot-instructions.md` that:
- References `.ai-rules/router.md` as a mandatory source of rules and routing that MUST be followed with no exceptions
- Includes the following:

```
## PROTOCOL ENFORCEMENT CHECKLIST

Before responding to ANY user request, AI MUST confirm:
- [ ] Have I read `.ai-rules/router.md`?
- [ ] Have I identified the current context (file/directory/intent)?
- [ ] Have I loaded the appropriate technology rules?
- [ ] Have I loaded the appropriate SDLC rules?
- [ ] Have I applied rules in correct precedence order?

**If ANY checkbox is unchecked, STOP and complete the protocol first.**
```

- Provides Copilot-specific enhancements and features

### Technology-Specific Instructions Files
Create individual `.github/instructions/*.instructions.md` files for each technology rule in `.ai-rules/rules/tech/` with:
- Proper front matter headers with `description` and `applyTo` glob patterns
- References back to corresponding `.ai-rules/rules/tech/` rule modules
- VS Code instructions file format compliance

Each file uses the patterns and content shown in the technology-specific rules sections above.

### SDLC Rules & Chatmodes
Create individual `.github/chatmodes/*.chatmode.md` files for each chat mode with:
- Proper front matter headers with `description` and `model` name
- References back to corresponding `.ai-rules/rules/sdlc/` rule modules
- VS Code instructions file format compliance

**Generated Files Based on Project Chat Modes:**
- `.github/chatmodes/define.chatmode.md` (for Requirements and Design chat mode)
- `.github/chatmodes/develop.chatmode.md` (for Coding-specific chat mode)
- `.github/chatmodes/test.chatmode.md` (for Testing-specific chat mode)
- `.github/chatmodes/deploy.chatmode.md` (for Deployment-specific chat mode)

Each file uses the patterns and content shown in the chat mode sections above.

### Auto-Activation Features
- Individual `.instructions.md` files automatically load based on `applyTo` patterns
- Technology-specific instructions activate when working with matching file types
- Follows VS Code Copilot customization best practices for workspace instructions

### Validation Requirements
- ✅ Verify `.github/copilot-instructions.md` is recognized by VS Code
- ✅ Test that individual `.instructions.md` files are automatically loaded based on `applyTo` patterns
- ✅ Confirm technology-specific instructions activate when working with matching file types
- ✅ Check that Markdown links to `.ai-rules/` files are accessible from VS Code
- ✅ Validate front matter headers are correctly formatted
- ✅ Chatmode files exist for each SDLC file

## Tool Differences from Base Rules

### Copilot-Specific Enhancements
1. **ApplyTo Headers**: Use file pattern matching for automatic rule activation
2. **Workspace Integration**: Leverage VS Code workspace awareness and file context
3. **Chat Commands**: Integrate with Copilot Chat commands (`/explain`, `/fix`, `/tests`, `/doc`)
4. **GitHub Features**: Enhanced integration with GitHub workflows and PR processes
5. **Multi-File Context**: Better understanding of project structure and cross-file relationships

### Syntax Adaptations
- Use Markdown with front matter headers for instructions files
- Implement `applyTo` glob patterns for automatic rule targeting
- Structure content for progressive disclosure and context awareness
- Reference external rule files through relative paths in VS Code

The base rule content remains tool-agnostic, while the presentation and additional features are tailored to Copilot's specific capabilities and integration patterns.
