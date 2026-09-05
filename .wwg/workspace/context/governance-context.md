# Governance Context

## Purpose

Compile evidence, approval, drift, release, and quality expectations for agent work.

## Source Wiki Artifacts

- wiki/08-operations/README.md
- wiki/08-operations/incident-log.md
- wiki/08-operations/known-issues.md
- wiki/08-operations/monitoring.md
- wiki/08-operations/operations-report-template.md
- wiki/08-operations/public-discovery.md
- wiki/08-operations/public-surface-updates.md
- wiki/08-operations/qa-checklists.md
- wiki/08-operations/runbooks.md
- wiki/08-operations/signoff-learnings.md
- wiki/12-maintenance/README.md
- wiki/12-maintenance/change-classification.md
- wiki/12-maintenance/context-maintenance-matrix.md
- wiki/12-maintenance/drift-policy.md
- wiki/12-maintenance/maintenance-contract.md
- wiki/principles/README.md
- wiki/principles/accessibility-principles.md
- wiki/principles/ai-agent-interface-principles.md
- wiki/principles/changelog-product-memory-principle.md
- wiki/principles/readme-front-door-principle.md
- wiki/principles/ui-ux-simplicity-principles.md
- wiki/profiles/README.md
- wiki/profiles/game/README.md
- wiki/profiles/game/governance-additions.md
- wiki/profiles/game/wiki-additions.md
- wiki/profiles/game/workspace-additions.md

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

### Operations Folder

Source: `wiki/08-operations/README.md`

# Operations Folder
## Purpose
Orient maintainers to operational knowledge.
## Compiled Truth
Operations files describe runbooks, incidents, known issues, QA checklists, public-surface update needs, and signoff learnings.
Public surface updates belong here when shipped behavior, capabilities, policies, constraints, or release changes require stakeholder communication.
Signoff learnings belong here when missed bugs, incidents, or validation blind spots teach the team how to improve future guardrails.
Monitoring belongs here when production health, performance, reliability, and scale readiness are reviewed in read-only-audit mode.
Public discovery belongs here when canonical URLs, metadata, sitemap, robots.txt, llms.txt, structured data, or index/noindex route policy affects how public pages are found.
### Incident Log

Source: `wiki/08-operations/incident-log.md`

# Incident Log
## Purpose
Record incidents and follow-up actions.
## Compiled Truth
Incident records should include date, impact, cause, mitigation, prevention, and owner.
### Known Issues

Source: `wiki/08-operations/known-issues.md`

# Known Issues
## Purpose
Track accepted or unresolved issues.
## Compiled Truth
Known issues should include impact, workaround, status, owner, and planned resolution when known.
Known runtime issues should distinguish confirmed causes from likely issues, hypotheses, and unknowns. Include evidence paths and missing evidence.
### Monitoring

Source: `wiki/08-operations/monitoring.md`

# Monitoring
## Purpose
Define read-only production monitoring expectations for live system health, performance, reliability, and scale readiness.
## Compiled Truth
Production monitoring is a read-only evidence-gathering workflow. It should not modify code, config, deployments, secrets, data, or infrastructure unless the user explicitly asks for that.
Monitoring reports should be comparable over time. Reports must separate confirmed issues, watch-items, likely benign signals, and unknowns. Sampled logs must be described as sampled evidence, not full-census proof.
Monitoring findings may trigger bug-fix, runtime-infrastructure, regression-guardrail, or public-surface workflows, but should not silently execute fixes unless requested.
If findings reveal a repeatable workflow gap, update governance guardrails or recommend a guardrail update.
### Operations Report

Source: `wiki/08-operations/operations-report-template.md`

# Operations Report
## Monitoring Window
Describe start/end time, timezone, environments, and evidence sources.
## Health Verdict
Use one:
- healthy
- healthy with findings
- degraded
- unknown / insufficient evidence
## Confirmed Issues
List issues proven by direct evidence.
## Watch-Items / Hotspots
### Public Discovery

Source: `wiki/08-operations/public-discovery.md`

# Public Discovery
## Purpose
Define public discovery, SEO, GEO, and AI crawler readiness for public WWG projects.
## Compiled Truth
Public discovery surfaces include canonical host policy, canonical URLs, redirect policy, metadata, Open Graph metadata, Twitter/X card metadata, sitemap, robots.txt, llms.txt, structured data / JSON-LD, index/noindex route policy, public route registry, Search Console/webmaster issues, and AI crawler or LLM discovery surfaces.
Every public project should declare a canonical production host. Legacy, staging, preview, and temporary hosts must not leak into production metadata.
## Public Route Policy
## Rules
- Public metadata should be generated from canonical helpers or documented source-of-truth files.
- Indexable and noindex routes must be explicitly classified.
- Private, admin, auth, operational, redirect-only, and ephemeral routes should be noindex and excluded from sitemap by default.
- Public release notes, docs, changelogs, content hubs, and approved marketing pages may be indexable.
### Public Surface Updates

