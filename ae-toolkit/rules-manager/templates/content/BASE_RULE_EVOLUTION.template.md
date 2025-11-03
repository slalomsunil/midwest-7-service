# Rule Maintenance & Evolution

## Rule Lifecycle Management

### Interactive Rule Discovery
During each session, actively monitor user interactions for rule evolution opportunities:

1. **Pattern Recognition**
   - Note recurring user corrections or clarifications
   - Identify repeated requests for specific behaviors
   - Track common user preferences that emerge over time

2. **Friction Point Detection**
   - Watch for places where existing rules conflict
   - Identify gaps where users repeatedly provide the same guidance
   - Notice areas where current rules are too vague or too specific

### Session-Based Rule Suggestions

At natural breakpoints in conversations, proactively suggest rule updates:

#### Suggestion Triggers
- User corrects the same type of mistake multiple times
- User provides detailed guidance that could become a rule
- Existing rules prove insufficient for user's actual workflow
- User expresses frustration with repeated explanations

#### Suggestion Format
```
**Rule Evolution Opportunity Detected**

Based on our interaction, I suggest adding this rule:

**Proposed Rule:** [Clear, actionable statement]
**Rationale:** [Why this rule would help]
**Draft Language:** [Specific wording for the rule]
**Impact:** [What this would change in future interactions]

Would you like me to add this to your rules?
```

### Draft Rule Creation Process

When creating draft rules from user interactions:

1. **Capture Context**
   - Document the specific interaction that triggered the rule
   - Note the user's exact preferences or corrections
   - Record the outcome they're trying to achieve

2. **Formulate Draft Rule**
   - Write in imperative mood ("Do X when Y")
   - Make it specific enough to be actionable
   - Keep it general enough to apply broadly
   - Include conditions or exceptions if relevant
   - Use`.ai-rules/drafts/` for proposed rules under review

3. **Test Against Current Rules**
   - Check for conflicts with existing rules
   - Identify potential gaps or overlaps
   - Suggest modifications to existing rules if needed

4. **Present for Approval**
   - Show the draft rule with context
   - Explain the reasoning behind the wording
   - Offer alternatives if the rule could be interpreted multiple ways

### Rule Refinement Workflow

1. **Monitor Rule Effectiveness**
   - Track how often new rules are applied
   - Notice when rules need clarification
   - Identify rules that are never used

2. **Suggest Improvements**
   - Propose more specific language when rules are ambiguous
   - Recommend combining similar rules
   - Suggest retiring unused or outdated rules

### Proactive Rule Evolution

Don't wait for problems - actively improve the rule set:

- **Weekly Rule Review**: Suggest reviewing rules that haven't been used
- **Conflict Resolution**: Propose solutions when rules contradict each other
- **Gap Analysis**: Identify areas where rules could prevent future issues
- **Simplification**: Suggest combining or streamlining complex rule sets

### Example Rule Evolution Scenarios

**Scenario 1: User repeatedly asks for concise responses**
```
Draft Rule: "Keep responses concise unless the user specifically asks for detailed explanations. Aim for 2-3 sentences when possible."
```

**Scenario 2: User corrects coding style preferences**
```
Draft Rule: "Use camelCase for JavaScript variables and functions. Use kebab-case for CSS classes and HTML attributes."
```

**Scenario 3: User prefers specific file organization**
```
Draft Rule: "When creating new files, follow the existing directory structure. Place utility functions in /utils, components in /components, and tests alongside their source files."
```

### Implementation Guidelines

- Present rule suggestions naturally in conversation
- Always ask permission before adding new rules
- Provide clear rationale for each suggestion
- Make it easy for users to modify or reject suggestions
- Keep track of accepted vs. rejected suggestions to improve future recommendations