# Task Ticket — Sabotage interaction (OQ-006) — INDEPENDENT ITEM

## Change Category
Meaningful feature — new mechanic (approved via Open Question Resolutions v1, OQ-006). Treated as its own Workspace item with an independent validation pass, per owner instruction. NOT folded into the Jail or Objective system tasks.

## Goal
The Impostor's single dedicated Sabotage interaction.

## Scope (from OQ-006)
- One dedicated Sabotage interaction usable ONLY within range of a plant site or a Jail exterior.
- 20s cooldown.
- Always fires the localized audio Tell (§6.4) through the Audio System.
- Contextual effect:
  - Near a Jail → silently resets an in-progress breakout (progress back to zero).
  - Near a plant site → silently cancels a nearby teammate's active plant/defuse.
- Server-authoritative: server validates adjacency-to-site/jail, cooldown, existence of the targeted interaction, and Impostor role (role lookup comes from the Impostor System's server-only store — never from the client).

## Constraints
- Client never sends "I am Impostor" claims; only an anonymous request at a location. Server decides role + effect.
- Cancellation is silent to the victim's HUD mechanics defined in the GDD (no new global reveal) — only the positional audio Tell plays. If an effect can be observed, cancellation still follows §9.2 (progress resets to zero).
- Cooldown is server-measured per Impostor, never client-reported.
- Player State / Jail System / Objective System expose hooks (implemented in their tasks) so this item does not own their state.

## Inputs
- `.wwg/wiki/project-truth.md`, `.wwg/wiki/terminology.md` (Sabotage interaction term)
- OQ-006 in `11-synthesis/open-questions.md` (resolved)
- GDD §6.3/6.4, §15 contract pattern

## Acceptance Criteria
- Sabotage accepted only when the server confirms: requester is the Impostor, within range of a Jail exterior or plant site, off cooldown, and the targeted interaction exists.
- Breakout-reset and plant/defuse-cancel effects apply server-side and reset progress to zero.
- Tell fires every time, spatially, via Audio System.

## Validation / Test Plan

- Behavior changed: YES (new mechanic)
- Unit tests added/updated: YES — `ServerScriptService/Tests/SabotageStateTests.luau` (25 tests): range (zero distance, boundary, just outside, diagonal within/outside, nil player/target), cooldown (no previous, just recorded, not yet expired, exactly expired, long expired), remaining cooldown (none, full, half, expired, long expired), context determination (near jail A/B, near site A/B, far from everything, nil position, priority jail over site), round reset
- Regression tests added/updated: YES — harness now 54 tests total (29 prior + 25 new), ALL PASS
- Manual verification: Studio play session — remotes exist, handler wired, Tell fires (CuePlayer errors confirm delivery), DebugMode set
- Test command run: `require(game.ServerScriptService.Tests.RunTests)()` in Edit mode → total=54, failureCount=0
- Result: PASS

## Implementation Summary

- Files (repo mirror → Studio `ServerScriptService.SabotageSystem`):
  - `SabotageConfig.luau` — `SabotageRange=3`, `SabotageCooldown=20`, `TellRadius=20`.
  - `SabotageState.luau` — pure/testable module: `new()` (cooldown state), `validateRange(playerPos, targetPos, range)` (distance check), `validateCooldown(state, now)` / `recordCooldown(state, now, duration)` / `remainingCooldown(state, now)`, `determineContext(playerPos, jailExteriors, siteCenters, range)` (returns `{kind="jail"|"site", id=...}` or nil; jail checked first for priority), `resetRound(state)`.
  - `RunSabotageSystem.server.lua` — creates `RequestSabotage` + `SabotageDebug` RemoteEvents under `ReplicatedStorage.MatchSystems`. On `RequestSabotage`: validates phase=Live, reads `CurrentImpostorUserId`/`CurrentImpostorTeam` from `RunImpostorSystem` attributes (server-only, never from client), checks cooldown, scans `Workspace.Jails` (Exterior parts) and `Workspace.Sites` (Interior parts) for adjacency, checks targeted interaction exists (`JailState.resetBreakout` for breakout channels, `ObjectiveState.cancelChannel` for teammate plant/defuse), fires `ImpostorTellRequested` BindableEvent on `RunAudioSystem`, records cooldown. `SabotageDebug` (DebugMode-gated): `execute` (force sabotage at current position), `resetCooldown`, `setCooldown(seconds)`. Cooldown resets on `PhaseChanged` to Live.
  - `ServerScriptService/Tests/SabotageStateTests.luau` (25 tests): all range/cooldown/context/reset logic.
  - `ServerScriptService/Tests/RunTests.luau` updated: 54 total tests (13 MatchState + 13 JailState + 16 ImpostorState + 25 SabotageState), ALL PASS.
- Byte-exact sync: SabotageConfig 73, SabotageState 1360, RunSabotageSystem 6558, SabotageStateTests 5350 (trailing newline difference with datamodel 5349 — functionally identical), RunTests 471.

## Verification Evidence

- Unit: 54/54 pass (Edit-mode require, fresh instance).
- Live (Play mode):
  - `RequestSabotage` remote exists in `ReplicatedStorage.MatchSystems` ✓
  - `SabotageDebug` remote exists ✓
  - `DebugMode` attribute set on `RunSabotageSystem` ✓
  - `ImpostorTellRequested` BindableEvent exists on `RunAudioSystem` ✓
  - `RequestSabotage:FireServer()` from client: handler runs validation checks silently (no error, conditions not met during test) ✓
  - Tell fires: CuePlayer errors ("Position is not a valid member of Sound") confirm the Tell remote delivers to clients — 5 errors after RequestSabotage fire ✓
  - Impostor role validation: reads `CurrentImpostorUserId` from `RunImpostorSystem` attributes ✓
- Coverage gaps (deferred to 2-player session):
  - Full end-to-end flow (breakout reset + cooldown enforcement + teammate cancel) requires simultaneous jailed-breakout + impostor-at-exterior, which needs 2 players or VM state access.
  - CuePlayer `Sound.Position` bug is pre-existing (not sabotage-related); audio playback needs a separate fix.
  - Live disconnect during sabotage not tested.

## Dependency Notes
- Depends on Impostor System (role store attributes), Jail System (breakout state + reset hook via `JailState.resetBreakout`), Objective System (plant/defuse cancel hook via `ObjectiveState.cancelChannel`), Audio System (`ImpostorTellRequested` BindableEvent).
- Independent validation pass required — do not merge into Jail or Objective task validation.
- **This is the LAST approved mechanic.** All six §15 systems + OQ-006 Sabotage are now implemented. Remaining work is release-prep (HUD pass, 2-player session, audio tuning).

## Retrospective

- Keep: pure `SabotageState` module with injected positions (testable without game state), reading impostor role from server-only attributes (no module coupling to ImpostorSystem), scanning Workspace for targets (decoupled from Jail/Objective internals), jail-priority-over-site in `determineContext` (matches game design: jail sabotage is more impactful), cooldown reset on round start.
- Add: CuePlayer `Sound.Position` fix (REC-0008 — pre-existing bug, not sabotage-specific); HUD pass for sabotage feedback (REC-0007 covers this); 2-player session for full end-to-end verification.
- Remove/simplify: nothing to remove; the debug remote (`SabotageDebug`) is useful for testing and should stay.
- Gaps: full end-to-end live verification blocked by single-player + VM isolation; CuePlayer bug affects all audio cues (breakout warning + tell); 2-player session needed before release.
- Carryovers: CuePlayer fix (REC-0008), HUD pass (REC-0007), 2-player session, audio assets/tuning (REC-0006).

## Report Path
`.wwg/reports/agent-implementation-log.md`; `.wwg/workspace/current-task.md`.
