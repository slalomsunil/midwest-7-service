#!/bin/bash

set -e

# Claude Code Chat Collection Orchestrator
# Orchestrates the collection of Claude Code chat sessions across projects
#
# For detailed documentation, see: [claude-support/README.md](claude-support/README.md)
#
# FUNCTIONALITY:
# - Auto-detects current workspace and processes it (preserves existing UX)
# - --all-projects mode discovers and processes all Claude projects
# - Delegates actual processing to gather-claude-project.sh
# - Generates consolidated summaries across projects
#
# OUTPUT STRUCTURE:
# build/claude-chats/
# ├── all-projects-summary.md (when using --all-projects)
# └── {project-name}/
#     ├── project-summary.md
#     └── processed-chats/
#         └── chat-{id}/

# Show usage information
show_usage() {
    echo "Usage: $0 [ACTION] [OPTIONS]"
    echo ""
    echo "Orchestrates Claude Code chat collection across projects."
    echo ""
    echo "Actions:"
    echo "  list                  List all available Claude projects"
    echo "  collect               Collect and process chat data (default)"
    echo ""
    echo "Options (for collect action):"
    echo "  --all-projects        Process all Claude projects"
    echo "  -p, --project PATH    Process specific Claude project"
    echo "  -n, --number NUM      Process only the NUM most recent chats from each project"
    echo "  -s, --session-id ID   Process only the chat with the specified session ID"
    echo "  -f, --force           Force reprocessing of all files"
    echo "  --debug               Keep intermediate files for debugging"
    echo "  -h, --help            Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 list               List available Claude projects"
    echo "  $0                    Process current workspace (auto-detect)"
    echo "  $0 collect -p \"-Users-allenh-projects-my-app\"    Process specific project"
    echo "  $0 collect --all-projects     Process all Claude projects"
    echo "  $0 collect --all-projects -n 5    Process 5 most recent chats from each project"
    echo "  $0 collect -s abc123          Search for session ID across current workspace"
    echo ""
    echo "Requirements:"
    echo "  - jq (brew install jq)"
    echo "  - claude-support/gather-project.sh script"
}

# Script directory and build output path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULE_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$MODULE_DIR/build"
OUTPUT_DIR="$BUILD_DIR/claude-chats"

# Source common library functions
source "$SCRIPT_DIR/common-lib.sh"

# Source project discovery functions
source "$SCRIPT_DIR/claude-support/project-discovery.sh"

# Global variables populated by parse_args
ACTION="collect"  # Default action
ALL_PROJECTS="false"
PROJECT_PATH=""
NUM_CHATS=""
SESSION_ID=""
FORCE_REPROCESS="false"
DEBUG_MODE="false"


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
                --all-projects)
                    ALL_PROJECTS="true"
                    shift
                    ;;
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
    fi
    
    # Check for mutually exclusive options
    if [[ -n "$NUM_CHATS" && -n "$SESSION_ID" ]]; then
        echo -e "${RED}Error: -n/--number and -s/--session-id options are mutually exclusive${NC}"
        show_usage
        exit 1
    fi
    
    if [[ "$ALL_PROJECTS" == "true" && -n "$PROJECT_PATH" ]]; then
        echo -e "${RED}Error: --all-projects and -p/--project options are mutually exclusive${NC}"
        show_usage
        exit 1
    fi
}



# Build arguments for gather-claude-project.sh
build_project_args() {
    local args=""
    
    if [[ -n "$NUM_CHATS" ]]; then
        args="$args -n $NUM_CHATS"
    fi
    
    if [[ -n "$SESSION_ID" ]]; then
        args="$args -s $SESSION_ID"
    fi
    
    if [[ "$FORCE_REPROCESS" == "true" ]]; then
        args="$args -f"
    fi
    
    if [[ "$DEBUG_MODE" == "true" ]]; then
        args="$args --debug"
    fi
    
    echo "$args"
}

