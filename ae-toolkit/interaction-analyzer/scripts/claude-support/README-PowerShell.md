# Claude Code Chat Collection System (PowerShell)

This directory contains PowerShell scripts for collecting and processing Claude Code chat sessions from the local Claude Code storage on Windows systems.

## Overview

The Gather-Claude PowerShell system is a two-tier orchestration system that processes Claude Code chat sessions stored as JSONL files and converts them into organized, human-readable markdown documentation.

## System Architecture

### 1. **Gather-Claude.ps1** (Orchestrator)
The main entry point that orchestrates the collection process across projects.

**Features:**
- Auto-detects current workspace and processes it (default behavior)
- `-AllProjects` mode discovers and processes all Claude projects
- Delegates actual processing to `Gather-ClaudeProject.ps1`
- Generates consolidated summaries when processing multiple projects

**Options:**
- `-AllProjects` - Process all Claude projects found in `~\.claude\projects\`
- `-Number NUM` - Process only the NUM most recent chats per project
- `-SessionId ID` - Process only the chat with the specified session ID
- `-Force` - Force reprocessing of all files (ignores skip logic)
- `-Help` - Show usage information

**Examples:**
```powershell
.\Gather-Claude.ps1 list
.\Gather-Claude.ps1
.\Gather-Claude.ps1 collect -AllProjects
.\Gather-Claude.ps1 collect -AllProjects -Number 5
.\Gather-Claude.ps1 collect -ProjectPath "-Users-{username}-projects-my-app"
```

### 2. **Gather-ClaudeProject.ps1** (Worker)
Handles the actual processing of JSONL chat files for a specific project.

**Features:**
- Accepts a specific Claude project directory path
- Processes JSONL files into structured markdown output
- Extracts tool execution results into separate sections
- Creates comprehensive chat summaries
- Implements incremental processing (skips already processed files)

**Options:**
- `-ProjectPath PATH` - Required: Claude project directory path
- `-Number NUM` - Process only the NUM most recent chats
- `-SessionId ID` - Process only the chat with the specified session ID
- `-Force` - Force reprocessing of all files
- `-DebugMode` - Keep intermediate files for debugging

**Examples:**
```powershell
.\Gather-ClaudeProject.ps1 -ProjectPath "-Users-allenh-projects-ai-accelerator"
.\Gather-ClaudeProject.ps1 -ProjectPath "-Users-allenh-projects-ai-accelerator" -Number 5
.\Gather-ClaudeProject.ps1 -ProjectPath "-Users-allenh-projects-ai-accelerator" -SessionId abc123 -Force
```

### 3. **ClaudeProjectDiscovery.ps1** (Helper Functions)
Provides project discovery and validation functions.

**Functions:**
- `Find-ClaudeProjectDir` - Auto-detects Claude project for current directory
- `Test-ProjectDir` - Validates project paths
- `Show-AvailableProjects` - Lists all available projects
- `Get-AvailableProjectDirs` - Returns project directory paths
- `Test-ClaudeInstallation` - Checks if Claude is installed
- `ConvertTo-ClaudeEscapedPath` - Converts filesystem paths to Claude's format

## Output Structure

```
build/claude-chats/
├── all-projects-summary.md (when using -AllProjects)
└── {project-name}/
    ├── project-summary.md
    └── processed-chats/
        └── chat-{id}/
            ├── detailed.md
            ├── abbreviated.md
            └── tool_results/ (placeholder for future enhancement)
```

## Requirements

- **PowerShell 5.1 or later**
- **ConvertFrom-Json cmdlet** (built into PowerShell)
- **Claude Code installed** with projects in `~\.claude\projects\`

## Installation Locations

The scripts expect Claude Code to store projects in:
- `$env:USERPROFILE\.claude\projects` (default)

## Differences from Bash Version

This PowerShell implementation provides equivalent functionality to the bash scripts with the following adaptations:

1. **Native JSON Processing**: Uses PowerShell's built-in `ConvertFrom-Json` instead of `jq`
2. **Windows Path Handling**: Proper handling of Windows filesystem paths and escaping
3. **PowerShell Conventions**: Uses PowerShell parameter naming and help conventions
4. **Integrated Functions**: Helper functions are integrated rather than sourced from separate files

## Parallel Processing

The PowerShell version processes projects sequentially for simplicity and reliability on Windows systems. For large numbers of projects, consider running multiple instances manually if needed.

## Error Handling

- Comprehensive error checking for missing Claude installation
- Validation of project directories and chat files
- Graceful handling of malformed JSONL files
- Clear error messages with suggested remediation steps

## Debugging

Use the `-DebugMode` flag to enable verbose output and preserve intermediate files for troubleshooting.

## Future Enhancements

- Enhanced tool result extraction and processing
- Parallel project processing support
- Integration with Windows PowerShell ISE and VS Code
- Advanced filtering and search capabilities
- Export to different formats (HTML, PDF, etc.)
