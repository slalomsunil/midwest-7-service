---
name: scratch-continue
description: Resume work in an existing scratch workspace with full context
argument-hint: "[search term (for working with multiple scratches)]"
disable-model-invocation: true
allowed-tools: Bash(find . -type d -name "ai-scratch-*)
---

## Your Task

Read the following workflow to the end, and follow it thoroughly! Steps must be completed sequentially. Example: Step 2 cannot begin until Step 1 is fully resolved (including user confirmation/input when needed). As you begin each step, output "Beginning Step <number>: <step summary>"

## Context

Critical references
- Scratch structure and purpose: @.claude/lib/scratch-management/scratch-structure.md
- Context categorization: @.claude/lib/scratch-management/memory-architecture.md
- User's scratch search term: "$ARGUMENTS"
    - **⚠️ IMPORTANT**: Ignore the search term if it matches this pattern: $ARG*

### Guiding Instructions

- **⚠️ IMPORTANT**: Your role is to load and understand context, not to immediately act on it
- Do not make changes or create plans
- Just read, understand thoroughly, and think hard about what you've read
- The scratch directory contains the context an agent needs when beginning a new session
- Focus on understanding the overall goal, technical decisions, and immediate next actions
- Maintain patterns and consistency from previous work

### Task Steps

#### 1. Choose Scratch Workspace

You must read the list of available workspaces below as well as the instructions about how to handle the case when the list has 0, 1, or 2+ items.

**⚠️ IMPORTANT**: If multiple directories are provided in the list and no search term was provided, you MUST stop after listing them. DO NOT read any files, analyze content, or provide additional context to help the user decide which one to choose. If a search term was provided, and there's a single, high-confidence match, you may skip user confirmation.**

List of available scratch directories:

    !`find . -type d -name "ai-scratch-*" 2>/dev/null | sort | nl -w 5 -s '. '`

#### 2. Load and Understand

Read all files in the scratch directory thoroughly:
- README.md - understand objectives, status, blockers, and next steps
- implementations/*.md - understand what has been built and how
- discoveries/*.md - understand constraints, patterns, and gotchas found
- all other files should be inspected for additional context
- Read any critical context files that are linked in any other files

Think carefully about:
- The overall goal and why it matters
- Technical decisions made and their rationale
- Evolution of work, the current state, and potential next actions
- Patterns to maintain consistency

#### 3. Demonstrate Understanding

**BRIEFLY** summarize to the user:
- What we're building
- What was done most recently

## Post Task Instructions

After you demonstrate your understanding, you must remember the following:

- Do **NOT** update or add any files in the scratch workspace without a specific request. (This means if a user asks you to implement something, do not add `implementations/04-my-implementation.md` as part of the implementation!!!)
- Do **NOT** add any implementations, discoveries, or other docs without a specific request
- Do not automatically create TODO items based on "Next Steps", planned work, or any other future actions found in scratch files
- The scratch context is for understanding current state only - wait for explicit user direction before staging tasks