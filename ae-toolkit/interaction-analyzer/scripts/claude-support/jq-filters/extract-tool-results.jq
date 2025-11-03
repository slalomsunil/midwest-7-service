# Extract tool results from truncated tool results JSON
# This script processes only the tool results that were truncated in the summary
# and need full files created
#
# For system documentation, see: [README.md](README.md)

# Process each truncated tool result
.[] |
{
    filename: .filename,
    content: (  
        "# Tool Result: " + .tool_name + "\n\n" +
        "**Timestamp:** " + (.timestamp // "Unknown") + "\n" +
        "**Tool Name:** " + .tool_name + "\n" +
        "**Tool Use ID:** " + .tool_use_id + "\n\n" +
        "## Content\n\n" +
        (if (.content | type) == "string" then
            .content
        elif (.content | type) == "array" then
            (.content | tostring)
        else
            "No content"
        end)
    )
}