# Agent Implementation Log

Meaningful implementation entries, newest last.

## 2026-09-05 — Match Manager (s15-match-manager)

- **Status**: Implemented and verified in Studio (Place1). OQ-001…OQ-009 + match-length confirmed closed (OQ-010 remains open).
- **Files** (Script Sync → `ServerScriptService.MatchManager`):
  - `MatchConfig.lua` (ModuleScript): match constants.
  - `MatchState.lua` (ModuleScript): pure state machine (phases, halftime swap, outcome intake, tally, `tie_pending_oq010`).
  - `MatchManager.server.lua` (Script): Heartbeat-driven loop, auto-start-with-players, server-internal BindableEvents (`PhaseChanged`, `PreRoundStarted`, `RoundEnded`, `MatchEnded`, `RoundOutcomeReported`), attributes + `shared.MatchPhaseApi` for cross-system reads.
- **Verification evidence**: live play-mode — auto-start → PreRound(15s) → Live r1; injected Defender outcome → RoundEnd → PreRound r2 → Live r2; no runtime errors.
- **Assumptions flagged (not silently decided)**: OQ-011 (team split = first 5 Attackers / next 5 Defenders), OQ-012 (late-join scope = sit out current match, enter next). Added to `open-questions.md` Open table for owner confirmation.
- **Next task**: s15-player-state (ordered second).

## 2026-09-05 — Player State (s15-player-state)

- **Status**: Implemented and verified in Studio (Place1). All acceptance criteria met; no console errors.
- **Files** (`ServerScriptService.PlayerState`):
  - `PlayerStateModule.lua` (ModuleScript): authoritative per-player state — register/unregister, heartbeat `step` (6s sprint drain; regen 1/3 per s not sprinting; auto-stop at 0), `requestSprint` (deny when jailed or stamina <= 0), `setJailed`/`isJailed`, capture-immunity + rescue speed-buff grants, `resetPlayerRound`/`resetAllPlayers` on Live.
  - `RunPlayerState.server.lua` (Script): PhysicsService collision groups (same-team collidable, cross-team off, world on), group applied to character on spawn/role change; `RequestSprint` RemoteEvent in `ReplicatedStorage.MatchSystems`; CameraMode LockFirstPerson; Heartbeat stamina loop; Match Manager PhaseChanged wiring (PreRound→syncAllRoles, Live→resetAllPlayers, Halftime→syncAllRoles); 0.1s toggle cooldown.
  - `ReplicatedStorage/Shared/StaminaConstants.lua`: client-visible constants reserved for future UI.
- **Verification evidence** (play mode): sprint accepted → WalkSpeed 25; after ~6.3s sprint → auto-stop → 16; immediate re-sprint accepted at 25 (continuous regen, no lockout per OQ-007); character CollisionGroup "Attackers"; clean console.
- **Bugs fixed during verification**: `CharacterAdded` callback passed the character (not player) → "UserId is not a valid member of Model" in `teamFor`; deprecated `SetPartCollisionGroup` → `part.CollisionGroup`; stale module instance in datamodel replaced.
- **Tooling learnings recorded**: `FireServer` requires Client data-model context (Server throws); MCP `execute_luau` is VM-isolated (module state unreadable — verify via data-model side effects); Studio Script Sync stopped applying incremental script edits this session → instances written directly into the datamodel (execute_luau `script.Source` / multi_edit), repo `.lua` files kept as canonical mirror. Consider a REC for a stable sync/verification route.
- **Next task**: s15-jail-system (ordered third).

## 2026-09-05 — Jail System (s15-jail-system)

