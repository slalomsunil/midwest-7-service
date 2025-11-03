#!/bin/bash

# Common library functions for interaction-analyzer scripts

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
VIOLET='\033[0;35m'
NC='\033[0m' # No Color

# Check for required tools and optional features
check_dependencies() {
    # if XARGS_PARALLEL_SUPPORTED is not empty string, return early
    if [[ -n "$XARGS_PARALLEL_SUPPORTED" ]]; then
        return
    fi

    echo -e "${BLUE}Checking dependencies...${NC}"
    
    if ! command -v jq &> /dev/null; then
        echo -e "${RED}Error: jq is required but not installed${NC}"
        echo "Install with: brew install jq"
        exit 1
    fi
    
    echo -e "${GREEN}✓ jq found${NC}"
    
    # Test for ripgrep (rg) - much faster than grep for pattern searches
    if command -v rg &> /dev/null; then
        RIPGREP_AVAILABLE="true"
        echo -e "${GREEN}✓ ripgrep (rg) found - using fast search${NC}"
    else
        RIPGREP_AVAILABLE="false"
        echo -e "${YELLOW}! ripgrep not found - using standard grep${NC}"
    fi

    # Test for xargs -P support (parallel processing)
    if echo "test" | xargs -P 1 echo &> /dev/null; then
        XARGS_PARALLEL_SUPPORTED="true"
        echo -e "${GREEN}✓ xargs parallel processing available${NC}"
    else
        XARGS_PARALLEL_SUPPORTED="false"
        echo -e "${YELLOW}! xargs parallel processing not available (will process sequentially)${NC}"
    fi

    echo ""

    export XARGS_PARALLEL_SUPPORTED RIPGREP_AVAILABLE
}

# Get file creation timestamp in ISO8601 format
get_file_timestamp() {
    local file="$1"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS uses -f flag for format, %SB for birth time (creation)
        stat -f "%SB" -t "%Y-%m-%dT%H:%M:%SZ" "$file"
    else
        # Linux uses --format flag, %W for birth time (if supported, otherwise fallback to mtime)
        local birth_time=$(stat --format="%W" "$file")
        if [[ "$birth_time" != "0" && -n "$birth_time" ]]; then
            date -d "@$birth_time" -Iseconds | sed 's/+00:00/Z/'
        else
            # Fallback to modification time if birth time not available
            stat --format="%y" "$file" | cut -d' ' -f1,2 | sed 's/ /T/' | sed 's/$/Z/'
        fi
    fi
}

# URL decode function (POSIX-compliant)
# Decodes URL-encoded strings (e.g., %20 -> space, %2F -> /)
url_decode() {
    local encoded_string="$1"
    # Replace '+' with spaces first
    local temp_string="${encoded_string//+/ }"
    # Replace percent-encoded characters (%XX) with their corresponding ASCII characters
    printf '%b\n' "${temp_string//%/\\x}"
}

# URL encode function (POSIX-compliant)
# Properly encodes strings for use in URLs
urlencode() {
    # urlencode <string>
    local string="$1"
    local length="${#string}"
    local i=0
    while [ $i -lt $length ]; do
        local c="${string:$i:1}"
        case $c in
            [a-zA-Z0-9.~_/-]) printf "%s" "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
        i=$((i + 1))
    done
}

# Extract workspace path from VS Code workspace.json
# Takes a workspace.json path and returns the decoded workspace path
get_workspace_path_from_json() {
    local workspace_json="$1"
    
    if [[ ! -f "$workspace_json" ]]; then
        echo "Unknown"
        return 1
    fi
    
    local workspace_paths
    workspace_paths=$(jq -r '.folder // .workspace.folders[]?.uri // empty' "$workspace_json" 2>/dev/null)
    
    if [[ -n "$workspace_paths" ]]; then
        # Take the first path and decode it
        local first_path
        first_path=$(echo "$workspace_paths" | head -1)
        if [[ -n "$first_path" ]]; then
            local workspace_path
            workspace_path=$(echo "$first_path" | sed 's|^file://||')
            workspace_path=$(url_decode "$workspace_path")
            echo "$workspace_path"
            return 0
        fi
    fi
    
    echo "Unknown"
    return 1
}

