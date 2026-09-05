# Canonical Context Policy

## Purpose

Define how WWG distinguishes current canonical truth from generated context, reference history, temporary notes, public surfaces, and machine-readable catalogs.

## Compiled Truth

WWG should distinguish current canonical truth from reference history, generated context, and temporary notes.

Upstream template defaults and local generated-project truth are separate. Local Project Truth wins after the project owner accepts or customizes it.

## Artifact Categories

| Artifact Type | Meaning | Update Policy |
|---|---|---|
| `canonical-update-on-change` | Current source-of-truth docs agents must keep aligned with shipped or intentionally accepted behavior. | Update when canonical behavior, product truth, architecture truth, governance truth, or workflow truth changes. |
| `generated-from-wiki` | Files generated or compiled from canonical wiki truth for specific tools or workflows. | Regenerate or refresh when source wiki truth changes. Do not edit generated sections outside safe hand-written areas. |
| `reference-history` | Dated reports, postmortems, incident notes, investigation artifacts, rollout notes, old plans, and historical decisions. | Do not update automatically on every change. Keep as evidence unless explicitly promoted into canonical guidance. |
| `temporary-working` | Scratch notes, drafts, temporary analysis, and local working files. | Never treat as canonical truth. Promote useful findings into canonical docs before relying on them. |
| `public-surface` | User-facing or stakeholder-facing communication artifacts. | Update when user-facing behavior, public messaging, trust, safety, pricing, permissions, or release communication changes. Approval may be required before publishing. |
| `machine-readable-catalog` | Structured artifacts used by agents, scripts, or future CLI/WebApp flows. | Keep machine-readable structure valid. Prefer generated-section markers when automation updates only part of the file. |

## Canonical Families

- project/product
- requirements
- domain/rules
- architecture/runtime
- data/persistence
- security/permissions
- ux/design
- operations/reliability
- public surfaces
- public discovery
- agent context/skills
- governance/release

Profiles may add canonical families such as mechanics, match lifecycle, payment flows, ledger/reconciliation, agent roles, tool permissions, memory boundaries, and evaluation.

## Master Context Size Policy

Project master context should summarize and route. Dedicated canonical context files should hold deep recurring domain detail.

Do not merge every incident, report, or implementation detail into master context. Promote only durable, current guidance into canonical context. If a domain becomes recurring and cross-session continuity materially benefits, create or update a dedicated canonical context file instead of bloating master context.

## Metadata Shape

```yaml
wwg:
  artifact_type: canonical-update-on-change
  owner_layer: wiki
  canonical_family: architecture/runtime
  update_policy: update_when_behavior_changes
  generated: false
  profile_scope:
    - base
  related_artifacts:
    - .wwg/wiki/12-maintenance/context-maintenance-matrix.md
```

## Valid Update Policies

- `update_when_behavior_changes`
- `regenerate_from_wiki`
- `append_only`
- `manual_review_only`
- `do_not_update_unless_promoted`
- `approval_required_before_publish`