# Generate consolidated summary
generate_consolidated_summary() {
    local summary_file="$OUTPUT_DIR/all-projects-summary.md"
    
    {
        echo "# Claude Code Chat Collection - All Projects Summary"
        echo ""
        echo "**Generated:** $(date)"
        echo "**Total Projects Processed:** $1"
        echo ""
        echo "## Project Summaries"
        echo ""
        
        # List each project's summary
        for project_dir in "$OUTPUT_DIR"/*; do
            if [[ -d "$project_dir" && -f "$project_dir/project-summary.md" ]]; then
                local project_name=$(basename "$project_dir")
                local chat_count=$(grep "Total Chats Found:" "$project_dir/project-summary.md" | awk '{print $NF}' || echo "0")
                local processed_count=$(grep "Chats Processed:" "$project_dir/project-summary.md" | awk '{print $NF}' || echo "0")
                
                echo "### $project_name"
                echo "- **Total Chats:** $chat_count"
                echo "- **Processed:** $processed_count"
                echo "- **Details:** [project-summary.md]($project_name/project-summary.md)"
                echo ""
            fi
        done
    } > "$summary_file"

    echo -e "${GREEN}✓ Consolidated summary: ${VIOLET}$summary_file${NC}"
}

# Main execution
main() {
    # Handle list action
    if [[ "$ACTION" == "list" ]]; then
        print_available_projects
        return 0
    fi
    
    # Handle collect action
    echo -e "${BLUE}Claude Code Chat Collection Orchestrator${NC}"
    echo "=========================================="
    
    # Check dependencies (includes parallel processing support check)
    check_dependencies
    
    local project_script="$SCRIPT_DIR/claude-support/gather-project.sh"
    
    # Check if the project script exists
    if [[ ! -f "$project_script" ]]; then
        echo -e "${RED}Error: gather-project.sh not found at: $project_script${NC}"
        exit 1
    fi
    
    local project_args
    project_args=$(build_project_args)
    
    if [[ "$ALL_PROJECTS" == "true" ]]; then
        # Clean entire claude-chats directory when using --all-projects with -f
        if [[ "$FORCE_REPROCESS" == "true" ]]; then
            echo -e "${YELLOW}Force reprocessing enabled - cleaning entire claude-chats directory${NC}"
            rm -rf "$OUTPUT_DIR"
            mkdir -p "$OUTPUT_DIR"
        fi
        
        echo -e "${BLUE}Processing all Claude projects...${NC}"
        echo ""
        
        local projects
        projects=$(get_available_project_dirs)
        local project_count=0
        
        if [[ -z "$projects" ]]; then
            echo -e "${YELLOW}No Claude projects found${NC}"
            exit 0
        fi
        
        # Build array of project names
        local project_names=()
        while IFS= read -r project_path; do
            if [[ -n "$project_path" ]]; then
                local project_name=$(basename "$project_path")
                project_names+=("$project_name")
            fi
        done <<< "$projects"
        
        local project_count=${#project_names[@]}
        
        # Process projects using xargs (with parallel support if available)
        if [[ $project_count -gt 0 ]]; then
            # Create wrapper function for xargs
            process_project_wrapper() {
                local project_name="$1"
                local project_args="$2"
                local project_script="$3"
                
                echo -e "${BLUE}Processing project: $project_name${NC}"
                
                # Call gather-claude-project.sh with -p flag
                if ! "$project_script" -p "$project_name" $project_args; then
                    echo -e "${RED}✗ Failed: $project_name${NC}"
                fi
                echo ""
            }
            export -f process_project_wrapper
            export BLUE GREEN RED NC
            
            # Build xargs command with conditional parallel flag
            local xargs_cmd="xargs"
            if [[ "$XARGS_PARALLEL_SUPPORTED" == "true" && $project_count -gt 1 ]]; then
                xargs_cmd="xargs -P 3"  # Use up to 3 parallel processes for projects
                echo -e "${BLUE}Processing $project_count projects in parallel...${NC}"
            else
                echo -e "${BLUE}Processing $project_count projects sequentially...${NC}"
            fi
            echo ""
            
            printf '%s\n' "${project_names[@]}" | $xargs_cmd -I {} bash -c 'process_project_wrapper "$@"' _ {} "$project_args" "$project_script"
        fi
        
        # Generate consolidated summary
        generate_consolidated_summary "$project_count"
        
    else
        # Determine project path (provided or auto-detect)
        local target_project_path="$PROJECT_PATH"
        
        if [[ -z "$target_project_path" ]]; then
            echo -e "${BLUE}Auto detecting project...${NC}"
            local detected_project_dir
            detected_project_dir=$(find_claude_project_dir)
            target_project_path="$(basename "$detected_project_dir")"
            echo ""
        fi
        
        echo -e "${BLUE}Processing project: ${VIOLET}$target_project_path${NC}"
        echo ""
        
        # Call gather-claude-project.sh with project path
        if ! "$project_script" -p "$target_project_path" $project_args; then
            echo -e "${RED}✗ Processing failed${NC}"
            exit 1
        fi
    fi
}

# Parse arguments and run main
parse_args "$@"
main