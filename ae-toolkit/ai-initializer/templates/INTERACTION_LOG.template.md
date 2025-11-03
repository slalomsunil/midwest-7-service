# Interaction Log Template

This template is **MANDATORY** for all AI agents performing initialization processes. Following this template is **REQUIRED**. Deviating from this template will result in termination of the agent.

## Template Structure

The interaction log must capture the conversational nature of the user-agent interaction in alternating format:

```
<user> [exact verbatim user input]
<agent> [brief summary of agent actions/tools used]
<user> [exact verbatim user input]
<agent> [brief summary of agent actions/tools used]
...
```

## Critical Requirements

### User Entries
- **VERBATIM QUOTES**: Record the exact wording of user inputs
- **COMPLETE RESPONSES**: Include full user responses, not excerpts
- **PRESERVE FORMATTING**: Maintain any special formatting, punctuation, or capitalization the user provided

### Agent Entries  
- **SUMMARIZE ACTIONS**: Brief descriptions of tools used and actions taken
- **NO VERBATIM AGENT TEXT**: Do not include full agent responses
- **FOCUS ON BEHAVIOR**: What the agent did, not what it said

### Format Rules
- Use `<user>` and `<agent>` tags for each entry
- No overarching summary or conclusion
- Purely chronological interaction log
- Preserve the conversational flow

## Example Format

```
<user> I'd like to initialize my React project with AI development tools. It's a medium-sized app with about 200 components.

<agent> Analyzed project structure, detected React with TypeScript, assessed as medium complexity, found no existing AI context files, recommended Standard Context Organization Template.

<user> That sounds good. We mainly use Claude and sometimes GitHub Copilot. Can you make sure the setup works well with both?

<agent> Confirmed multi-tool setup requirement, prepared implementation plan for Claude-first configuration with Copilot compatibility, created implementation plan document.

<user> Perfect! Go ahead and implement it.

<agent> User approved implementation plan, began Phase 5 implementation, created CLAUDE.md, installed context organization templates, configured tool-specific settings.
```

## File Naming Convention

Save interaction logs as:
`${INITIALIZER_MODULE_DIR}/build/INTERACTION_LOG_[YYYY-MM-DD].md`

## Mandatory Compliance

This template structure is **NON-NEGOTIABLE**. Agents must:
1. Follow the exact `<user>` / `<agent>` format
2. Preserve verbatim user quotes
3. Summarize agent entries
4. Maintain chronological order
5. Include no additional summary or analysis

**Failure to comply with this template will result in agent termination.**