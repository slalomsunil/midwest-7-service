#!/bin/bash

# Claude Code Project Discovery Functions
# Provides functions for finding and listing Claude Code projects
#
# Functions exported:
# - find_claude_project_dir: Finds Claude project directory for current directory
# - validate_project_dir: Validates that a specific project path exists
# - print_available_projects: Lists all available Claude projects
# - get_available_project_dirs: Returns project directory paths

# Find Claude Code project directory for current directory
find_claude_project_dir() {
    local current_dir
    current_dir="$(pwd)"
    echo -e "${BLUE}Finding Claude Code project for: ${VIOLET}${current_dir}${NC}" >&2
    
    local claude_projects_dir="$HOME/.claude/projects"
    
    if [[ ! -d "$claude_projects_dir" ]]; then
        echo -e "${RED}Error: Claude Code projects directory not found${NC}" >&2
        echo "Expected: $claude_projects_dir" >&2
        exit 1
    fi
    
    # Try current directory first, then walk up the tree
    local check_dir="$current_dir"
    while [[ "$check_dir" != "/" ]]; do
        # Convert directory to escaped format
        local escaped_path
        escaped_path="$(escape_path_using_claude_escaping "$check_dir")"
        echo -e "${BLUE}    Looking for Claude Code project ${VIOLET}${escaped_path}${NC}" >&2
        local project_dir="$claude_projects_dir/$escaped_path"
        
        if [[ -d "$project_dir" ]]; then
            echo -e "${GREEN}✓ Found project: ${VIOLET}${escaped_path}${NC}" >&2
            echo "$project_dir" # return value
            return 0
        fi
        
        # Move up one directory
        check_dir="$(dirname "$check_dir")"
    done
    
    # No project found in any ancestor directory
    echo -e "${YELLOW}Warning: Could not find Claude Code project directory for: ${VIOLET}${current_dir}${NC}" >&2
    echo -e "${YELLOW}Checked all ancestor directories up to root${NC}" >&2
    echo "" >&2
    echo "Available Claude projects (escaped format):" >&2
    ls -1 "$claude_projects_dir" | head -5 | sed 's/^/  /' >&2
    exit 1
}

# Validate project directory exists (when provided via -p flag)
validate_project_dir() {
    local project_path="$1"
    local claude_projects_dir="$HOME/.claude/projects"
    local full_project_path="$claude_projects_dir/$project_path"
    
    if [[ ! -d "$claude_projects_dir" ]]; then
        echo -e "${RED}Error: Claude Code projects directory not found${NC}" >&2
        echo "Expected: $claude_projects_dir" >&2
        exit 1
    fi
    
    if [[ ! -d "$full_project_path" ]]; then
        echo -e "${RED}Error: Project directory not found: $full_project_path${NC}" >&2
        echo "" >&2
        echo "Available Claude projects (escaped format):" >&2
        ls -1 "$claude_projects_dir" | head -5 | sed 's/^/  /' >&2
        exit 1
    fi
    
    echo "$full_project_path"
}

# Get all Claude projects
get_available_project_dirs() {
    local claude_projects_dir="$HOME/.claude/projects"
    
    if [[ ! -d "$claude_projects_dir" ]]; then
        echo -e "${RED}Error: Claude Code projects directory not found${NC}" >&2
        echo "Expected: $claude_projects_dir" >&2
        exit 1
    fi
    
    find "$claude_projects_dir" -maxdepth 1 -type d -name "-*" | sort
}

# List all available Claude projects (for list action)
print_available_projects() {
    echo -e "${BLUE}Available Claude Projects:${NC}"
    echo ""
    
    local projects
    projects=$(get_available_project_dirs)
    
    if [[ -z "$projects" ]]; then
        echo -e "${YELLOW}No Claude projects found${NC}"
        return 0
    fi
    
    while IFS= read -r project_path; do
        if [[ -n "$project_path" ]]; then
            local project_name=$(basename "$project_path")
            echo "$project_name"
        fi
    done <<< "$projects"
}