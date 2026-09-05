# Current Task

## Task Summary

- Status: DONE (this session) — first four §15 server-authoritative systems implemented and verified in Studio (Match Manager, Player State, Jail System, Objective System)
- Task mode: Meaningful feature (system implementation, Roblox Luau, server-side)
- User request: Begin §15 systems as tracked Workspace tasks in order — Match Manager → Player State → Jail → Objective → Audio → Impostor last. Confirm open questions OQ-001…OQ-009 (plus match length) closed before implementation; keep OQ-010 flagged open.

## Task Classification

- Classification: meaningful feature
- Delivery mode: AI-agent
- High-risk areas touched: none beyond normal gameplay networking (server-authoritative only, no auth/payment/persistence)

## Decisions Confirmed Before Implementation

- OQ-001…OQ-009 + match-length definition: CLOSED (DECIDED in Open Question Resolutions v1), promoted to Project Truth / Terminology. All nine confirmed closed in `.wwg/wiki/11-synthesis/open-questions.md` before §15 code began.
- OQ-010 (3–3 tied match outcome): still OPEN, owner decision required. Match Manager exposes `tie_pending_oq010` instead of picking a default.

## Implementation Summary — Match Manager (Task s15-match-manager)

- Files (Script Sync roots → Studio Place1, `ServerScriptService.MatchManager`):
  - `MatchConfig.lua` — constants (6 rounds, 3/half, 15s pre-round, 180s round, 2s round-end grace, 5/team, 10 max).
  - `MatchState.lua` — pure/testable state machine: phases Idle → PreRound → Live → RoundEnd → (repeat) → MatchEnd; halftime role swap after round 3; per-round outcome intake via `reportOutcome` (live-phase only); round tally; match result builder (attacker/defender win, or `tie_pending_oq010`).
  - `MatchManager.server.lua` — Script driving `MatchState.step` on Heartbeat; auto-starts match when players exist; fires server-internal BindableEvents (`PhaseChanged`, `PreRoundStarted` pre-impostor hook, `RoundEnded`, `MatchEnded`, `RoundOutcomeReported` input bus); publishes phase/round as Script attributes and via `shared.MatchPhaseApi` for other server systems.
- Behavior verified live in Studio (play mode):
  - Auto-start with existing player; PreRound(15s) → Live(round 1).
  - Injected `RoundOutcomeReported("Defenders", test)` during Live → RoundEnd (2s) → PreRound(round 2) → Live(round 2).
  - No script runtime errors in Edit or Server data model.
- Assumptions made (GDD does not specify — flagged, NOT silently fixed):
  - Team split policy: first 5 joined players initial Attackers, next 5 Defenders; applies even with fewer players (OQ-011).
  - "No late join" scope: players arriving after match start sit out the current match and are placed in the next one (OQ-012).

## Implementation Summary — Player State (Task s15-player-state)

- Files (Script Sync roots → Studio Place1, `ServerScriptService.PlayerState`):
  - `PlayerStateModule.lua` (ModuleScript) — authoritative per-player state: register/unregister, heartbeat `step` (6s sprint drain, regen 1/3 per s not sprinting, auto-stop at 0), `requestSprint` (denied when jailed or stamina <= 0), `setJailed`/`isJailed`, capture-immunity and rescue speed-buff grants, `resetPlayerRound`/`resetAllPlayers` (fires on Live phase).
  - `RunPlayerState.server.lua` (Script) — collision groups (cross-team non-collidable, same-team + world collidable), group applied to character on spawn and role changes; `RequestSprint` RemoteEvent created in `ReplicatedStorage.MatchSystems`; LockFirstPerson camera; Heartbeat stamina loop; Match Manager PhaseChanged wiring (PreRound→syncAllRoles, Live→resetAllPlayers, Halftime→syncAllRoles); 0.1s toggle cooldown.
  - `ReplicatedStorage/Shared/StaminaConstants.lua` — client-visible constants reserved for later UI.
- Behavior verified live in Studio (play mode): sprint accepted → WalkSpeed 25; after ~6.3s continuous sprint → auto-stop back to 16; firing sprint again right after → accepted at 25 (continuous regen, no lockout, per OQ-007); character CollisionGroup = "Attackers"; no console errors.
- Bugs fixed during verification: `CharacterAdded` callback signature (was receiving the character as the "player", crashing `teamFor` with "UserId is not a valid member of Model"); deprecated `SetPartCollisionGroup` → `part.CollisionGroup`; stale module instance in the datamodel replaced via direct instance write (Studio Script Sync had stopped applying incremental changes in this session).
- No Impostor role data in Player State surface (constraint honored).

## Implementation Summary — Jail System (Task s15-jail-system)

