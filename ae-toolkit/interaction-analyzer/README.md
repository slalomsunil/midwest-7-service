<!-- AGENTS
If you're looking to invoke the module, please proceed to [ANALYZER_PROMPT.md](./ANALYZER_PROMPT.md)
-->

# Interaction Analyzer

**A diagnostic tool that helps teams understand *why* their AI interactions are inefficient, not just *that* they are.**

This analyzer examines AI-human interactions in the context of your project's documentation infrastructure, identifying root causes of inefficiencies - whether they stem from documentation gaps, outdated information, user patterns, or AI tool limitations.

## Quick Setup

> **Not sure if this module is right for your situation?** Check the [Getting Started Guide](../getting-started/README.md) for guidance on when to use each toolkit module.

1. **Copy the toolkit** into your project root (see main README installation steps)
2. **Gather interaction data** - Collect AI chat logs, code reviews, and collaboration examples
3. **Activate the analyzer** - In any AI chat interface:

```
I need to analyze our AI-human interaction patterns to optimize our collaboration. Please activate the `interaction-analyzer` module by reading and following the ANALYZER_PROMPT.md.
```

## Future Directions

1. Further refine chat formatting for both tools
2. Provide tool name definitions to help the analyzer understand more about how each agent uses each type of tool
3. Provide tool feature guidance so analyzer knows what e.g. Claude Code is capable of
4. Include truncation strategy from copilot abbreviated.md into claude code
5. Convert the script infrastructure so that it is structured as a plugin system, with standard interfaces the orchestrator is able to use for each type of tool. Allowing for easier extensibility and more code sharing.

## Testing Status

| AI Tool | LLM | Windows | MacOS |
|---------|-----|---------|-------|
| **GitHub Copilot** | | | |
| | GPT-4.1 | ❌ Not Tested | ❌ Not Tested |
| | Claude Sonnet 4 | ✅ Fully Tested | ✅ Fully Tested |
| | o3-mini | ❌ Not Tested | ❌ Not Tested |
| | Gemini 2.5 Pro | ❌ Not Tested | ❌ Not Tested |
| | GPT-5 | ✅ Fully Tested | ❌ Not Tested |
| **Cursor** | | | |
| | GPT-4.1 | ❌ Not Tested | ❌ Not Tested |
| | Claude Sonnet 4 | ❌ Not Tested | ❌ Not Tested |
| | o3-mini | ❌ Not Tested | ❌ Not Tested |
| | Gemini 2.5 Pro | ❌ Not Tested | ❌ Not Tested |
| | GPT-5 | ❌ Not Tested | ❌ Not Tested |
| **Claude** | | | |
| | GPT-4.1 | ❌ Not Tested | ❌ Not Tested |
| | Claude Sonnet 4 | ❌ Not Tested | ✅ Fully Tested |
| | o3-mini | ❌ Not Tested | ❌ Not Tested |
| | Gemini 2.5 Pro | ❌ Not Tested | ❌ Not Tested |
| | GPT-5 | ❌ Not Tested | ❌ Not Tested |

**Legend:**
- ✅ Fully Tested - All functionality verified to work correctly
- ⚠️ Partially Tested - Basic functionality tested, some edge cases or **known issues** may exist
- ❌ Not Tested - No testing completed on this platform/LLM combination, or **significant issues** were found