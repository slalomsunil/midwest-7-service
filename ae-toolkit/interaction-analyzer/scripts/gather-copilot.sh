#!/bin/bash

set -e

# GitHub Copilot Chat Collector (Orchestrator)
# Orchestrates collection and processing of GitHub Copilot chat sessions across VS Code workspaces
#
# For detailed documentation, see: [copilot-support/README.md](copilot-support/README.md)
#
# FUNCTIONALITY:
# - Auto-detects current workspace and processes it (default behavior)
# - --all-workspaces mode discovers and processes all VS Code workspaces
# - Delegates actual processing to gather-copilot-workspace.sh
# - Generates consolidated summaries when processing multiple workspaces
# - Supports list mode to discover available workspaces
#
# OUTPUT STRUCTURE:
# build/copilot-chats/
# ├── all-workspaces-summary.md     # Consolidated summary (--all-workspaces mode)
# └── {escaped-workspace-path}/     # e.g., -Users-allenh-projects-my-app
#     ├── workspace-summary.md      # Workspace-level summary
#     └── chats/
#         └── chat-{timestamp}-{id}/
#             ├── detailed.md
#             └── abbreviated.md

# Show usage information
show_usage() {
    echo "Usage: $0 [ACTION] [OPTIONS]"
    echo ""
    echo "Orchestrates GitHub Copilot chat collection across VS Code workspaces."
    echo ""
    echo "Actions:"
    echo "  list                  List all available VS Code workspaces with Copilot chats"
    echo "  collect               Collect and process chat data (default)"
    echo ""
    echo "Options (for collect action):"
    echo "  --all-workspaces      Process all VS Code workspaces with Copilot chats"
    echo "  -w, --workspace HASH  Process specific workspace by hash"
    echo "  -n, --number NUM      Process only the NUM most recent chats per workspace"
    echo "  -s, --session-id ID   Process only the chat with the specified session ID"
    echo "  -f, --force           Force reprocessing of all files (ignores skip logic)"
    echo "  --debug               Keep intermediate files for debugging"
    echo "  -h, --help            Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 list               List available workspaces with their paths"
    echo "  $0                    Process current workspace (auto-detect)"
    echo "  $0 collect -n 5               Process 5 most recent chats from current workspace"
    echo "  $0 collect --all-workspaces   Process all workspaces with Copilot chats"
    echo "  $0 collect --all-workspaces -n 3  Process 3 most recent chats from each workspace"
    echo "  $0 collect -w 6586153aefd75ad1b35940bda0bc5d39 -n 5"
    echo ""
    echo "Requirements:"
    echo "  - jq (brew install jq)"
    echo "  - VS Code with GitHub Copilot chats"
}

# Script directory and build output path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULE_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$MODULE_DIR/build"
OUTPUT_DIR="$BUILD_DIR/copilot-chats"

# Source common library functions
source "${SCRIPT_DIR}/common-lib.sh"

# Path to worker script
WORKER_SCRIPT="$SCRIPT_DIR/copilot-support/gather-copilot-workspace.sh"

# Global variables populated by parse_args
ACTION="collect"  # Default action
ALL_WORKSPACES="false"
WORKSPACE_HASH=""
NUM_CHATS=""
SESSION_ID=""
FORCE_REPROCESS="false"
DEBUG_MODE="false"

