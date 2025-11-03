# Data Collection Summary Template

Use this template to document data collected for analysis. Replace bracketed placeholders with actual values.

```markdown
# Data Collection Summary - [Date]

## Analysis Scope

Data collected for this analysis session:
- **Source:** [Claude Code/GitHub Copilot/Both]
- **Collection Method:** [e.g., "Current project only" or "All workspaces"]

## Data Available for Analysis

[Include ONLY sections for data that was successfully collected in this session]

### Claude Code Data
- **Navigation File:** [all-projects-summary.md](build/claude-chats/all-projects-summary.md)
- **Project:** [Project Name] ([Full Project Path])
- **Total Chats:** [X] chats processed
- **Date Range:** [Start Date] to [End Date]

#### Notable Chat Statistics:
- **Top 5 Most Active Chats:**
  1. [X messages, Y tool uses ([Date])]([link to chat directory])
     - [detailed.md]([link to detailed.md])
     - [abbreviated.md]([link to abbreviated.md])
  2. [X messages, Y tool uses ([Date])]([link to chat directory])
     - [detailed.md]([link to detailed.md])
     - [abbreviated.md]([link to abbreviated.md])
  3. [X messages, Y tool uses ([Date])]([link to chat directory])
     - [detailed.md]([link to detailed.md])
     - [abbreviated.md]([link to abbreviated.md])
  4. [X messages, Y tool uses ([Date])]([link to chat directory])
     - [detailed.md]([link to detailed.md])
     - [abbreviated.md]([link to abbreviated.md])
  5. [X messages, Y tool uses ([Date])]([link to chat directory])
     - [detailed.md]([link to detailed.md])
     - [abbreviated.md]([link to abbreviated.md])

### GitHub Copilot Data
- **Navigation File:** [all-workspaces-summary.md](build/copilot-chats/all-workspaces-summary.md)
- **Workspace:** [Workspace Name] ([Full Workspace Path])
- **Total Sessions:** [X] sessions processed
- **Date Range:** [Start Date] to [End Date]

#### Notable Session Statistics:
- **Top 5 Most Active Sessions:**
  1. [X interactions, Y completions ([Date])]([link to session directory])
     - [detailed.md]([link to detailed.md])
     - [abbreviated.md]([link to abbreviated.md])
  2. [X interactions, Y completions ([Date])]([link to session directory])
     - [detailed.md]([link to detailed.md])
     - [abbreviated.md]([link to abbreviated.md])
  3. [X interactions, Y completions ([Date])]([link to session directory])
     - [detailed.md]([link to detailed.md])
     - [abbreviated.md]([link to abbreviated.md])
  4. [X interactions, Y completions ([Date])]([link to session directory])
     - [detailed.md]([link to detailed.md])
     - [abbreviated.md]([link to abbreviated.md])
  5. [X interactions, Y completions ([Date])]([link to session directory])
     - [detailed.md]([link to detailed.md])
     - [abbreviated.md]([link to abbreviated.md])

## Data Format

Collected chats are available in two formats:
- **abbreviated.md** - Streamlined conversation logs
- **detailed.md** - Full summaries with metadata

## Ready for Analysis

✅ Data collection complete. Proceed to Phase 2: Pattern Analysis using only the data listed above.
```

## File Location

Save data collection summary as:
`${INTERACTION_ANALYZER_DIR}/build/DATA_COLLECTION_SUMMARY.md`

## MANDATORY TEMPLATE COMPLIANCE

**CRITICAL:** This template format is REQUIRED and NON-NEGOTIABLE. 

When filling out this template:
1. **EXACTLY follow the markdown structure** - Do not deviate from the format
2. **ONLY include data that was collected in the current session** - No assumptions
3. **Subsequent analysis phases will ONLY use data explicitly listed in this summary** - Nothing else
4. **All metrics and detailed navigation are provided in the referenced summary files** - Do not duplicate
5. **Use the precise section structure** - Missing sections indicate missing data scope