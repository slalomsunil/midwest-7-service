# Excessive Consecutive Scope Pattern

## Detection Signals

IMPORTANT! These signals are exemplary, not exhaustive or constraints.

- [User behavior] Gives agent multiple complex tasks in single request without breaking into testable phases
- [Agent behavior] Creates plans with 6+ consecutive implementation tasks before user validation
- [Agent behavior] Executes multiple operations across many files without pausing for validation
- [User behavior] Has to redirect or clarify mid-implementation because scope exceeded their intent
- [Agent behavior] Implements entire features without checkpoints for user feedback

## Root Cause
User provides broad requirements without setting explicit boundaries or checkpoints. Agents naturally try to be maximally helpful by completing as much work as possible - this is designed behavior that requires user guidance to control. Without explicit stopping points, the agent will continue implementing until the perceived task is complete.

## Impact
- High risk of rework when implementation diverges from user expectations
- Difficult to isolate issues when errors occur deep in implementation chain
- User loses control over implementation direction
- Wasted effort on features that may need significant revision

## Common Manifestations
- **Chain implementations**: Multiple related features implemented in sequence without validation
- **Bulk refactoring**: Applying changes across entire codebase before testing the pattern
- **Complete workflows**: Building entire user journeys without testing individual steps
- **Mass updates**: Updating all occurrences of a pattern without confirming the approach
- **Feature completeness**: Implementing all CRUD operations before testing basic create

## Improvement Strategies
### For Users
- Break complex requests into phases with explicit checkpoints
- Use "implement X, then show me before continuing to Y" pattern
- Request plan approval before implementation begins
- Set explicit scope boundaries ("only implement the login form, not the entire auth system")

### For Documentation
- Add guidance on incremental development practices
- Document checkpoint patterns for complex features
- Include examples of appropriately scoped requests
- Create templates for phased implementation requests