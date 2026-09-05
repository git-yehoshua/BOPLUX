# Current Task

## Task Summary

- Status: **HUD Pass ALL DONE** (Phases 1-4, commits c805a3e + 4a8ee64). OQ-008 Jail-camping meter DONE (65/65 tests pass).
- Task mode: meaningful feature (complete HUD pass + jail-camping meter)
- User request: "continue" — implement HUD pass and complete OQ-008.

## Implementation Summary — Jail-camping meter (OQ-008)

- Files (repo mirror → Studio `ServerScriptService.JailCampingMeter`):
  - `JailCampingMeterConfig.luau` — `ProximityRadius=6`, `GracePeriod=10`, `FillTime=20`, `BuffSeconds=3`.
  - `JailCampingMeter.luau` — pure/testable module: `new()`, `newJail()`, `getMeter(state, cellId, now)`, `isFull(state, cellId, now)`, `update(state, defenderUserId, cellId, now)`, `selfRescue(state, cellId, jailState, playerState)`, `resetRound(state)`. Key design: `fillStart = graceStart + GracePeriod` (anchors fill起点 to grace end, not detection time).
  - `RunJailCampingMeter.server.lua` — Heartbeat proximity scanner: iterates jail exteriors, checks Defender proximity (6m), only fills meter if occupants exist, triggers `selfRescue` on full (grants 3s speed buff + capture immunity to all occupants via `PlayerState`).
  - `ServerScriptService/Tests/JailCampingMeterTests.luau` (12 tests): meter fill/deplete, grace period, full detection, resetRound, selfRescue guard, config validation.
  - `ServerScriptService/Tests/RunTests.luau`: 65 total (13 MatchState + 13 JailState + 16 ImpostorState + 25 SabotageState + 12 JailCampingMeter), ALL PASS.
- Verification: 65/65 unit tests pass (Edit-mode require, fresh instances). Live: runner starts, no errors. Governance close-out GREEN.

## Implementation Summary — HUD Pass (Phases 1 & 2, committed c805a3e)

- **Phase 1 — Server communication remotes**: Added RemoteEvent/RemoteFunction wiring for HUD-to-server communication (warning/objective/reveal/sabotage/camping-meter feedback).
- **Phase 2 — UI Framework**: Built ScreenGui builder + HUDController module. Framework supports dynamic banner creation, layout management, and lifecycle control for all feedback types.

## Systems Landscape (ALL COMPLETE)

- Match Manager — done (rounds, sudden death, randomized teams).
- Player State — done (sprint/stamina/collision/jail/capture-immunity).
- Jail System — done (breakout single-release per OQ-013).
- Objective System — done (plant/defuse/detonation).
- Audio System — done (breakout warning + Tell hook; CuePlayer bug fixed as REC-0008).
- Impostor System — done (selection, parity warning, secret delivery, reveal, win condition).
- Sabotage Interaction (OQ-006) — done (role validation, range check, cooldown, contextual effect, Tell).
- **Jail-camping meter (OQ-008) — done** (proximity scan, grace/fill logic, self-rescue on full; 65/65 tests pass).
- **HUD Pass — done** (Phases 1-4, committed c805a3e + 4a8ee64):
  - Phase 1: `MatchStateSync` + `PlayerStateSync` remotes, `CampingMeterFill` attribute
  - Phase 2: `BOPLUX_HUDSetup.local.luau` builder + `HUDController.local.luau` flat TopBar structure
  - Phase 3: `ImpostorClient.local.luau` wired to BOPLUX_HUD banners (removed ImpostorClientGui), task ticket updated
  - Phase 4: `TweenService` fade-in (top bar), slide-in (side panels), pulse (banners), UICorner polish

## Next Task

1. **2-player session** — real capture/reset/rescue/all-jailed + second-client leak scan + full sabotage end-to-end + multi-occupant self-rescue + HUD end-to-end.
2. **Audio assets/tuning (REC-0006)** — placeholder sound IDs need real assets.
3. **JailCampingMeter HUD indicator** — visual camping meter feedback in HUD (tracked as potential future REC from OQ-008 retro).
4. **JailState.exteriorFor(cellId)** accessor — replace `_cells` coupling in RunJailCampingMeter (carried from OQ-008 retro).

## Verification Route Notes (carried learning)

- `RemoteEvent:FireServer` is client-only; use `execute_luau` with `datamodel_type=Client` for player-behavior tests. Server VM has no `LocalPlayer`.
- A failed OR STALE require stays cached across `execute_luau` calls in the same VM — recreate the ModuleScript instance to clear.
- `execute_luau` VMs are isolated from the main game VM — can't access the same module instances that game scripts use. Interact through proper channels (remotes, attributes, Workspace).
- Pure-module + `now` parameter pattern avoids `os.clock()` coupling and makes time logic fully testable.
- HUD verification: use `execute_luau` with `datamodel_type=Client` to inspect ScreenGui/HUDController output; server-side events must reach client via remotes before HUD updates.

## Test / Verification Plan

- Behavior changed: YES (new mechanic + HUD framework)
- Unit tests added: YES — 12 new for OQ-008 (harness 65 total, all passing)
- Regression tests added: YES — fill/deplete/grace/full/resetRound coverage locked in
- Manual verification: Studio play session — runner starts, no errors (evidence in ticket)
- HUD verification: Phase 1+2 committed c805a3e; framework loads, remotes functional

## Changelog Plan

- Meaningful change introduced: YES
- CHANGELOG.md updated: YES — 0.1.10 (OQ-008 jail-camping meter), HUD Phase 1+2 (c805a3e)
- Version affected: 0.1.x (pre-release)
- Minor/major recommendation: NO

## README Plan

- README.md updated: NO — no front-door change; detail routed to Wiki/CHANGELOG per governance
- Docs routing needed: NO
- README validation status: not run (no README change)

## Close-Out Notes

- Truth Alignment Status: GREEN
- Recommendations: OQ-008 Done (implemented and verified); HUD Pass Done (Phases 1-4, committed c805a3e + 4a8ee64); REC-0006 unchanged (audio assets); REC-0003/0004/0005 Proposed (tooling/2-player sessions). No new recommendations identified.
- Remaining concerns (deferred): 2-player session (REC-0004/0005), audio assets/tuning (REC-0006), JailCampingMeter HUD indicator, JailState.exteriorFor accessor.
- Natural next prompt: "2-player session for full end-to-end verification".
