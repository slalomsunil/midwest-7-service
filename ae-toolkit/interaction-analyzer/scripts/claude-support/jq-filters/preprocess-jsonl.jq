# Preprocess Claude Code JSONL chat files into optimized structure
# This script reads JSONL and creates a structured JSON for efficient downstream processing
#
# For system documentation, see: [README.md](README.md)

# Time formatting functions
def format_time_no_colon: if . then split("T")[1] | split(".")[0] | gsub(":"; "") else "" end;

# Build lookup maps for efficient processing
def build_maps:
  . as $messages |
  
  # Build tool name mapping from assistant messages with tool_use
  ($messages | map(select(.type == "assistant" and .message.content and (.message.content | type) == "array")) |
   map(.message.content[] | select(.type == "tool_use") | {(.id): .name}) | 
   add // {}) as $tool_names |
   
  # Build tool input mapping
  ($messages | map(select(.type == "assistant" and .message.content and (.message.content | type) == "array")) |
   map({uuid: .uuid, tools: [.message.content[] | select(.type == "tool_use")]}) |
   map(select(.tools | length > 0)) | 
   map({(.uuid): .tools}) | add // {}) as $tool_inputs |
   
  # Build tool result mapping by parentUuid
  ($messages | map(select(.type == "user" and .message.content and (.message.content | type) == "array")) |
   map(select(.message.content[0].type == "tool_result")) |
   map({(.parentUuid): {
     timestamp: .timestamp,
     uuid: .uuid,
     content: .message.content[0].content,
     tool_use_id: .message.content[0].tool_use_id,
     tool_name: ($tool_names[.message.content[0].tool_use_id] // "unknown"),
     toolUseResult: .toolUseResult,
     filename: ((.timestamp // "" | split("T")[1] | split(".")[0] | gsub(":"; "")) + "-" + 
               ($tool_names[.message.content[0].tool_use_id] // "unknown") + "-" + 
               .message.content[0].tool_use_id + ".md")
   }}) | add // {}) as $tool_results |
   
  # Build sidechain mapping for Task tools and similar spawning tools
  ($messages | map(select(.type == "assistant" and .message.content and (.message.content | type) == "array")) |
   map({uuid: .uuid, timestamp: .timestamp, tools: [.message.content[] | select(.type == "tool_use")]}) |
   map(select(.tools | length > 0)) |
   # For each assistant message with tools, find subsequent sidechains
   map(
     . as $assistant_msg |
     # Look for Task tools that might spawn sidechains
     ($assistant_msg.tools | map(select(.name == "Task")) | .[0]) as $task_tool |
     if $task_tool then
       # Find sidechain messages that start after this assistant message
       ($messages | map(select(.isSidechain == true and .timestamp > $assistant_msg.timestamp)) | 
        # Group consecutive sidechain messages by looking for the first one with parentUuid == null
        # and then collecting all subsequent ones in the same chain
        reduce .[] as $msg (
          {current_chain: [], chains: [], first_msg_content: null};
          if $msg.parentUuid == null then
            # Start of new sidechain - check if content matches task input
            ($task_tool.input.prompt // "" | if type == "string" then . else "" end | ascii_downcase) as $task_prompt |
            ($msg.message.content // "" | if type == "string" then . else "" end | ascii_downcase) as $msg_content |
            if ($task_prompt != "" and $msg_content != "" and (($task_prompt | contains($msg_content[0:200])) or ($msg_content | contains($task_prompt[0:200])))) then
              # Content matches - start new chain for this task
              .current_chain = [$msg] | .first_msg_content = $msg_content
            else
              # No match, keep current state
              .
            end
          elif (.current_chain | length) > 0 then
            # Continue existing chain
            .current_chain += [$msg]
          else
            # No active chain, skip
            .
          end
        ) | .current_chain) as $sidechain_msgs |
       
       if ($sidechain_msgs | length) > 0 then
         {($task_tool.id): $sidechain_msgs}
       else
         {}
       end
     else
       {}
     end
   ) | add // {}) as $sidechain_map |
   
  # Build set of UUIDs that are part of linked sidechains
  ($sidechain_map | to_entries | map(.value[]) | map(.uuid) | unique) as $linked_sidechain_uuids |
   
  {tool_names: $tool_names, tool_inputs: $tool_inputs, tool_results: $tool_results, sidechain_map: $sidechain_map, linked_sidechain_uuids: $linked_sidechain_uuids};

# Main processing
. as $messages |
build_maps as $maps |

{
  metadata: {
    sessionId: ([$messages[] | select(.sessionId)] | first | .sessionId // "unknown"),
    totalMessages: ($messages | length),
    firstTimestamp: ([$messages[] | select(.timestamp)] | first | .timestamp // null),
    lastTimestamp: ([$messages[] | select(.timestamp)] | last | .timestamp // null),
    toolUsageCount: ($maps.tool_names | to_entries | group_by(.value) | map({(.[0].value): length}) | add // {})
  },
  summaries: (
    $messages | map(select(.type == "summary") | {(.leafUuid): .summary}) | add // {}
  ),
  conversation: [
    $messages[] |
    select(.type == "user" or .type == "assistant") |
    # Filter out linked sidechain messages (only ones we successfully matched to tools)
    select((.uuid as $uuid | $maps.linked_sidechain_uuids | index($uuid) | not)) |
    
    if .type == "user" then
      # Skip tool result messages - they're already captured in tool_calls
      if (.message.content and (.message.content | type) == "array" and 
          (.message.content | length) > 0 and .message.content[0].type == "tool_result") then
        empty
      else
        # Regular user message - preserve all original fields
        . + {
          text: (if (.message.content | type) == "string" then
                   .message.content
                 elif (.message.content | type) == "array" then
                   ([.message.content[] | select(.type == "text") | .text] | join("\n"))
                 else ""
                 end)
        }
      end
      
    elif .type == "assistant" then
      # Assistant message - preserve all original fields
      . + {
        text: (if (.message.content | type) == "string" then
                 .message.content
               elif (.message.content | type) == "array" then
                 # Combine text and thinking content
                 (([.message.content[] | select(.type == "text") | .text] | join("\n")) as $text |
                  ([.message.content[] | select(.type == "thinking") | "[Thinking] " + .thinking] | join("\n")) as $thinking |
                  ([$text, $thinking] | map(select(. != "")) | join("\n\n")))
               else ""
               end),
        toolCalls: (if (.message.content and (.message.content | type) == "array") then
                       . as $parent |
                       [.message.content[] | select(.type == "tool_use") | 
                        (. as $tool |
                         {
                           toolId: .id,
                           toolName: .name,
                           toolInput: .input,
                           result: ($maps.tool_results[$parent.uuid] // null)
                         } +
                         (if $maps.sidechain_map[$tool.id] then
                            {sideChain: $maps.sidechain_map[$tool.id]}
                          else
                            {}
                          end)
                        )]
                     else []
                     end)
      }
    else
      empty
    end
  ]
}