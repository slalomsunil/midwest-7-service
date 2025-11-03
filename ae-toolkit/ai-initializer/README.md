<!-- AGENTS
If you're looking to invoke the module, please proceed to [INITIALIZER_PROMPT.md](./INITIALIZER_PROMPT.md)
-->

# AI Initializer

Transform your existing project for AI development with structured assessment and customized implementation.

## Usage Instructions

⚠️ **Thoroughly review output** - _Human in the loop is important everywhere_<br>
✅ **Continue to grow** - _Consider the outputs a starting point!_

> **Not sure if this module is right for your situation?** Check the [Getting Started Guide](../getting-started/README.md) for guidance on when to use each toolkit module.

#### **Send this prompt to your agent to begin**

   ```
   Use the `ai-initializer` module in the ae-toolkit directory to initialize my project for AI development. Follow the module's prompt (ae-toolkit/ai-initializer/INITIALIZER_PROMPT.md) thoroughly.
   ```

##### Copilot Example

   ```
┌───────────────────────────────────────────────────────────┐
│ 📎 Add Context...                                         │
│                                                           │
│ Use ai-initializer module in the ae-toolkit directory     |
| to initialize my project for AI development. Follow the   |
| module's prompt (ae-toolkit/ai-                           |
| initializer/INITIALIZER_PROMPT.md) thoroughly.            |
│                                                           │
│ Agent ▼   Claude Sonnet 4 ▼                     🛠️ 🎤 ▶️ ▼ │
└───────────────────────────────────────────────────────────┘
   ```

## Expected End State

After initialization, your project will have:

- **Project context documentation** in a `docs/` directory tailored to your tech stack and patterns
- **AI tool configuration files** (CLAUDE.md, .cursorrules, .github/copilot-instructions.md, etc.) for your preferred tools
- **Other things** as this is an AI executed workflow, the agent will be influenced by the interaction with YOU!

## Caveats

- This is a **consultative process** that requires your input, approval at key steps, and thorough review of all outputs!
- The agent will assess your project and gather your preferences before implementing anything

## Testing Status

| AI Tool | LLM | Windows | MacOS |
|---------|-----|---------|-------|
| **GitHub Copilot** | | | |
| | GPT-4.1 | ✅ Fully Tested | ❌ Not Tested |
| | Claude Sonnet 4 | ✅ Fully Tested | ✅ Fully Tested |
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
| | Claude Sonnet 4 | ❌ Not Tested | ✅ Fully Tested |
| | o3-mini | ❌ Not Tested | ❌ Not Tested |
| | Gemini 2.5 Pro | ❌ Not Tested | ❌ Not Tested |
| | GPT-5 | ❌ Not Tested | ❌ Not Tested |
| **GPT-5** | | | |
| | GitHub Copilot | ❌ Not Tested | ❌ Not Tested |
| | Cursor | ❌ Not Tested | ❌ Not Tested |
| | Claude | ❌ Not Tested | ❌ Not Tested |

**Legend:**
- ✅ Fully Tested - All functionality verified to work correctly
- ⚠️ Partially Tested - Basic functionality tested, some edge cases or **known issues** may exist
- ❌ Not Tested - No testing completed on this platform/LLM combination, or **significant issues** were found