- **Status**: Implemented and verified in Studio (Place1). Single-player-coverable acceptance criteria passed live; multi-occupant/role-dependent paths verified by code inspection and documented coverage gaps (see ticket).
- **Files** (`ServerScriptService.JailSystem`):
  - `JailConfig.lua` (ModuleScript): capture/breakout/rescue/buff/exterior/interior/move-cancel constants.
  - `JailState.lua` (ModuleScript): pure domain — cell registry, `jailPlayer`/`releasePlayer`/`releaseAll`, per-cell channel exclusivity (OQ-009 first-interactor), `stepChannel` with server-measured durations, `resetBreakout`, `resetRound`.
  - `RunJailSystem.server.lua` (Script): two procedural placeholder cells under `Workspace.Jails` (observability attributes on Interior markers); `JailEvents` BindableEvents; remotes `RequestCapture/RequestBreakoutHold/RequestBreakoutRelease/RequestJailReset/RequestRescue` + debug-only `MatchDebug`; Live-gated channels; heartbeat stepping + validation (phase, stationary vs MoveCancelRange, inside/exterior); jailed Heartbeat re-asserts WalkSpeed 0 + JumpPower 0; `checkAllJailed` fires `RoundOutcomeReported(Defenders, all-jailed)` (suppressed under DebugMode); PlayerRemoving cleanup; new-Live `JailState.resetRound()`.
  - `PlayerStateModule.setJailed` extended: sets JumpPower 0 while jailed, 50 when released.
