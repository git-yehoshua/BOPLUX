# WWG Recommendation Registry

This registry captures useful future work discovered by agents, humans, audits, reviews, maintenance runs, retrospectives, and implementation closeouts.

Recommendations are not project truth until accepted.
Recommendations are not active work until promoted into the workspace backlog, current task, proposal, issue, or implementation plan.
Agents may add recommendations, but they must not treat recommendations as authorization to expand scope.

## Status Lifecycle

| Status | Meaning |
|---|---|
| Proposed | Captured but not reviewed |
| Accepted | Reviewed and considered useful future work |
| Promoted | Moved into backlog, proposal, issue, or current task |
| In Progress | Actively being worked on |
| Done | Completed and reconciled into relevant WWG files |
| Deferred | Useful, but intentionally postponed |
| Rejected | Reviewed and intentionally declined |
| Superseded | Replaced by another recommendation |

## Recommendation Registry

| ID | Name | Type | Source | Reason | Suggested Timing | Impact | Effort | Risk If Ignored | Status | Owner | Created | Review By | Links |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| REC-0001 | Example recommendation | Governance | Agent closeout | Explain why this should be revisited | Next minor release | Medium | Medium | Useful improvement may be forgotten | Proposed | Unassigned | YYYY-MM-DD | YYYY-MM-DD | |
| REC-0002 | Luau unit-test harness (TestEZ / Studio test runner) | Testing | Implementation closeout — Match Manager | Server-authoritative systems keep growing (Player State, Jail, Objective, Audio, Impostor); `MatchState` is isolated as a pure module specifically so phase/swap/tally/tie logic can be unit-tested. Test Enforcement otherwise falls back to manual Studio play sessions. | Before next server system completes | Medium | Medium | Logic regressions only caught in manual playtests | Proposed | Unassigned | 2026-09-05 | 2026-09-19 | `.wwg/workspace/tasks/s15-match-manager.task.md` |
| REC-0003 | Studio Script Sync / verification workflow hardening | Tooling | Implementation closeout — Player State | This session Studio Script Sync stopped applying incremental file edits for script files, forcing direct datamodel instance writes (execute_luau `script.Source` / multi_edit) with repo `.lua` files kept as canonical mirror. Also confirmed MCP `execute_luau` is VM-isolated (module state unreadable) and `FireServer` requires Client data-model context. A documented, repeatable sync + side-effect-verification route would prevent future systems (Objective, Audio, Impostor) from re-deriving this workflow. | Before Objective System implementation | Low | Low | Each future system wastes setup time and risks stale-instance bugs | Proposed | Unassigned | 2026-09-05 | 2026-09-19 | `.wwg/workspace/tasks/s15-player-state.task.md` |
| REC-0004 | Two-player Jail System verification session | Testing | Implementation closeout — Jail System | Single-client play session cannot exercise role-dependent Jail paths: real Defender-on-Attacker capture (≤1.5m), Defender exterior reset-on-touch, rescue that frees an actual occupant (rescuer + jailed must coexist), and the all-jailed Defender-win signal (needs ≥2 Attackers). All were verified by code inspection only; a 2-player session closes the evidence gap. | Before release (after Audio/Impostor pass) | Medium | Low | Role-dependent victory paths ship unverified; defects surface only in real playtests | Proposed | Unassigned | 2026-09-05 | 2026-09-19 | `.wwg/workspace/tasks/s15-jail-system.task.md` |
| REC-0005 | Two-player Objective System verification session (real Defender defuse) | Testing | Implementation closeout — Objective System | The legitimate `RequestDefuseHold` path is gated on a Defender player; with a single client the session player is always an Attacker. The Defender win was verified live with the debug `defuse` command bypassing only the role check (all other Heartbeat validation still applies: site range, stationary, planted, not jailed). A second client as Defender closes the fully-legit-path evidence gap; also naturally exercises the same-tick detonate/defuse race. | Before release (after Audio/Impostor pass) | Medium | Low | Defender defuse ships with only a debug-bypass live path; real-client defects surface only in playtests | Proposed | Unassigned | 2026-09-05 | 2026-09-19 | `.wwg/workspace/tasks/s15-objective-system.task.md` |

## Entry Guidance

Each recommendation should answer:

- What is being recommended?
- Why was it discovered?
- What evidence supports it?
- When should it be revisited?
- What is the risk if ignored?
- Should it become a backlog item, proposal, ADR, regression test, documentation update, or governance rule?

## Promotion Rule

A recommendation may only become active work when it is explicitly promoted into one of the following:

- `.wwg/workspace/current-task.md`
- a backlog or planning artifact
- a proposal under `docs/proposals` or `.wwg/proposals` if present
- an issue tracker item
- an implementation prompt
- an accepted governance rule
- a regression test plan
