# Generate detailed summary for GitHub Copilot chat session
# Input: Copilot JSON chat file
# Output: Markdown conversation flow with metadata

# Function to process response array sequentially maintaining interleaved order
def process_ai_response_summary:
    .response as $responses |
    
    # Build a condensed transcript showing the flow
    reduce range(0; ($responses | length)) as $i (
        {parts: [], current_text: [], current_tools: [], prev_item_type: null};
        
        $responses[$i] as $item |
        
        if $item.kind == null or $item.kind == "" then
            # Text response - add to current text accumulator
            if $item.value and $item.value != "" then
                # Check if we should join with previous text (for inline references)
                if .prev_item_type == "inlineReference" and (.current_text | length) > 0 then
                    .current_text[-1] = (.current_text[-1] + $item.value)
                else
                    .current_text += [$item.value]
                end
            else . end
            
        elif $item.kind == "prepareToolInvocation" then
            # Tool preparation - flush text if any, then track tool
            if (.current_text | length) > 0 then
                # Join current text elements without extra spacing
                (.current_text | join("")) as $merged_text |
                .parts += [($merged_text | split("\n") | map("    " + .) | join("\n"))] |
                .current_text = []
            else . end |
            
            # Add tool name
            if $item.toolName then
                .current_tools += [$item.toolName]
            else . end
            
        elif $item.kind == "toolInvocationSerialized" then
            # Tool completion - when we see this, we can output the tool usage
            if $item.toolId and (.current_tools | length) > 0 then
                .parts += [((.current_tools | unique) | map("    [Used " + . + "]") | join("\n"))] |
                .current_tools = []
            else . end
            
        elif $item.kind == "inlineReference" then
            # Inline file reference - append directly to last text element without spaces
            if $item.inlineReference and $item.inlineReference.path and (.current_text | length) > 0 then
                # Handle directory paths (ending with /) by taking second to last element + "/"
                ($item.inlineReference.path | 
                 if endswith("/") then 
                     split("/") | if length > 1 then .[-2] + "/" else "" end
                 else 
                     split("/") | last 
                 end) as $filename |
                .current_text[-1] = (.current_text[-1] + $filename)
            elif $item.inlineReference and $item.inlineReference.path then
                ($item.inlineReference.path | 
                 if endswith("/") then 
                     split("/") | if length > 1 then .[-2] + "/" else "" end
                 else 
                     split("/") | last 
                 end) as $filename |
                .current_text += [$filename]
            else . end
            
        elif $item.kind == "textEditGroup" then
            # File edit group - extract filename and add to parts directly
            if $item.uri and $item.uri.path then
                ($item.uri.path | 
                 if endswith("/") then 
                     split("/") | if length > 1 then .[-2] + "/" else "" end
                 else 
                     split("/") | last 
                 end) as $filename |
                .parts += ["    [Edited " + $filename + "]"]
            else
                .parts += ["    [Edited unknown]"]
            end
            
        else
            # Other kinds - ignore
            .
        end |
        
        # Update previous item type for next iteration
        .prev_item_type = ($item.kind // "text")
    ) |
    
    # Flush any remaining content
    (
        if (.current_text | length) > 0 then
            # Join current text elements without extra spacing
            (.current_text | join("")) as $merged_text |
            .parts += [($merged_text | split("\n") | map("    " + .) | join("\n"))]
        else . end |
        
        if (.current_tools | length) > 0 then
            .parts += [((.current_tools | unique) | map("    [Used " + . + "]") | join("\n"))]
        else . end
    ) |
    
    .parts | join("\n");

.requests[]? |
"### User Message\n" +
"**Message:**\n\n" +
((.userText // "No message text") | split("\n") | map("    " + .) | join("\n")) + "\n" +
(
    if .response then 
        "\n**AI Response:**\n\n" + process_ai_response_summary + "\n" 
    else "" end
) +
(
    if .result.timings.totalElapsed then 
        "**Response Time:** " + (.result.timings.totalElapsed | tostring) + "ms\n" 
    else "" end
) +
"\n---\n"