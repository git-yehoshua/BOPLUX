# WWG Wiki Resolver

## Purpose

Decide where knowledge belongs in the Wiki Layer.

## Filing Rules

- Raw evidence goes in `01-sources/raw` and should not be rewritten.
- Cleaned extracts or summaries go in `01-sources/processed`.
- Product truth and identity belong in `02-project`.
- Requirements and acceptance rules belong in `03-requirements`.
- Architecture decisions belong in `04-decisions`.
- Runtime Truth, source-of-truth declarations, integration shape, and technical architecture belong in `05-architecture`.
- Domain rules and product invariants belong in `06-domain`.
- Design truth, screens, user journeys, and content guidance belong in `07-ux`.
- Incidents, known issues, runbooks, public-surface updates, signoff learnings, and operational procedures belong in `08-operations`.
- Public discovery, monitoring, and operations reports belong in `08-operations`.
- Agent context inputs belong in `09-agent-context`.
- Current canonical context policy, project master context, runtime context, and public discovery context belong in `09-agent-context`.
- Skills and reusable wiki procedures belong in `10-skills`.
- Current synthesis, open questions, and contradictions belong in `11-synthesis`.
- Context maintenance, change classification, drift policy, and maintenance contracts belong in `12-maintenance`.
- Governance checks belong in the generated project's `.wwg/governance/` layer.
- Public content terminology belongs first in `02-project/glossary.md` and `07-ux/content-guidelines.md`, then derived docs or public surfaces.
- Regression guardrail catalogs belong in the Governance layer; narrative lessons from sign-off misses belong in `08-operations/signoff-learnings.md`.
- Generated-section policy belongs in `.wwg/workspace/generation-policy.md`.
- Evidence standards, operational readiness, and public discovery review belong in the Governance layer.
- Truth conflict resolution and enforcement levels belong in the Governance layer.

## Canonical Families

Universal canonical families are project/product, requirements, domain/rules, architecture/runtime, data/persistence, security/permissions, ux/design, operations/reliability, public surfaces, public discovery, agent context/skills, and governance/release.

Profiles may add canonical families such as game mechanics, fintech ledger/reconciliation, or agent-webapp tool permissions.

## Template vs Project Note

Upstream template defaults are starter material. Do not overwrite accepted local Project Truth, Terminology, decisions, reports, or user-written docs with generic template content.

## Maintenance Routing

Every meaningful request should be classified with `12-maintenance/change-classification.md`.

Use `12-maintenance/context-maintenance-matrix.md` to determine which wiki, workspace, skill, and governance artifacts to check.

Use `12-maintenance/maintenance-contract.md` to report canonical artifacts checked, context updated, skills changed, governance checks run, and known drift.

Use the Task Router skill for short natural prompts. Route public or stakeholder-facing communication through `08-operations/public-surface-updates.md` and `governance-template/base/public-surface-review.md`.

Route runtime, deployment, local-vs-deployed, and infrastructure investigation through the runtime-infrastructure skill. Route production health checks through read-only monitoring and evidence standards.

## Conflict Handling

When information conflicts, preserve the evidence, record the contradiction in `11-synthesis/contradictions.md`, and do not silently overwrite compiled truth.

## Output Format

Every meaningful filing change should update the relevant page, `index.md`, and `log.md`.
