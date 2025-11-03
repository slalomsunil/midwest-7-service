# Interaction Analyzer Scripts

Scripts for collecting AI chat histories and converting them to markdown for analysis. Available in both bash (for Unix/Linux/macOS) and PowerShell (for Windows) versions.

## Available Scripts

### Bash Scripts (Unix/Linux/macOS)
**Dependencies:** POSIX-compliant shell (Bash 4.0+) and jq. No other external tools needed.

- **`gather-claude.sh`** - Processes Claude Code chats from `~/.claude/projects/`. [Details](claude-support/README.md)
- **`gather-copilot.sh`** - Processes Copilot chats from VS Code workspaces. [Details](copilot-support/README.md)

### PowerShell Scripts (Windows)
**Dependencies:** PowerShell 5.1+, VS Code with GitHub Copilot extension, Claude Code application, System.Web assembly.

- **`Gather-Copilot.ps1`** - GitHub Copilot chat collection orchestrator
- **`Gather-Claude.ps1`** - Claude Code chat collection orchestrator  
- **`CommonFunctions.psm1`** - Shared PowerShell functions module

#### Support Scripts
- **`copilot-support\Gather-CopilotWorkspace.ps1`** - Copilot workspace processor
- **`claude-support\Gather-ClaudeProject.ps1`** - Claude project processor
- **`claude-support\ClaudeProjectDiscovery.ps1`** - Claude project discovery functions

## Basic Usage

### Bash Scripts
```bash
# Process current project/workspace
./gather-claude.sh
./gather-copilot.sh

# Process last 5 chats only
./gather-claude.sh -n 5
./gather-copilot.sh -n 5
```

### PowerShell Scripts

#### GitHub Copilot
```powershell
# List available Copilot workspaces
.\Gather-Copilot.ps1 list

# Process current workspace
.\Gather-Copilot.ps1

# Process specific workspace with 5 most recent chats
.\Gather-Copilot.ps1 collect -WorkspaceHash abc123def456 -Number 5

# Process all workspaces
.\Gather-Copilot.ps1 collect -AllWorkspaces
```

#### Claude Code
```powershell
# List available Claude projects
.\Gather-Claude.ps1 list

# Process current project (auto-detect)
.\Gather-Claude.ps1

# Process specific project
.\Gather-Claude.ps1 collect -ProjectPath "-Users-allenh-projects-my-app"

# Process all projects with 3 most recent chats each
.\Gather-Claude.ps1 collect -AllProjects -Number 3
```

## Output Structure

Both bash and PowerShell scripts generate organized markdown in the `build/` directory:

```
build/
├── claude-chats/           # Claude Code output
│   └── {project-name}/
│       └── processed-chats/
│           └── chat-{id}/
│               ├── abbreviated.md   # Conversation log
│               ├── detailed.md      # Full summary
│               └── tool_results/    # (Claude only)
└── copilot-chats/          # Copilot output
    ├── workspace-summary.md                    # Single workspace mode (PowerShell)
    └── {escaped-workspace-path}/               # e.g., -Users-allenh-projects-my-app
        ├── workspace-summary.md                # (PowerShell)
        └── chats/
            └── chat-{timestamp}-{id}/
                ├── abbreviated.md   # Conversation log
                └── detailed.md      # Full summary
```

## Output Files

### abbreviated.md
Streamlined IRC-style conversation log showing the essential flow:
```
[09:45:12] User: How do I implement authentication?
[09:45:15] Assistant: I'll help you implement authentication...
[09:45:18] User: Can you show me an example?
[09:45:20] Assistant: Here's a basic JWT authentication example...
```

### detailed.md
Full chat summary with metadata, tool usage (Claude), and complete responses:
```markdown
# Chat Session: abc-123-def
Created: 2024-01-15 09:45:12
Messages: 8
Duration: 5m 32s

## Conversation
### User
How do I implement authentication?

### Assistant
I'll help you implement authentication. Let me first check your current setup...
[Used tools: Read, Edit, Bash]
...
```

For complete documentation of each system, see the linked README files above.