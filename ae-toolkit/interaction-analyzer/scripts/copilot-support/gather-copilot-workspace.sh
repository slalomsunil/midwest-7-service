#!/bin/bash

set -e

# GitHub Copilot Chat Workspace Processor
# Processes GitHub Copilot chat sessions from a specified VS Code workspace
#
# For detailed documentation, see: [README.md](./README.md)
#
# FUNCTIONALITY:
# - Processes .json chat files from specified VS Code workspace directory into structured markdown output
# - Creates individual chat folders with detailed.md and abbreviated.md
# - Skips already processed files unless they're newer than output
# - Generates consolidated workspace summary report
# - Supports parallel processing and filtering by recent chats or session ID
#
# OUTPUT STRUCTURE:
# build/copilot-chats/
# └── {escaped-workspace-path}/    # e.g., -Users-allenh-projects-my-app
#     ├── workspace-summary.md
#     └── chats/
#         ├── chat-{timestamp}-{id}/
#         │   ├── detailed.md
#         │   └── abbreviated.md
#         └── chat-{timestamp}-{other-id}/
#             ├── detailed.md
#             └── abbreviated.md

# Show usage information
show_usage() {
    echo "Usage: $0 -w WORKSPACE_HASH [-n NUM] [-s SESSION_ID] [-f]"
    echo ""
    echo "Processes GitHub Copilot chat sessions from a specified VS Code workspace."
    echo ""
    echo "Options:"
    echo "  -w, --workspace HASH  Required: VS Code workspace hash"
    echo "  -n, --number NUM      Process only the NUM most recent chats"
    echo "  -s, --session-id ID   Process only the chat with the specified session ID"
    echo "  -f, --force           Force reprocessing of all files (ignores skip logic)"
    echo "  --debug               Keep intermediate files for debugging"
    echo "  -h, --help            Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 -w 6586153aefd75ad1b35940bda0bc5d39                    Process specified workspace"
    echo "  $0 -w 6586153aefd75ad1b35940bda0bc5d39 -n 5               Process 5 most recent chats from workspace"
    echo "  $0 -w 6586153aefd75ad1b35940bda0bc5d39 -n 5"
    echo "  $0 -w 6586153aefd75ad1b35940bda0bc5d39 -s abc123 -f"
    echo ""
    echo "Requirements:"
    echo "  - jq (brew install jq)"
    echo "  - Valid VS Code workspace with Copilot chats"
}

# Script directory and build output path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$(dirname "$SCRIPT_DIR")"
MODULE_DIR="$(dirname "$SCRIPTS_DIR")"
BUILD_DIR="$MODULE_DIR/build"
BASE_OUTPUT_DIR="$BUILD_DIR/copilot-chats"
JQ_INCLUDE_DIR="$SCRIPT_DIR"

# Source common library functions

# shellcheck source=SCRIPTDIR/../common-lib.sh
source "${SCRIPTS_DIR}/common-lib.sh"

# Path to jq script files (in copilot-support directory)
JQ_PREPROCESS_SCRIPT="$SCRIPT_DIR/jq-filters/preprocess-chat-json.jq"
JQ_DETAILED_SCRIPT="$SCRIPT_DIR/jq-filters/generate-copilot-detailed.jq"
JQ_ABBREVIATED_SCRIPT="$SCRIPT_DIR/jq-filters/generate-copilot-abbreviated.jq"