- Files (Script Sync roots → Studio Place1, `ServerScriptService.JailSystem`):
  - `JailConfig.lua` (ModuleScript) — capture (1.5m), breakout (45s), rescue (3.0s), buff (3s), exterior/interior/move-cancel ranges, cell count (2).
  - `JailState.lua` (ModuleScript) — pure domain: cell registry, jail/release/release-all, per-cell channel exclusivity (OQ-009 first-interactor), server-measured progress stepping, `resetBreakout`, `resetRound`.
  - `RunJailSystem.server.lua` (Script) — two placeholder cells under `Workspace.Jails` (observability attributes: CellId, JailOccupantCount, ChannelKind, BreakoutProgress, RescueProgress); `JailEvents` BindableEvents; remotes `RequestCapture/RequestBreakoutHold/RequestBreakoutRelease/RequestJailReset/RequestRescue` + debug-only `MatchDebug`; Live-gated hold channels validated each Heartbeat (phase, stationary vs MoveCancelRange, inside/exterior); jail completion → release (breakout rewardless, rescue grants 3s speed buff + capture immunity to rescued + rescuer); jailed players' WalkSpeed/JumpPower re-asserted 0; `checkAllJailed` fires `RoundOutcomeReported(Defenders, all-jailed)` (suppressed under DebugMode); new-Live `JailState.resetRound()`; PlayerRemoving cleanup.
  - `PlayerStateModule.setJailed` extended: JumpPower 0 while jailed, 50 when released.