# Escape path using Claude's escaping scheme
# Converts absolute paths to Claude Code's escaped format
# Example: /Users/allenh/projects/my-app → -Users-allenh-projects-my-app
escape_path_using_claude_escaping() {
    local path="$1"
    
    # Require absolute paths (must start with /)
    if [[ "${path:0:1}" != "/" ]]; then
        echo "Error: escape_path_using_claude_escaping requires an absolute path (got: $path)" >&2
        return 1
    fi
    
    # Apply Claude's escaping rules:
    # 1. Replace all forward slashes with hyphens
    # 2. Replace spaces with hyphens
    # 3. Replace other filesystem-reserved characters with hyphens
    # 4. Remove control characters
    echo "${path}" | sed -e 's|/|-|g' \
                        -e 's| |-|g' \
                        -e 's|[<>:"|?*\\]|-|g' \
                        -e 's|[[:cntrl:]]||g'
}

# Find VS Code workspace hash for current directory
# Walks up directory tree to find matching workspace
find_workspace_hash() {
    local current_dir
    current_dir="$(pwd)"
    echo -e "${BLUE}Finding VS Code workspace for: ${current_dir}${NC}" >&2
    
    local vscode_storage_dir="$HOME/Library/Application Support/Code/User/workspaceStorage"
    
    if [[ ! -d "$vscode_storage_dir" ]]; then
        echo -e "${RED}Error: VS Code workspace storage directory not found${NC}" >&2
        echo "Expected: $vscode_storage_dir" >&2
        exit 1
    fi
    
    # Try current directory first, then walk up the tree
    local check_dir="$current_dir"
    while [[ "$check_dir" != "/" ]]; do
        # Look for workspace.json files that match the directory path
        local workspace_hash=""
        
        for workspace_dir in "$vscode_storage_dir"/*; do
            if [[ -d "$workspace_dir" ]]; then
                local workspace_json="$workspace_dir/workspace.json"
                if [[ -f "$workspace_json" ]]; then
                    # Extract workspace paths and compare with current directory
                    local workspace_paths
                    workspace_paths=$(jq -r '.folder // .workspace.folders[]?.uri // empty' "$workspace_json" 2>/dev/null)
                    
                    while IFS= read -r workspace_uri; do
                        if [[ -n "$workspace_uri" ]]; then
                            # Convert file:// URI to local path and resolve to canonical path
                            local workspace_path
                            workspace_path=$(echo "$workspace_uri" | sed 's|^file://||')
                            workspace_path=$(url_decode "$workspace_path")
                            workspace_path=$(realpath "$workspace_path" 2>/dev/null || echo "$workspace_path")
                            
                            # Compare canonical paths
                            if [[ "$workspace_path" == "$check_dir" ]]; then
                                workspace_hash="$(basename "$workspace_dir")"
                                echo -e "${GREEN}✓ Found workspace hash for: ${check_dir}${NC}" >&2
                                echo -e "${GREEN}  Workspace: ${workspace_hash}${NC}" >&2
                                echo "$workspace_hash"
                                return 0
                            fi
                        fi
                    done <<< "$workspace_paths"
                fi
            fi
        done
        
        # Move up one directory
        check_dir="$(dirname "$check_dir")"
    done
    
    # No workspace found in any ancestor directory
    echo -e "${YELLOW}Warning: Could not find VS Code workspace hash for: ${current_dir}${NC}" >&2
    echo -e "${YELLOW}Checked all ancestor directories up to root${NC}" >&2
    echo "" >&2
    echo "Available workspaces:" >&2
    for ws_dir in "$vscode_storage_dir"/*; do
        if [[ -d "$ws_dir" ]]; then
            local ws_hash=$(basename "$ws_dir")
            local ws_json="$ws_dir/workspace.json"
            if [[ -f "$ws_json" ]]; then
                local ws_path=$(jq -r '.folder // .workspace.folders[]?.uri // empty' "$ws_json" 2>/dev/null | head -1)
                if [[ -n "$ws_path" ]]; then
                    ws_path=$(echo "$ws_path" | sed 's|^file://||')
                    ws_path=$(url_decode "$ws_path")
                    echo "  $ws_hash: $ws_path"
                fi
            fi
        fi
    done | head -5 >&2
    exit 1
}