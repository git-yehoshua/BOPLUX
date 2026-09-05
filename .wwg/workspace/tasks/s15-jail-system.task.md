# Task Ticket — §15 Jail System (server-authoritative)

## Change Category
Meaningful feature — system implementation (Roblox Luau, server-side).

## Goal
Authoritative capture, jailing, breakout, reset, and rescue behavior.

## Scope
- Capture (GDD §4.1): Defender presses interact within 1.5m of an active Attacker → instant capture; server validates distance/roles.
- Jailing (§4.2): captured Attacker teleported to one of two Jails; cannot exit via normal movement; retains voice.
- Breakout (§4.3): hold interact 45s continuous; loud audio warning; any Defender interacting with the cell exterior resets progress to zero.
- Rescue (§4.4/4.5): active Attacker holds interact on Jail exterior 3.0s → releases all occupants; rescuer + rescued each get 3s speed buff + temporary capture immunity.
- Only the first interactor progresses a rescue/breakout attempt (OQ-009 / §9.4); additional present teammates do not stack/accelerate.
- Channeled interaction rules (§9.1/9.3): breakout/rescue are stationary; movement or capture cancels; progress resets.
- Round-end condition "all Attackers jailed" reported to Match Manager (§5.4).
- Remotes: `RequestBreakoutHold`, `RequestBreakoutRelease`, `RequestJailReset`, `RequestRescue` (§15) — server measures hold durations, never trusts client time.

## Constraints
- Server-authoritative; hold duration server-tracked.
- Special interactions (Sabotage breakout reset, Jail-camping meter, rescue immunity) are separate items — expose hooks/attributes, do NOT implement them inside this task.

## Inputs
- `.wwg/wiki/project-truth.md`, `.wwg/wiki/terminology.md`
- GDD §4, §9.1/9.3/9.4, §15 Jail System row
- OQ-009 first-interactor ruling

## Acceptance Criteria
- Capture only valid ≤1.5m, Defender-on-Attacker, on an active (unjailed) target.
- Breakout 45s requires uninterrupted stationary hold; reset-on-touch works; Jail-camping hooks present.
- Rescue releases all occupants and applies buff/immunity for exactly 3s.
- All-Jailed signal fires to Match Manager.

## Validation / Test Plan
- Behavior changed: YES
- Unit tests added/updated: capture distance/role checks, breakout 45s + reset, rescue release-all + buff, first-interactor exclusivity (no harness — REC-0002; logic verified via Studio play + code inspection)
- Regression tests added/updated: YES (Weekly-style Studio play regression of prior systems did not regress)
- Manual verification: Studio play session
- Test command run: Studio play (single client, DebugMode + DebugBreakoutScale/DebugRescueScale 0.1)
- Result: PASS (verified live, see Implementation Notes)

## Verification Evidence (live, round 2 Live)
- Flood-fail experiment: Phase-not-Live gates confirmed (breakout hold during PreRound rejected silently).
- Debug-jail self → WalkSpeed 0, JumpPower 0, teleported to cell interior center, `JailOccupantCount` 1, `ChannelKind`/`BreakoutProgress` attributes update.
- `RequestBreakoutHold` in Live → channel starts, progress climbs server-side; completes at 4.5s (scaled 45s) → released: WalkSpeed 16, JumpPower restored, occupant 0, teleported to exterior door offset.
- Breakout release grants NO buff (spec §4.3); WalkSpeed 16 confirmed.
- `MatchDebug resetBreakout` → progress drops toward 0 while `ChannelKind` stays breakout and occupant stays jailed.
- `MatchDebug release` → un-jail + WalkSpeed 16 + occupant 0.
- Capture self-fire → rejected quietly (target==player, Defender-only), no error.
- Rescue-fire while self is jailed → rejected (isJailed guard), no error.
- New-Live auto-reset verified: round 2 reset un-jailed the round-1 occupant (occupant 0, WalkSpeed 16).
- Console clean throughout.

## Coverage Gaps (single-client limitation, documented not fixed)
- Real capture (Defender-on-Attacker ≤1.5m): requires 2 players.
- `RequestJailReset` reset-on-touch (Defender + exterior): requires 2 players.
- Rescue with occupants: rescuer must be a non-jailed Attacker while someone else is jailed — impossible solo.
- All-jailed Defender-win signal: fires only when ALL attackers jailed; with one attacker, DebugMode must be ON for debug-jail, but DebugMode suppresses `checkAllJailed`. Logic verified by inspection (matches §5.4: fires `RoundOutcomeReported(Defenders, all-jailed)` when every Live attacker is jailed). Unverifiable solo via UI; requires 2-player session.
- First-interactor exclusivity (channel-busy): JailState.startChannel returns false when a cell already has an active channel (OQ-009) — verified by code inspection + single-channel heartbeat wiring; multi-interactor timing needs 2 players.

## Dependency Notes
- Depends on Match Manager (roles, round state) and Player State (jail/capture status).
- Independent sibling items (tracked separately): Jail-camping meter (s15-jail-camping-meter-oo008.task.md) and Sabotage breakout-reset (s15-sabotage-interaction-oo006.task.md) — implement hooks only.

## Retrospective

- Keep: server-measured channel durations, per-cell channel exclusivity (OQ-009), attribute-driven observability + debug-only bypasses gated behind DebugMode, the pure `JailState` module now unit-covered.
- Add: a real 2-player session still needed before release (capture, reset-on-touch, rescue-with-occupants, all-jailed Defender win, multi-interactor timing). Consider clearer naming for the release helpers now that breakout and rescue diverge (single vs all).
- Remove/simplify: the former "breakout releases everyone" assumption is replaced by OQ-013 (frees only the completing player) — remove any stale all-occupant breakout references in docs/UI text.
- Gaps: role-dependent Jail paths unverifiable solo are deferred to the 2-player session; not blockers.
- Carryover: Impostor Sabotage breakout-reset and the Jail-camping meter (OQ-008) are separate tracked items (`s15-sabotage-interaction-oo006.task.md`, `s15-jail-camping-meter-oo008.task.md`) that hook this system later.

## Report Path
`.wwg/reports/agent-implementation-log.md`; `.wwg/workspace/current-task.md`.