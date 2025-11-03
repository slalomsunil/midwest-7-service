#!/bin/bash

set -e

# Claude Code Project Chat Processor
# Processes Claude Code chat sessions from a specified project directory
#
# For detailed documentation, see: [README.md](./README.md)
#
# FUNCTIONALITY:
# - Processes .jsonl chat files from specified Claude project directory into structured markdown output
# - Creates individual chat folders with detailed.md and tool_results/ subdirectory
# - Skips already processed files unless they're newer than output
# - Generates consolidated summary report
# - Supports parallel processing and filtering by recent chats or session ID
#
# OUTPUT STRUCTURE:
# build/claude-chats/
# ├── project-summary.md
# └── chats/
#     ├── chat-{timestamp}-{id}/
#     │   ├── detailed.md
#     │   ├── abbreviated.md
#     │   └── tool_results/
#     │       ├── {timestamp}-{tool_name}-{uuid}.md
#     │       └── ...
#     └── chat-{timestamp}-{other-id}/
#         ├── detailed.md
#         ├── abbreviated.md
#         └── tool_results/

# Show usage information
show_usage() {
    echo "Usage: $0 -p PROJECT_PATH [-n NUM] [-s SESSION_ID] [-f]"
    echo ""
    echo "Processes Claude Code chat sessions from a specified project directory."
    echo ""
    echo "Options:"
    echo "  -p, --project PATH    Required: Claude project directory path"
    echo "  -n, --number NUM      Process only the NUM most recent chats"
    echo "  -s, --session-id ID   Process only the chat with the specified session ID"
    echo "  -f, --force           Force reprocessing of all files (ignores skip logic)"
    echo "  --debug               Keep intermediate files for debugging"
    echo "  -h, --help            Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 -p \"-Users-allenh-projects-ai-accelerator-ae-delivery-accelerator\"                    Process specified project"
    echo "  $0 -p \"-Users-allenh-projects-ai-accelerator-ae-delivery-accelerator\" -n 5               Process 5 most recent chats from project"
    echo "  $0 -p \"-Users-allenh-projects-ai-accelerator-ae-delivery-accelerator\" -n 5"
    echo "  $0 -p \"-Users-allenh-projects-ai-accelerator-ae-delivery-accelerator\" -s abc123 -f"
    echo ""
    echo "Requirements:"
    echo "  - jq (brew install jq)"
    echo "  - Valid Claude project directory path"
}

# Script directory and build output path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$(dirname "$SCRIPT_DIR")"
MODULE_DIR="$(dirname "$SCRIPTS_DIR")"
BUILD_DIR="$MODULE_DIR/build"
BASE_OUTPUT_DIR="$BUILD_DIR/claude-chats"
JQ_INCLUDE_DIR="$SCRIPT_DIR"

# Source common library functions
# shellcheck source=SCRIPTDIR/../common-lib.sh
source "${SCRIPTS_DIR}/common-lib.sh"
source "${SCRIPT_DIR}/project-discovery.sh"

# Global configuration
TOOL_RESULT_TRUNCATION_LENGTH=500

# Path to jq script files (in same directory as this script)
JQ_PREPROCESS_SCRIPT="$SCRIPT_DIR/jq-filters/preprocess-jsonl.jq"
JQ_EXTRACT_SCRIPT="$SCRIPT_DIR/jq-filters/extract-tool-results.jq"
JQ_DETAILED_SCRIPT="$SCRIPT_DIR/jq-filters/generate-detailed.jq"
JQ_ABBREVIATED_SCRIPT="$SCRIPT_DIR/jq-filters/generate-abbreviated.jq"

# Global variables populated by parse_args
PROJECT_PATH=""
NUM_CHATS=""
SESSION_ID=""
FORCE_REPROCESS="false"
DEBUG_MODE="false"

