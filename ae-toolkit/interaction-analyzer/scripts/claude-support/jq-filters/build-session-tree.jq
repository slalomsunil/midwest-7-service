# Build session tree showing hierarchical parent-child relationships and reverse map
# Input: phase1 session data with reliable .sessionId field
# Returns: object with both session_tree and sessions (reverse map)

map(select(.sessionId != null)) as $all_files |

# Build reverse map (sessions field) - what the old standalone code did
([.[] | select(.sessionId != null) as $file | $file.sessions[] | {session: ., file: $file.sessionId}] |
 group_by(.session) |
 map({key: .[0].session, value: {appears_in_sessions: [.[].file]}}) |
 from_entries) as $reverse_map |

# Build parent-child mappings by analyzing session continuation patterns
# A file's direct parent is the first session in its sessions array that isn't itself
($all_files | map(
  .sessionId as $child |
  (.sessions - [$child]) as $parents |
  if ($parents | length) > 0 then
    # Use direct parent (first in array excluding self) for parent-child relationship
    [{child: $child, parent: $parents[0]}]
  else
    []
  end
) | flatten) as $parent_child_pairs |

# Group children by parent
($parent_child_pairs | group_by(.parent) | map({
  key: .[0].parent,
  value: [.[].child]
}) | from_entries) as $parent_to_children |

# Build recursive tree structure with continued_in wrapper
def build_subtree($sessionId):
  if $parent_to_children[$sessionId] then
    {
      continued_in: ($parent_to_children[$sessionId] | map({(.): build_subtree(.)}) | add)
    }
  else
    {}
  end;

# Find root sessions (those that don't appear as children)
($all_files | map(.sessionId)) as $all_sessions |
($parent_child_pairs | map(.child)) as $all_children |
($all_sessions - $all_children) as $roots |

($roots | map({(.): build_subtree(.)}) | add // {})