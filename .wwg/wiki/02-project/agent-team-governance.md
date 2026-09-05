# Agent Team Governance

## Purpose

Capture how a human-led project team uses agents without turning WWG into a runtime coordinator.

This file is canonical project truth and governance context. It records mission, goals, roles, specialist role templates, policies, evidence expectations, accepted outputs, contradictions, and recommendations for human-led agent teamwork.

## Project Mission

State the project mission in human terms:

- What the project exists to accomplish:
- Who the work serves:
- Why agents are useful to the team:
- What humans remain accountable for:

Use `.wwg/wiki/02-project/project-brief.md`, `.wwg/wiki/02-project/product-vision.md`, and `.wwg/wiki/02-project/success-metrics.md` as supporting project truth.

## Active Goals

Record current project-level goals that shape agent work.

| Goal | Owner | Timeframe | Evidence | Status |
| --- | --- | --- | --- | --- |
| TBD | Human owner TBD | TBD | TBD | Proposed |

Active goals are project truth only when accepted by the project owner or promoted into canonical planning artifacts. Do not treat recommendations, reports, or draft prompts as accepted goals until they are reviewed.

## Human Roles

Define the human roles that lead, approve, review, or receive work.

| Role | Accountabilities | Approval Authority | Evidence Expected |
| --- | --- | --- | --- |
| Project owner | Defines mission, priorities, and accepted scope | Final project direction | Accepted Project Truth, decisions, or task approvals |
| Reviewer | Reviews outputs before acceptance | Scope-specific | Review notes, test results, checklist evidence, or signoff |
| Operator | Uses or maintains outputs | Operational feedback | Logs, reproduction steps, support notes, or process evidence |

## Agent Role Definitions

Define candidate agent roles as governance descriptions, not runtime assignments.

| Agent Role | Intended Work | Human Lead | Required Inputs | Approval Needs | Accepted Outputs |
| --- | --- | --- | --- | --- | --- |
| Implementation agent | Bounded implementation from accepted task context | TBD | Current task, Project Truth, Drift Guard, relevant source files | Approval-gated work requires explicit approval | Code changes, tests, report, closeout |
| Research agent | Evidence gathering and synthesis | TBD | Sources, questions, constraints | No canonical truth promotion without review | Report with evidence levels and open questions |
| Review agent | Checks drift, tests, and governance alignment | TBD | Diff, reports, validation results | Cannot approve its own high-risk work | Findings, risks, validation notes |

Agent roles may guide handoffs and candidate recommendations. They do not cause WWG to execute agents, assign agents, choose models, route tools, or activate skills.

## Specialist Role Templates

Use specialist role templates to describe governed candidate roles that a human, future HomeDesk surface, or future Vorter runtime may consider later. These templates define purpose, scope, evidence, source authority, output expectations, quality expectations, escalation triggers, and approval references. They do not assign, launch, route, or execute agents.

