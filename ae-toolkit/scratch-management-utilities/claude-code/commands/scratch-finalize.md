---
name: scratch-finalize
description: Promote scratch knowledge to docs and clean up workspace
argument-hint: "[brief description]"
disable-model-invocation: true
---

## Your Task

Read the following workflow to the end, and follow it thoroughly! Steps must be completed sequentially. Example: Step 2 cannot begin until Step 1 is fully resolved (including user confirmation/input when needed).

## Context

Critical references
- Scratch structure and purpose: @.claude/lib/scratch-management/scratch-structure.md
- Context categorization: @.claude/lib/scratch-management/memory-architecture.md

### Task Summary

The following workflow will guide you through propagating the knowledge contained within L1 to the L2 (project) documentation and then cleaning up the scratch files.

### Guiding Instructions

- Be thorough reviewing scratch for preservable knowledge
- ALWAYS check existing documentation before recommending updates
- Only update docs for information that is genuinely missing or incorrect
- Update thoughtfully - don't over-document or duplicate existing content
- Documentation updates should be clear and useful
- Think long-term about what helps future developers
- Clean up completely after knowledge is preserved
- Only delete scratch after confirming all valuable information transferred

### Task Steps

#### 1. Verify Scratch Context
Check if we know which scratch directory we're working with from this session:
- If known from `/scratch-continue` or `/scratch-start` in current session → proceed
- If unknown → inform user:
  ```
  No current scratch context found.

  Please either:
  - Run /scratch-continue [scratch-name] to establish context, or
  - Provide the scratch directory path explicitly

  Example: /scratch-finalize path/to/ai-scratch-oauth/
  ```
  Then stop - do not search or guess.

**Note:** With multiple scratch workspaces, explicit context is critical. Never assume which workspace to finalize.

#### 2. Load Complete Scratch Context
Read the entire scratch directory:
- README.md for objectives and outcomes
- implementations/*.md for what was built
- discoveries/*.md for learnings

#### 3. Review Accomplishments
Compile summary of:
- Features implemented
- Problems solved
- Patterns established
- Lessons learned
- Key decisions made

#### 4. Identify Documentation Candidates

**Analyze using L1→L2 promotion triggers:**
- "This surprised me" → others will be surprised too
- "This wasn't documented" → fill the documentation gap
- "I'll need this again" → make it discoverable
- "This pattern works well" → share with the team
- "This constraint isn't obvious" → make it visible

**Potential documentation candidates:**
- New features needing user documentation
- Changed APIs or interfaces
- New configuration requirements
- Discovered gotchas or workarounds
- Architectural decisions
- New development patterns

#### 5. Verify What's Already Documented

**CRITICAL**: Before recommending any documentation updates, check existing docs:

**Common documentation locations:**
- README.md
- CLAUDE.md
- docs/ directory structure
- Code comments in relevant files
- Configuration files (.env.example, etc.)

**Verification process:**
1. Read relevant existing documentation files
2. Search for content related to your findings
3. Only recommend updates for information that is:
   - Completely missing from existing docs
   - Insufficiently explained in existing docs
   - Contradicted by your findings (needs correction)

**If already documented:**
- Note it in your summary as "Already documented in [file]"
- Do not recommend redundant updates
- Consider if existing docs need minor clarification only

#### 6. Execute Documentation Updates

**Only for findings NOT already documented:**

Create or update documentation as needed:
- Add to existing docs when possible
- Create new docs only when necessary
- Follow project documentation standards
- Include examples where helpful
- Provide context for future developers

Focus on information that:
- Is genuinely missing from existing docs
- Will help someone working on this in 6 months
- Makes the system more understandable

#### 7. Cleanup and Confirm
Show user:
- What documentation was updated
- Key learnings preserved
- Work completion summary

Then:
- Delete scratch directory
- Confirm finalization complete

##### Completion Summary Template
Present to user:
```
# Work Completed: [Scratch Name]

## Implemented
- [Brief descriptions of what was built]

## Documentation Updated
- [File]: [What was added/changed]
OR
- No documentation updates needed (findings already documented)

## Key Learnings
- [Findings]: Already documented in [file]
- [New findings]: Preserved in [file]

Scratch directory removed.
```

## Post Task Instructions

After this task is complete, you must remember the following:

- Do not automatically or proactively plan updates to scratch workspace files without explicit instructions to do so
- Do not automatically create TODO items based on "Next Steps", planned work, or any other future actions found in scratch files
- The scratch context is for understanding current state only - wait for explicit user direction before staging tasks