# Validate workspace hash exists (when provided via -w flag)
validate_workspace_hash() {
    local workspace_hash="$1"
    local vscode_storage_dir="$HOME/Library/Application Support/Code/User/workspaceStorage"
    local workspace_storage_dir="$vscode_storage_dir/$workspace_hash"
    
    if [[ ! -d "$vscode_storage_dir" ]]; then
        echo -e "${RED}Error: VS Code workspace storage directory not found${NC}" >&2
        echo "Expected: $vscode_storage_dir" >&2
        exit 1
    fi
    
    if [[ ! -d "$workspace_storage_dir" ]]; then
        echo -e "${RED}Error: Workspace directory not found: $workspace_storage_dir${NC}" >&2
        echo "" >&2
        echo "Available workspaces:" >&2
        for ws_dir in "$vscode_storage_dir"/*; do
            if [[ -d "$ws_dir" ]]; then
                local ws_hash=$(basename "$ws_dir")
                local ws_json="$ws_dir/workspace.json"
                if [[ -f "$ws_json" ]]; then
                    local ws_path=$(jq -r '.folder // .workspace.folders[]?.uri // empty' "$ws_json" 2>/dev/null | head -1)
                    if [[ -n "$ws_path" ]]; then
                        # Remove file:// prefix and decode URL
                        ws_path=$(echo "$ws_path" | sed 's|^file://||')
                        ws_path=$(url_decode "$ws_path")
                        echo "  $ws_hash: $ws_path"
                    else
                        echo "  $ws_hash: Unknown path"
                    fi
                else
                    echo "  $ws_hash: No workspace.json"
                fi
            fi
        done | head -5 >&2
        exit 1
    fi
    
    echo "$workspace_storage_dir"
}

# Extract useful information from Copilot JSON
process_copilot_json() {
    local chat_file="$1"
    local chat_dir="$2"
    local chat_id
    chat_id="$(basename "$chat_file" .json)"
    
    # Create buffer file for output when running in parallel
    local output_buffer="$chat_dir/processing.log"
    
    # Ensure buffer gets output even on failure
    cleanup_and_output_buffer() {
        if [[ "$XARGS_PARALLEL_SUPPORTED" == "true" && -f "$output_buffer" ]]; then
            cat "$output_buffer"
            rm -f "$output_buffer"
        fi
    }
    trap cleanup_and_output_buffer EXIT
    
    # Function to output message (buffered or direct)
    output_msg() {
        if [[ "$XARGS_PARALLEL_SUPPORTED" == "true" ]]; then
            echo -e "$1" >> "$output_buffer"
        else
            echo -e "$1"
        fi
    }
    
    output_msg "${BLUE}Processing chat: ${NC}${chat_id}"
    
    # Step 1: Preprocess JSON into optimized structure
    output_msg "${BLUE}  ├── Preprocessing JSON...${NC}"
    local preprocessed_file="$chat_dir/preprocessed.json"
    local preprocess_start=$(date +%s.%N)
    if ! jq -L "$JQ_INCLUDE_DIR" -f "$JQ_PREPROCESS_SCRIPT" "$chat_file" > "$preprocessed_file"; then
        output_msg "${RED}    ✗ Failed to preprocess JSON${NC}"
        # If we buffered output, display it now before returning
        if [[ "$XARGS_PARALLEL_SUPPORTED" == "true" && -f "$output_buffer" ]]; then
            cat "$output_buffer"
            rm -f "$output_buffer"
        fi
        return 1
    fi
    local preprocess_time=$(echo "$(date +%s.%N) - $preprocess_start" | bc -l)
    output_msg "${GREEN}    ✓ Preprocessing: ${preprocess_time}s${NC}"
    
    # Step 2: Create detailed.md
    output_msg "${BLUE}  ├── Writing detailed.md...${NC}"
    local start_time=$(date +%s.%N)
    # URL encode the path before building content
    local encoded_path=$(urlencode "$chat_file")
    
    # Build detailed.md content in memory first
    local detailed_md_content
    detailed_md_content="# Copilot Chat: $chat_id\n\n"
    detailed_md_content+="**Generated:** $(date)\n"
    detailed_md_content+="**Source:** [$chat_file](file://$encoded_path)\n\n"
    detailed_md_content+="## Chat Metadata\n\n"
    
    # Add creation date if present
    if jq -e '.creationDate' "$chat_file" >/dev/null 2>&1; then
        local creation_date
        creation_date=$(jq -r '.creationDate // "Unknown"' "$chat_file") || { cleanup_and_output_buffer; return 1; }
        detailed_md_content+="- **Created:** $creation_date\n"
    fi
    
    # Add last message date if present
    if jq -e '.lastMessageDate' "$chat_file" >/dev/null 2>&1; then
        local last_message_date
        last_message_date=$(jq -r '.lastMessageDate // "Unknown"' "$chat_file") || { cleanup_and_output_buffer; return 1; }
        detailed_md_content+="- **Last Message:** $last_message_date\n"
    fi
    
    # Add message count
    local message_count
    message_count=$(jq '.requests | length' "$chat_file") || { cleanup_and_output_buffer; return 1; }
    detailed_md_content+="- **Message Count:** $message_count\n\n"
    
    # Add conversation flow section
    detailed_md_content+="## Conversation Flow\n\n"
    
    # Extract conversation flow using external jq script
    local conversation_content
    conversation_content=$(jq -L "$JQ_INCLUDE_DIR" -r -f "$JQ_DETAILED_SCRIPT" "$preprocessed_file") || {
        output_msg "${RED}    ✗ Failed to generate detailed view${NC}"
        cleanup_and_output_buffer
        return 1
    }
    detailed_md_content+="$conversation_content\n"
    
    # Only write file if all content generation succeeded
    printf "%b" "$detailed_md_content" > "$chat_dir/detailed.md"
    
    local write_summary_time=$(echo "$(date +%s.%N) - $start_time" | bc -l)
    
    # Step 3: Create streamlined conversation log
    output_msg "${BLUE}  ├── Writing abbreviated.md...${NC}"
    start_time=$(date +%s.%N)
    if ! jq -L "$JQ_INCLUDE_DIR" -r -f "$JQ_ABBREVIATED_SCRIPT" "$preprocessed_file" > "$chat_dir/abbreviated.md"; then
        output_msg "${RED}    ✗ Failed to generate abbreviated conversation${NC}"
        # If we buffered output, display it now before returning
        if [[ "$XARGS_PARALLEL_SUPPORTED" == "true" && -f "$output_buffer" ]]; then
            cat "$output_buffer"
            rm -f "$output_buffer"
        fi
        return 1
    fi
    local write_conversation_time=$(echo "$(date +%s.%N) - $start_time" | bc -l)
    
    output_msg "${GREEN}    ✓ Summary: ${write_summary_time}s, Conversation: ${write_conversation_time}s${NC}"
    
    # Clean up preprocessed file (unless in debug mode)
    [[ "$DEBUG_MODE" != "true" ]] && rm -f "$preprocessed_file"
    
    output_msg "${GREEN}✓ Processed: ${NC}chat-$chat_id"
    
    # If we buffered output, display it now atomically
    if [[ "$XARGS_PARALLEL_SUPPORTED" == "true" && -f "$output_buffer" ]]; then
        cat "$output_buffer"
        rm -f "$output_buffer"
    fi
}

# Global variables for arguments
WORKSPACE_HASH=""
NUM_CHATS=""
SESSION_ID=""
FORCE_REPROCESS="false"
DEBUG_MODE="false"

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
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
    
    # Workspace hash is required
    if [[ -z "$WORKSPACE_HASH" ]]; then
        echo -e "${RED}Error: Workspace hash is required. Use -w/--workspace option.${NC}"
        show_usage
        exit 1
    fi
    
    # Check for mutually exclusive options
    if [[ -n "$NUM_CHATS" && -n "$SESSION_ID" ]]; then
        echo -e "${RED}Error: -n/--number and -s/--session-id options are mutually exclusive${NC}"
        show_usage
        exit 1
    fi
}


# Main execution
main() {
    local num_chats="$NUM_CHATS"
    local session_id="$SESSION_ID"
    local force_reprocess="$FORCE_REPROCESS"
    local debug_mode="$DEBUG_MODE"

    # Only check dependencies if not already set (avoids redundant checks in parallel processing)
    check_dependencies
    
    # Create base output directory
    mkdir -p "$BASE_OUTPUT_DIR"
    
    # Use provided workspace hash (required)
    echo -e "${BLUE}Processing workspace: $WORKSPACE_HASH${NC}"
    local workspace_hash="$WORKSPACE_HASH"
    local workspace_storage_dir
    workspace_storage_dir=$(validate_workspace_hash "$WORKSPACE_HASH")
    local workspace_path
    local escaped_workspace_path
    
    # Get the workspace path and escape it
    workspace_path=$(get_workspace_path_from_json "$workspace_storage_dir/workspace.json")
    if [[ "$workspace_path" == "Unknown" ]]; then
        echo -e "${RED}Error: Could not determine workspace path from workspace.json${NC}" >&2
        echo -e "${RED}Workspace: $workspace_hash${NC}" >&2
        exit 1
    fi
    
    escaped_workspace_path=$(escape_path_using_claude_escaping "$workspace_path")
    
    # Set workspace-specific output directory using escaped path
    local WORKSPACE_OUTPUT_DIR="$BASE_OUTPUT_DIR/$escaped_workspace_path"
    
    # Handle force reprocessing now that we have WORKSPACE_OUTPUT_DIR
    if [[ "$force_reprocess" == "true" ]]; then
        if [[ -n "$session_id" ]]; then
            echo -e "${YELLOW}Force reprocessing enabled - cleaning session: $session_id${NC}"
            rm -rf "$WORKSPACE_OUTPUT_DIR/chats/chat-"*"-$session_id"
        else
            echo -e "${YELLOW}Force reprocessing enabled - cleaning all existing output${NC}"
            rm -rf "$WORKSPACE_OUTPUT_DIR/chats"
        fi
    fi
    
    # Create workspace-specific directory structure
    mkdir -p "$WORKSPACE_OUTPUT_DIR/chats"
    
    echo ""
    echo -e "${BLUE}Looking for chats in: ${workspace_storage_dir}/chatSessions${NC}"
    
    # Build path to chat sessions
    local chat_sessions_dir="$workspace_storage_dir/chatSessions"
    
    if [[ ! -d "$chat_sessions_dir" ]]; then
        echo -e "${YELLOW}No chat sessions directory found for this workspace${NC}"
        echo "This means no Copilot chats have been created yet."
        exit 0
    fi
    
    # Count available chat files, sorted by modification time (newest first)
    local chat_files=()
    while IFS= read -r file; do
        chat_files+=("$file")
    done < <(find "$chat_sessions_dir" -name "*.json" -type f -exec ls -t {} +)
    
    if [[ ${#chat_files[@]} -eq 0 ]]; then
        echo -e "${YELLOW}No chat files found in workspace${NC}"
        exit 0
    fi
    
    echo -e "${GREEN}Found ${#chat_files[@]} chat file(s)${NC}"
    
    # Limit to requested number if specified (unless session ID is specified)
    if [[ -n "$session_id" ]]; then
        echo -e "${BLUE}Processing only session ID: ${session_id}${NC}"
    elif [[ -n "$num_chats" ]]; then
        echo -e "${BLUE}Processing only the ${num_chats} most recent chat(s)${NC}"
        chat_files=("${chat_files[@]:0:$num_chats}")
    fi
    
    echo ""
    
    # Build list of chats to process (after filtering)
    local chats_to_process=()
    for chat_file in "${chat_files[@]}"; do
        local chat_id
        chat_id="$(basename "$chat_file" .json)"
        local file_timestamp
        file_timestamp=$(get_file_timestamp "$chat_file")
        local chat_dirname="chat-${file_timestamp}-${chat_id}"
        local chat_dir="$WORKSPACE_OUTPUT_DIR/chats/$chat_dirname"
        local summary_file="$chat_dir/detailed.md"
        
        # Skip if session ID specified and this chat doesn't match
        if [[ -n "$session_id" && "$chat_id" != "$session_id" ]]; then
            continue
        fi
        
        # Skip chats with empty requests array (IDE noise)
        local request_count
        request_count=$(jq '.requests | length' "$chat_file" 2>/dev/null || echo "0")
        if [[ "$request_count" -eq 0 ]]; then
            echo -e "${YELLOW}Skipping (empty chat): $chat_id${NC}"
            continue
        fi
        
        # Skip if already processed and newer (unless force reprocessing)
        if [[ "$force_reprocess" != "true" && -f "$summary_file" && "$summary_file" -nt "$chat_file" ]]; then
            echo -e "${YELLOW}Skipping (already processed): $chat_id${NC}"
            continue
        fi
        
        chats_to_process+=("$chat_file")
    done
    
    # Process chats using xargs (with parallel support if available)
    local processed_count=${#chats_to_process[@]}
    if [[ $processed_count -gt 0 ]]; then
        # Create wrapper function for xargs
        process_chat_wrapper() {
            # Source common-lib to ensure functions are available in subshell
            # shellcheck source=SCRIPTDIR/../common-lib.sh
            source "${SCRIPTS_DIR}/common-lib.sh"
            
            local chat_file="$1"
            local chat_id
            chat_id="$(basename "$chat_file" .json)"
            
            # Get file modification time for chronological sorting
            local file_timestamp
            file_timestamp=$(get_file_timestamp "$chat_file")
            
            # Create directory name with timestamp
            local chat_dirname="chat-${file_timestamp}-${chat_id}"
            local chat_dir="$WORKSPACE_OUTPUT_DIR/chats/$chat_dirname"
            
            # Create chat directory
            mkdir -p "$chat_dir"
            
            process_copilot_json "$chat_file" "$chat_dir"
        }
        export -f process_copilot_json process_chat_wrapper get_file_timestamp
        export WORKSPACE_OUTPUT_DIR JQ_PREPROCESS_SCRIPT JQ_DETAILED_SCRIPT JQ_ABBREVIATED_SCRIPT BLUE GREEN YELLOW RED NC XARGS_PARALLEL_SUPPORTED DEBUG_MODE SCRIPTS_DIR JQ_INCLUDE_DIR

        # Build xargs command with conditional parallel flag
        local xargs_cmd="xargs"
        if [[ "$XARGS_PARALLEL_SUPPORTED" == "true" && $processed_count -gt 1 ]]; then
            xargs_cmd="xargs -P 4"
            echo -e "${BLUE}Processing $processed_count chats in parallel...${NC}"
        else
            echo -e "${BLUE}Processing $processed_count chats sequentially...${NC}"
        fi
        
        printf '%s\n' "${chats_to_process[@]}" | $xargs_cmd -I {} bash -c 'process_chat_wrapper "$@"' _ {}
        echo -e "${GREEN}✓ Completed processing all $processed_count chat(s)${NC}"
    fi
    
    # Check if session ID was specified but no matching chat was found
    if [[ -n "$session_id" && $processed_count -eq 0 ]]; then
        echo -e "${RED}Error: No chat found with session ID '$session_id'${NC}"
        echo -e "${YELLOW}Available chat sessions:${NC}"
        for chat_file in "${chat_files[@]:0:5}"; do
            local available_id
            available_id="$(basename "$chat_file" .json)"
            echo "  - $available_id"
        done
        exit 1
    fi
    
    # If no chats were processed (all were empty), clean up the workspace directory
    if [[ $processed_count -eq 0 && ${#chat_files[@]} -gt 0 ]]; then
        echo -e "${YELLOW}All chats were empty (filtered out), cleaning up workspace directory${NC}"
        rm -rf "$WORKSPACE_OUTPUT_DIR"
        exit 0
    fi
    
    # Create workspace summary
    {
        echo "# GitHub Copilot Chat Collection Summary"
        echo ""
        echo "**Generated:** $(date)"
        echo "**Workspace Hash:** $workspace_hash"
        echo "**Workspace Path:** $workspace_path"
        echo "**Total Chats Found:** ${#chat_files[@]}"
        echo "**Chats Processed:** $processed_count"
        echo "**Source Directory:** [$(echo "$chat_sessions_dir" | sed "s|$HOME|~|")](file://$(echo "$chat_sessions_dir" | sed 's/ /%20/g'))"
        echo ""
        echo "## Processed Files"
        echo ""
        for chat_file in "${chat_files[@]}"; do
            local chat_id
            chat_id="$(basename "$chat_file" .json)"
            local file_timestamp
            file_timestamp=$(get_file_timestamp "$chat_file")
            local chat_dirname="chat-${file_timestamp}-${chat_id}"
            
            # Extract basic metadata from JSON
            local message_count="unknown"
            message_count=$(jq '.requests | length' "$chat_file" 2>/dev/null || echo "0")
            
            echo "- [$chat_dirname/](chats/$chat_dirname/) - $message_count requests"
            echo "  - [detailed.md](chats/$chat_dirname/detailed.md)"
            echo "  - [abbreviated.md](chats/$chat_dirname/abbreviated.md)"
        done
    } > "$WORKSPACE_OUTPUT_DIR/workspace-summary.md"
    
    echo ""
    echo -e "${GREEN}✓ Completed Collecting ${VIOLET}${escaped_workspace_path}${GREEN}!${NC}"
    echo -e "${GREEN}    ✓ Summary: ${VIOLET}$WORKSPACE_OUTPUT_DIR/workspace-summary.md${NC}"
    echo -e "${GREEN}    ✓ Processed chats: ${VIOLET}$WORKSPACE_OUTPUT_DIR/chats/${NC}"
    echo ""
}

# Parse arguments and run main
parse_args "$@"
main