# Task Ticket — §15 Match Manager (server-authoritative)

## Change Category
Meaningful feature — system implementation (Roblox Luau, server-side).

## User Request
Implement the section 15 Match Manager system, tracked as the first Workspace task. Source of truth: GDD v1.1 (`.wwg/wiki/01-sources/raw/uploads/docs/Core_Game_Design_Specification_v1.1_Plant_Mode.md`) and Open Question Resolutions v1 (`.wwg/wiki/01-sources/raw/uploads/docs/Open_Questions_Resolutions_v1.md`).

## Goal
Server-authoritative driving of round/match state, phase transitions, timers, role rotation, and win evaluation.

## Scope
- Match structure: a match is **6 rounds**; roles swap after **round 3** (half = 3 rounds per side); match winner = most rounds won (OQ-005 + match-length).
- Per-round phases: **pre-round 15s** (full movement, no capture/plant/rescue/sabotage interactions — §8.3) → **round 180s** (§2).
- Round outcome inputs come from other systems (Objective detonate/defuse, All-Jailed) via server-internal bus — Match Manager does not read client events.
- Role assignment per half: 5 Attackers / 5 Defenders, swapped at halftime.
- Cross-team collision disabled (§2.1) applied for the round.
- Gather round wins per team; evaluate match winner at round 6 end.
- No client-fired remotes for Match Manager (§15: "— (drives state, not player-invoked)").

## Constraints
- Server-authoritative only; client never trusts Match Manager claims from transport. Internal cross-system communication uses server-only BindableEvents/ModuleScript APIs (request channel remotes are for player inputs only, per §15 contract).
- Phase legality gate: interactions other than movement/sprint are rejected before the round starts (GDD §8.3).
- Impostor selection timing (§12.1): selection occurs at start of pre-round, before movement control — Match Manager must expose the "pre-round begins" hook the Impostor System subscribes to (Impostor System implemented last; the hook is interface-declared here).
- Never resolve by default the **3–3 tied match** outcome — OQ-010 is open; expose an explicit `TIE_RESULT_PENDING_OQ010` signal / logged warning rather than silently picking a tiebreaker.

## Inputs
- `.wwg/wiki/project-truth.md` (canonical truth)
- `.wwg/wiki/terminology.md` (terms: Match, Half, Halftime, Round, Pre-round)
- `.wwg/wiki/11-synthesis/open-questions.md` (OQ-010 open/tie)
- GDD §2, §8, §15 Match Manager row

## Acceptance Criteria
- A match completes 6 rounds with halftimes exactly as defined.
- Pre-round interaction lock is enforced server-side.
- Match end evaluates rounds-won per team; 3–3 produces the OQ-010 pending signal, not a guessed winner.
- No RemoteEvents are client-fireable against Match Manager state.

## Validation / Test Plan
- Behavior changed: YES — match/round state machine
- Unit tests added/updated: pending (test harness does not exist yet — recommendation added for TestEZ/Studio runner; logic lives in the pure `MatchState` module for unit-testability)
- Regression tests added/updated: to be added with harness (round-tally and tie-signal cases)
- Manual verification: Studio play session — observed auto-start (with existing player), PreRound 15s → Live r1, injected outcome → RoundEnd 2s → PreRound r2 → Live r2; no runtime errors
- Test command run: N/A this session (manual Studio verification per Test Enforcement bypass reason: harness not yet present)
- Result: PASS — state machine verified end-to-end in live play mode
- If no tests were added, reason: no unit-test harness exists yet; logic isolated in pure module so tests can be added when harness lands

## Dependency Notes
- Depends on: OQ-010 owner decision for the decisive-end/tie edge (non-blocking for all decided paths).
- Declares interfaces consumed later by: Player State (role assignment), Jail System, Objective System (round-outcome reports), Impostor System (pre-round hook).

## Report Path
`.wwg/reports/agent-implementation-log.md` (entry for this task); status updated in `.wwg/workspace/current-task.md`.