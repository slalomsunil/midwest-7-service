#!/bin/bash

# Gather project-wide metadata for Claude Code chat sessions
# This script collects summary cross-references across all sessions in a project
# Returns JSON object with summary metadata
#
# Usage: gather-project-metadata.sh <project-name> <output-file>
# Example: gather-project-metadata.sh "-Users-allenh-projects-ai-accelerator-ae-delivery-accelerator" output.json

set -e

# Script directory for jq filters
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$(dirname "$SCRIPT_DIR")"

# shellcheck source=SCRIPTDIR/../common-lib.sh
source "${SCRIPTS_DIR}/common-lib.sh"

# Accept project name as argument, or use default for testing
project_name="${1:-"-Users-allenh-projects-ai-accelerator-ae-delivery-accelerator"}"
project_dir="$HOME/.claude/projects/$project_name"
output_file="${2}"

# Start total timer
total_start_time=$(date +%s.%N)

# Validate project directory exists
if [[ ! -d "$project_dir" ]]; then
    echo "{\"error\": \"Project directory not found: $project_dir\"}" > "$output_file"
    exit 1
fi

echo -e "${BLUE}Step 1: Getting all summaries with their session IDs...${NC}"
step_start_time=$(date +%s.%N)

# Step 1a: Search for all summary lines (using rg if available, fallback to grep)
echo -e "${BLUE}  ├── Searching for summary lines...${NC}"
grep_start_time=$(date +%s.%N)

