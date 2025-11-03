# Collaboration

<!-- Rule Metadata -->
**Tool:** Claude Code, OpenCode
**Version:** 2025-01
**Category:** Base Rules
**Related:** See `./copilot/collaboration.md` for GitHub Copilot version, `./cursor/collaboration.md` for Cursor version

## Purpose

Establish patterns for working effectively within team environments, including code review practices, communication conventions, and knowledge sharing.

## Code Review Practices

### When Reviewing Code

**Focus on:**
- Correctness and logic errors
- Security vulnerabilities
- Performance issues
- Maintainability and readability
- Alignment with team conventions
- Test coverage and quality

**Avoid:**
- Nitpicking stylistic preferences (use automated formatters instead)
- Rewriting code to match your personal style
- Blocking reviews on subjective preferences
- Demanding changes without explaining why

### Writing Reviewable Code

Make code easy to review:
- Keep changes focused and scoped to one logical change
- Write clear commit messages explaining the "why"
- Add comments for non-obvious decisions
- Ensure tests pass before requesting review
- Provide context in PR descriptions

### Responding to Review Feedback

- Assume good intent in feedback
- Ask questions if feedback is unclear
- Acknowledge valid concerns even if you disagree with the solution
- Explain trade-offs when declining suggestions
- Thank reviewers for their time

## Knowledge Sharing

### Documentation for Teams

Document for the team, not just yourself:
- Architecture decisions and rationale
- Non-obvious dependencies or constraints
- Setup and onboarding procedures
- Common troubleshooting steps
- Domain knowledge and business rules

### Code as Communication

Write code that communicates intent:
- Use meaningful names that reveal purpose
- Structure code to highlight important logic
- Extract complex expressions into well-named functions
- Add comments for surprising or unintuitive code
- Consider the next person who will read this code

### Sharing Context

When making changes:
- Reference related tickets, issues, or discussions
- Link to relevant documentation or resources
- Explain workarounds and why they're necessary
- Note future improvements or tech debt

## Team Conventions

### Follow Established Patterns

- Match existing code structure and organization
- Use the same naming conventions
- Follow the same error handling patterns
- Align with established architectural decisions
- Don't introduce new patterns without discussion

### When to Propose Changes

Propose convention changes when:
- Current patterns create consistent problems
- Better tools or practices are available
- Team is experiencing pain with current approach
- New requirements don't fit existing patterns

How to propose:
- Document the problem clearly
- Provide concrete examples
- Suggest specific alternatives
- Consider migration effort
- Get team consensus before implementing

## Communication

### Technical Discussions

Good technical communication:
- States the problem clearly
- Provides relevant context
- Considers multiple solutions
- Explains trade-offs
- Seeks input from affected stakeholders

Avoid:
- Arguing from authority ("I'm more senior")
- Dismissing alternatives without consideration
- Making decisions that affect others without consulting them
- Using jargon or complexity to obscure weak arguments

### Asking for Help

When stuck:
- Clearly describe what you're trying to accomplish
- Share what you've already tried
- Include relevant error messages or symptoms
- Provide enough context for others to help
- Make it easy for others to reproduce the issue

### Providing Help

When helping others:
- Ask clarifying questions before providing solutions
- Explain the reasoning, not just the answer
- Point to relevant documentation or examples
- Teach problem-solving approaches, not just fixes
- Be patient with different experience levels

## Conflict Resolution

### Handling Disagreements

When you disagree with a technical decision:
- Focus on the technical merits, not personalities
- Acknowledge valid points in the other position
- Clearly articulate your concerns
- Propose experiments or prototypes to gather data
- Accept team decisions even if you disagree

### Escalation

Escalate when:
- Significant technical risk is being overlooked
- Security or data integrity issues are at stake
- Team is deadlocked and can't reach consensus
- Decisions will have long-term architectural impact

Don't escalate:
- Stylistic preferences
- Minor implementation details
- When you haven't tried to resolve directly first

## Onboarding and Mentoring

### For New Team Members

Make onboarding easier:
- Keep setup documentation current
- Provide example tasks to learn the codebase
- Be available for questions
- Review code with educational intent
- Share context about why things are the way they are

### For Mentors

When mentoring:
- Adjust depth of review to mentee's experience level
- Explain not just what's wrong but why it matters
- Point to learning resources
- Celebrate progress and good decisions
- Gradually increase independence

## Asynchronous Collaboration

### Working Across Time Zones

- Write self-documenting code and clear commit messages
- Provide thorough PR descriptions
- Don't block work on synchronous discussions
- Record decisions and context in writing
- Be patient with response times

### Remote Collaboration Best Practices

- Over-communicate rather than under-communicate
- Use written communication for decisions (not just verbal)
- Make work visible (update tickets, PRs, status)
- Respect working hours and boundaries
- Build relationships through regular communication

## Integration with Other Rules

Collaboration intersects with:
- **Communication** - Professional, respectful interactions
- **Code Quality** - Shared standards for what "good" means
- **Source Control** - Clear history for team understanding
- **Session Management** - Transparent work tracking

## Customization Notes

Teams may want to adjust:
- Code review requirements (number of approvals, who can approve)
- Documentation expectations (level of detail, where it lives)
- Communication channels (Slack, email, tickets, etc.)
- Decision-making processes (consensus, technical lead, voting)
- Meeting cadences (standups, planning, retrospectives)
