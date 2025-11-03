# Claude Code Chat Collection System

This directory contains scripts for collecting and processing Claude Code chat sessions from the local Claude Code storage.

## Overview

The gather-claude system is a two-tier orchestration system that processes Claude Code chat sessions stored as JSONL files and converts them into organized, human-readable markdown documentation.

## System Architecture

### 1. **gather-claude.sh** (Orchestrator)
The main entry point that orchestrates the collection process across projects.

**Features:**
- Auto-detects current workspace and processes it (default behavior)
- `--all-projects` mode discovers and processes all Claude projects
- Delegates actual processing to `gather-project.sh`
- Generates consolidated summaries when processing multiple projects

**Options:**
- `--all-projects` - Process all Claude projects found in ~/.claude/projects/
- `-n, --number NUM` - Process only the NUM most recent chats per project
- `-s, --session-id ID` - Process only the chat with the specified session ID
- `-f, --force` - Force reprocessing of all files (ignores skip logic)
- `-h, --help` - Show usage information

### 2. **gather-project.sh** (Worker)
Handles the actual processing of JSONL chat files for a specific project.

**Features:**
- Auto-detects or accepts a specific Claude project directory
- Processes JSONL files into structured markdown output
- Extracts tool execution results into separate files
- Creates comprehensive chat summaries
- Implements incremental processing (skips already processed files)

**Options:**
- `-p, --project PATH` - Claude project directory path (auto-detects if not provided)
- `-n, --number NUM` - Process only the NUM most recent chats
- `-s, --session-id ID` - Process only the chat with the specified session ID
- `-f, --force` - Force reprocessing of all files
- `-h, --help` - Show usage information

### 3. **JQ Processing Scripts**

#### preprocess-jsonl.jq
Optimizes JSONL data for efficient processing:
- Builds tool mappings once (eliminates redundant processing)
- Links tool uses with their results using UUID relationships
- Creates unified conversation structure with metadata
- Generates performance-optimized JSON for downstream scripts

#### extract-tool-results.jq
Extracts tool execution results from preprocessed JSON:
- Uses pre-built tool mappings for efficient processing
- Extracts tool results with proper naming including timestamps
- Formats results as markdown files

#### generate-conversation.jq
Creates streamlined IRC-style conversation logs from preprocessed JSON:
- Extracts just the essential conversation flow (user/assistant messages)
- Groups consecutive tool-only assistant messages for cleaner output
- Formats timestamps as HH:MM:SS for easy reading
- Creates compact, readable chat logs without metadata headers

#### generate-summary.jq
Creates markdown summaries from preprocessed conversations:
- Processes unified conversation structure
- Identifies tool usage from preprocessed data
- Creates links to full tool result files
- Truncates long content with references to full files

## Data Flow

### Source Data Structure
Claude Code stores chat sessions in: `~/.claude/projects/{escaped-project-path}/`

Directory names are escaped paths where slashes become hyphens:
- `/Users/allenh/projects/my-app` → `-Users-allenh-projects-my-app`

Each JSONL file represents one chat session with entries containing:
- User messages with text content
- Assistant messages with text and tool use information
- Tool results returned from executed tools
- Metadata (timestamps, UUIDs, session IDs, parent UUIDs)

### Processing Pipeline
1. **Preprocessing Stage**: `preprocess-jsonl.jq` optimizes raw JSONL into structured JSON
2. **Parallel Processing**: Multiple chats processed simultaneously using `xargs -P`
3. **Extraction Stage**: Tool results and summaries generated from preprocessed data
4. **Output Buffering**: Clean parallel execution with atomic output display

### Output Structure
```
build/claude-chats/
├── all-projects-summary.md         # Consolidated summary (--all-projects mode)
└── {project-name}/
    ├── project-summary.md          # Project-level summary
    └── processed-chats/
        └── chat-{session-id}/
            ├── abbreviated.md     # Streamlined chat conversation log
            ├── detailed.md          # Individual chat summary with tool usage
            └── tool_results/       # Extracted tool execution results
                └── {timestamp}-{tool_name}-{uuid}.md
```

## Usage Examples

### Process Current Workspace
```bash
# Auto-detect and process current project
./gather-claude.sh

# Process only 5 most recent chats
./gather-claude.sh -n 5

# Process specific session
./gather-claude.sh -s abc123-def456
```

### Process All Projects
```bash
# Process all Claude projects
./gather-claude.sh --all-projects

# Process 3 most recent chats from each project
./gather-claude.sh --all-projects -n 3

# Force reprocess everything
./gather-claude.sh --all-projects -f
```

### Process Specific Project
```bash
# Process specific project
./gather-project.sh -p "-Users-allenh-projects-my-app"

# Process with options
./gather-project.sh -p "-Users-allenh-projects-my-app" -n 10 -f
```

## Key Features

### Incremental Processing
- Compares file modification times
- Skips already processed files unless source is newer
- Use `-f` flag to force reprocessing

### Flexible Filtering
- Limit processing to N most recent chats
- Search for specific session IDs across projects
- Mutually exclusive options prevent conflicts

### Comprehensive Output
- **Conversation logs**: Clean, IRC-style chat flow (`abbreviated.md`)
- **Detailed summaries**: Full analysis with tool usage (`detailed.md`)
- **Extracted tool results**: Individual tool outputs in separate files
- **Timestamps and metadata**: Preserved throughout the processing pipeline
- **Cross-references**: Links between summaries and full tool result content

### Performance Features
- **Parallel Processing**: Concurrent processing of multiple chats and projects using `xargs -P`
- **Preprocessing Pipeline**: Builds tool mappings once and reuses them, eliminating redundant processing across extraction and summary stages
- **Output Buffering**: Clean display during parallel execution with atomic output
- **Optimized File Operations**: Batch jq commands for efficient file I/O
- **Graceful Fallback**: Automatic sequential processing when parallel support unavailable

## Requirements

- **jq** - Command-line JSON processor (install with `brew install jq`)
- **bash** - Bash shell version 4.0 or higher (POSIX-compliant)
- **Claude Code** - Must have Claude Code installed with existing chat sessions

**Note:** These scripts only require POSIX-compliant shell and jq. No other external dependencies are needed.

## Error Handling

The scripts include comprehensive error handling for:
- Missing dependencies (jq)
- Invalid project paths
- Missing Claude Code data directory
- Malformed JSONL data
- File system permissions

## Implementation Notes

1. **Path Escaping**: Claude Code escapes project paths by replacing `/` with `-` and prepending `-`
2. **JSONL Format**: Each line is a complete JSON object, allowing streaming processing
3. **Tool Mapping**: Assistant messages contain tool definitions, user messages contain results
4. **UUID Tracking**: Parent UUIDs link related messages in conversations