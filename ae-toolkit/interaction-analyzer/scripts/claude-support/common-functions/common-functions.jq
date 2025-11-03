# Common jq functions for Claude Code chat processing
# This file contains shared functions used across multiple jq scripts

# Time formatting function - extract just HH:MM:SS
def format_time: 
    if . then 
        split("T")[1] | split(".")[0] 
    else 
        error("Unexpected time format \(.)") 
    end;