# Domain Context

## Purpose

Compile domain entities, workflows, edge cases, rules, and requirements.

## Source Wiki Artifacts

- wiki/03-requirements/README.md
- wiki/03-requirements/acceptance-criteria.md
- wiki/03-requirements/constraints.md
- wiki/03-requirements/functional-requirements.md
- wiki/03-requirements/non-functional-requirements.md
- wiki/03-requirements/user-stories.md
- wiki/06-domain/README.md
- wiki/06-domain/edge-cases.md
- wiki/06-domain/entities.md
- wiki/06-domain/rules.md
- wiki/06-domain/workflows.md
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
### Domain Folder

Source: `wiki/06-domain/README.md`

# Domain Folder
## Purpose
Orient maintainers to domain knowledge.
## Compiled Truth
Domain files describe entities, workflows, rules, and edge cases independent of implementation details.
### Domain Edge Cases

Source: `wiki/06-domain/edge-cases.md`

# Domain Edge Cases
## Purpose
Collect unusual but important conditions.
## Compiled Truth
Edge cases should include expected behavior, risk, and whether they are in scope for current delivery.
### Domain Entities

Source: `wiki/06-domain/entities.md`

# Domain Entities
## Purpose
Define business objects and concepts.
## Compiled Truth
Entities should include meaning, lifecycle, owner, fields, relationships, and examples.
### Domain Rules

Source: `wiki/06-domain/rules.md`

# Domain Rules
## Purpose
Capture business rules and invariants.
## Compiled Truth
Rules should be precise enough to drive validation, tests, and agent implementation.
## Product Invariants
Product invariants are non-negotiable truths that must not be violated by implementation.
Profile starter examples:
### SaaS
- Tenant data must remain isolated.
- Authorization must be enforced server-side.
- Billing events must be auditable.
### Domain Workflows

Source: `wiki/06-domain/workflows.md`

# Domain Workflows
## Purpose
Describe important business workflows.
## Compiled Truth
Workflows should include triggers, actors, steps, outcomes, exceptions, and related requirements.
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
