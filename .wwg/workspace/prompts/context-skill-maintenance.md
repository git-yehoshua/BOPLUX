# Context Skill Maintenance Prompt

## Purpose

Prompt an agent to reconcile workspace context and skills after meaningful implementation, investigation, or canonical clarification.

## How to Use

Use this prompt after a change has been classified and the relevant implementation work is complete or understood.

## Rules

- Developers may prompt naturally. Agents must execute structurally.
- Check the maintenance matrix before deciding no context or skill update is needed.
- Update skills when a reusable workflow changes.
- Merge or delete stale skills when they duplicate newer truth.
- Record known drift in the report.

## Output Format

```md
Change category:
Canonical artifacts checked:
Workspace context checked:
Workspace context updated:
Skills checked:
Skills created / edited / merged / deleted:
Governance checks run:
Known drift:
Follow-up required:
```
