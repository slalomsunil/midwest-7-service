# Interaction Analysis

## Analysis Instructions

**CRITICAL**: This analysis must consume and examine ALL available interaction data. Use the Task tool with subagents when available to analyze large datasets in parallel.

### Analysis Priorities
1. **Deep-dive into complex interactions** (>20 messages or >10 tool uses)
2. **Sample shorter interactions** (5-10% of interactions <10 messages) to identify quick-hit patterns
3. **Focus on interactions with high iteration counts** (multiple rejections/corrections)
4. **Examine failed interactions** where goals were not achieved

### Evidence Requirements
- Every finding MUST reference specific line numbers from interaction files
- Include direct quotes showing the issue
- Note frequency of pattern occurrence across interactions
- **File references MUST be unique markdown links**: `[chat-id/abbreviated.md:lines](../build/claude-chats/chat-id/abbreviated.md)` or `[workspace-name/abbreviated.md:lines](../build/copilot-workspace/workspace-name/abbreviated.md)`

## Analysis Scope

### Data Coverage
- **Total Interactions Analyzed**: [Number]
- **Complex Interactions (>20 messages)**: [Number analyzed in detail]
- **Sampled Short Interactions**: [Number sampled from total]
- **Date Range**: [Start date - End date]
- **AI Tools Covered**: [Claude Code, GitHub Copilot, etc.]

### Analysis Approach
[Describe how you prioritized and analyzed the data, including any subagent usage]

## Pattern Detection

### Systematic Pattern Analysis
[For each pattern from patterns/ directory that was detected:]

#### [Pattern Name]
- **Frequency**: [X occurrences across Y interactions]
- **Severity**: [Impact on interaction efficiency]
- **Evidence**:
  - [chat-id/abbreviated.md:line-range](../build/claude-chats/chat-id/abbreviated.md) - "[Quote showing pattern]"
  - [Additional examples with markdown links to specific files]

### Emergent Patterns
[Novel patterns discovered during analysis]

#### [New Pattern Name]
- **Description**: [What the pattern is]
- **Detection Signals**: [How to identify it]
- **Frequency**: [How often it occurred]
- **Evidence**:
  - [chat-id/abbreviated.md:line-range](../build/claude-chats/chat-id/abbreviated.md) - "[Quote showing pattern]"

## Root Cause Analysis

### User Patterns
[Issues stemming from user behavior]

#### [Issue Title]
- **Root Cause**: [Specific user behavior causing inefficiency]
- **Impact**: [How this affects interaction quality]
- **Frequency**: [How often this occurs]
- **Evidence**:
  - [chat-id/abbreviated.md:line-range](../build/claude-chats/chat-id/abbreviated.md) - "[Supporting quote]"

### Documentation Issues
[Problems with passive infrastructure]

#### [Issue Title]
- **Root Cause**: [Missing/poor documentation or organization]
- **Impact**: [How this forces repetitive interactions]
- **Frequency**: [Pattern occurrence rate]
- **Evidence**:
  - [chat-id/abbreviated.md:line-range](../build/claude-chats/chat-id/abbreviated.md) - "[User repeatedly explaining same concept]"

### AI Tool Limitations
[Constraints and bugs in AI tools]

#### [Issue Title]
- **Root Cause**: [Specific tool limitation or bug]
- **Workaround Used**: [How users currently cope]
- **Frequency**: [How often this limitation is hit]
- **Evidence**:
  - [chat-id/abbreviated.md:line-range](../build/claude-chats/chat-id/abbreviated.md) - "[Tool error or limitation example]"

## Interaction Quality Assessment

### Overall Efficiency Score
[Qualitative assessment: Poor/Fair/Good/Excellent]

### Key Metrics
- **Average Messages per Goal**: [Number]
- **Rework Rate**: [% of interactions requiring corrections]
- **Context Loss Frequency**: [How often AI forgets context]
- **Documentation Reference Rate**: [How often users explain vs. reference docs]

### Most Impactful Issues
1. [Top issue with severity and frequency]
2. [Second issue]
3. [Third issue]

### Success Patterns
[What's working well - patterns to preserve]

## Deep Dive Examples

### Example 1: [Descriptive Title]
- **Interaction**: [chat-id/abbreviated.md](../build/claude-chats/chat-id/abbreviated.md) - [general description]
- **Issue Demonstrated**: [What this shows]
- **Line References**: [Lines X-Y showing the problem]
- **Analysis**: [Why this happened and what it reveals]

### Example 2: [Descriptive Title]
[Same structure as above with unique markdown link]

## Summary

### Critical Findings
[Top 3-5 most important discoveries about interaction quality]

### Root Cause Distribution
- User Patterns: [X% of issues]
- Documentation Issues: [Y% of issues]  
- Tool Limitations: [Z% of issues]

### Recommendations Preview
[Brief preview of what types of improvements will be most impactful]

---
**File Location**: Save as `${INTERACTION_ANALYZER_DIR}/build/INTERACTION_ANALYSIS.md`

**IMPORTANT**: This analysis forms the foundation for Phase 3 recommendations. Ensure all findings are evidence-based and reference specific interaction data.