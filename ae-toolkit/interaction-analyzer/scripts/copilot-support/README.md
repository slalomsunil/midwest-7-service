# GitHub Copilot Chat Collection System

This directory contains scripts for collecting and processing GitHub Copilot chat sessions from VS Code workspace storage.

## Overview

The gather-copilot system processes GitHub Copilot chat sessions stored as JSON files and converts them into organized, human-readable markdown documentation. Unlike the Claude system, Copilot chats don't require complex preprocessing since the data is already well-structured.

## System Architecture

### 1. **gather-copilot.sh** (Orchestrator)
The main entry point that orchestrates the collection process across VS Code workspaces.

**Features:**
- Auto-detects current workspace and processes it (default behavior)
- `--all-workspaces` mode discovers and processes all VS Code workspaces
- Delegates actual processing to `gather-copilot-workspace.sh`
- Generates consolidated summaries when processing multiple workspaces

**Options:**
- `--all-workspaces` - Process all VS Code workspaces found in Application Support
- `-w, --workspace HASH` - Process specific workspace by hash
- `-n, --number NUM` - Process only the NUM most recent chats per workspace
- `-s, --session-id ID` - Process only the chat with the specified session ID
- `-f, --force` - Force reprocessing of all files (ignores skip logic)
- `-h, --help` - Show usage information

### 2. **gather-copilot-workspace.sh** (Worker)
Handles the actual processing of JSON chat files for a specific VS Code workspace.

**Features:**
- Processes JSON files into structured markdown output
- Creates conversation logs and detailed summaries
- Implements incremental processing (skips already processed files)
- Extracts metadata like response times and message counts

**Options:**
- `-w, --workspace HASH` - VS Code workspace hash (auto-detects if not provided)
- `-n, --number NUM` - Process only the NUM most recent chats
- `-s, --session-id ID` - Process only the chat with the specified session ID
- `-f, --force` - Force reprocessing of all files
- `-h, --help` - Show usage information

### 3. **JQ Processing Scripts**

#### generate-copilot-summary.jq
Creates detailed markdown summaries from Copilot JSON:
- Extracts metadata (creation date, message count, response times)
- Formats conversation flow with user messages and AI responses
- Handles response chunking (Copilot responses come as arrays)
- No complex preprocessing needed - works directly with JSON structure

#### generate-copilot-conversation.jq
Creates streamlined conversation logs from Copilot JSON:
- Extracts essential conversation flow (user/assistant messages)
- Formats timestamps for easy reading
- Creates compact, readable chat logs
- Groups response chunks into single assistant messages

## Data Flow

### Source Data Structure
VS Code stores Copilot chats in: `~/Library/Application Support/Code/User/workspaceStorage/{hash}/chatSessions/`

Each JSON file represents one chat session with structure:
- `sessionId`: Unique identifier for the chat session
- `creationDate`: When the chat was created
- `lastMessageDate`: When the last message was sent
- `requests[]`: Array of request/response pairs containing:
  - `message`: User message with text and parts
  - `response[]`: AI response as array of chunks with `.value`
  - `requestId`: Unique identifier for the request
  - `result.timings`: Response timing information

### Processing Pipeline
1. **Discovery Stage**: Find VS Code workspace for current directory or all workspaces
2. **Parallel Processing**: Multiple chats processed simultaneously using `xargs -P`
3. **Direct Extraction**: JSON data extracted directly without preprocessing
4. **Output Generation**: Conversation logs and summaries created from extracted data

### Output Structure
```
build/copilot-chats/
├── all-workspaces-summary.md       # Consolidated summary (--all-workspaces mode)
└── {escaped-workspace-path}/       # e.g., -Users-allenh-projects-my-app
    ├── workspace-summary.md        # Workspace-level summary
    └── chats/
        └── chat-{timestamp}-{id}/
            ├── detailed.md          # Detailed chat summary with metadata
            └── abbreviated.md     # Streamlined conversation log
```

## Usage Examples

### Process Current Workspace
```bash
# Auto-detect and process current workspace
./gather-copilot.sh

# Process only 5 most recent chats
./gather-copilot.sh -n 5

# Process specific session
./gather-copilot.sh -s abc123-def456
```

### Process All Workspaces
```bash
# Process all VS Code workspaces
./gather-copilot.sh --all-workspaces

# Process 3 most recent chats from each workspace
./gather-copilot.sh --all-workspaces -n 3

# Force reprocess everything
./gather-copilot.sh --all-workspaces -f
```

### Process Specific Workspace
```bash
# Process specific workspace by hash
./gather-copilot-workspace.sh -w 6586153aefd75ad1b35940bda0bc5d39

# Process with options
./gather-copilot-workspace.sh -w 6586153aefd75ad1b35940bda0bc5d39 -n 10 -f
```

## Key Features

### Simple Data Processing
- No preprocessing required - Copilot JSON is already well-structured
- Direct extraction of request/response pairs
- Simple conversation flow creation
- No tool use/result linking needed

### Infrastructure Alignment with Claude
- Same command-line interface and options
- Parallel processing capabilities
- Incremental updates with timestamp-based skip logic
- Comprehensive error handling and user feedback

### Workspace Discovery
- Auto-detects VS Code workspace for current directory
- Supports processing multiple workspaces
- Handles workspace.json parsing and path resolution

## Requirements

- **jq** - Command-line JSON processor (install with `brew install jq`)
- **bash** - Bash shell version 4.0 or higher (POSIX-compliant)
- **VS Code** - Must have VS Code with Copilot chats created

**Note:** These scripts only require POSIX-compliant shell and jq. No other external dependencies are needed.

## Key Differences from Claude System

1. **Simpler Data Structure**: JSON vs JSONL, no tool use complexity
2. **Direct Processing**: No preprocessing pipeline needed
3. **Conversation-Focused**: Pure text interactions, no tool results
4. **Workspace-Based**: VS Code workspaces vs Claude projects
5. **Response Chunking**: Copilot responses come as arrays of chunks

The Copilot system maintains the organizational benefits and user experience of the Claude system while being appropriately simplified for the less complex data structure.