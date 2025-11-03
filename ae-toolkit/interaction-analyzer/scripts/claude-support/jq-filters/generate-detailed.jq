# Generate summary for preprocessed Claude Code JSON with truncation tracking
# This script processes preprocessed JSON to create a markdown conversation summary
# and outputs a list of tool results that need full files created
#
# Usage: jq --arg truncation_length "500" -r -f generate-summary.jq preprocessed.json
# For system documentation, see: [README.md](README.md)

# Get truncation length from argument (default to 500)
($truncation_length // "500" | tonumber) as $max_length |

# Time formatting functions
def format_time: if . then split("T")[1] | split(".")[0] else "" end;

# Format tool content with special handling for specific tools
def format_tool_content(content; tool_name; toolUseResult):
    (content | if type == "string" then . elif type == "array" then tostring else "No content" end) +
    (if tool_name == "TodoWrite" and toolUseResult then
        "\n\n**Todo Changes:**\n" +
        (if toolUseResult.oldTodos and (toolUseResult.oldTodos | length) > 0 then
          "Previous todos:\n" + 
          (toolUseResult.oldTodos | map("- [" + .status + "] " + .content) | join("\n")) + "\n\n"
        else ""
        end) +
        (if toolUseResult.newTodos and (toolUseResult.newTodos | length) > 0 then
          "Updated todos:\n" + 
          (toolUseResult.newTodos | map("- [" + .status + "] " + .content) | join("\n"))
        else ""
        end)
    else ""
    end);

# Build the summary content and collect truncated tool results
# Create summary lookup from project metadata (now already a map)
(if $project_metadata and ($project_metadata | length) > 0 then
   ($project_metadata[0].summaries // {} | to_entries | map({(.key): .value.summary}) | add // {})
 else 
   (.summaries // {})
 end) as $summaries |
{
    summary: [
        .conversation[] |
        (.timestamp // "" | format_time) as $time |
        (if $time != "" then " (" + $time + ")" else "" end) as $display_time |
        
        # Check if this message has an AI summary
        (if .uuid and $summaries[.uuid] then
            "**🤖 AI Summary:** " + $summaries[.uuid] + "\n\n"
        else ""
        end) as $ai_summary |

        if .type == "user" then
            if .text != "" then
                "### User Message" + $display_time + "\n\n" + 
                (if $ai_summary != "" then $ai_summary else "" end) +
                .text + "\n\n---\n"
            else ""
            end
            
        elif .type == "assistant" then
            # Build tool summary with results
            (if (.toolCalls | length) > 0 then
                ([.toolCalls[] | 
                    "Tool: " + .toolName + 
                    (if .result and .result.content then
                        # Format content with tool-specific enhancements
                        format_tool_content(.result.content; .toolName; .result.toolUseResult) as $content_str |
                        "\nResult: " + 
                        (if ($content_str | length) > $max_length then
                            ($content_str | .[0:$max_length]) + "...\n\n*Full content in: [tool_results/" + .result.filename + "](tool_results/" + .result.filename + ")*"
                        else 
                            $content_str
                        end)
                    else ""
                    end)
                ] | join("\n\n"))
            else "" end) as $tools |
            
            if .text != "" or $tools != "" then
                "### Assistant Response" + $display_time + "\n\n" +
                (if $ai_summary != "" then $ai_summary else "" end) +
                (if .text != "" then .text + "\n" else "" end) +
                (if $tools != "" then "\n**Tools Used:**\n" + $tools + "\n" else "" end) +
                "\n---\n"
            else ""
            end
            
        else ""
        end
    ] | join(""),
    
    truncated_tool_results: [
        .conversation[] | 
        select(.type == "assistant" and .toolCalls) |
        .toolCalls[] |
        select(.result and .result.content) |
        format_tool_content(.result.content; .toolName; .result.toolUseResult) as $content_str |
        select(($content_str | length) > $max_length) |
        {
            filename: .result.filename,
            tool_name: .toolName,
            tool_use_id: .toolId,
            timestamp: .result.timestamp,
            content: $content_str
        }
    ]
}