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
- If terminology differs across layers, record the conflict and update the glossary before spreading the new term.

## Drift Types

- Requirement Evolution: a user-requested or intentionally accepted change in product direction, feature scope, architecture, terminology, or behavior.
- Undocumented Requirement Change: requirement evolution that appears in recent implementation, docs, or reports but has not been promoted into Project Truth or requirements documentation.
- Documentation Lag: implementation and recent reports agree, but canonical Project Truth or core docs are behind.
- Implementation Drift: code behavior, architecture, or UI has moved away from Project Truth without a documented reason.
- Regression / Quality Drift: a previously fixed issue appears to have returned, required tests are missing, or implementation quality declined relative to governance expectations.
- Terminology Drift: terms changed or multiplied without canonical terminology updates.
- Terminology drift: different names for the same product concept.
- Architecture drift: code or deployment no longer matches architecture truth.
- Source-of-truth drift: caches, queues, pub/sub, or UI state become hidden sources of truth.
- Skill drift: reusable workflows change but skills remain stale.
- Design drift: UI behavior diverges from design source-of-truth files.
- Test drift: tests no longer reflect requirements, invariants, or known risks.
- Public content drift: docs, public pages, release notes, or admin copy contradict current product truth.
- Guardrail drift: regression guardrail catalog or sign-off workflow no longer reflects known misses.
- Generated-section drift: generated markers are stale, overlapping, missing, or overwritten outside safe regions.
- Runtime drift: deployed runtime behavior, config, secrets, migrations, workers, queues, or caches diverge from documented architecture or Runtime Truth.
- Discovery drift: public metadata, canonical URLs, sitemap, robots.txt, llms.txt, structured data, or index/noindex policy diverges from public truth.
- Evidence drift: reports present hypotheses as confirmed facts or fail to preserve evidence paths.
- Canonical context drift: project master context or dedicated context files no longer reflect current canonical truth.
- Reference-history drift: historical reports are edited as if they were current guidance instead of being promoted through canonical docs.

## Truth Conflict Rule

When code/runtime behavior and docs disagree, do not silently choose one. Classify the conflict, establish evidence, and resolve through the appropriate canonical artifact.

Template-vs-project drift occurs when generic template defaults are mistaken for accepted local project truth, or local project truth is overwritten by generic defaults.

## Resolution

Resolve drift by updating the canonical artifact, then synchronizing derived artifacts. If the correct truth is unclear, record the conflict in `11-synthesis/contradictions.md` and the follow-up in a report.

For meaningful implementation changes involving behavior, business rules, state management, parsing, payments, auth/security, persistence, workflows, prior bug fixes, or user-visible feature behavior, close-out should include new/updated tests, an updated regression test, or an explicit documented reason why tests were not added.
