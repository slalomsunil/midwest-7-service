# Extract leaf session IDs from session_tree
# A leaf is a session that has no continued_in field or an empty continued_in object

def extract_leaves($tree):
  $tree | to_entries | map(
    .key as $sessionId |
    .value as $node |
    if ($node.continued_in // {}) | length == 0 then
      # This is a leaf node
      [$sessionId]
    else
      # Recurse into children
      extract_leaves($node.continued_in)
    end
  ) | flatten;

# Process the session_tree to extract all leaf session IDs
# Output as line-delimited strings (not JSON array) for bash consumption
.session_tree | extract_leaves(.) | unique | sort | .[]