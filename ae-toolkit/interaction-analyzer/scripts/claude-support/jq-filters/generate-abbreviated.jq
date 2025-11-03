# Generate streamlined IRC-style conversation log from preprocessed Claude Code JSON
# This script creates a compact, readable chat log without metadata headers

# Import common functions
include "common-functions";

# Collapse consecutive MultiEdit tool calls into a single instance
def collapse_consecutive_multiedit:
    reduce .[] as $t (
        [];
        if ($t.toolName == "MultiEdit") and (length > 0 and (.[-1].toolName == "MultiEdit")) then
            .
        else
            . + [$t]
        end
    );

# Group consecutive assistant tool-only messages
def group_sequential_tools:
    . as $messages |
    reduce range(0; length) as $i (
        [];
        . as $result |
        $messages[$i] as $current |
        
        if $current.type == "user" then
            $result + [$current]
        elif $current.type == "assistant" and $current.text != "" then
            $result + [$current]
        elif $current.type == "assistant" and ($current.toolCalls | length) > 0 then
            # This is a tool-only assistant message
            if ($result | length) > 0 and 
               ($result[-1].type == "assistant") and 
               ($result[-1].text == "" or $result[-1].text == null) and
               (($result[-1].toolCalls // []) | length) > 0 then
                # Merge with previous tool-only assistant message
                $result[:-1] + [(
                    $result[-1] + {
                        toolCalls: (($result[-1].toolCalls + $current.toolCalls) | collapse_consecutive_multiedit),
                        timestamp: $result[-1].timestamp  # Keep first timestamp
                    }
                )]
            else
                $result + [$current]
            end
        else
            $result + [$current]
        end
    );

# Pre-pass: convert any assistant message containing a TodoWrite tool call
# into a normal assistant text message saying "Updated Todos" so that:
#  - It is displayed as a regular assistant line (not a generic tool usage)
#  - It will NOT be merged into adjacent tool-only messages by group_sequential_tools
#  - The TodoWrite tool call is removed from toolCalls so it doesn't appear in the "Used ..." list
# If the original assistant message also had text, append a blank line then "Updated Todos".
def mark_todowrite:
    map(
        if .type == "assistant" and ((.toolCalls // []) | any(.toolName == "TodoWrite")) then
            . as $m |
            # Remove TodoWrite tool calls, keep others (future-proof if multiple toolCalls exist)
            (($m.toolCalls // []) | map(select(.toolName != "TodoWrite"))) as $remaining |
            # Extract TodoWrite tool data for todo list formatting
            (($m.toolCalls // []) | map(select(.toolName == "TodoWrite")) | .[0].toolInput.todos // []) as $todos |
            # Format todo list if todos exist
            (if ($todos | length) > 0 then
                "\n" + ([$todos[] | "    - [" + .status + "] " + .content] | join("\n"))
            else
                ""
            end) as $todo_list |
            $m
            | .text = (
                if ($m.text // "") != "" then
                    # Ensure exactly one blank line separation before the marker if not already present
                    ($m.text + (if ($m.text | endswith("\n\n")) then "" else "\n\n" end) + "Updated Todos" + $todo_list)
                else
                    ("Updated Todos" + $todo_list)
                end)
            | .toolCalls = $remaining
        else
            .
        end
    );

# Pre-pass: convert any assistant message containing a Task tool call
# into a normal assistant text message showing task details so that:
#  - It is displayed as a regular assistant line (not a generic tool usage)
#  - It will NOT be merged into adjacent tool-only messages by group_sequential_tools
#  - The Task tool call is removed from toolCalls so it doesn't appear in the "Used ..." list
# If the original assistant message also had text, append a blank line then task details.
def mark_task:
    map(
        if .type == "assistant" and ((.toolCalls // []) | any(.toolName == "Task")) then
            . as $m |
            # Remove Task tool calls, keep others (future-proof if multiple toolCalls exist)
            (($m.toolCalls // []) | map(select(.toolName != "Task"))) as $remaining |
            # Extract Task tool data for formatting
            (($m.toolCalls // []) | map(select(.toolName == "Task")) | .[0].toolInput) as $task_input |
            # Format task details
            ("Task: " + ($task_input.description // "Unknown task") + "\nAgent: " + ($task_input.subagent_type // "unknown")) as $task_details |
            $m
            | .text = (
                if ($m.text // "") != "" then
                    # Ensure exactly one blank line separation before the task details if not already present
                    ($m.text + (if ($m.text | endswith("\n\n")) then "" else "\n\n" end) + $task_details)
                else
                    $task_details
                end)
            | .toolCalls = $remaining
        else
            .
        end
    );

[
    (.conversation | mark_todowrite | mark_task | group_sequential_tools)[] |
    (.timestamp | format_time) as $time |
    
    if .type == "user" then
        if .text != "" then
            "**user " + $time + "**\n" + 
            (.text | split("\n") | map("  " + .) | join("\n")) + "\n\n"
        else ""
        end
        
    elif .type == "assistant" then
        # Assistant message with text
        (if .text != "" then
            "**assistant " + $time + "**\n" + 
            (.text | split("\n") | map("  " + .) | join("\n")) + "\n\n"
        else ""
        end) +
        
        # Tool usage line (coalesced across sequential messages)
        (if (.toolCalls | length) > 0 then
            "**assistant " + $time + "**\n" + 
            "  Used " + ([.toolCalls[] | .toolName] | join(", ")) + "\n\n"
        else ""
        end)
        
    else ""
    end
] | join("")