# Extracts the first 60 characters from the first user message from a Claude conversation JSONL file
# This is meant to be used to help identify chats by how they started which is easier to do for humans
# than using session IDs.
#
# Technically this could be made better by finding the first user message with a non-null content, but I don't feel like it
map(select(.type == "user")) | first 
| 
    # claude code has 3 possible formats for .message
    # 1) .content is a string
    # 2) .content is an array of objects with .type and .text fields
    # 3) .message is itself an array of objects with .type and .text fields
    if (.message.content | type) == "string" then 
        .message.content
    elif (.message.content | type) == "array" then 
        (.message.content | map(select(.type == "text")) | first | .text)
    elif (.message | type) == "array" then 
        (.message | map(select(.type == "text")) | first | .text)
    else 
        $default 
    end
    // $default 
    | if length > 60 then .[:60] + "..." else . end 
    | gsub("^ +| +$"; "") # Trim leading/trailing spaces
    | gsub("\\n+"; " ") # Replace newlines with spaces
    