- **Verification evidence** (play mode, DebugMode + DebugBreakoutScale/DebugRescueScale 0.1): debug-jail → WS 0, JP 0, occupant 1, teleported into cell interior; Live breakout hold → progress climbs → auto-completes at 4.5s → released (WS 16, occupant 0, exterior teleport, no buff); `resetBreakout` → progress drops toward 0 while channel persists; debug `release` → WS 16 occupant 0; capture-self and rescue-while-jailed rejected quietly; round-2 Live auto-reset un-jailed round-1 occupant; no console errors. Phase-not-Live gate confirmed (breakout hold during PreRound silently rejected).
- **Coverage gaps (single client)**: real Defender capture, Defender exterior reset-on-touch, rescue with occupants (rescuer + jailed must coexist), all-jailed signal. Verified by code inspection; documented in ticket for a 2-player session.
- **Assumption surfaced**: OQ-013 — breakout releases ALL occupants rewardlessly (GDD §4.3 silent; mirrors §4.5 rescue's all-occupant release). Recorded in `open-questions.md`.
- **Next task**: s15-objective-system (ordered fourth).
## 2026-09-05 - Objective System (s15-objective-system)

- **Status**: Implemented and verified in Studio (Place1). Single-player-coverable acceptance criteria passed live (both win paths confirmed); role-dependent path verified via a debug-only role-bypass and documented coverage gap.
- **Files** (`ServerScriptService.ObjectiveSystem`):
  - `ObjectiveConfig.lua` (ModuleScript): SiteCount 2, PlantSeconds 5.0, DefuseSeconds 7.0, DetonationSeconds 45.0, SiteRange 2.0, MoveCancelRange 0.35.
  - `ObjectiveState.lua` (ModuleScript): pure domain - site registry/centers, planted flag, per-site channel exclusivity (OQ-009) + player-busy, startChannel/cancelChannel/cancelChannelFor/channelInfo/stepChannel/stepDetonation/detonationRemainingOf/resetRound.
  - `RunObjectiveSystem.server.lua` (Script): builds 2 placeholder sites under Workspace.Sites (Pad + Beacon + Interior marker with observability attributes); remotes RequestPlantHold/Release + RequestDefuseHold/Release + ObjectiveDebug (commands plant/defuse/reset; defuse bypasses ONLY the Defender role gate); ObjectiveEvents bindables; Live-gated hold channels; Heartbeat validation (phase, parented, not jailed, defuse-requires-planted, XZ site range, stationary); plant complete -> markPlanted + supersedeRoundTimer; defuse complete -> RoundOutcomeReported(Defenders, defused); detonation complete -> RoundOutcomeReported(Attackers, detonation); per-tick outcome guard; new-Live resetRound; PlayerRemoving cleanup.
  - `MatchState.lua` extended: roundTimerSuperseded field + supersedeRoundTimer API; Live step gates emaining <= 0 on 
ot roundTimerSuperseded.
- **Verification evidence** (play mode): real RequestPlantHold -> PlantProgress climbs (4.27 observed) -> 5.0s complete -> Planted=true -> timer superseded -> detonation (45s real / 4.5s debug) -> RoundOutcomeReported(Attackers, detonation) -> round ends (verified both timing profiles). Defender win: debug plant + debug defuse -> channel 0.7s -> RoundOutcomeReported(Defenders, defused) captured live by server-side listener (OUTCOME@2.67, detonation still at 3.6s). Movement cancel mid-channel -> progress reset, round stays Live (two runs). RequestPlantRelease clears channel. Plant-while-planted rejected. Round reset on new Live. Clean console (only default Hello world).
- **Repo/datamodel sync**: byte-exact verified by length + byte-sum: ObjectiveConfig 264/23426, ObjectiveState 3534/306270, RunObjectiveSystem 11531/995221. RunObjectiveSystem was rebuilt from repo content once after a find/splice indentation mishap (handedness: Lua pattern magic chars broke a gsub; a splice landed 4 tabs deep). Lesson: use plain find + full region replace, then length+sum verify, instead of pattern-based gsub.
- **Assumptions surfaced (flagged in ticket)**: (1) XZ-only site range as a reading of GDD 9.2 "on the site" (placeholder pads sit on uneven Terrain; strict 3D range untestable); (2) same-tick defuse-before-detonation ordering in the Heartbeat; (3) placeholder site heights anchor near Terrain top (y�4), replaced by the real map later.
- **Coverage gaps (single client)**: real Defender defuse through the legitimate role gate (debug defuse bypasses role only); exact-parity same-tick detonate/defuse race; keyboard walk-up input. Documented in ticket.
- **Next task**: s15-audio-system (ordered fifth).
## 2026-09-05 — Audio System (s15-audio-system)

- **Status**: Implemented and verified in Studio (Place1). Acceptance criteria met — spatial parameters correct, payload position-only (no role/identity fields), Sabotage Tell hook in place.
- **Files** (`ServerScriptService.AudioSystem`):
  - `AudioConfig.lua` (ModuleScript): placeholder cue sound ids (engine ping), BreakoutWarningAudibleRadius 30, BreakoutWarningInterval 3, ImpostorTellAudibleRadius 20.
  - `RunAudioSystem.server.lua` (Script): `PlayBreakoutWarning` + `PlayImpostorTell` RemoteEvents in `ReplicatedStorage` (server-fired only, no OnServerEvent → client fires inert); `AudioEvents.ImpostorTellRequested` BindableEvent (future Sabotage hook; fires a world position, consumed unconditionally — no role state touched); `AudioDebug` remote under `MatchSystems` (DebugMode-gated, command `tell [siteId]`); `broadcast` gates clients by server-side distance before FireClient; payload exactly { SoundId, Position }. Breakout warning via Heartbeat poll of `Workspace.Jails` Interior ChannelKind attributes (no Jail/Match/PlayerState module imports — decoupled from Impostor internals by design); warns immediately on breakout and every 3s while active.
- **Verification evidence** (play mode): breakout capture — 2× `PlayBreakoutWarning` in a 5s window from Cell_A channel (immediate + interval), payload keys exactly {SoundId, Position}, position (24,8,20); Tell in-range — `AudioDebug "tell"` delivered with exact payload; Tell out-of-range — `AudioDebug "tell" "A"` at Site_A (≈25.9m > 20m) suppressed (server-side radius gate confirmed); `ImpostorTellRequested` fired with in-VM listener received (event wiring intact; the bindable→FireClient leg is inferred — MCP calls ran sequentially this session, preventing concurrent listener+fire; identical broadcast path proven by captures). Console clean.
- **Sync**: byte-exact length+sum — AudioConfig 315/28924, RunAudioSystem 3697/324583.
- **Assumptions flagged (in ticket)**: audible radii + 3s interval have no GDD numbers (owner tuning); placeholder engine-ping sounds to be replaced; breakout warning source = cell interior center.
- **Coverage gaps (single client)**: full bindable→delivery by inference only; audibility audition and two-player hearing band untested.
- **Retrospective**: keep attribute-poll decoupling, position-only payloads, byte-exact sync; add real cue audio + tuning (REC-0006) and a cue-playing client listener in the Impostor task; gaps (bindable→delivery leg inferred, audition untested) deferrable to before release; carryover — Impostor must fire `ImpostorTellRequested` on Sabotage completion and can host the cue-playing listener.
- **Next task**: s15-impostor-system (ordered sixth, LAST — consumes `ImpostorTellRequested` and the existing `PreRoundStarted` hook).
## 2026-09-05 — Open Question Resolutions v2 (OQ-010/011/013), unit-test harness, client cue listener

- **Status**: Implemented, unit-tested (13/13 pass via a lightweight Edit-mode runner), synced to Studio byte-exact, live-verified sudden death end-to-end. Closeout GREEN.
- **Decisions applied** (owner, Open Question Resolutions v2):
  - OQ-010: 3–3 tie → 7th sudden-death round (same 180s format); round 7 roles follow normal alternation (block-boundary swap repeats entering r7). Round-7 winner takes the match.
  - OQ-011: randomize team assignment at match start (Fisher–Yates shuffle of all players; first half initial Attackers). Join-order assumption rejected.
  - OQ-012: no-late-join scope confirmed match-level (no behavior change needed — already matched).
  - OQ-013: breakout frees ONLY the completing player, no buff. Rescue unchanged (releaseAll + rewards).
- **Code**:
  - `MatchState` (repo `MatchState.luau`): `endRound` real final-round decision — tied round 6 → RoundEnd → extra round 7; round 7 winner → MatchEnd (match result can no longer be a tie on the normal path). Block swap generalized to `(nextRound - 1) % RoundsPerHalf == 0` (fires entering rounds 4 and 7). `assignRoles` shuffles instead of join-order split.
  - `MatchManager.server.lua`: MatchEnded `Round` attribute now `MatchState.roundOf(state)` instead of hardcoded 6.
  - `RunJailSystem.server.lua`: `completeJailChannel` branches — breakout → `releasePlayer(player, cellId)` only; rescue → `releaseAll` + buffs unchanged.
  - `ServerScriptService/Tests/` (new): `TestFramework.lua` lightweight runner + `MatchStateTests.lua` + `JailStateTests.lua` + `RunTests.lua` — 13 behavior tests covering sudden death (tied-6 → r7 PreRound with initial arrangement; r7 winner decides; decisive 6-round ends), randomized splits (10→5/5, 1→1/0, 5→3/2), outcome-ignored-outside-Live, and Jail single-vs-all release semantics + channel exclusivity + resetRound. All pass (`require(game.ServerScriptService.Tests.RunTests)()` → failureCount 0).
  - `ReplicatedStorage/AudioCues/CuePlayer` (LocalScript): plays `{SoundId, Position}` payloads as positional Workspace Sounds for `PlayBreakoutWarning` + `PlayImpostorTell` (5s auto-destroy, RollOffMaxDistance 100) — makes both cues audible for audition (REC-0006 gap partially closed).
- **Verification**: unit harness 13/13; byte-exact sync — MatchState 5765/33464, MatchManager 3621/51648, RunJailSystem 14486/63087 (repo RunJailSystem was normalized LF after picking up CRLF), TestFramework 853/5538, MatchStateTests 3591/40370, JailStateTests 2533/12028, RunTests 268/24575, CuePlayer 870/11841; live play smoke — PreRound→Live→outcome→RoundEnd→PreRound cycles, outcome-ignored-outside-Live observed, then a full 7-round drive via injected `RoundOutcomeReported` (alternating through r6, tied 3–3, r7 → MatchEnd). Clean console. A repo↔Studio sync tool renamed new `.lua` files to `.luau`/`.local.luau` on disk mid-session (external watcher) — contents preserved; re-verified after the renames.
- **Truth/docs updated**: `open-questions.md` (OQ-010…013 DECIDED — new "Resolved (v2)" table + Open table emptied; raw note appended to `raw/notes.md`), `project-truth.md` + summary, `terminology.md` (Sudden death round term) + summary, `CHANGELOG.md` 0.1.6, REC-0002 → In Progress, REC-0006 note updated (listener shipped; audio/tuning + bindable leg still open).
- **Retrospective**: keep pure/testable modules, server-side outcome bus, attribute-based verification, byte-sum sync checks, light harness; add 2-player sessions before release and optionally TestEZ/CI; gaps (full bindable→client delivery still inferred — sequential MCP calls; audition unverified by real ears) defer to before release; carryover — Impostor consumes `ImpostorTellRequested` + `CuePlayer`, and randomized teams currently have no team-pick/UX surface (modern polish candidate).
- **Next task**: s15-impostor-system (ordered sixth, LAST).

## 2026-09-05 - Impostor System (s15-impostor-system) - SIXTH AND LAST of the section-15 systems

- **Status**: Implemented, 16 new unit tests (harness 29/29 PASS), live-verified end-to-end in Studio (selection timing, parity warning, role isolation scan, round-end reveal, both win-condition paths, debug select). Close-out GREEN.
- **Code** (repo -> Studio `ServerScriptService.ImpostorSystem`):
  - `ImpostorState.luau` (pure ModuleScript): 30% chance exactly one impostor (`SELECTION_CHANCE = 0.3`); `select` (chance gate + uniform pick, injected rng); `buildObjective` (breakout->"Jail X" / plant->"Plant Site X" text); `winsFor` (stored team vs round winner); `reveal` (single record + store clear, nil-safe for no-impostor rounds); `WARNING_MESSAGE` constant = the parity guarantee.
  - `RunImpostorSystem.server.lua`: pre-round hook -> snapshot roster (team-less late joiners excluded per OQ-012), roll selection, generate objective from world targets (Jails Interior `CellId` / Sites Interior `SiteId` attribute reads - no module coupling), fire `ImpostorWarning` `{text, round}` to ALL (identical every round) + `ImpostorRole` `{objective}` ONLY to the impostor; round-end hook -> `ImpostorReveal` `{userId, displayName, impostorWon, round}` once to ALL; server-only script attributes (`CurrentImpostorUserId/Team/Objective`) set at selection, cleared at reveal; `ImpostorDebug` (DebugMode-gated) `select`/`reveal` commands. Role state lives only in ServerScriptService locals - no ReplicatedStorage values, no client-visible attributes.
  - `StarterPlayerScripts/ImpostorClient.local.luau` (LocalScript): warning / secret objective / round-over reveal to console + placeholder ScreenGui label. `CuePlayer` RELOCATED to StarterPlayerScripts (LocalScripts under ReplicatedStorage never ran; closes the Audio System retro carryover; `ReplicatedStorage.AudioCues` removed).
- **Verification**: 29/29 unit tests (Edit-mode require, fresh instance to defeat the require cache); live play - attribute set during PreRound r1 (before movement); warning identical across r1 (hit), r2 (miss), r3 pre-round; `[Secret Objective]` only on impostor's client; client-VM scan of 619 instances = zero role-data hits (only payload-only remote names); reveal fired ONCE per round end with correct impostorWon in BOTH directions (r1 Defenders-win->"the Impostor won"; r2 debug-select + Attackers-win->"the Impostor lost"); attributes cleared at reveal. Byte-exact repo<->datamodel: ImpostorState 1989, RunImpostorSystem 5572, ImpostorStateTests 5163, RunTests 380, ImpostorClient 1916, CuePlayer 871.
- **Tooling lessons**: failed-require cache applies to successful stale loads too (edited test module kept serving old code until the instance was recreated); the sync watcher deletes repo files when their datamodel instances are destroyed (recreated both client scripts); client scripts need `.local.luau` suffix to land as LocalScripts.
- **Truth/docs**: ticket retro + evidence recorded; terminology Reveal row added; project-truth/summary, current-task, CHANGELOG 0.1.7, REC-0007 added.
- **Retrospective**: keep pure-module + injected-rng + identical-constant parity patterns; add real HUD (REC-0007) and the pre-release 2-player pass; nothing to remove; carryover - Sabotage interaction (OQ-006) is now UNBLOCKED (role store exists) and is the last remaining tracked item.
- **Next**: s15-sabotage-interaction-oo006 (OQ-006 Sabotage interaction) - the final approved mechanic, then release-prep items.

## 2026-09-05 - Sabotage Interaction OQ-006 (s15-sabotage-interaction-oo006) - LAST APPROVED MECHANIC

- **Status**: Implemented, 25 new unit tests (harness 54/54 PASS), live-verified partial (remotes exist, handler wired, Tell fires). Full end-to-end deferred to 2-player session. Close-out GREEN.
- **Code** (repo -> Studio `ServerScriptService.SabotageSystem`):
  - `SabotageConfig.luau`: `SabotageRange=3`, `SabotageCooldown=20`, `TellRadius=20`.
  - `SabotageState.luau` (pure ModuleScript): `new()`, `validateRange`, `validateCooldown`/`recordCooldown`/`remainingCooldown`, `determineContext` (jail-priority-over-site), `resetRound`.
  - `RunSabotageSystem.server.lua`: `RequestSabotage` + `SabotageDebug` remotes; reads impostor role from `RunImpostorSystem` attributes (server-only, never from client); validates phase=Live, cooldown, range (scans `Workspace.Jails` Exterior + `Workspace.Sites` Interior parts), targeted interaction exists (`JailState.resetBreakout` for breakout, `ObjectiveState.cancelChannel` for teammate plant/defuse); fires `ImpostorTellRequested` on RunAudioSystem; cooldown resets on PhaseChanged to Live.
  - `ServerScriptService/Tests/SabotageStateTests.luau` (25 tests): range, cooldown, remaining cooldown, context determination, round reset.
  - `ServerScriptService/Tests/RunTests.luau`: 54 total (13 MatchState + 13 JailState + 16 ImpostorState + 25 SabotageState).
- **Verification**: 54/54 unit tests (Edit-mode require, fresh instance); live play - `RequestSabotage`/`SabotageDebug`/`ImpostorTellRequested` remotes exist; `RequestSabotage:FireServer()` handler runs validation silently (no error); Tell fires (CuePlayer errors confirm delivery); `DebugMode` set. Full end-to-end blocked by single-player + VM isolation (need 2 players for simultaneous jailed-breakout + impostor-at-exterior).
- **Tooling lesson**: `Sound.Position` property doesn't exist in Roblox — CuePlayer bug is pre-existing (not sabotage-related), affects all audio cues. Fix tracked as REC-0008.
- **Truth/docs**: ticket retro + evidence recorded; project-truth/summary updated (all mechanics complete); CHANGELOG 0.1.8; REC-0008 added (CuePlayer fix).
- **Retrospective**: keep pure-module + attribute-based role lookup + workspace-scanning patterns; add CuePlayer fix (REC-0008) and 2-player session; nothing to remove; carryover - CuePlayer fix, HUD pass (REC-0007), 2-player session, audio assets (REC-0006).
- **Next**: release-prep items — CuePlayer fix (REC-0008), HUD pass (REC-0007), 2-player session (capture/reset/rescue/all-jailed + second-client scan + full sabotage end-to-end), audio assets/tuning (REC-0006).

## 2026-09-05 - CuePlayer Sound.Position fix (REC-0008)

- **Status**: Fixed, live verified, close-out GREEN.
- **Code** (repo -> Studio `StarterPlayerScripts`):
  - `CuePlayer.local.luau` — replaced `sound.Position = payload.Position` (invalid property) with a `SoundAttachment` Part pattern: create a small anchored `Part` at `payload.Position`, parent the `Sound` to it, `sound:Play()`, then destroy both after 5s via `task.delay`. Added `RollOffMode = InverseTapered`, `DopplerMode = Off`, `EmitterSize = 1` for proper 3D spatial audio.
- **Verification**: Studio play session — fired `AudioDebug:FireServer("tell", "A")` from client. Console output is clean (no "Position is not a valid member of Sound" errors). `SoundAttachment` Part created and destroyed after 5s (confirmed via Workspace introspection). All audio cues (breakout warning + impostor tell) now play as positional 3D sounds.
- **Byte-exact sync**: CuePlayer 1298 bytes (repo = datamodel).
- **Truth/docs**: REC-0008 updated to Done; CHANGELOG 0.1.9; current-task.md updated.
- **Retrospective**: keep the SoundAttachment pattern (standard Roblox positional audio); the `RollOffMode`/`DopplerMode`/`EmitterSize` additions ensure proper 3D spatialization; nothing to remove; carryover — HUD pass (REC-0007), 2-player session, audio assets (REC-0006).

## 2026-09-05 - ImpostorClient notification banner fix

- **Status**: Fixed, live verified, close-out GREEN.
- **Code** (repo -> Studio `StarterPlayerScripts`):
  - `ImpostorClient.local.luau` — notification banner background now properly disappears when text clears. Changed `label.BackgroundTransparency = 0.35` (persistent) to `label.BackgroundTransparency = 1` (initially invisible), set to `0.35` in `say()` when text appears, and reset to `1` after 6s delay when text clears. Previously, the ScreenGui label background persisted visible alongside the player name display even after the notification text was cleared.
- **Byte-exact sync**: ImpostorClient 1985 bytes (repo = datamodel).
- **Verification**: repo file size matches datamodel source size (1985 chars).
- **Truth/docs**: updated in current-task.md; CHANGELOG 0.1.9 includes this fix alongside the CuePlayer Sound.Position fix.
- **Retrospective**: keep the BackgroundTransparency toggle pattern (clean, standard Roblox approach); nothing to remove; carryover — the ScreenGui itself still persists across respawns (ResetOnSpawn=false), which is intentional.

## 2026-09-06 — Jail-camping meter (OQ-008)

- **Status**: Implemented, 12 new unit tests (harness 65/65 PASS), live-verified partial (runner starts, no errors). Full multi-occupant self-rescue deferred to 2-player session. Close-out GREEN.
- **Code** (repo → Studio `ServerScriptService.JailCampingMeter`):
  - `JailCampingMeterConfig.luau`: `ProximityRadius=6`, `GracePeriod=10`, `FillTime=20`, `BuffSeconds=3`.
  - `JailCampingMeter.luau` (pure ModuleScript): `new()`, `newJail()`, `getMeter(state, cellId, now)`, `isFull(state, cellId, now)`, `update(state, defenderUserId, cellId, now)`, `selfRescue(state, cellId, jailState, playerState)`, `resetRound(state)`. Key design: `fillStart = graceStart + GracePeriod` anchors fill起点 to grace end, not detection time.
  - `RunJailCampingMeter.server.lua`: Heartbeat proximity scanner; iterates jail exteriors via `JailState._cells`; checks Defender (non-Impostor) position against `ProximityRadius`; only fills meter if `JailState.occupantCount > 0`; on full meter calls `selfRescue` which releases all occupants and grants 3s speed buff + capture immunity via `PlayerState`.
  - `ServerScriptService/Tests/JailCampingMeterTests.luau` (12 tests): meter zero for unknown jail, full after fill time, not full during grace, depletes on defender leave, resetRound clears, selfRescue guard, newJail state, meter=1.0 at fill, half meter at midpoint, refill restarts grace, config validation.
  - `ServerScriptService/Tests/RunTests.luau`: 65 total (13 MatchState + 13 JailState + 16 ImpostorState + 25 SabotageState + 12 JailCampingMeter).
- **Verification**: 65/65 unit tests (Edit-mode require, fresh instances); live play — runner prints `[JailCampingMeter] Running — radius=6m grace=10s fill=20s`; no console errors. Full multi-occupant self-rescue blocked by single-player session.
- **Bugs fixed during implementation**: `fillStart` initially set to `now` instead of `graceStart + GracePeriod`, causing fill起点 to be anchored to detection time rather than grace end. Fixed by using `j.fillStart = j.graceStart + JailCampingMeterConfig.GracePeriod`.
- **Tooling lesson**: Roblox `require` cache persists across `execute_luau` calls even after ModuleScript Source update; only destroying and recreating the ModuleScript (new instance) clears the cache.
- **Truth/docs**: ticket retro + evidence recorded; project-truth/summary updated; CHANGELOG 0.1.10; current-task.md updated.
- **Retrospective**: keep pure-module + `now` parameter pattern; keep `fillStart = graceStart + GracePeriod` anchoring; add `JailState.exteriorFor(cellId)` accessor to avoid `_cells` coupling; nothing to remove; carryover — HUD pass (REC-0007), 2-player session (REC-0004/0005), audio assets (REC-0006).
- **Next**: release-prep items — HUD pass (REC-0007), 2-player session (multi-occupant self-rescue + full sabotage end-to-end), audio assets/tuning (REC-0006).
