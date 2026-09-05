# Architecture Context

## Purpose

Compile architecture, integration, security, runtime, and deployment truth.

## Source Wiki Artifacts

- wiki/05-architecture/README.md
- wiki/05-architecture/api-map.md
- wiki/05-architecture/data-model.md
- wiki/05-architecture/deployment-model.md
- wiki/05-architecture/integration-map.md
- wiki/05-architecture/security-model.md
- wiki/05-architecture/system-overview.md
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

### Architecture Folder

Source: `wiki/05-architecture/README.md`

# Architecture Folder
## Purpose
Orient maintainers to technical shape files.
## Compiled Truth
Architecture files describe system boundaries, data, APIs, integrations, security, and deployment.
### API Map

Source: `wiki/05-architecture/api-map.md`

# API Map
## Purpose
Map internal and external APIs.
## Compiled Truth
The API map should list endpoints, consumers, providers, contracts, auth expectations, and stability notes.
### Data Model

Source: `wiki/05-architecture/data-model.md`

# Data Model
## Purpose
Describe core data entities and relationships.
## Compiled Truth
The data model should identify records, ownership, lifecycle, retention, and sensitive fields.
## Runtime Truth
Data-model changes must identify which records are authoritative, which are derived, and which must never be treated as persistence-critical truth. Agents must not move persistence-critical flows to non-authoritative systems.
Schema and migration state must be validated against deployed runtime when production behavior depends on it. Cache, queue, pub/sub, and projections must not become hidden sources of truth.
### Deployment Model

Source: `wiki/05-architecture/deployment-model.md`

# Deployment Model
## Purpose
Describe environments and release topology.
## Compiled Truth
The deployment model should capture environments, hosting, configuration, rollout, rollback, and observability.
## Runtime and Infrastructure Investigation
Deployment work must distinguish local behavior from deployed behavior. "Works locally" is not sufficient proof of architectural correctness.
Runtime configuration must be explicit, validated, and documented. Deployment fixes must not mask authoritative backend defects with client-side workarounds.
Validation should cover config present at runtime, secrets loaded correctly, database connection, migration/schema state, worker/queue flow if touched, cache/projection consistency, startup paths, request-time paths, and normal backend/API flows.
### Integration Map

Source: `wiki/05-architecture/integration-map.md`

# Integration Map
## Purpose
Track external services and dependencies.
## Compiled Truth
The integration map should describe each integration, data exchanged, failure modes, and ownership.
### Security Model

Source: `wiki/05-architecture/security-model.md`

# Security Model
## Purpose
Record security architecture assumptions.
## Compiled Truth
The security model should cover identity, authorization, data protection, secrets, logging, and threat assumptions.
### System Overview

Source: `wiki/05-architecture/system-overview.md`

# System Overview
## Purpose
Describe the system at a high level.
## Compiled Truth
The system overview should capture components, responsibilities, boundaries, and major data flows.
## Runtime Truth
Runtime Truth declares which systems are authoritative, which are derived, and which must never become sources of truth.
Every generated project should explicitly declare authoritative storage. Cache, queue, and pub/sub systems must not silently become hidden sources of truth. Agents must not move persistence-critical flows to non-authoritative systems.
Runtime Truth must hold under deployed conditions, not only local development. Runtime suspects are hypotheses until verified by logs, config, reproduction, targeted checks, or deployment output.
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
