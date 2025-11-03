<!-- AGENTS
If you're looking to invoke the module, please proceed to [REFRESHER_PROMPT.md](./REFRESHER_PROMPT.md)
-->

# Context Refresher

Keep your AI context documentation current by analyzing git history to identify what has changed since documentation was last updated.

## Usage Instructions

> **Not sure if this module is right for your situation?** Check the [Getting Started Guide](../getting-started/README.md) for guidance on when to use each toolkit module.

1. **Start the Context Refresher** - In any AI chat interface:

   ```
   I'd like to use the context-refresher module to update my AI context documentation. Please follow the module's prompt thoroughly.
   ```

2. **Follow the structured workflow** - The refresher will guide you through 5 phases of analysis

3. **Review and approve** - Each phase produces concrete output documents for your review

4. **Execute updates** - Apply approved changes or confirm documentation is already current

## Expected Outputs

After running the Context Refresher, you'll have:

- **Current state inventory** - What context docs exist and when last updated
- **Commit history analysis** - Timeline of changes since last update
- **Diff analysis** - Detailed before/after comparisons
- **Update plan** - Proposed updates or "no changes needed" confirmation
- **Execution log** - Record of changes made (if any)

## Key Features

- **Git-first approach** - Uses git history as source of truth
- **Two valid outcomes** - Either updates documentation OR confirms it's current
- **User control** - Requires explicit approval before making changes

## Files Overview

- `README.md` - This file
- `REFRESHER_PROMPT.md` - AI agent instructions for consistent behavior
- `WORKFLOW.md` - Detailed phase-by-phase workflow documentation
- `templates/` - Structured templates for each output document
- `examples/` - Example outputs including "no changes needed" scenarios
- `build/` - Directory where generated outputs are saved

## Testing Status

| AI Tool | LLM | Windows | MacOS |
|---------|-----|---------|-------|
| **GitHub Copilot** | | | |
| | GPT-4.1 | ❌ Not Tested | ❌ Not Tested |
| | Claude Sonnet 4 | ❌ Not Tested | ✅ Fully Tested |
| | o3-mini | ❌ Not Tested | ❌ Not Tested |
| | Gemini 2.5 Pro | ❌ Not Tested | ❌ Not Tested |
| | GPT-5 | ❌ Not Tested | ❌ Not Tested |
| **Cursor** | | | |
| | GPT-4.1 | ❌ Not Tested | ❌ Not Tested |
| | Claude Sonnet 4 | ❌ Not Tested | ❌ Not Tested |
| | o3-mini | ❌ Not Tested | ❌ Not Tested |
| | Gemini 2.5 Pro | ❌ Not Tested | ❌ Not Tested |
| | GPT-5 | ❌ Not Tested | ❌ Not Tested |
| **Claude** | | | |
| | GPT-4.1 | ❌ Not Tested | ❌ Not Tested |
| | Claude Sonnet 4 | ❌ Not Tested | ❌ Not Tested |
| | o3-mini | ❌ Not Tested | ❌ Not Tested |
| | Gemini 2.5 Pro | ❌ Not Tested | ❌ Not Tested |
| | GPT-5 | ❌ Not Tested | ❌ Not Tested |

**Legend:**
- ✅ Fully Tested - All functionality verified to work correctly
- ⚠️ Partially Tested - Basic functionality tested, some edge cases or **known issues** may exist
- ❌ Not Tested - No testing completed on this platform/LLM combination, or **significant issues** were found