# UX Context

## Purpose

Compile UX principles, content standards, screens, journeys, and public surface considerations.

## Source Wiki Artifacts

- wiki/07-ux/README.md
- wiki/07-ux/content-guidelines.md
- wiki/07-ux/design-preferences.md
- wiki/07-ux/design-principles.md
- wiki/07-ux/reference-screenshots.md
- wiki/07-ux/screens.md
- wiki/07-ux/user-journeys.md
- wiki/08-operations/public-discovery.md
- wiki/08-operations/public-surface-updates.md
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

### UX Folder

Source: `wiki/07-ux/README.md`

# UX Folder
## Purpose
Orient maintainers to user experience truth.
## Compiled Truth
UX files describe journeys, screens, interaction principles, and content guidance.
UI/app profiles may add the governed UI/UX principle pack under `.wwg/wiki/principles/`, `.wwg/wiki/design-system/`, `.wwg/workspace/context/`, and `.wwg/workspace/checklists/`. The pack guides user-facing and agent-facing surfaces, but the target app still owns rendering and runtime behavior.
### Content Guidelines

Source: `wiki/07-ux/content-guidelines.md`

# Content Guidelines
## Purpose
Define voice, labels, and message patterns.
## Compiled Truth
Content guidelines should keep product text consistent, clear, and appropriate for users.
### Design Preferences

Source: `wiki/07-ux/design-preferences.md`

# Design Preferences
## Purpose
Design direction inferred from user answers and visual references.
Generated design reference summary here.
## Human Notes
### Design Principles

Source: `wiki/07-ux/design-principles.md`

# Design Principles
## Purpose
Capture product-specific design rules.
## Compiled Truth
Design principles should guide layout, tone, density, accessibility, and interaction behavior.
## Default Lightweight Guidance
All generated projects may have human-facing outputs such as README files, reports, checklists, docs, CLI messages, or handoff artifacts. Keep those outputs clear, accessible, and action-oriented.
Do not assume every project is a UI product. Full UI/UX principle-pack surfaces are profile-propagated for app, web, agent interface, internal tool, mobile, and game projects rather than copied into every workspace.
## Design Source of Truth
UI/UX changes must review design source-of-truth files. Meaningful changes to visual language, component behavior, page layout, loading states, empty states, responsive behavior, or admin presentation must update design docs.
If a project has a standalone `DESIGN.md`, agents must treat it as canonical.
## Optional UI/UX Principle Pack
### Reference Screenshots

Source: `wiki/07-ux/reference-screenshots.md`

# Reference Screenshots
## Purpose
Visual references uploaded or linked by the user.
## Human Notes
### Screens

Source: `wiki/07-ux/screens.md`

# Screens
## Purpose
Track screens and their purpose.
## Compiled Truth
Screen notes should list users, primary actions, states, empty states, errors, and data shown.
## Design Source of Truth
For each meaningful screen, capture:
- Primary user and goal
- Main actions
- Data shown
- Loading state
- Empty state
### User Journeys

Source: `wiki/07-ux/user-journeys.md`

# User Journeys
## Purpose
Map user paths through the product.
## Compiled Truth
Journeys should identify goals, entry points, steps, decisions, friction, and success states.
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
