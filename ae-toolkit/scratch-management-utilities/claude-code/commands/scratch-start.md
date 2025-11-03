---
name: scratch-start
description: Initialize a new scratch workspace with background research
argument-hint: "[brief description]"
disable-model-invocation: true
---

## Your Task

Read the following workflow to the end, and follow it thoroughly! Steps must be completed sequentially. Example: Step 2 cannot begin until Step 1 is fully resolved (including user confirmation/input when needed).

## Context

Critical references
- Scratch structure and purpose: @.claude/lib/scratch-management/scratch-structure.md
- Context categorization: @.claude/lib/scratch-management/memory-architecture.md
- User's scratch purpose description: "$ARGUMENTS"
    - **⚠️ IMPORTANT**: Ignore the scratch purpose description if it matches this pattern: $ARG*

### Task Summary

The following workflow will guide you through initializing a new scratch workspace directory and populating it with the user-provided content as well as comprehensive background research.

### Guiding Instructions

- Be thorough but focused in research
- Document non-obvious discoveries immediately
- Verify interpretations with user
- Structure information for easy consumption by future sessions
- Ensure scratch directory is ready for work
- This workflow **ONLY** sets up the workspace and documents relevant context - it does NOT begin implementation. **DO NOT** begin implementing or planning any objectives

### Task Steps

#### 1. Gather Objectives
Before collecting objectives, recall whether a scratch workspace is already "open."

A scratch counts as "open" if:
- You remember running any `/scratch-*` commands in this session
- You remember being instructed to work with files in a scratch workspace
- You remember being asked to do scratch-related tasks

⚠️ **CRITICAL: This is a memory-only check!**
- Use ONLY your conversation history from this session
- Do NOT use any tools (Read, Bash, Grep, Glob, etc.)
- Do NOT spawn subtasks or agents (especially not Task tool)
- Do NOT search for scratch directories on disk
- Simply recall: "Have I run scratch commands in THIS conversation?"
- If this is the first message, the answer is always "no"

If a scratch appears to be open, present options to the user:

> It looks like we already have a scratch workspace active (`ai-scratch-<current>`).
>
> Options:
> - **Continue anyway** — Start a new scratch (useful for cross-referencing multiple efforts)
> - **Start fresh session** — Open a new chat for a different scratch
> - **Use existing commands** — Maybe you meant `/scratch-checkpoint` or `/scratch-continue`?

Only proceed with gathering objectives after confirming the user’s intent.

---

Now, gather objectives from the user:
- What we're building and why
- Success criteria
- Known constraints or requirements
- Relevant context

**CRITICAL**: These objectives are for DOCUMENTATION ONLY. You will record them in the scratch workspace but NOT act on them. Implementation happens later with other commands.

Clarify scope and confirm understanding.

#### 2. Background Research

**User-Guided:**
- Which files/systems are most relevant?
- Existing patterns to follow?
- Dependencies and integration points?

**Self-Guided:**
- Search for related code patterns
- Identify architectural constraints
- Locate relevant documentation
- Find similar implementations for reference

#### 3. Create Scratch Directory

**Directory naming:**
- Format: `ai-scratch-<descriptor>`
- Use the user's scratch purpose description or other user inputs to generate a meaningful 2 - 5 word `<descriptor>`
- Follow naming guidelines from scratch-structure.md

**Create structure:**
```
ai-scratch-<descriptor>/
├── README.md
├── implementations/
└── discoveries/
```

**Populate README.md** with:
- Work objectives and success criteria
- Relevant files and their purposes
- Discovered constraints and patterns
- Initial implementation approach
- Key decisions and rationale

Use README.md format template from scratch-structure.md

#### 4. Confirm Setup Complete
Present workspace status to user:
- Scratch workspace created at `ai-scratch-<descriptor>`
- Objectives documented in README.md
- Background research captured
- **Ready for implementation** (use `/scratch-continue` in this or a new session)

**STOP HERE**: Do not proceed with implementation. The scratch workspace is now ready for work to begin.

## Post Task Instructions

After this task is complete, you must remember the following:

- **STOP** - The scratch-start command is complete when the workspace is created
- Do not proceed with implementation - that requires explicit user direction
- Do not automatically or proactively plan updates to scratch workspace files without explicit instructions to do so
- Do not automatically create TODO items for the objectives you documented
- Do not begin coding or making changes to implement the documented objectives
- The objectives you gathered are for documentation only, not immediate action
- Your role was ONLY to set up the scratch workspace and document objectives