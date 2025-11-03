# Interaction Patterns Library

This directory contains curated patterns of common interaction issues between users and AI agents.

## How to Use These Patterns

During Phase 2 (Interaction Analysis), review each pattern file and check if the detection signals are present in the analyzed interactions.

## Documented Patterns

- `user-rabbit-trailing.md` - User branches to fix incidental issues mid-task
- `excessive-consecutive-scope.md` - Insufficient user boundaries lead to excessive implementation scope
- `monolithic-implementation.md` - Lack of user checkpoints results in non-incremental implementations
- `version-mismatch-generation.md` - Agent generates code for wrong dependency versions

## Adding New Patterns

When novel issues are identified during analysis, consider documenting them as new patterns if they appear to be recurring issues. Each pattern should include:
- Detection signals
- Root cause analysis
- Impact assessment
- Improvement strategies