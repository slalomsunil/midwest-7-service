# Common jq functions for Copilot chat processing
# This file contains shared functions used across multiple jq scripts

# Extracts the last path component of a path-like string. 
def last_path_component:
    # directory
    if endswith("/") then 
        split("/") | if length > 1 then .[-2] + "/" else "" end
    # not a directory
    else 
        split("/") | last 
    end;