# Find all available VS Code workspaces
find_all_workspaces() {
    local vscode_storage_dir="$HOME/Library/Application Support/Code/User/workspaceStorage"
    
    if [[ ! -d "$vscode_storage_dir" ]]; then
        echo -e "${RED}Error: VS Code workspace storage directory not found${NC}" >&2
        echo "Expected: $vscode_storage_dir" >&2
        exit 1
    fi
    
    local workspaces=()
    for workspace_dir in "$vscode_storage_dir"/*; do
        if [[ -d "$workspace_dir" ]]; then
            local workspace_hash="$(basename "$workspace_dir")"
            local workspace_json="$workspace_dir/workspace.json"
            local chat_sessions_dir="$workspace_dir/chatSessions"
            
            # Only include workspaces that have:
            # 1. workspace.json file
            # 2. chatSessions directory with JSON files
            if [[ -f "$workspace_json" && -d "$chat_sessions_dir" ]]; then
                local chat_count=$(find "$chat_sessions_dir" -name "*.json" -type f | wc -l)
                if [[ $chat_count -gt 0 ]]; then
                    workspaces+=("$workspace_hash")
                fi
            fi
        fi
    done
    
    printf '%s\n' "${workspaces[@]}"
}


# List all available workspaces with paths (for list action)
list_copilot_workspaces() {
    echo -e "${BLUE}Available VS Code Workspaces with Copilot Chats:${NC}"
    echo ""
    
    local vscode_storage_dir="$HOME/Library/Application Support/Code/User/workspaceStorage"
    
    if [[ ! -d "$vscode_storage_dir" ]]; then
        echo -e "${RED}Error: VS Code workspace storage directory not found${NC}" >&2
        echo "Expected: $vscode_storage_dir" >&2
        exit 1
    fi
    
    local found_workspaces=false
    for workspace_dir in "$vscode_storage_dir"/*; do
        if [[ -d "$workspace_dir" ]]; then
            local workspace_hash="$(basename "$workspace_dir")"
            local workspace_json="$workspace_dir/workspace.json"
            local chat_sessions_dir="$workspace_dir/chatSessions"
            
            # Only include workspaces that have Copilot chats
            if [[ -f "$workspace_json" && -d "$chat_sessions_dir" ]]; then
                local chat_count=$(find "$chat_sessions_dir" -name "*.json" -type f | wc -l)
                if [[ $chat_count -gt 0 ]]; then
                    local workspace_path
                    workspace_path=$(get_workspace_path_from_json "$workspace_json")
                    echo "$workspace_hash: $workspace_path"
                    found_workspaces=true
                fi
            fi
        fi
    done
    
    if [[ "$found_workspaces" == "false" ]]; then
        echo -e "${YELLOW}No VS Code workspaces with Copilot chats found${NC}"
    fi
}

# Parse command line arguments
parse_args() {
    # Check if first argument is an action (doesn't start with -)
    if [[ $# -gt 0 && "$1" != -* ]]; then
        case "$1" in
            list|collect)
                ACTION="$1"
                shift
                ;;
            *)
                # Invalid action - error out
                echo -e "${RED}Unknown action: $1${NC}"
                echo -e "${YELLOW}Valid actions: list, collect${NC}"
                show_usage
                exit 1
                ;;
        esac
    fi
    
    # Parse remaining arguments (only for collect action)
    if [[ "$ACTION" == "collect" ]]; then
        while [[ $# -gt 0 ]]; do
            case $1 in
                --all-workspaces)
                    ALL_WORKSPACES="true"
                    shift
                    ;;
                -w|--workspace)
                    WORKSPACE_HASH="$2"
                    shift 2
                    ;;
                -n|--number)
                    NUM_CHATS="$2"
                    shift 2
                    ;;
                -s|--session-id)
                    SESSION_ID="$2"
                    shift 2
                    ;;
                -f|--force)
                    FORCE_REPROCESS="true"
                    shift
                    ;;
                --debug)
                    DEBUG_MODE="true"
                    shift
                    ;;
                -h|--help)
                    show_usage
                    exit 0
                    ;;
                *)
                    echo -e "${RED}Unknown option: $1${NC}"
                    show_usage
                    exit 1
                    ;;
            esac
        done
    fi
    
    # Check for mutually exclusive options
    if [[ -n "$NUM_CHATS" && -n "$SESSION_ID" ]]; then
        echo -e "${RED}Error: -n/--number and -s/--session-id options are mutually exclusive${NC}"
        show_usage
        exit 1
    fi
    
    if [[ "$ALL_WORKSPACES" == "true" && -n "$WORKSPACE_HASH" ]]; then
        echo -e "${RED}Error: --all-workspaces and -w/--workspace options are mutually exclusive${NC}"
        show_usage
        exit 1
    fi
}


# Build worker command arguments
build_worker_args() {
    local args=()
    
    if [[ -n "$NUM_CHATS" ]]; then
        args+=("-n" "$NUM_CHATS")
    fi
    
    if [[ -n "$SESSION_ID" ]]; then
        args+=("-s" "$SESSION_ID")
    fi
    
    if [[ "$FORCE_REPROCESS" == "true" ]]; then
        args+=("-f")
    fi
    
    if [[ "$DEBUG_MODE" == "true" ]]; then
        args+=("--debug")
    fi
    
    printf '%s\n' "${args[@]}"
}

# Main execution
main() {
    # Handle list action
    if [[ "$ACTION" == "list" ]]; then
        list_copilot_workspaces
        return 0
    fi
    
    # Handle collect action
    echo -e "${BLUE}GitHub Copilot Chat Collector${NC}"
    echo "=================================="

    check_dependencies
    
    # Create output directory
    mkdir -p "$OUTPUT_DIR"
    
    # Determine processing mode
    local workspaces_to_process=()
    
    if [[ "$ALL_WORKSPACES" == "true" ]]; then
        echo -e "${BLUE}Discovering all VS Code workspaces with Copilot chats...${NC}"
        
        while IFS= read -r workspace_hash; do
            workspaces_to_process+=("$workspace_hash")
        done < <(find_all_workspaces)
        
        if [[ ${#workspaces_to_process[@]} -eq 0 ]]; then
            echo -e "${YELLOW}No VS Code workspaces with Copilot chats found${NC}"
            exit 0
        fi
        
        echo -e "${GREEN}Found ${#workspaces_to_process[@]} workspace(s) with Copilot chats${NC}"
        
    elif [[ -n "$WORKSPACE_HASH" ]]; then
        echo -e "${BLUE}Processing specified workspace: $WORKSPACE_HASH${NC}"
        workspaces_to_process+=("$WORKSPACE_HASH")
        
    else
        echo -e "${BLUE}Auto-detecting current workspace...${NC}"
        local detected_workspace
        if detected_workspace=$(find_workspace_hash); then
            workspaces_to_process+=("$detected_workspace")
            echo -e "${GREEN}✓ Found workspace: $detected_workspace${NC}"
        else
            echo -e "${RED}Error: Could not find VS Code workspace for current directory${NC}"
            echo -e "${YELLOW}Try using -w WORKSPACE_HASH or --all-workspaces${NC}"
            exit 1
        fi
    fi
    
    echo ""
    
    # Process workspaces
    local worker_args=($(build_worker_args))
    local processed_workspaces=0
    local total_workspaces=${#workspaces_to_process[@]}
    
    if [[ $total_workspaces -gt 1 && "$XARGS_PARALLEL_SUPPORTED" == "true" ]]; then
        echo -e "${BLUE}Processing $total_workspaces workspaces in parallel...${NC}"
        
        # Create wrapper function for xargs
        process_workspace_wrapper() {
            local workspace_hash="$1"
            shift
            "$WORKER_SCRIPT" -w "$workspace_hash" "$@"
        }
        export -f process_workspace_wrapper
        export WORKER_SCRIPT
        
        # Process in parallel with limited concurrency
        printf '%s\n' "${workspaces_to_process[@]}" | xargs -P 3 -I {} bash -c 'process_workspace_wrapper "$@"' _ {} "${worker_args[@]}"
        processed_workspaces=$total_workspaces
        
    else
        echo -e "${BLUE}Processing $total_workspaces workspace(s) sequentially...${NC}\n"
        
        for workspace_hash in "${workspaces_to_process[@]}"; do
            "$WORKER_SCRIPT" -w "$workspace_hash" "${worker_args[@]}"
            ((processed_workspaces++))
        done
    fi
    
    # Generate consolidated summary if processing multiple workspaces
    if [[ "$ALL_WORKSPACES" == "true" && $processed_workspaces -gt 0 ]]; then
        echo -e "${BLUE}Generating consolidated summary...${NC}"
        
        # Count workspaces with chats first
        local total_chats=0
        local workspaces_with_chats=0
        for workspace_hash in "${workspaces_to_process[@]}"; do
            # Get the workspace path and escape it to find the output directory
            local workspace_json="$HOME/Library/Application Support/Code/User/workspaceStorage/$workspace_hash/workspace.json"
            local workspace_path=$(get_workspace_path_from_json "$workspace_json")
            if [[ "$workspace_path" == "Unknown" ]]; then
                echo -e "${YELLOW}Warning: Could not determine path for workspace $workspace_hash - skipping${NC}" >&2
                continue
            fi
            local escaped_workspace_path=$(escape_path_using_claude_escaping "$workspace_path")
            local workspace_summary="$OUTPUT_DIR/$escaped_workspace_path/workspace-summary.md"
            
            if [[ -f "$workspace_summary" ]]; then
                local workspace_chat_count=$(grep "Total Chats Found:" "$workspace_summary" | grep -o '[0-9]*' || echo "0")
                total_chats=$((total_chats + workspace_chat_count))
                workspaces_with_chats=$((workspaces_with_chats + 1))
            fi
        done
        
        # Generate summary with correct counts
        {
            echo "# All Workspaces Copilot Chat Collection Summary"
            echo ""
            echo "**Generated:** $(date)"
            echo "**Total Workspaces Processed:** $workspaces_with_chats"
            echo ""
            
            for workspace_hash in "${workspaces_to_process[@]}"; do
                # Get the workspace path and escape it
                local workspace_json="$HOME/Library/Application Support/Code/User/workspaceStorage/$workspace_hash/workspace.json"
                local workspace_path=$(get_workspace_path_from_json "$workspace_json")
                if [[ "$workspace_path" == "Unknown" ]]; then
                    continue
                fi
                local escaped_workspace_path=$(escape_path_using_claude_escaping "$workspace_path")
                local workspace_summary="$OUTPUT_DIR/$escaped_workspace_path/workspace-summary.md"
                
                if [[ -f "$workspace_summary" ]]; then
                    local workspace_chat_count=$(grep "Total Chats Found:" "$workspace_summary" | grep -o '[0-9]*' || echo "0")
                    
                    echo "## Workspace: $workspace_path"
                    echo ""
                    echo "- **Chat Count:** $workspace_chat_count"
                    echo "- **Summary:** [$escaped_workspace_path/workspace-summary.md]($escaped_workspace_path/workspace-summary.md)"
                    echo "- **Chats:** [$escaped_workspace_path/chats/]($escaped_workspace_path/chats/)"
                    echo ""
                fi
            done
            
            echo "**Total Chats Across All Workspaces:** $total_chats"
            
        } > "$OUTPUT_DIR/all-workspaces-summary.md"
    fi
    
    if [[ "$ALL_WORKSPACES" == "true" ]]; then
        echo ""
        echo -e "${GREEN}✓ Completed Collecting All Workspaces!${NC}"
        echo -e "${GREEN}✓ Processed $processed_workspaces workspace(s)${NC}"
        if [[ -f "$OUTPUT_DIR/all-workspaces-summary.md" ]]; then
            echo -e "${GREEN}✓ Summary: ${VIOLET}$OUTPUT_DIR/all-workspaces-summary.md${NC}"
        fi
    fi
    # The workspace script outputs its own summary for single workspace mode
}

# Parse arguments and run main
parse_args "$@"
main "$@"