- Behavior verified live in Studio (play mode, DebugMode + DebugBreakoutScale/DebugRescueScale 0.1): debug-jail → WS 0 / JP 0 / occupant 1 / inside cell; Live breakout hold → progress climbs → auto-completes at 4.5s → released (WS 16, occupant 0, exterior teleport, no buff); resetBreakout → progress collapses while channel persists; debug release → WS 16; capture-self and rescue-while-jailed rejected; round-2 Live auto-reset cleared round-1 occupant; no console errors.
- Coverage gaps (single client, documented in ticket): real Defender capture, Defender exterior reset-on-touch, rescue with occupants, all-jailed signal — need a 2-player session; verified by inspection (§5.4 wiring correct).
- Assumption surfaced: OQ-013 — breakout releases ALL occupants rewardlessly (GDD §4.3 silent; mirrors §4.5 rescue's all-occupant release). Flagged in `open-questions.md`.

## Implementation Summary — Objective System (Task s15-objective-system)

- Files (Script Sync roots → Studio Place1, `ServerScriptService.ObjectiveSystem`):
  - `ObjectiveConfig.lua` (ModuleScript) — SiteCount 2, PlantSeconds 5.0, DefuseSeconds 7.0, DetonationSeconds 45.0, SiteRange 2.0, MoveCancelRange 0.35.
  - `ObjectiveState.lua` (ModuleScript) — pure domain: site registry/centers, plant flag, per-site channel exclusivity (OQ-009 first-interactor) + player-busy, `startChannel`/`cancelChannel`/`cancelChannelFor`/`channelInfo`/`stepChannel`/`stepDetonation`/`detonationRemainingOf`/`resetRound`.
  - `RunObjectiveSystem.server.lua` (Script) — builds 2 placeholder sites under `Workspace.Sites` (Pad + Beacon + invisible 4×4×4 `Interior` marker with observability attributes SiteId/Planted/ChannelKind/PlantProgress/DefuseProgress/DetonationRemaining); remotes `RequestPlantHold/RequestPlantRelease/RequestDefuseHold/RequestDefuseRelease` + `ObjectiveDebug` (DebugMode-gated; commands `plant`/`defuse`/`reset` — `defuse` bypasses only the Defender role gate for 1-client verification); `ObjectiveEvents` bindables (PlantCompleted/DefuseCompleted/Detonated); Live-gated hold channels validated each Heartbeat (phase, parented, not jailed, defuse-requires-planted, XZ site range, stationary vs MoveCancelRange); plant complete → `markPlanted` + `MatchState.supersedeRoundTimer`; defuse complete → `RoundOutcomeReported(Defenders, "defused")`; detonation complete → `RoundOutcomeReported(Attackers, "detonation")`; per-tick `outcomeFiredThisTick` guard; new-Live `resetRound`; PlayerRemoving cleanup.
  - `MatchState.lua` extended — added `roundTimerSuperseded` field (reset in `beginPreRound`) + `MatchState.supersedeRoundTimer(state)` API; Live step `elseif (not state.roundTimerSuperseded) and remaining <= 0` so a planted round concludes by detonation, not the round timer (§10).
- Behavior verified live in Studio (play mode):
  - Attacker win: walk-up → real `RequestPlantHold` → `PlantProgress` climbs (4.27/5.0 observed) → completes at 5.0s → `Planted=true` → timer superseded → detonation (45s real / 4.5s debug-scaled) → `RoundOutcomeReported(Attackers, "detonation")` → round ends. Verified with both timing profiles.
  - Defender win: debug plant + debug defuse → defuse channel stepped 0.7s → `RoundOutcomeReported(Defenders, "defused")` captured live by a server-side listener (OUTCOME@2.67 with detonation still at 3.6s). Round ended with DetonationRemaining 0 — no, with det 3.6 remaining → Defender won before detonation.
  - Movement cancel: started hold then moved ~112m → channel cancelled, progress reset 0, round still Live; repeated in a tight run (hold → move before 5s) with the same result.
  - Release: `RequestPlantRelease` mid-channel → channel cleared.
  - Plant-while-planted rejected (guard on `plantedSite()`); site range enforced (XZ-only, 2.0m); defuse requires a planted site (Heartbeat validate).
  - Round 2 Live auto-reset cleared `Planted`/detonation/channels from round 1.
- Coverage gaps (single client, in ticket): real Defender defuse through the legit `RequestDefuseHold` role gate (debug `defuse` bypasses only the role check; all other Heartbeat validation still enforced); same-tick defuse-vs-detonation race not exercised at exact parity; keyboard walk-up/hold input not used (MCP navigation equivalent).
- Assumptions surfaced: (1) site range interpreted as XZ (horizontal "on the site") because placeholder pads sit on uneven Terrain and a strict 3D range was untestable; (2) same-tick defuse-before-detonation ordering in the Heartbeat; (3) placeholder site heights anchor to local Terrain top (y≈4), replaced by real map later.

## Next Task

- `.wwg/workspace/tasks/s15-audio-system.task.md` — Audio System, fifth in the mandated order.

## Verification Route Notes (important learning)

- `RemoteEvent:FireServer` from Server data model throws "FireServer can only be called from the client". Player-behavior verification uses `execute_luau` with `datamodel_type=Client` (the simulated player fires the remote; replicated humanoid properties are readable).
- MCP `execute_luau` runs in a VM isolated from running scripts — `require()` returns a fresh module instance, so verifying module-internal state must go through data-model side effects (attributes, properties), not module reads.
- Studio Script Sync: in this session incremental file edits stopped flowing into the place for script files. Reliable route = write instances into the datamodel directly (script.Source via execute_luau / multi_edit) and keep repo `.lua` files as canonical mirror.

## Test / Verification Plan

- Behavior changed: YES (match/round state machine; player state/sprint/stamina/collision; capture/jail/breakout/rescue)
- Unit tests added: pending harness (TestEZ/Studio test runner) — recommended in `.wwg/governance/recommendation-registry.md`
- Regression tests added: pending harness
- Manual verification: Studio play session — transitions observed as recorded above (Match Manager round cycling; Player State sprint/stamina; Jail System capture/breakout/reset/release)
- Test command run: N/A this session (manual Studio verification used)

## Changelog Plan

- Meaningful change introduced: YES (Match Manager, Player State, Jail systems)
- CHANGELOG.md updated or changelog command run: YES
- Version affected: 0.1.x (pre-release)
- Minor/major recommendation: NO

## README Plan

- README.md updated or README command run: NO — system detail routed to Wiki/CHANGELOG per governance; README stays concise
- Docs routing needed: NO
- README validation status: not run (no README change)

## Close-Out Notes

- Truth Alignment Status: GREEN
- Remaining concerns:
  - OQ-010 open (tie match) — Match Manager already emits `tie_pending_oq010`
  - OQ-011 / OQ-012 flagged implementation assumptions — owner confirmation requested
  - OQ-013 open (breakout release scope — Jail System assumed release-all, rewardless) — owner confirmation requested
  - Objective System assumptions flagged: XZ-only site range (§9.2 reading), same-tick defuse-before-detonation ordering, placeholder site geometry — all documented in ticket
  - Unit-test harness absent — recommendation added; tests deferred to harness
  - Studio Script Sync flakiness (incremental file edits not applied this session) — instances written directly into datamodel; REC covers a repeatable sync/verification route
  - Jail System 2-player coverage gaps (real capture, Defender reset, rescue-with-occupants, all-jailed signal) — documented in ticket; needs a second client session
  - Objective System 2-player coverage gap (real Defender defuse through the role gate) — documented in ticket; debug `defuse` bypasses role only for 1-client verification
- Natural next prompt: "Review the Jail and Objective System verification evidence, then continue with the Audio System (s15-audio-system.task.md)."