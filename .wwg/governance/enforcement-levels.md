# Enforcement Levels

## Purpose

Define WWG enforcement levels from advisory guidance to approval-gated changes.

## Levels

| Level | Name | Definition |
|---:|---|---|
| 0 | Advisory | Docs recommend review, but no enforcement. |
| 1 | Agent-required | AGENTS, skills, and prompts require the agent to review and report maintenance actions. |
| 2 | Local validation | Local scripts check structure, schema validity, generated markers, reports, and obvious drift. |
| 3 | CI warning | CI reports possible drift or missing maintenance actions but does not block merges. |
| 4 | CI blocking | CI blocks high-risk drift, invalid schemas, broken generated sections, missing required approval, or failed tests. |
| 5 | Approval-gated | Human approval is required before release-impacting changes, high-risk public messaging, compliance-sensitive updates, production config changes, data migrations, permission changes, or irreversible operations. |

## Enforcement Stance

Default local governance should primarily use Level 1 and Level 2 enforcement. CI workflows may add Level 3 and Level 4 automation.

Level 5 applies conceptually whenever approval-gated changes are documented, even before full automation exists.

Generated-project maintenance should use Level 1 agent-required checks and Level 2 local validation for template-vs-project boundaries.

## Output Format

Governance reports should state the enforcement level applied and any missing automation.

## Generated Governance Context

<!-- WWG_GENERATED:SELECTED_PROFILE_GATES:START -->
- .wwg/governance Profiles (governance/profiles/README.md): # .wwg/governance Profiles
- Game Governance Profile (governance/profiles/game/governance-profile.md): # Game Governance Profile
- .wwg/wiki Profiles (wiki/profiles/README.md): # .wwg/wiki Profiles
- Game Profile (wiki/profiles/game/README.md): # Game Profile
- Game Governance Additions (wiki/profiles/game/governance-additions.md): # Game Governance Additions
- Game Wiki Additions (wiki/profiles/game/wiki-additions.md): # Game Wiki Additions
- Game Workspace Additions (wiki/profiles/game/workspace-additions.md): # Game Workspace Additions
<!-- WWG_GENERATED:SELECTED_PROFILE_GATES:END -->

<!-- WWG_GENERATED:APPROVAL_GATED_AREAS:START -->
- Governance level: standard
- Production configuration, compliance-sensitive behavior, pricing, billing, permissions, security posture, legal/trust messaging, public customer notices, data deletion/migration, and irreversible operations require approval-gated handling.
- Selected profiles reviewed: game
<!-- WWG_GENERATED:APPROVAL_GATED_AREAS:END -->

<!-- WWG_GENERATED:EVIDENCE_STANDARDS_SUMMARY:START -->
Claims about root cause, fixes, operational state, drift, release readiness, and approval decisions must cite code paths, logs, tests, config, database state, deployment output, source artifacts, or reproduction evidence.
<!-- WWG_GENERATED:EVIDENCE_STANDARDS_SUMMARY:END -->
