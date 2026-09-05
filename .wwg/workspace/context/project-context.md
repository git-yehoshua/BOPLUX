# Project Context

## Purpose

Provide project orientation, requirements routing, and current canonical project truth for agents.

## Source Wiki Artifacts

- wiki/02-project/README.md
- wiki/02-project/agent-team-governance.md
- wiki/02-project/business-model.md
- wiki/02-project/glossary.md
- wiki/02-project/product-vision.md
- wiki/02-project/project-brief.md
- wiki/02-project/success-metrics.md
- wiki/02-project/target-users.md
- wiki/03-requirements/README.md
- wiki/03-requirements/acceptance-criteria.md
- wiki/03-requirements/constraints.md
- wiki/03-requirements/functional-requirements.md
- wiki/03-requirements/non-functional-requirements.md
- wiki/03-requirements/user-stories.md
- wiki/09-agent-context/README.md
- wiki/09-agent-context/canonical-context-policy.md
- wiki/09-agent-context/claude-context.md
- wiki/09-agent-context/codex-context.md
- wiki/09-agent-context/cursor-context.md
- wiki/09-agent-context/project-master-context.md
- wiki/09-agent-context/public-discovery-context.md
- wiki/09-agent-context/reusable-prompts.md
- wiki/09-agent-context/runtime-context.md
- wiki/index.md
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

### Project Folder

Source: `wiki/02-project/README.md`

# Project Folder
## Purpose
Orient maintainers to project identity files.
## Compiled Truth
Project identity files define why the project exists, who it serves, how it succeeds, and what terms mean.
## Files
- `project-brief.md`: Short canonical project description.
- `product-vision.md`: Long-term direction.
- `success-metrics.md`: Measurable success signals.
- `target-users.md`: Users, roles, and audiences.
- `business-model.md`: Business model and value exchange.
- `glossary.md`: Project-specific terms.
### Agent Team Governance

Source: `wiki/02-project/agent-team-governance.md`

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
### Business Model

Source: `wiki/02-project/business-model.md`

# Business Model
## Purpose
Describe how the project creates and captures value.
## Compiled Truth
Business model notes should include pricing, stakeholders, acquisition assumptions, and non-goals where relevant.
### Glossary

Source: `wiki/02-project/glossary.md`

# Glossary
## Purpose
Maintain shared vocabulary.
## Compiled Truth
Terms should have one canonical definition and link to domain or architecture pages when needed.
## Canonical Terminology
- Product terms must have one canonical name.
- Deprecated names must be documented.
- Agents must preserve terminology across server, client, docs, admin surfaces, public pages, and reports.
- Renames should update the glossary first, then derived context, UI copy, public content, and reports.
## Deprecated Names
### Product Vision

Source: `wiki/02-project/product-vision.md`

# Product Vision
## Purpose
State the long-term product direction.
## Compiled Truth
The product vision should describe the desired future state and guide prioritization without becoming a feature backlog.
### Project Brief

Source: `wiki/02-project/project-brief.md`

# Project Brief
## Purpose
Capture the short canonical description of the project.
## Compiled Truth
The project brief should answer what is being built, who it is for, why it matters, and what constraints shape delivery.
### Success Metrics

Source: `wiki/02-project/success-metrics.md`

# Success Metrics
## Purpose
Define measurable signs of success.
## Compiled Truth
Success metrics should include product, technical, business, and operational indicators where applicable.
### Target Users

Source: `wiki/02-project/target-users.md`

# Target Users
## Purpose
Define primary and secondary users.
## Compiled Truth
Target user descriptions should include goals, pains, permissions, technical comfort, and success criteria.
### Requirements Folder

Source: `wiki/03-requirements/README.md`

# Requirements Folder
## Purpose
Orient maintainers to requirement files.
## Compiled Truth
Requirements describe expected behavior, qualities, constraints, acceptance criteria, and stories.
### Acceptance Criteria

Source: `wiki/03-requirements/acceptance-criteria.md`

# Acceptance Criteria
## Purpose
Define how work is accepted.
## Compiled Truth
Acceptance criteria should be observable, specific, and suitable for agent implementation checks.
### Constraints

Source: `wiki/03-requirements/constraints.md`

# Constraints
## Purpose
Record limits that shape implementation.
## Compiled Truth
Constraints may include budget, stack, policy, timeline, platform, compliance, data, or team limitations.
### Functional Requirements

Source: `wiki/03-requirements/functional-requirements.md`

# Functional Requirements
## Purpose
Capture what the system must do.
## Compiled Truth
Functional requirements should be testable, traceable to user or business needs, and scoped clearly.
### Non-Functional Requirements

Source: `wiki/03-requirements/non-functional-requirements.md`

# Non-Functional Requirements
## Purpose
Capture quality attributes and operational expectations.
## Compiled Truth
Non-functional requirements should cover performance, reliability, accessibility, privacy, maintainability, and scalability where relevant.
### User Stories

Source: `wiki/03-requirements/user-stories.md`

# User Stories
## Purpose
Capture user-centered slices of value.
## Compiled Truth
Stories should describe actor, need, outcome, acceptance notes, and dependencies.
### Agent Context Folder

Source: `wiki/09-agent-context/README.md`

