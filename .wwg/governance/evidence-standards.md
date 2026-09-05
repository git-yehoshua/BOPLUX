# Evidence Standards

## Purpose

Define how WWG agents should classify, report, and support claims during implementation, debugging, monitoring, and governance review.

## Evidence Ladder

| Level | Meaning | Acceptable Support |
|---|---|---|
| Confirmed | Proven by direct evidence | Reproduction, test, log, trace, DB state, code path, config, deployment output |
| Likely | Strongly suggested but not fully proven | Multiple consistent signals, partial logs, correlated metrics |
| Hypothesis | Plausible but unverified | Known failure pattern, code smell, temporal correlation |
| Unknown | Not enough evidence | Missing logs, inaccessible environment, unreproduced issue |

## Rules

- Do not present hypotheses as confirmed causes.
- Every root-cause claim must map to concrete code paths, logs, tests, config, database state, or reproduction.
- Separate confirmed issues from likely issues, hypotheses, benign signals, and unknowns.
- When evidence is sampled, say so.
- When evidence is unavailable, say what is missing.
- Recommendations must state their evidence level.
- Truth conflicts must record evidence level for each conflicting claim before deciding whether docs, code, generated context, or governance should change.

## Output Format

Evidence-backed reports should list claim, evidence level, supporting evidence, missing evidence, recommendation, and follow-up workflow.

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
