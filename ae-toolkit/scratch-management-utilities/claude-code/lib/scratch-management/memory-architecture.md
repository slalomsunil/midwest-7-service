# Memory Architecture for Scratch Management

## Three-Tier Memory System

The scratch management system uses a three-tier memory architecture inspired by computer memory hierarchies. This provides clear categorization rules for knowledge at different scopes and lifespans.

## L1 Cache (Scratch Space)

**Location**: `ai-scratch-<descriptor>/`
**Lifespan**: Current scratch only
**Access**: Fast, frequent, scratch-specific

### What Belongs in L1
- Active implementation notes and decisions
- Current blockers and their resolutions
- Scratch-specific discoveries and gotchas
- Work-in-progress documentation
- Session handoff notes
- Implementation choices with rationale

### Examples
- "OAuth provider requires exact redirect URI match including trailing slash"
- "Database connection pool exhausted at 50 connections during testing"
- "Decided on Strategy A over B because of X constraint"

## L2 RAM (Project Documentation)

**Location**: README.md, CLAUDE.md, docs/, code comments
**Lifespan**: Project lifetime
**Access**: Shared team knowledge

### What Belongs in L2
- Architectural patterns and decisions
- Development standards and conventions
- Non-obvious constraints and gotchas
- Setup and configuration guides
- API documentation
- Performance benchmarks

### Examples
- "Authentication uses JWT with 15-minute expiry"
- "Database migrations must be reversible"
- "Frontend components follow Atomic Design pattern"

## L3 Disk (External Systems)

**Location**: Jira, Confluence, wikis, issue trackers
**Lifespan**: Organization lifetime
**Access**: Cross-project reference

### What Belongs in L3
- Product requirements and specifications
- Historical decisions and their context
- Compliance and regulatory documentation
- Cross-team dependencies
- Long-term roadmaps
- Post-mortems and learnings

### Examples
- "PCI compliance requires encryption at rest"
- "Q3 2024 decision to migrate from Provider A to Provider B"
- "Customer data retention policy: 7 years"

## Knowledge Promotion Triggers

### L1 → L2 Promotion
Move knowledge from scratch to project docs when:

- **"This surprised me"** → Others will be surprised too
- **"This wasn't documented"** → Fill the documentation gap
- **"I'll need this again"** → Make it discoverable
- **"This pattern works well"** → Share with the team
- **"This constraint isn't obvious"** → Make it visible

### L2 → L3 Promotion
Escalate to external systems when:

- **Cross-project impact** → Other teams need to know
- **Compliance requirement** → Must be formally documented
- **Strategic decision** → Needs organizational visibility
- **Contract or commitment** → Requires audit trail

## Quick Decision Framework

Ask yourself:
- **Will I need this tomorrow?** → L1 (scratch)
- **Will my team need this next month?** → L2 (project)
- **Will the org need this next year?** → L3 (external)

## Anti-Patterns to Avoid

### L1 Mistakes
- Keeping everything forever (scratch should be temporary)
- Not capturing enough context for session handoffs
- Losing valuable discoveries when work completes

### L2 Mistakes
- Polluting with scratch-specific details
- Not updating when understanding changes
- Duplicating L3 information locally

### L3 Mistakes
- Using for active development notes
- Not linking from project docs
- Creating without clear ownership