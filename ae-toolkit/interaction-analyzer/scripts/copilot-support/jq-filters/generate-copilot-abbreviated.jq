# Generate clean IRC-style conversation log for GitHub Copilot chat session
# Input: Preprocessed Copilot JSON (from preprocess-chat-json.jq)
# Output: Clean conversation flow without metadata overhead

# Import common functions
include "common-functions";

# Function to format timestamp
def format_time:
    if . then 
        (. / 1000 | strftime("%H:%M:%S"))
    else 
        "Unknown"
    end;

# Function to truncate text to 2 lines
def truncate_text:
    ([scan("[^\\n].+\\n*"; "g")] as $sections |
     if ($sections | length) > 2 then
         ($sections[0:2] | join("")) + "... [" + (($sections | length) - 2 | tostring) + " lines truncated] ..."
     else
         .
     end);

# Extract conversation flow from preprocessed structure
.requests[]? |
(if .user.timestamp then (.user.timestamp | format_time) else "Unknown" end) as $time |

# User message
"**user " + $time + "**\n" +
((.userText // "No message text") | split("\n") | map("    " + .) | join("\n")) + "\n\n" +

# Assistant response - simplified processing using preprocessed data with smart spacing
"**assistant " + $time + "**\n" +
((.response | to_entries) as $indexed |
 reduce range(0; ($indexed | length)) as $i (
    {output: [], skip_count: 0};
    
    if .skip_count > 0 then
        # Skip this element (it was part of a coalesced group)
        .skip_count = .skip_count - 1
    else
        $indexed[$i] as $current |
        $current.value as $item |
        
        # Determine element types for spacing logic
        ($item.value != null and $item.value != "") as $is_text |
        ($item.kind == "toolInvocationSerialized" or $item.kind == "fileEdit_synthetic" or $item.kind == "textEditGroup") as $is_action |
        
        # Determine previous element type for transition detection
        (if $i > 0 then
            $indexed[$i-1].value as $prev |
            ($prev.value != null and $prev.value != "") as $prev_is_text |
            ($prev.kind == "toolInvocationSerialized" or $prev.kind == "fileEdit_synthetic" or $prev.kind == "textEditGroup") as $prev_is_action |
            {prev_is_text: $prev_is_text, prev_is_action: $prev_is_action}
         else
            {prev_is_text: false, prev_is_action: false}
         end) as $prev_type |
        
        # Add spacing logic: blank line when transitioning between text and actions
        (if ($i > 0 and .skip_count == 0) and (($is_text and $prev_type.prev_is_action) or ($is_action and $prev_type.prev_is_text)) then
            .output += [""]  # Add empty line for transitions between text and actions
         else . end) |
        
        # Add the formatted content
        if $is_text then
            # Text element - apply truncation and formatting
            .output += [($item.value | truncate_text | split("\n") | map("    " + .) | join("\n"))]
        elif $item.kind == "toolInvocationSerialized" then
            # Skip tools with presentation: "hidden"
            if $item.presentation == "hidden" then
                .  # Skip hidden tools - do nothing
            elif ($item.toolId // "") | contains("copilot_readFile") then
                # Find all consecutive copilot_readFile operations starting from current position
                (reduce range($i; ($indexed | length)) as $j (
                    {indices: [], found_non_readfile: false};
                    if .found_non_readfile then
                        .
                    else
                        $indexed[$j].value as $item |
                        if $item.kind == "toolInvocationSerialized" and $item.presentation != "hidden" and (($item.toolId // "") | contains("copilot_readFile")) then
                            .indices += [$j]
                        else
                            .found_non_readfile = true
                        end
                    end
                ).indices) as $readfile_indices |
                
                if ($readfile_indices | length) > 1 then
                    # Collect file:fragment pairs from all consecutive readFile operations
                    ([$readfile_indices[] | $indexed[.].value | 
                      .invocationMessage.uris // {} | to_entries[]?.value | select(.path) | 
                      ((.path | last_path_component) + if .fragment then ":" + .fragment else "" end)] | join(", ")) as $all_filenames |
                    .output += ["        <tool> copilot_readFile [" + $all_filenames + "]"] |
                    .skip_count = (($readfile_indices | length) - 1)
                else
                    # Single readFile - process normally
                    if $item.invocationMessage then
                        ([$item.invocationMessage.uris // {} | to_entries[]?.value | select(.path) | 
                          ((.path | last_path_component) + if .fragment then ":" + .fragment else "" end)] | join(", ")) as $filenames |
                        .output += ["        <tool> " + ($item.toolId // "unknown") + " [" + $filenames + "]"]
                    else
                        .output += ["        <tool> " + ($item.toolId // "unknown")]
                    end
                end
            else
                .output += ["        <tool> " + ($item.toolId // "unknown")]
            end
        elif $item.kind == "fileEdit_synthetic" then  
            # File edit synthetic (coalesced from codeblock_synthetic + textEditGroup) - simple display
            .output += ["        <edited> " + $item.filename]
        elif $item.kind == "textEditGroup" then
            # Legacy textEditGroup (not coalesced) - extract filename
            if $item.uri and $item.uri.path then
                .output += ["        <edited> " + ($item.uri.path | if endswith("/") then split("/") | if length > 1 then .[-2] + "/" else "" end else split("/") | last end)]
            else
                .output += ["        <edited> unknown"]
            end
        else
            # Other elements - ignore for clean conversation flow
            .
        end
    end
 ).output | join("\n")) + "\n\n"