# Choose search command
if [[ "$RIPGREP_AVAILABLE" == "true" ]]; then
    search_cmd=(rg --no-heading --no-line-number -H '"type":"summary"' "$project_dir"/*.jsonl)
else
    search_cmd=(grep -H '"type":"summary"' "$project_dir"/*.jsonl)
fi

# Execute search, capturing exit code
set +e
grep_output=$("${search_cmd[@]}" 2>/dev/null)
grep_exit_code=$?
set -e

# Handle exit codes: 0=found, 1=not found, >1=error
if [[ $grep_exit_code -gt 1 ]]; then
    echo -e "${RED}    ✗ Search failed with exit code $grep_exit_code${NC}" >&2
    exit $grep_exit_code
fi

grep_time=$(echo "$(date +%s.%N) - $grep_start_time" | bc -l)
echo -e "${GREEN}    ✓ Search completed: ${grep_time}s${NC}"

# Handle empty grep output (no summaries found)
if [[ -z "$grep_output" ]]; then
    step_time=$(echo "$(date +%s.%N) - $step_start_time" | bc -l)
    echo -e "${YELLOW}  ⚠ No summaries found in project (${step_time}s)${NC}"
    # Return empty metadata
    jq -n \
      --arg project_name "$project_name" \
      --arg timestamp "$(date -Iseconds)" \
      '{
        project: $project_name,
        timestamp: $timestamp,
        summary_count: 0,
        unique_leafuuid_count: 0,
        target_found_count: 0,
        summaries: []
      }' > "$output_file"
    exit 0
fi

# Step 1b: Process grep output with single jq call
echo -e "${BLUE}  ├── Processing with jq...${NC}"
jq_start_time=$(date +%s.%N)
summaries=$(echo "$grep_output" | \
  awk -F: '{
    # Extract session ID from filepath
    n = split($1, path_parts, "/")
    filename = path_parts[n]
    gsub(/\.jsonl$/, "", filename)
    
    # Print JSON with session field added
    json = substr($0, index($0, ":") + 1)
    print "{\"sessionId\":\"" filename "\",\"json\":" json "}"
  }' | \
  jq -c '{
    sessionId: .sessionId,
    leafUuid: .json.leafUuid,
    summary: .json.summary
  }')
jq_time=$(echo "$(date +%s.%N) - $jq_start_time" | bc -l)
echo -e "${GREEN}    ✓ jq processing: ${jq_time}s${NC}"

summary_count=$(echo "$summaries" | wc -l)
step_time=$(echo "$(date +%s.%N) - $step_start_time" | bc -l)
echo -e "${GREEN}  ✓ Found $summary_count summaries (${step_time}s)${NC}"

echo -e "${BLUE}Step 2: Extracting unique leaf UUIDs...${NC}"
step_start_time=$(date +%s.%N)
leaf_uuids=$(echo "$summaries" | jq -r '.leafUuid' | sort -u)
uuid_count=$(echo "$leaf_uuids" | wc -l)
step_time=$(echo "$(date +%s.%N) - $step_start_time" | bc -l)
echo -e "${GREEN}  ✓ Found $uuid_count unique UUIDs (${step_time}s)${NC}"

echo -e "${BLUE}Step 3: Building regex pattern for bulk search...${NC}"
step_start_time=$(date +%s.%N)
uuid_pattern=$(echo "$leaf_uuids" | paste -sd '|' -)
pattern_length=${#uuid_pattern}
step_time=$(echo "$(date +%s.%N) - $step_start_time" | bc -l)
echo -e "${GREEN}  ✓ Pattern length: $pattern_length characters (${step_time}s)${NC}"

echo -e "${BLUE}Step 4: Finding all target messages in one pass...${NC}"
step_start_time=$(date +%s.%N)
if [[ -n "$uuid_pattern" ]]; then
  if [[ "$RIPGREP_AVAILABLE" == "true" ]]; then
    target_raw=$(rg --no-heading --no-line-number --no-filename -e "\"uuid\":\"($uuid_pattern)\"" "$project_dir"/*.jsonl)
  else
    target_raw=$(grep -E "\"uuid\":\"($uuid_pattern)\"" "$project_dir"/*.jsonl)
  fi

  target_messages=$(echo "$target_raw" | jq -c '.' | jq -s 'map({(.uuid): .}) | add')
  target_count=$(echo "$target_messages" | jq 'keys | length')
  step_time=$(echo "$(date +%s.%N) - $step_start_time" | bc -l)
  echo -e "${GREEN}  ✓ Found $target_count target messages (${step_time}s)${NC}"
else
  target_messages="{}"
  step_time=$(echo "$(date +%s.%N) - $step_start_time" | bc -l)
  echo -e "${YELLOW}  ⚠ No UUIDs to search for (${step_time}s)${NC}"
fi

echo -e "${BLUE}Step 5: Discovering session files and relationships...${NC}"
step_start_time=$(date +%s.%N)

# This is process builds a tree of session relationships to account for continuations
# and resuming chats. It allows us to find leaf sessions which represent complete chats.
# We generally don't want to process partial chats that were continued later, because all the content
# before the continuation will be duplicated in both sessions.

# Generate JSON metadata for each session file
phase1_output=""
while IFS= read -r file; do
    # Skip files with no user messages (likely are summary-only files)
    first_user_message=$(jq -sr '. | map(select(.type == "user")) | first // ""' "$file")
    if [[ -z "$first_user_message" ]]; then
        continue
    fi
    session_id=$(basename "$file" .jsonl)
    file_json=$(jq -sr --arg filepath "$file" --arg sessionId "$session_id" '
        . as $lines | 
        $lines | map(.sessionId | select(. != null)) as $all | 
        $all | unique as $sessionIds | {
            filepath: $filepath,
            sessionId: $sessionId,
            count: ($sessionIds | length),
            sessions: $sessionIds,
            lastMessageTime: $lines[-1].timestamp
        }' "$file")
    phase1_output+="$file_json"$'\n'
done < <(find "$project_dir" -name "*.jsonl" -type f)

step_time=$(echo "$(date +%s.%N) - $step_start_time" | bc -l)
echo -e "${GREEN}  ✓ Session discovery completed (${step_time}s)${NC}"

# Build session tree structure and reverse map together
session_tree=$(echo "$phase1_output" | jq -s -f "${SCRIPT_DIR}/jq-filters/build-session-tree.jq")

step_time=$(echo "$(date +%s.%N) - $step_start_time" | bc -l)
echo -e "${GREEN}  ✓ Chat relationships built (${step_time}s)${NC}"

echo -e "${BLUE}Step 6: Building final metadata object...${NC}"
step_start_time=$(date +%s.%N)

# Build the final metadata object
jq -n \
  --arg project_name "$project_name" \
  --argjson summaries "$(echo "$summaries" | jq -s '.')" \
  --argjson targets "$target_messages" \
  --argjson session_tree "$session_tree" \
  --arg timestamp "$(date -Iseconds)" \
  '{
    project: $project_name,
    timestamp: $timestamp,
    summary_count: ($summaries | group_by(.leafUuid) | length),
    unique_leafuuid_count: ($summaries | map(.leafUuid) | unique | length),
    target_found_count: ($targets | keys | length),
    session_tree: $session_tree,
    summaries: ($summaries | group_by(.leafUuid) | map({
      (.[0].leafUuid): {
        sessionId: .[0].sessionId,
        summary: .[0].summary,
        targetMessage: $targets[.[0].leafUuid]
      }
    }) | add // {})
  }' > "$output_file"

step_time=$(echo "$(date +%s.%N) - $step_start_time" | bc -l)
echo -e "${GREEN}  ✓ Metadata object built (${step_time}s)${NC}"

# Calculate and display total time
total_time=$(echo "$(date +%s.%N) - $total_start_time" | bc -l)
echo ""
echo -e "${GREEN}✓ Total execution time: ${total_time}s${NC}"