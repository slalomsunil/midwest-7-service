---
name: scratch-checkpoint
description: Capture current progress and discoveries to scratch workspace
argument-hint: "[summary]"
disable-model-invocation: true
---

## Your Task

Read the following workflow to the end, and follow it thoroughly! Steps must be completed sequentially. Example: Step 2 cannot begin until Step 1 is fully resolved (including user confirmation/input when needed).

## Context

Critical references
- Scratch structure and purpose: @.claude/lib/scratch-management/scratch-structure.md
- Context categorization: @.claude/lib/scratch-management/memory-architecture.md
- User's checkpoint summary: "$ARGUMENTS"
  - **⚠️ IMPORTANT**: Ignore the checkpoint summary if it matches this pattern: $ARG*

### Task Summary

The following workflow will guide you through documenting the current session's progress, discoveries, and decisions to the scratch directory.

### Guiding Instructions

- Checkpoint should happen within established scratch context
- The workflow is: start/continue → work → checkpoint (repeat as needed)
- Always use the plan-confirm-execute pattern for checkpoint operations
- Checkpointing mid-session is encouraged for incremental progress capture
- User can continue working after a checkpoint - it's not just for session end
- Never assume work is complete or final - checkpoint captures current state, not completion
- Use work-in-progress language: "in progress", "advanced", "attempted", "worked on"
- Avoid completion language: "completed", "finished", "finalized", "done"
- Focus on capturing context shifts, implementation choices, blockers, and dependencies
- Only create implementation files for substantial work
- Group related discoveries in single files when appropriate
- Be conservative when classifying side quests

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

  Example: /scratch-checkpoint "implement auth" path/to/ai-scratch-oauth/
  ```
  Then stop - do not search or guess.

**Note:** With multiple scratch workspaces, explicit context is critical. Never assume which workspace to checkpoint.

#### 2. Analyze Current Session
Review what has happened in this session:
- What was the starting context?
- What work was attempted or advanced?
- What discoveries were made?
- What decisions were taken?
- What blockers were encountered or addressed?

##### Identify Side Quests
Examine work done for out-of-band activities:
- Work that is valuable but **clearly unrelated** to the scratch workspace's primary goal
- Tasks the user requested that diverged from the main objective
- Improvements or fixes to other areas of the codebase encountered along the way

**Note:** Be conservative - only classify as side quests if they are definitively outside the scratch's stated objectives. When in doubt, treat as mainline work.

##### Identify Promotion Candidates
Check if any discoveries should become permanent documentation:
- "This surprised me" → L2 candidate
- "Others will hit this" → L2 candidate
- "This wasn't clear" → L2 candidate
Use the decision framework from @.claude/lib/scratch-management/memory-architecture.md

#### 3. Plan Updates and Additions

Based on the analysis, plan the following updates:

##### Plan README.md updates:
- Will update "Last Updated" timestamp
- Will revise "Current State" section to reflect progress
- Will update "Blockers" list with resolved/new items
- Will refresh "Next Steps" based on current progress
- Will add any new "Key Decisions" made this session

##### Plan implementation file:
If significant implementation work occurred:
- Will create next numbered file in `implementations/`
- Will document what was worked on and current state
- Will explain technical choices made
- Will note any issues encountered and resolutions

##### Plan discovery files:
For any new findings:
- Constraints discovered → will create `discoveries/<name>-constraint.md`
- Patterns identified → will create `discoveries/<name>-pattern.md`
- Gotchas found → will create `discoveries/<name>-gotcha.md`

##### Plan side quest documentation:
For identified out-of-band activities:
- Will create `side-quests/` directory if needed
- Will document in `side-quests/##-<brief-description>.md` (numbered sequentially)
- Will include:
  - What was done and why
  - Files affected
  - Whether it's complete or needs follow-up
  - Potential value for future reference

##### Present the Plan:
Format the planned updates as a File System Battle Map:

```
<scratch-directory-name>/
├── README.md                           [MODIFY/NO CHANGES] - Brief description
├── implementations/
│   └── ##-<descriptive-name>.md       [CREATE] - Brief description (if applicable)
├── discoveries/                        [NO CHANGES or list new files]
└── side-quests/                       [NO CHANGES or list new files]
```

Include a legend:
- [MODIFY] - Existing file to be updated
- [CREATE] - New file to be created
- [NO CHANGES] - Directory/file unchanged

Follow with a "Specific Changes" section detailing what will be modified in each file.

End with: **Confirm this checkpoint plan?** (yes/no)

#### 4. Execute Plan

Once the user confirms the plan:
- Execute all planned updates exactly as specified in section 3
- Create/update files according to the confirmed plan
- Maintain consistency with scratch structure guidelines

#### 5. Summarize
Show the user:
- What was captured
- Which files were updated/created
- Any L2 promotion candidates identified

**Note:** If summary provided via "$ARGUMENTS", include it prominently in updates and use it to title new implementation files.

## Post Task Instructions

After this task is complete, you must remember the following:

- Do not automatically or proactively plan updates to scratch workspace files without explicit instructions to do so
- Do not automatically create TODO items based on "Next Steps", planned work, or any other future actions found in scratch files
- The scratch context is for understanding current state only - wait for explicit user direction before staging tasks
- Your role is to load and understand context, not to immediately act on it