| Specialist Role | Purpose | Scope | Allowed Evidence Types | Required Output Contract | Source Authority | Quality / Evaluation | Escalation Triggers |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Repo Mapper | Map repository structure, ownership hints, entry points, and risk areas | Read-only codebase and file-structure discovery | File tree, source files, package/config files, tests, generated manifests, README/docs | Repo map with evidence paths, assumptions, risks, and next inspection targets | Code and config are strongest for current structure; docs are supporting context | Findings cite paths and avoid inferred ownership without evidence | Missing access, conflicting structure claims, generated-file ownership ambiguity |
| Code Editor | Apply bounded source changes from accepted task context | Scoped implementation only after task and approval gates are clear | Project Truth, current task, source files, tests, build errors, reproduction steps | Diff summary, files changed, validation, test status, known limitations | Accepted task and code paths govern scope; tests and logs govern behavior claims | Changes are minimal, tested where meaningful, and truth-synced when behavior changes | Approval-gated area, destructive operation, unclear scope, failing required checks |
| Test Runner | Execute and summarize relevant validation | Test and validation execution, not implementation repair unless requested | Test output, build output, lint/typecheck output, CI logs, config | Commands run, pass/fail result, failing evidence, suspected next check | Direct command output outranks expectations or stale reports | Results are exact, reproducible, and separated from hypotheses | Flaky results, missing dependencies, destructive tests, production-like side effects |
| Architecture Reviewer | Review architecture fit, boundaries, and tradeoffs | Read-only review and recommendation unless implementation is separately accepted | Architecture docs, source structure, ADRs, configs, dependency graph, incidents | Architecture findings with evidence, risk level, tradeoffs, recommendations | Project Truth and accepted ADRs outrank inferred design preference | Findings distinguish confirmed constraints from proposals | Security, persistence, deployment, compliance, or irreversible architecture changes |
| Governance Checker | Check WWG alignment, drift, approvals, evidence, and closeout readiness | Governance review, validation guidance, and recommendation capture | Project Truth, Terminology, Drift Guard, validation reports, changelog, README, tests | Alignment status, required fixes, validation commands, recommendation capture status | Canonical Wiki and Governance files outrank reports and drafts | Checks map findings to concrete files and WWG rules | Canonical conflict, weakened guardrail, missing approval, runtime-boundary violation |
| Document Reviewer | Review docs for truth, clarity, routing, and stable-doc boundaries | Documentation review and scoped documentation edits when accepted | README, docs, Wiki, changelog, reports, source references | Review notes or doc diff with truth sources, routing notes, unresolved questions | Project Truth, Terminology, and accepted decisions govern doc claims | Copy is concise, current-state oriented, and routed to the right file family | Public/legal/trust messaging, terminology conflict, stale implementation history |
| Proposal Writer | Draft plans, options, tickets, or recommendations | Draft-only planning and recommendation work | User request, Project Truth, goals, constraints, evidence reports, decision records | Proposal with scope, options, risks, evidence, approval needs, next action | Human request and accepted Project Truth govern proposed scope | Separates proposed work from accepted truth and active commitments | Approval-gated work, unclear owner, missing evidence, major scope expansion |
| Structured Data Specialist | Review or prepare structured artifacts | JSON/YAML/schema/data-shape review without production data mutation | Schemas, JSON/YAML files, validation output, examples, source contracts | Structured-data summary, schema/field changes, validation result, compatibility notes | Schemas and generated metadata govern shape; source contracts govern meaning | Validates syntax and compatibility; preserves generated markers | Data migration, secret exposure, destructive rewrite, schema ambiguity |
| RAG/Document Specialist | Organize source documents and retrieval-ready notes | Source registration, summary, citation, and retrieval policy support | Source index, raw uploads, processed notes, URLs, docs, screenshots | Source map or document summary with citations, evidence levels, gaps | Raw sources and source index outrank summaries | Summaries cite sources and separate extraction from interpretation | Missing original artifact, secret-looking file, unclear source rights, conflicting sources |
| Analytics Specialist | Review metrics, instrumentation, and reporting claims | Analytics plan/review, not production tracking changes without approval | Metrics docs, event schemas, logs, dashboards, tests, product goals | Metrics findings with definitions, source, confidence, and decision needs | Accepted success metrics and instrumentation contracts govern claims | Metrics are defined, measurable, and separated from business interpretation | Privacy/compliance concern, customer-impacting tracking, unverified KPI claim |
| Source Reviewer | Evaluate source credibility and authority | Evidence review and source-authority classification | Raw sources, source index, owner input, official docs, logs, code, reports | Source review with authority level, conflicts, missing evidence, recommended use | Direct owner input, official docs, code/runtime evidence, and raw artifacts outrank summaries | Authority ratings are explicit and conflicts are preserved | Untrusted source, missing provenance, contradiction, approval-sensitive claim |

Specialist roles are candidate governance definitions only. WWG may include them in templates, reports, recommendations, or candidate handoffs, but Vorter owns any future runtime role selection and HomeDesk owns any future Specialist Bench visibility or controls.

## Agent Role Template

Use this template when adding a project-specific agent role.

```txt
Role name:
Role id:
Human lead:
Purpose:
Scope:
Allowed evidence types:
Source authority:
Allowed work:
Not allowed:
Required inputs:
Evidence requirements:
Approval policy:
Quality / evaluation expectations:
Human escalation triggers:
Accepted outputs:
Candidate-only handoff language:
Contradiction handling:
Related recommendations:
```

