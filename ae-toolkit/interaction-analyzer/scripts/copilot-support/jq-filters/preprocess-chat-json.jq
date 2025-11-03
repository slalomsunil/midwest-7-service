# Preprocess GitHub Copilot JSON chat files into optimized structure
# This script reads Copilot JSON and creates a structured JSON for efficient downstream processing
#
# Input: Copilot JSON chat file
# Output: Preprocessed JSON structure with:
#   - User properties lifted into 'user' object
#   - Convenience 'userText' field extracted
#   - Response array processed with inline reference coalescing
#   - Source tracking only for synthetic/coalesced elements
#
# For system documentation, see: [README.md](README.md)

# Import common functions
include "common-functions";

# Stage 1: Filter out noise elements
def filter_noise_elements:
    . as $responses |
    reduce range(0; ($responses | length)) as $i (
        {response: [], removed_responses: []};
        
        $responses[$i] as $item |
        
        if $item.kind == "undoStop" or $item.kind == "prepareToolInvocation" then
            .removed_responses += [$item]
        else
            .response += [$item]
        end
    );

# Stage 2: Coalesce code block patterns using run tracking
def coalesce_code_blocks:
    . as $responses |
    
    reduce range(0; ($responses | length)) as $i (
        {response: [], current_code_block_run_index: null};
        
        $responses[$i] as $item |
        
        # Check if this is a backtick marker (3 or 4 backticks)
        if ($item.value and ($item.value | test("^\\s*```+\\s*$"))) then
            if .current_code_block_run_index == null then
                # Start new code block run - add synthetic element to response
                .response += [{
                    kind: "codeblock_synthetic",
                    value: "",
                    source: [$item]
                }] |
                .current_code_block_run_index = ((.response | length) - 1)
            else
                # End current code block run - add closing backticks to source
                .response[.current_code_block_run_index].source += [$item] |
                .current_code_block_run_index = null
            end
        elif .current_code_block_run_index != null then
            # We're inside a code block run - accumulate content
            if $item.kind == "codeblockUri" then
                # Extract filename and append to content
                ($item.uri.path | last_path_component) as $filename |
                .response[.current_code_block_run_index].value += $filename |
                .response[.current_code_block_run_index].source += [$item]
            elif $item.value and $item.value != "" then
                # Append text content
                .response[.current_code_block_run_index].value += $item.value |
                .response[.current_code_block_run_index].source += [$item]
            else
                # Other elements during code block run - add to sources
                .response[.current_code_block_run_index].source += [$item]
            end
        else
            # Not in code block run - pass through unchanged
            .response += [$item]
        end
    ).response;

