# Public Surface Review

## Purpose

Review user-facing and stakeholder-facing communication needs after meaningful shipped behavior, capability, policy, constraint, or release changes.

## How to Use

Use during feature completion, release signoff, permission changes, safety changes, pricing changes, compliance-sensitive changes, and user-impacting bug fixes.

## Rules

- Meaningful user-facing behavior changes must review public-surface update needs.
- Public copy should describe user outcomes, not internal implementation details.
- Drafts must remain unpublished unless explicit approval is given.
- Approval rules must be documented.
- Public copy must match shipped truth.
- Public copy should avoid internal backend details unless the audience is technical.
- Human approval is required when the public message affects customers, legal/compliance posture, pricing, permissions, safety, or trust.
- Public discovery review is required when public routes, metadata, sitemap, robots.txt, llms.txt, structured data, or index/noindex policy changes.

## Public Writing Guidance

Lead with what users can do, notice, avoid, trust, unlock, approve, or understand. Translate internal fixes into user outcomes. Keep technical implementation details in engineering docs unless the public audience needs them.

## Profile Examples

- SaaS App: release notes, billing notices, onboarding changes, admin dashboard changes.
- Agent WebApp: tool permission notices, agent capability changes, human review policy changes, safety disclaimers.
- Game: patch notes, gameplay updates, balance notes, event announcements.
- Fintech: customer notices, payment status wording, transaction support articles, compliance-sensitive disclosures.
- Internal Tool: internal announcements, SOP updates, admin notices, workflow change notices.
- Mobile App: app store release notes, permission explanations, onboarding screens, push notification copy.

## Output Format

Record surfaces reviewed, copy drafted, approval owner, publication status, and unresolved risks.

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
