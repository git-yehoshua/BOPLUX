# Maintenance Contract

## Purpose

Provide the required checklist every agent should use to reconcile project truth after a meaningful change.

## Compiled Truth

Every meaningful feature, bug fix, canonical clarification, architecture change, UX change, or production fix should explicitly review this contract.

## Contract Template

```md
Change category:
User request:
Decision flow:
Wiki-first or code-investigation-first:
Canonical artifacts checked:
Canonical artifacts updated:
Workspace context checked:
Workspace context updated:
Skills checked:
Skills created / edited / merged / deleted:
Governance checks run:
Public/user-facing surfaces reviewed:
Tests/validation performed:
Execution mode:
Evidence level:
Runtime/infrastructure reviewed:
Public discovery reviewed:
Monitoring/operations reviewed:
Approval gate required:
Guardrail catalog update required:
Regression guardrail updated:
Generated sections touched:
Artifact type:
Canonical family:
Truth conflict reviewed:
Generated context refreshed:
Template-vs-project impact:
Migration needed:
Local project assets updated:
Upstream template defaults updated:
Known drift:
Follow-up required:
```

## Rules

- Record known drift instead of hiding it.
- Do not leave docs, skills, context, and implementation drifting after a canonical decision.
- Use this contract in implementation reports when the change affects reusable truth or workflow.
