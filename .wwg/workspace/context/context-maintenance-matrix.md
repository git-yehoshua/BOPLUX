# Context Maintenance Matrix

## Purpose

Compile routing guidance for keeping Wiki, Workspace, skills, prompts, and Governance synchronized.

## Source Wiki Artifacts

- wiki/12-maintenance/context-maintenance-matrix.md
- wiki/12-maintenance/drift-policy.md
- wiki/12-maintenance/maintenance-contract.md

## Compiled Context

<!-- WWG_GENERATED:COMPILED_CONTEXT:START -->
- Project: BOPLUX
- Slug: boplux
- Status: initialized
- Primary agent: generic
- Governance level: standard
- Wiki root: .wwg/wiki
- Workspace root: .wwg/workspace
- Governance root: .wwg/governance
- Selected profiles: game

### Context Maintenance Matrix

Source: `wiki/12-maintenance/context-maintenance-matrix.md`

# Context Maintenance Matrix
## Purpose
Answer which canonical artifacts must be reviewed, which must be updated when behavior changes, which public surfaces need review, whether release/public drafts are required, whether skill updates are required, and which governance checks apply.
## Compiled Truth
The global project master context is the overview, not the only upkeep target. Update dedicated canonical context files when their domain truth changes.
Reference/history docs are not automatically updated unless explicitly refreshed or promoted. When in doubt, update the canonical doc first and leave reference/history docs unchanged unless the task needs them refreshed.
Profiles may extend the matrix with domain-specific rows.
## Canonical Families
Universal canonical families:
- project/product
- requirements
- domain/rules
### Drift Policy

Source: `wiki/12-maintenance/drift-policy.md`

# Drift Policy
## Purpose
Define how WWG projects detect and resolve drift between implementation, documentation, context, skills, and governance.
## Compiled Truth
No Drift Rule: Do not leave docs, skills, context, and implementation drifting after a canonical decision.
Drift is not always bad. Requirement evolution is normal when requested or intentionally accepted and documented in canonical truth.
Truth Alignment Status should be interpreted alongside any drift score or `Drift status: NONE / LOW / MEDIUM / HIGH` field. The score shows amount or severity of movement; alignment status explains whether the movement is accepted evolution, undocumented change, documentation lag, implementation drift, regression/quality drift, or terminology drift.
When alignment is not GREEN, choose a Truth Sync decision path before continuing: Accept as New Truth, Reconcile to Existing Truth, Investigate / Plan First, or Regression / Quality Repair. Natural-language agent instructions are preferred; CLI commands such as `align-check`, `update-truth`, `reconcile`, `plan`, and `regression-check` are backup report-first tools.
## Canonical Terminology
- Product terms must have one canonical name.
- Deprecated names must be documented.
- Agents must preserve terminology across server, client, docs, admin surfaces, public pages, and reports.
### Maintenance Contract

Source: `wiki/12-maintenance/maintenance-contract.md`

# Maintenance Contract
## Purpose
Provide the required checklist every agent should use to reconcile project truth after a meaningful change.
## Compiled Truth
Every meaningful feature, bug fix, canonical clarification, architecture change, UX change, or production fix should explicitly review this contract.
## Contract Template
Change category:
User request:
Decision flow:
Wiki-first or code-investigation-first:
Canonical artifacts checked:
Canonical artifacts updated:
<!-- WWG_GENERATED:COMPILED_CONTEXT:END -->

## Maintenance Notes

- Refresh this file with `wwg refresh-context` after canonical Wiki truth changes.
- Do not edit generated content directly; edit Wiki truth first.

## Related Files

- `.wwg/config/wwg.project.yaml`
- `.wwg/wiki/12-maintenance/context-maintenance-matrix.md`
- `.wwg/wiki/12-maintenance/maintenance-contract.md`
