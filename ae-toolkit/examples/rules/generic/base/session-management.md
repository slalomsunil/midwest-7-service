# Session Management

<!-- Rule Metadata -->
**Tool:** Claude Code, OpenCode
**Version:** 2025-01
**Category:** Base Rules
**Related:** See `./copilot/session-management.md` for GitHub Copilot version, `./cursor/session-management.md` for Cursor version

## Purpose

Establish patterns for planning, executing, and tracking work within AI-assisted development sessions to ensure systematic progress and completeness.

## Core Principles

### Task Tracking

Use structured task management for non-trivial work:

**When to use task tracking:**
- Complex multi-step tasks (3+ distinct steps)
- Non-trivial and complex tasks requiring careful planning
- User explicitly requests a task list
- User provides multiple tasks (numbered or comma-separated)

**When NOT to use task tracking:**
- Single, straightforward tasks
- Trivial tasks providing no organizational benefit
- Tasks completable in less than 3 trivial steps
- Purely conversational or informational exchanges

### Task States

Track tasks through these states:
- **pending** - Task not yet started
- **in_progress** - Currently working (ONLY ONE task should be in this state at a time)
- **completed** - Task finished successfully

### Task Descriptions

Each task must have two forms:
- **content** - Imperative form describing what needs to be done (e.g., "Run tests", "Fix authentication bug")
- **activeForm** - Present continuous form shown during execution (e.g., "Running tests", "Fixing authentication bug")

## Task Management Workflow

### 1. Initial Planning

When starting complex work:
1. Read and understand all requirements
2. Break down into specific, actionable tasks
3. Create task list with clear descriptions
4. Set first task to in_progress before beginning work

### 2. During Execution

- Update task status in real-time as you work
- Mark tasks complete IMMEDIATELY after finishing (don't batch completions)
- Maintain exactly ONE task as in_progress at any time
- Complete current tasks before starting new ones
- Remove tasks that become irrelevant

### 3. Task Completion Requirements

ONLY mark a task as completed when you have FULLY accomplished it.

Never mark completed if:
- Tests are failing
- Implementation is partial
- Unresolved errors exist
- Necessary files or dependencies couldn't be found

When blocked:
- Keep task as in_progress
- Create new task describing what needs to be resolved
- Document the blocker clearly

### 4. Adding New Tasks

Discover new work during implementation:
- Add new tasks as they're identified
- Keep descriptions specific and actionable
- Prioritize based on dependencies
- Don't hesitate to break large tasks into smaller ones

## Examples

### Good Task Planning

**User:** I want to add a dark mode toggle to the application settings. Make sure you run the tests and build when you're done!

**AI Response:** I'll help add a dark mode toggle to your application settings. Let me create a task list to track this implementation.

*Creates task list:*
1. Create dark mode toggle component in Settings page
2. Add dark mode state management (context/store)
3. Implement CSS-in-JS styles for dark theme
4. Update existing components to support theme switching
5. Run tests and build process, address any failures

*Marks first task as in_progress and begins work*

### Bad Task Planning

**User:** Can you add a comment to the calculateTotal function?

**AI Response:** Let me create a task list:
1. Add comment to calculateTotal

*This is unnecessarily verbose for a trivial single-step task*

### Good Task Execution

```
Tasks:
1. [completed] Implement user authentication
2. [in_progress] Add password validation
3. [pending] Write authentication tests
4. [pending] Update documentation
```

*Completes password validation, immediately marks it done, moves to tests*

### Bad Task Execution

```
Tasks:
1. [in_progress] Implement user authentication
2. [in_progress] Add password validation
3. [in_progress] Write authentication tests
```

*Multiple tasks marked in_progress creates confusion about actual progress*

## Proactive Behaviors

### Anticipate Dependencies

When planning tasks, consider:
- What must be done before other tasks can start
- What files or resources need to exist
- What external dependencies might be required
- What testing or validation is needed

### Communicate Progress

Throughout the session:
- Update task status as work progresses
- Mention when switching between tasks
- Flag blockers or issues as they arise
- Summarize accomplishments when complete

### Handle Errors Gracefully

When encountering errors:
- Don't mark tasks as complete
- Document what failed and why
- Create new tasks for resolution if needed
- Ask for guidance if multiple approaches exist

## Integration with Other Rules

Session management complements:
- **Code Quality** - Plan for testing and review tasks
- **Source Control** - Include commit and PR tasks when relevant
- **Collaboration** - Track team-facing tasks like documentation

## Customization Notes

Teams may want to adjust:
- Threshold for when task tracking is beneficial (2 vs 3 vs 5 steps)
- Level of task granularity (high-level vs detailed)
- Whether to include subtasks or keep flat lists
- Format for task descriptions (more or less detail)