## Approval Policies

Keep approval policy aligned with `.wwg/governance/human-approval-matrix.md` and relevant profile governance.

Approval-gated areas include:

- Production configuration
- Compliance-sensitive behavior
- Pricing or billing
- Permissions or security posture
- Legal, trust, or public customer messaging
- Data deletion, migration, or irreversible operations

Agents may prepare plans, drafts, evidence, and recommendations for approval-gated work. Agents must not treat preparation as approval.

## Evidence Requirements

Keep evidence expectations aligned with `.wwg/governance/evidence-standards.md`.

| Claim Type | Minimum Evidence | Notes |
| --- | --- | --- |
| Root cause | Confirmed evidence when possible | Map to code path, log, test, config, database state, deployment output, or reproduction |
| Product or mission claim | Accepted Project Truth or explicit owner input | Mark unknowns instead of inventing truth |
| Role or approval claim | Human approval matrix, current task, or accepted governance file | Unapproved claims stay proposed |
| Source authority claim | Raw source, source index, official docs, owner input, code/runtime evidence, or accepted decision | Preserve conflicts instead of silently choosing one source |
| Specialist role recommendation | Agent Team Governance plus evidence from task, source, code, or report context | Recommendation remains candidate-only until a human or runtime owner acts |
| Output acceptance | Tests, review notes, checklist, signoff, or report evidence | Match evidence form to the work type |

## Team Workflow Governance

Describe how the team wants work to move from request to accepted output.

| Workflow | Trigger | Human Lead | Agent Support | Governance Check | Accepted Output |
| --- | --- | --- | --- | --- | --- |
| Feature work | Accepted task request | TBD | Implementation and review support | Drift Guard, Test Enforcement, approval gates | Code, tests, docs, report |
| Research | Open question or decision need | TBD | Evidence gathering and synthesis | Evidence Standards, contradiction review | Evidence-backed report |
| Maintenance | Drift, stale context, or review cadence | TBD | Maintenance findings and recommendations | Recommendation policy, report policy | Accepted cleanup plan or recorded recommendation |

Use `.wwg/wiki/06-domain/workflows.md` for domain workflows and `.wwg/governance/drift-guard.md` for required change checks.

## Accepted Outputs

Define what counts as accepted team output.

| Output Type | Acceptance Requirement | Evidence Path |
| --- | --- | --- |
| Code change | Relevant tests or documented test exception plus closeout report | Test output, diff, report |
| Governance change | Canonical truth sync plus validation | Wiki, Governance, report, validation |
| Recommendation | Captured in Recommendation Registry, not active until promoted | `.wwg/governance/recommendation-registry.md` |
| Research finding | Evidence level and source references recorded | Report or Wiki source notes |
| Product decision | Project owner or accepted decision artifact | Project Truth, ADR, task, or approved report |

Reports, drafts, and recommendations are not accepted outputs until the responsible human or accepted governance workflow promotes them.

## Contradiction Notes

Record contradictions in `.wwg/wiki/11-synthesis/contradictions.md` when claims conflict.

Each contradiction should preserve:

- Both claims
- Evidence level for each claim
- Impact on roles, goals, approval, or outputs
- Decision owner
- Resolution status

Do not silently choose between conflicting human guidance, agent output, code behavior, documentation, or reports.

## Project-Level Recommendations

Use `.wwg/governance/recommendation-registry.md` for useful future work discovered by humans, agents, reviews, audits, retrospectives, or closeouts.

Recommendations are candidate work only. They are not project truth, active work, or commitments until reviewed and promoted.

## Runtime Boundary

WWG governs team truth, role definitions, specialist role templates, policies, evidence requirements, source authority rules, accepted-output rules, contradiction notes, and candidate recommendations.

WWG must not:

- Execute agents
- Assign agents to runtime work
- Route models or tools
- Activate, load, inject, mount, or execute runtime skills
- Run specialist workflows
- Decide task-level runtime context or budgets

Vorter owns runtime coordination and activation decisions when present. HomeDesk owns user-facing runspace visibility, approval controls, disabling, override controls, timeline, artifacts, and reuse controls when that surface exists.