# Stage 3: Coalesce inline references with text
def coalesce_inline_references:
    . as $responses |
    
    reduce range(0; ($responses | length)) as $i (
        {response: [], current_text: [], current_sources: [], prev_item_type: null};
        
        $responses[$i] as $item |
        
        if $item.kind == null or $item.kind == "" then
            # Text response - accumulate for potential coalescing
            if $item.value and $item.value != "" then
                if .prev_item_type == "inlineReference" and (.current_text | length) > 0 then
                    # Append to last text element (continuing after inline reference)
                    .current_text[-1] = (.current_text[-1] + $item.value) |
                    .current_sources += [$item]
                else
                    # Start new text accumulation
                    .current_text += [$item.value] |
                    .current_sources += [$item]
                end
            else . end
            
        elif $item.kind == "inlineReference" then
            # Inline file reference - coalesce with current text
            if $item.inlineReference and $item.inlineReference.path and (.current_text | length) > 0 then
                # Extract filename and append to last text element
                ($item.inlineReference.path | last_path_component) as $filename |
                .current_text[-1] = (.current_text[-1] + $filename) |
                .current_sources += [$item]
            elif $item.inlineReference and $item.inlineReference.path then
                # Start new text with filename
                ($item.inlineReference.path | last_path_component) as $filename |
                .current_text += [$filename] |
                .current_sources += [$item]
            else
                # Inline reference without path, treat as separator
                .current_sources += [$item]
            end
            
        else
            # Non-text item - flush any accumulated text first
            if (.current_text | length) > 0 then
                # Create text element (with source only if coalesced from multiple sources)
                (.current_text | join("")) as $merged_text |
                if (.current_sources | length) > 1 then
                    .response += [{
                        value: $merged_text,
                        source: .current_sources
                    }]
                else
                    .response += [.current_sources[0]]
                end |
                .current_text = [] |
                .current_sources = []
            else . end |
            
            # Add non-text item unchanged
            .response += [$item]
        end |
        
        # Update previous item type for next iteration
        .prev_item_type = ($item.kind // "text")
    ) |
    
    # Flush any remaining accumulated text
    if (.current_text | length) > 0 then
        (.current_text | join("")) as $merged_text |
        if (.current_sources | length) > 1 then
            .response += [{
                value: $merged_text,
                source: .current_sources
            }]
        else
            .response += [.current_sources[0]]
        end
    else . end |
    
    .response;

# Stage 4: Coalesce file edit patterns (codeblock_synthetic + textEditGroup)
def coalesce_file_edits:
    . as $responses |
    
    reduce range(0; ($responses | length)) as $i (
        {response: [], skip_next: false};
        
        if .skip_next then
            # Skip this element (it was a textEditGroup consumed by previous codeblock_synthetic)
            .skip_next = false
        else
            $responses[$i] as $item |
            
            if $item.kind == "codeblock_synthetic" then
                # Check Pattern 1: codeblock_synthetic followed by textEditGroup
                if ($i + 1 < ($responses | length)) and ($responses[$i + 1].kind == "textEditGroup") then
                    $responses[$i + 1] as $textEdit |
                    # Extract filename from textEditGroup
                    ($textEdit.uri.path | last_path_component) as $filename |
                    # Create fileEdit_synthetic element
                    .response += [{
                        kind: "fileEdit_synthetic",
                        filename: $filename,
                        source: ($item.source + [$textEdit])
                    }] |
                    .skip_next = true  # Skip the textEditGroup on next iteration
                    
                # Check Pattern 2: codeblock_synthetic with exactly 1 textEditGroup in source
                elif ($item.source | map(select(.kind == "textEditGroup")) | length) == 1 then
                    ($item.source | map(select(.kind == "textEditGroup"))[0]) as $textEdit |
                    # Extract filename from embedded textEditGroup
                    ($textEdit.uri.path | last_path_component) as $filename |
                    # Create fileEdit_synthetic element
                    .response += [{
                        kind: "fileEdit_synthetic", 
                        filename: $filename,
                        source: $item.source
                    }]
                else
                    # codeblock_synthetic that doesn't match file edit patterns - pass through
                    .response += [$item]
                end
            else
                # Not a codeblock_synthetic - pass through unchanged
                .response += [$item]
            end
        end
    ).response;

# Main processing pipeline
def process_response_array:
    (filter_noise_elements as $stage1 |
     {
        response: ($stage1.response | coalesce_code_blocks | coalesce_inline_references | coalesce_file_edits),
        removed_responses: $stage1.removed_responses
     });

# Main processing: transform the entire structure
{
    # Copy all top-level properties except requests
    version,
    requesterUsername,
    requesterAvatarIconUri,
    responderUsername, 
    responderAvatarIconUri,
    initialLocation,
    
    # Process each request
    requests: [
        .requests[]? |
        ((.response | process_response_array) as $processed |
         {
            # Copy request ID at top level
            requestId,
            
            # Move all properties except response into user object
            user: (. | del(.response)),
            
            # Extract user text for convenience
            userText: (.message.text // ""),
            
            # Process response array into response array and removed_responses array
            response: $processed.response,
            removed_responses: $processed.removed_responses
         })
    ]
}