# Extract useful information from Claude Code JSONL
process_claude_jsonl() {
    local chat_file="$1"
    local chat_dir="$2"
    local chat_id
    chat_id="$(basename "$chat_file" .jsonl)"
    
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
    
    # Create buffer file for output when running in parallel
    local output_buffer="$chat_dir/processing.log"
    
    # Function to output message (buffered or direct)
    output_msg() {
        if [[ "$XARGS_PARALLEL_SUPPORTED" == "true" ]]; then
            echo -e "$1" >> "$output_buffer"
        else
            echo -e "$1"
        fi
    }
    
    output_msg "${BLUE}Processing chat: ${chat_id}${NC}"
    
    # Step 1: Preprocess JSONL into optimized structure
    local chat_start_time=$(date +%s.%N)
    local step_start_time=$(date +%s.%N)

    output_msg "${BLUE}  ├── Preprocessing JSONL...${NC}"
    local preprocessed_file="$chat_dir/preprocessed.json"
    if ! jq -L "$JQ_INCLUDE_DIR" -s -f "$JQ_PREPROCESS_SCRIPT" "$chat_file" > "$preprocessed_file"; then
        output_msg "${RED}    ✗ Failed to preprocess JSONL${NC}"
        # If we buffered output, display it now before returning
        cleanup_and_output_buffer
        return 1
    fi
    local preprocess_time=$(echo "$(date +%s.%N) - $step_start_time" | bc -l)
    output_msg "${GREEN}    ✓ Preprocessing: ${preprocess_time}s${NC}"
    
    # Step 2: Generate summary with truncation tracking
    output_msg "${BLUE}  ├── Generating summary with truncation tracking...${NC}"
    step_start_time=$(date +%s.%N)
    local summary_data
    summary_data=$(jq -L "$JQ_INCLUDE_DIR" --arg truncation_length "$TOOL_RESULT_TRUNCATION_LENGTH" --slurpfile project_metadata "$PROJECT_METADATA_FILE" -f "$JQ_DETAILED_SCRIPT" "$preprocessed_file")
    local generate_detailed_time=$(echo "$(date +%s.%N) - $step_start_time" | bc -l)
    
    # Step 3: Extract summary content and truncated tool results
    local summary_content truncated_tool_results
    summary_content=$(echo "$summary_data" | jq -r '.summary')
    truncated_tool_results=$(echo "$summary_data" | jq '.truncated_tool_results')
    
    # Step 4: Create detailed.md
    output_msg "${BLUE}  ├── Writing detailed.md...${NC}"
    step_start_time=$(date +%s.%N)
    # URL encode the path before building content
    local encoded_path=$(urlencode "$chat_file")
    
    # Build detailed.md content in memory first
    local detailed_md_content
    detailed_md_content="# Claude Code Chat: $chat_id\n\n"
    detailed_md_content+="**Generated:** $(date)\n"
    detailed_md_content+="**Source:** [$chat_file](file://$encoded_path)\n\n"
    
    # Chat metadata from preprocessed data
    detailed_md_content+="## Chat Metadata\n\n"
    
    local session_id first_timestamp last_timestamp message_count
    session_id=$(jq -r '.metadata.sessionId // error("session ID null")' "$preprocessed_file") || { cleanup_and_output_buffer; return 1; }
    first_timestamp=$(jq -r '.metadata.firstTimestamp // "Unknown"' "$preprocessed_file") || { cleanup_and_output_buffer; return 1; }
    last_timestamp=$(jq -r '.metadata.lastTimestamp // "Unknown"' "$preprocessed_file") || { cleanup_and_output_buffer; return 1; }
    message_count=$(jq -r '.metadata.totalMessages // error("session ID null")' "$preprocessed_file") || { cleanup_and_output_buffer; return 1; }
    
    detailed_md_content+="- **Session ID:** $session_id\n"
    detailed_md_content+="- **Started:** $first_timestamp\n"
    detailed_md_content+="- **Last Message:** $last_timestamp\n"
    detailed_md_content+="- **Message Count:** $message_count\n\n"
    
    # Tool usage statistics
    local tool_usage
    tool_usage=$(jq -r '.metadata.toolUsageCount | to_entries | map("- **" + .key + ":** " + (.value | tostring)) | join("\n")' "$preprocessed_file") || { cleanup_and_output_buffer; return 1; }
    if [[ -n "$tool_usage" && "$tool_usage" != "null" ]]; then
        detailed_md_content+="## Tool Usage\n\n"
        detailed_md_content+="$tool_usage\n\n"
    fi
    
    # AI-Generated Summaries
    local summaries_count
    summaries_count=$(jq '.summaries | length' "$preprocessed_file") || { cleanup_and_output_buffer; return 1; }
    if [[ "$summaries_count" -gt 0 ]]; then
        detailed_md_content+="## AI-Generated Summaries\n\n"
        local summaries_content
        summaries_content=$(jq -r '.summaries | to_entries | map("- " + .value) | join("\n")' "$preprocessed_file") || { cleanup_and_output_buffer; return 1; }
        detailed_md_content+="$summaries_content\n\n"
    fi
    
    # Extract conversation flow
    detailed_md_content+="## Conversation Flow\n\n"
    detailed_md_content+="$summary_content\n"
    
    # Only write file if all content generation succeeded
    printf "%b" "$detailed_md_content" > "$chat_dir/detailed.md"
    local detailed_file_write_time=$(echo "$(date +%s.%N) - $step_start_time" | bc -l)
    
    # Step 5: Create streamlined conversation log
    output_msg "${BLUE}  ├── Writing abbreviated.md...${NC}"
    step_start_time=$(date +%s.%N)
    jq -L "$JQ_INCLUDE_DIR" -r -f "$JQ_ABBREVIATED_SCRIPT" "$preprocessed_file" > "$chat_dir/abbreviated.md"
    local generate_abbreviated_time=$(echo "$(date +%s.%N) - $step_start_time" | bc -l)
    
    # Step 6: Create tool result files only for truncated results
    output_msg "${BLUE}  ├── Creating tool result files for truncated content...${NC}"
    step_start_time=$(date +%s.%N)
    local tool_count=0
    local truncated_count
    truncated_count=$(echo "$truncated_tool_results" | jq '. | length')
    
    if [[ "$truncated_count" -gt 0 ]]; then
        # Extract tool results for truncated items only
        local tool_results
        tool_results=$(echo "$truncated_tool_results" | jq -c -f "$JQ_EXTRACT_SCRIPT")
        
        if [[ -n "$tool_results" ]]; then
            # Use jq to write files directly, avoiding bash loops and subshells
            echo "$tool_results" | jq -r '"echo " + (.content | @sh) + " > " + ("'"$chat_dir/tool_results/"'" + .filename | @sh)' | bash
            tool_count=$(echo "$tool_results" | wc -l)
        fi
    fi
    local write_time=$(echo "$(date +%s.%N) - $step_start_time" | bc -l)
    local total_chat_time=$(echo "$(date +%s.%N) - $chat_start_time" | bc -l)
    
    # Save metadata for project summary before cleanup
    jq -n --argjson metadata "$(jq '.metadata' "$preprocessed_file")" '$metadata' > "$chat_dir/.metadata.json"
    
    # Clean up preprocessed file (unless in debug mode)
    [[ "$DEBUG_MODE" != "true" ]] && rm -f "$preprocessed_file"

    output_msg "${GREEN}    ✓ Total: ${total_chat_time}s Generate Detailed: ${generate_detailed_time}s, Write Detailed: ${detailed_file_write_time}s, Abbreviated: ${generate_abbreviated_time}s, Tool files: ${write_time}s, Files: $tool_count${NC}"
    
    output_msg "${GREEN}✓ Processed: ${VIOLET}chat-$chat_id/${NC}"
    
    # If we buffered output, display it now atomically
    cleanup_and_output_buffer
}

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -p|--project)
                PROJECT_PATH="$2"
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
    
    # Project path is required
    if [[ -z "$PROJECT_PATH" ]]; then
        echo -e "${RED}Error: Project path is required. Use -p/--project option.${NC}"
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
    
    echo -e "${BLUE}Claude Code Chat Collector${NC}"
    echo "=============================="
    
    # Only check dependencies if not already set (avoids redundant checks in parallel processing)
    check_dependencies

    # Create base output directory
    mkdir -p "$BASE_OUTPUT_DIR"
    
    # Handle force reprocessing (after project directory is determined)
    # Note: This section will be moved after PROJECT_OUTPUT_DIR is set
    
    # Use provided project directory (required)
    echo -e "${BLUE}Processing project: ${VIOLET}$PROJECT_PATH${NC}"
    local project_dir
    project_dir=$(validate_project_dir "$PROJECT_PATH")
    local project_name="$PROJECT_PATH"
    
    # Set project-specific output directory
    local PROJECT_OUTPUT_DIR="$BASE_OUTPUT_DIR/$project_name"
    
    # Handle force reprocessing now that we have PROJECT_OUTPUT_DIR
    if [[ "$force_reprocess" == "true" ]]; then
        if [[ -n "$session_id" ]]; then
            echo -e "${YELLOW}Force reprocessing enabled - cleaning chats for session: $session_id${NC}"
            rm -rf "$PROJECT_OUTPUT_DIR/chats/chat-"*"-$session_id"
        else
            echo -e "${YELLOW}Force reprocessing enabled - cleaning all chats for project${NC}"
            rm -rf "$PROJECT_OUTPUT_DIR/chats"
        fi
    fi
    
    # Create project-specific directory structure
    mkdir -p "$PROJECT_OUTPUT_DIR/chats"
    
    echo ""
    echo -e "${BLUE}Looking for chats in: ${VIOLET}$project_dir${NC}"

    # Gather project-wide metadata first (includes session discovery and tree)
    echo ""
    echo -e "${BLUE}Gathering project-wide metadata...${NC}"
    
    # Gather comprehensive project metadata (summaries, session tree, and cross-references)
    local project_metadata_file="$PROJECT_OUTPUT_DIR/.project-metadata.json"
    if ! "$SCRIPT_DIR/gather-project-metadata.sh" "$project_name" "$project_metadata_file"; then
        echo -e "${RED}Error: Failed to gather project metadata${NC}"
        exit 1
    fi
    
    # Determine which session files to process
    # Two modes:
    # 1. Explicit session ID (-s option): Process specific session even if not a leaf
    # 2. Normal mode: Process only leaf sessions to avoid duplicates
    echo ""

    local chat_files=()

    if [[ -n "$session_id" ]]; then
        # Mode 1: Explicit session ID request
        # This allows processing of any session, including non-leaf sessions that were
        # continued or branched elsewhere. Useful for debugging or examining partial sessions.
        echo "Validating explicitly requested session: $session_id"
        local requested_session_file="$project_dir/$session_id.jsonl"

        if [[ -f "$requested_session_file" ]]; then
            echo -e "${GREEN}Found requested session file: ${session_id}${NC}"
            chat_files=("$requested_session_file")
        else
            # Session file not found - provide helpful error with available options
            echo -e "${RED}Error: Session file not found: $session_id.jsonl${NC}"
            echo -e "${YELLOW}Available session files:${NC}"

            # Show first 10 available sessions to help user identify correct ID
            local available_count=0
            for file in "$project_dir"/*.jsonl; do
                [[ -f "$file" ]] || continue
                echo "  - $(basename "$file" .jsonl)"
                ((++available_count >= 10)) && echo "...truncated to 10..." && break
            done

            if [[ $available_count -eq 0 ]]; then
                echo "  (No session files found in project)"
            fi
            exit 1
        fi
    else
        # Mode 2: Normal flow - process only leaf sessions
        # Leaf sessions are complete chats that haven't been continued elsewhere.
        # Processing only leaves avoids duplicate content from resumed/branched sessions.
        echo "Finding complete chats from session tree..."

        # Get leaf session IDs from the metadata
        # The session tree tracks parent-child relationships between sessions
        local leaf_sessions
        leaf_sessions=($(cat "$project_metadata_file" | jq -rf "${SCRIPT_DIR}/jq-filters/extract-leaf-sessions.jq"))

        # Build file paths for each leaf session
        local unsorted_chat_files=()
        for leaf_id in "${leaf_sessions[@]}"; do
            local file_path="$project_dir/$leaf_id.jsonl"
            if [[ -f "$file_path" ]]; then
                unsorted_chat_files+=("$file_path")
            fi
        done

        # Sort by modification time (newest first) for handling -n option
        if [[ ${#unsorted_chat_files[@]} -gt 0 ]]; then
            while IFS= read -r file; do
                chat_files+=("$file")
            done < <(ls -t "${unsorted_chat_files[@]}")
        fi

        # Note: "complete chat" means a leaf session (not continued elsewhere)
        echo -e "${GREEN}Found ${#chat_files[@]} complete chat(s)${NC}"
    fi
    
    # Export for subprocess access during parallel processing
    export PROJECT_METADATA_FILE="$project_metadata_file"
    
    local summary_count
    summary_count=$(jq -r '.summary_count' "$project_metadata_file")
    echo -e "${GREEN}✓ Project metadata gathered: $summary_count summaries found${NC}"
    
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
        chat_id="$(basename "$chat_file" .jsonl)"
        local file_timestamp
        file_timestamp=$(get_file_timestamp "$chat_file")
        local chat_dirname="chat-${file_timestamp}-${chat_id}"
        local chat_dir="$PROJECT_OUTPUT_DIR/chats/$chat_dirname"
        local summary_file="$chat_dir/detailed.md"
        
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
            chat_id="$(basename "$chat_file" .jsonl)"
            
            # Get file modification time for chronological sorting
            local file_timestamp
            file_timestamp=$(get_file_timestamp "$chat_file")
            
            # Create directory name with timestamp
            local chat_dirname="chat-${file_timestamp}-${chat_id}"
            local chat_dir="$PROJECT_OUTPUT_DIR/chats/$chat_dirname"
            
            # Create chat directory and tool_results subdirectory
            mkdir -p "$chat_dir/tool_results"
            
            process_claude_jsonl "$chat_file" "$chat_dir"
        }
        export -f process_claude_jsonl process_chat_wrapper get_file_timestamp
        export PROJECT_OUTPUT_DIR PROJECT_METADATA_FILE JQ_PREPROCESS_SCRIPT JQ_EXTRACT_SCRIPT JQ_DETAILED_SCRIPT JQ_ABBREVIATED_SCRIPT \
            TOOL_RESULT_TRUNCATION_LENGTH BLUE GREEN YELLOW RED NC XARGS_PARALLEL_SUPPORTED DEBUG_MODE SCRIPTS_DIR JQ_INCLUDE_DIR
        
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

    # Create summary
    local project_name
    project_name="$(basename "$project_dir")"
    {
        echo "# Claude Code Chat Collection Summary"
        echo ""
        echo "**Generated:** $(date)"
        echo "**Project:** $project_name"
        echo "**Total Chats Found:** ${#chat_files[@]}"
        echo "**Chats Processed:** $processed_count"
        echo ""
        echo "## Processed Files"
        echo ""
        for chat_file in "${chat_files[@]}"; do
            local chat_id
            chat_id="$(basename "$chat_file" .jsonl)"
            local file_timestamp
            file_timestamp=$(get_file_timestamp "$chat_file")
            local chat_dirname="chat-${file_timestamp}-${chat_id}"
            local chat_dir="$PROJECT_OUTPUT_DIR/chats/$chat_dirname"
            local tool_result_count=$(find "$chat_dir/tool_results" -name "*.md" | wc -l)
            
            # Extract metadata from saved metadata file
            local message_count="unknown"
            local tool_use_count="unknown"
            local metadata_file="$chat_dir/.metadata.json"
            
            if [[ -f "$metadata_file" ]]; then
                message_count=$(jq -r '.totalMessages // "unknown"' "$metadata_file")
                tool_use_count=$(jq -r '.toolUsageCount | to_entries | map(.value) | add // 0' "$metadata_file")
            fi

            first_user_message=$(jq --arg default "$chat_dirname" -sr -f "${SCRIPT_DIR}/jq-filters/first-user-message.jq" "$chat_file")
            local encoded_path=$(urlencode "$chat_file")
            echo "- [$first_user_message](chats/$chat_dirname/) - $message_count messages, $tool_use_count tool uses"
            echo "  - [${chat_id}](file://$encoded_path)"
            echo "  - [detailed.md](chats/$chat_dirname/detailed.md)"
            echo "  - [abbreviated.md](chats/$chat_dirname/abbreviated.md)"
            echo "  - [tool_results/](chats/$chat_dirname/tool_results/) ($tool_result_count files)"
        done
    } > "$PROJECT_OUTPUT_DIR/project-summary.md"
    
    echo ""
    echo -e "${GREEN}✓ Completed Collecting ${VIOLET}$PROJECT_PATH${GREEN}!${NC}"
    echo -e "    ${GREEN}✓ Summary: ${VIOLET}$PROJECT_OUTPUT_DIR/project-summary.md${NC}"
    echo -e "    ${GREEN}✓ Processed chats: ${VIOLET}$PROJECT_OUTPUT_DIR/chats/${NC}"
}

# Parse arguments and run main
parse_args "$@"
main