Source: `wiki/08-operations/public-surface-updates.md`

# Public Surface Updates
## Purpose
Track user-facing and stakeholder-facing communication needs for shipped behavior, capabilities, policies, constraints, and release changes.
## Compiled Truth
Public surfaces include release notes, patch notes, help docs, onboarding copy, admin notices, app store release notes, customer support articles, public changelogs, permission notices, safety disclaimers, and internal user announcements.
Public copy should describe user outcomes, not internal implementation details. Drafts must remain unpublished unless explicit approval is given.
Public discovery is part of public surface maintenance when route visibility, metadata, sitemap, robots.txt, llms.txt, structured data, or search/AI crawler discovery changes.
## Public Writing Guidance
Lead with what users can do, notice, avoid, trust, unlock, approve, or understand. Translate internal fixes into user outcomes. Avoid internal terms unless the public audience needs them. Keep technical implementation details in engineering docs.
## Profile Examples
- SaaS App: release notes, billing notices, onboarding changes, admin dashboard changes.
- Agent WebApp: tool permission notices, agent capability changes, human review policy changes, safety disclaimers.
### QA Checklists

Source: `wiki/08-operations/qa-checklists.md`

# QA Checklists
## Purpose
Store recurring quality checks.
## Compiled Truth
QA checklists should map to requirements, core flows, risk areas, and release gates.
### Runbooks

Source: `wiki/08-operations/runbooks.md`

# Runbooks
## Purpose
Document repeatable operational procedures.
## Compiled Truth
Runbooks should include owner, trigger, steps, verification, rollback, and escalation.
Runtime runbooks should include local-vs-deployed comparison, config/secret validation, database connectivity, migration/schema verification, worker/queue checks, cache/projection consistency, and rollback expectations.
### Signoff Learnings

Source: `wiki/08-operations/signoff-learnings.md`

# Signoff Learnings
## Purpose
Capture lessons from missed bugs, incidents, validation gaps, and release sign-off misses.
## Compiled Truth
Not every regression updates product truth. Some regressions update sign-off workflow truth, testing truth, or operational guardrails only.
Use this page to summarize what the team learned and link to governance guardrail catalog entries.
Production monitoring and runtime investigations may create signoff learnings when a repeatable workflow gap or validation blind spot is found.
## Learning Entry Template
Date:
Area:
Symptom:
Missed-by reason:
### Maintenance

Source: `wiki/12-maintenance/README.md`

# Maintenance
## Purpose
Define how a WWG project keeps code, wiki truth, workspace context, skills, governance checks, and reports synchronized after meaningful work.
## Compiled Truth
Developers may prompt naturally. Agents must execute structurally.
Every developer request should become a classified change request. Every meaningful change must reconcile:
- Code
- Wiki
- Workspace Context
- Skills
- Governance
- Reports
### Change Classification

Source: `wiki/12-maintenance/change-classification.md`

# Change Classification
## Purpose
Classify natural developer requests into structured change categories before implementation.
## Compiled Truth
Natural prompts are welcome, but agents must convert them into structured execution.
## Required Change Categories
- `bug-fix`
- `feature-implementation`
- `mechanics-or-domain-rule-change`
- `architecture-change`
- `data-model-change`
- `security-review`
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
### Principles

Source: `wiki/principles/README.md`

# Principles
This folder contains durable Principle Briefs for this project.
Principles explain how agents should reason about product direction, architecture, governance, positioning, UX, and long-term design choices.
Principles are not the same as project truth.
- Use `../project-truth.md` for canonical facts.
- Use `../terminology.md` for official names and definitions.
- Use `../decisions/` for specific decisions and rationale.
- Use `../../workspace/` for current task state.
- Use `../../governance/` for enforcement rules, drift checks, and validation behavior.
Recommended default frontmatter for active Principle Briefs:
type: principle-brief
status: active
### Accessibility Principles

Source: `wiki/principles/accessibility-principles.md`

type: principle-brief
status: active
mutability: high-friction
scope: "accessibility"
last_reviewed: 2026-05-20
# Accessibility Principles
## Purpose
Set the default accessibility reasoning baseline for projects with user-facing, staff-facing, or human-facing software surfaces.
Canonical WWG source: `.wwg/wiki/principles/accessibility-principles.md` in the WWG template repository.
## Default Target
Target WCAG 2.2 AA unless the project explicitly documents a different accessibility target in accepted Project Truth or accepted decisions.
Accessibility is a release requirement, not polish.
### AI Agent Interface Principles

Source: `wiki/principles/ai-agent-interface-principles.md`

type: principle-brief
status: active
mutability: high-friction
scope: "ai-agent-interface"
last_reviewed: 2026-05-20
# AI Agent Interface Principles
## Purpose
Define interface principles for products where agents, tools, automation, receipts, evidence, approvals, or model/tool choices are visible to humans.
Canonical WWG source: `.wwg/wiki/principles/ai-agent-interface-principles.md` in the WWG template repository.
## Core Rule
Simplicity must not hide accountability.
## Principles
### Changelog Product Memory Principle