# Agent Context Folder
## Purpose
Orient maintainers to agent context inputs.
## Compiled Truth
Agent context files summarize wiki truth into tool-specific inputs for coding agents.
WWG should distinguish current canonical truth from reference history, generated context, and temporary notes.
Codex, Claude, and Cursor context files are generated or compiled agent-facing contexts derived from canonical wiki truth. They should not silently become the only source of truth.
### Canonical Context Policy

Source: `wiki/09-agent-context/canonical-context-policy.md`

# Canonical Context Policy
## Purpose
Define how WWG distinguishes current canonical truth from generated context, reference history, temporary notes, public surfaces, and machine-readable catalogs.
## Compiled Truth
WWG should distinguish current canonical truth from reference history, generated context, and temporary notes.
Upstream template defaults and local generated-project truth are separate. Local Project Truth wins after the project owner accepts or customizes it.
## Artifact Categories
## Canonical Families
- project/product
- requirements
- domain/rules
- architecture/runtime
### Claude Code Context

Source: `wiki/09-agent-context/claude-context.md`

# Claude Code Context
## Purpose
Provide project context for Claude Code.
## Compiled Truth
Claude context should include task framing, repo conventions, acceptance criteria, and documentation expectations.
This file is generated or compiled agent-facing context derived from canonical wiki truth. It should not silently become the only source of truth. When it conflicts with canonical wiki pages, resolve the conflict through the maintenance matrix and truth-conflict policy.
### Codex Context

Source: `wiki/09-agent-context/codex-context.md`

# Codex Context
## Purpose
Provide project context for Codex.
## Compiled Truth
Codex context should include current project truth, workflow expectations, validation commands, and known constraints.
This file is generated or compiled agent-facing context derived from canonical wiki truth. It should not silently become the only source of truth. When it conflicts with canonical wiki pages, resolve the conflict through the maintenance matrix and truth-conflict policy.
### Cursor Context

Source: `wiki/09-agent-context/cursor-context.md`

# Cursor Context
## Purpose
Provide project context for Cursor workflows.
## Compiled Truth
Cursor context should include coding style, files to inspect, constraints, and examples for inline work.
This file is generated or compiled agent-facing context derived from canonical wiki truth. It should not silently become the only source of truth. When it conflicts with canonical wiki pages, resolve the conflict through the maintenance matrix and truth-conflict policy.
### Project Master Context

Source: `wiki/09-agent-context/project-master-context.md`

# Project Master Context
## Purpose
Provide a compact active overview and routing map for generated-project agents and developers.
## Scope
This file is active context, not full canonical truth. It should point agents to the right canonical sources before work begins.
Use this file for global orientation. Use dedicated Wiki pages, Project Truth, Terminology, and Governance for durable detail.
## Current State
- Project-specific facts are not defined until the generated project owner fills Wiki truth.
- `project-truth-summary.md` and `terminology-summary.md` are compact loading surfaces when present.
- `project-truth.md` and `terminology.md` remain the full canonical sources.
- Detailed domain, UX, architecture, operations, requirements, and decisions live in dedicated Wiki folders.
- Implementation reports and temporary notes are reference history until promoted.
### Public Discovery Context

Source: `wiki/09-agent-context/public-discovery-context.md`

# Public Discovery Context
## Purpose
Provide canonical context for public discovery, SEO, GEO, AI crawler readiness, canonical URLs, route indexing, and discovery validation.
## Canonical Host
Declare the canonical production host.
## Public Route Registry
List or link to approved public routes.
## Indexable Routes
List public routes approved for indexing and sitemap inclusion.
## Noindex Routes
List private, admin, auth, operational, redirect-only, staging, preview, or ephemeral routes excluded from discovery.
## Sitemap Policy
### Reusable Prompts

Source: `wiki/09-agent-context/reusable-prompts.md`

# Reusable Prompts
## Purpose
Store reusable prompts derived from wiki truth.
## Compiled Truth
Reusable prompts should be specific, version-aware, and connected to the source pages they summarize.
Generated or compiled prompts should trace back to canonical wiki truth. If prompt guidance conflicts with canonical docs, resolve through the maintenance matrix and truth-conflict policy before spreading the prompt.
### Runtime Context

Source: `wiki/09-agent-context/runtime-context.md`

# Runtime Context
## Purpose
Provide canonical runtime context for deployment, environment, secrets, workers, queues, jobs, caches, projections, and validation.
## Authoritative Systems
Declare runtime systems that own truth.
## Derived / Cache / Projection Systems
Declare derived systems that must not become hidden sources of truth.
## Deployment Model
Summarize deployment environments, hosting, rollout, rollback, and observability.
## Environment and Secret Policy
Document configuration, secrets, runtime validation, and ownership.
## Worker / Queue / Job Policy
### Wiki Index

Source: `wiki/index.md`

# Wiki Index
## Purpose
Map the primary home for each category of project knowledge.
## Primary Homes
- Project Truth: `project-truth.md`
- Active Summary: `project-truth-summary.md`
- Terminology: `terminology.md`
- Active Summary: `terminology-summary.md`
- Principles: `principles/README.md`
- Inbox: `00-inbox/README.md`
- Sources: `01-sources/README.md`
- Source Index: `01-sources/source-index.md`
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