Source: `wiki/principles/changelog-product-memory-principle.md`

type: principle-brief
status: active
mutability: high-friction
scope: "changelog governance"
last_reviewed: 2026-05-07
# Changelog Product Memory Principle
It should record meaningful changes in language project owners, users, developers, and future agents can understand. Patch-level entries may be automated when apply is explicit. Minor and major version bumps require an explicit user command.
### README Front Door Principle

Source: `wiki/principles/readme-front-door-principle.md`

type: principle-brief
status: active
mutability: high-friction
scope: "README governance"
last_reviewed: 2026-05-08
# README Front Door Principle
Keep README concise. Route detailed commands to docs, meaningful history to CHANGELOG.md, agent instructions to AGENTS.md, canonical truth to Wiki, validation rules to Governance, and generated findings to reports.
### UI/UX Simplicity Principles

Source: `wiki/principles/ui-ux-simplicity-principles.md`

type: principle-brief
status: active
mutability: high-friction
scope: "ui-ux"
last_reviewed: 2026-05-20
# UI/UX Simplicity Principles
## Purpose
Provide governed UI/UX simplicity guidance for generated projects that have user-facing, staff-facing, or human-facing software surfaces.
Canonical WWG source: `.wwg/wiki/principles/ui-ux-simplicity-principles.md` in the WWG template repository.
## Scope
Use this principle when designing or reviewing layout, navigation, forms, dashboards, empty states, lists, cards, actions, status states, onboarding, and progressive disclosure.
## Non-Goals
### .wwg/wiki Profiles

Source: `wiki/profiles/README.md`

# .wwg/wiki Profiles
- [game](game/README.md)
### Game Profile

Source: `wiki/profiles/game/README.md`

# Game Profile
## Purpose
Define WWG additions for Profile for games, simulations, and interactive play systems.
## Contents
- Apply after the universal base
- Use required questions during discovery
- Add profile gates to governance before release
## Maintenance
Keep this page current when files are added, renamed, or promoted into compiled project truth.
## Profile Product Invariants
- Match outcomes must remain authoritative and replayable.
- Anti-cheat boundaries must not be weakened.
### Game Governance Additions

Source: `wiki/profiles/game/governance-additions.md`

# Game Governance Additions
## Purpose
List profile-specific quality gates, reviews, and audit expectations.
## Additions
- `balance-review`: Define checks, owner, evidence, and pass/fail criteria.
- `save-state-test-gate`: Define checks, owner, evidence, and pass/fail criteria.
- `anti-cheat-review`: Define checks, owner, evidence, and pass/fail criteria.
- `telemetry-validation`: Define checks, owner, evidence, and pass/fail criteria.
## Rules
Governance additions enforce quality and review. They should not redefine product truth.
## Public Surface Review
Review patch notes, gameplay updates, balance notes, and event announcements when shipped gameplay changes what players can do or expect.
### Game Wiki Additions

Source: `wiki/profiles/game/wiki-additions.md`

# Game Wiki Additions
## Purpose
List profile-specific knowledge areas that should be added to the Wiki Layer.
## Additions
- `game-loop`: Capture current truth, assumptions, source evidence, and unresolved questions.
- `core-mechanics`: Capture current truth, assumptions, source evidence, and unresolved questions.
- `match-state`: Capture current truth, assumptions, source evidence, and unresolved questions.
- `balancing-model`: Capture current truth, assumptions, source evidence, and unresolved questions.
- `player-progression`: Capture current truth, assumptions, source evidence, and unresolved questions.
- `bot-behavior`: Capture current truth, assumptions, source evidence, and unresolved questions.
- `replay-systems`: Capture current truth, assumptions, source evidence, and unresolved questions.
- `economy-model`: Capture current truth, assumptions, source evidence, and unresolved questions.
### Game Workspace Additions

Source: `wiki/profiles/game/workspace-additions.md`

# Game Workspace Additions
## Purpose
List profile-specific agent operating context and task templates.
## Additions
- `gameplay-task-template`: Create agent-ready context or task guidance derived from wiki truth.
- `mechanic-tuning-context`: Create agent-ready context or task guidance derived from wiki truth.
- `bot-behavior-context`: Create agent-ready context or task guidance derived from wiki truth.
- `replay-system-context`: Create agent-ready context or task guidance derived from wiki truth.
## Rules
Workspace additions must be actionable for agents and trace back to Wiki Layer truth.
<!-- WWG_GENERATED:COMPILED_CONTEXT:END -->

## Maintenance Notes

- Refresh this file with `wwg refresh-context` after canonical Wiki truth changes.
- Do not edit generated content directly; edit Wiki truth first.

## Related Files

- `.wwg/config/wwg.project.yaml`
- `.wwg/wiki/12-maintenance/context-maintenance-matrix.md`
- `.wwg/wiki/12-maintenance/maintenance-contract.md`
