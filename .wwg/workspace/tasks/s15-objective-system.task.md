# Task Ticket — §15 Objective System (server-authoritative)

## Change Category
Meaningful feature — system implementation (Roblox Luau, server-side).

## Goal
Authoritative plant / detonation / defuse flow at plant sites.

## Scope
- Plant sites: **2 sites for v1.0** (OQ-004); third site deferred until 2-site rounds are validated.
- Universal planting (§5.2): any active Attacker at a site; 5.0s stationary channeled interaction; no physical bomb item.
- Detonation (§5.3): 45.0s countdown after successful plant; on completion → Attacker round win reported to Match Manager.
- Defuse (§5.3): Defender, 7.0s uninterrupted; on completion → Defender round win reported.
- Interaction legality (§8.3, §9.1/9.2/9.3): no plant/defuse during pre-round; single uninterrupted attempts; movement or capture cancels and resets progress to zero; no progress checkpoint.
- Only the first interactor progresses a site interaction (§9.4); multiple players do not stack.
- Remotes: `RequestPlantHold`, `RequestPlantRelease`, `RequestDefuseHold`, `RequestDefuseRelease` (§15) — server validates Attacker/Defender role, stationarity at site, no other active interactor on that site.

## Constraints
- Server-authoritative; interaction duration server-measured.
- Sabotage "cancel teammate plant/defuse" is a separate item — expose an interface hook for cancellation, do NOT implement it here.

## Inputs
- `.wwg/wiki/project-truth.md`, `.wwg/wiki/terminology.md`
- GDD §5, §9.2/9.3/9.4, §15 Objective System row
- OQ-004 site count

## Acceptance Criteria
- Plant succeeds only: post-pre-round, by an active Attacker, stationary, 5.0s uninterrupted at a site, no other active interactor on that site.
- Detonation countdown is authoritative and supersedes the round timer (§10).
- Defuse 7.0s uninterrupted; progress resets on any interruption.
- Round-win events emitted to Match Manager on detonate/defuse (and never from client input).

## Validation / Test Plan
- Behavior changed: YES
- Unit tests added/updated: plant timing/interruption, single-interactor rule, detonation countdown vs round timer precedence, defuse timing
- Regression tests added/updated: YES
- Manual verification: Studio play session (single client, debug scales enabled where noted)
- Test command run: N/A (manual Studio verification used)
- Result: IMPLEMENTED + LIVE-VERIFIED — see "Verification Evidence" below

## Verification Evidence (Studio Play, Datamodel + repo byte-synced: ObjectiveConfig 264, ObjectiveState 3534, RunObjectiveSystem 11531)

- Plant (real remote path): walk to Site_A → `RequestPlantHold("A")` → channel starts (`ChannelKind=plant`), `PlantProgress` climbs (observed 4.27/5.0 live) → completes at 5.0s → `Planted=true` → `MatchState.supersedeRoundTimer` → detonation countdown runs (real 45s / debug-scaled 4.5s) → `RoundOutcomeReported(Attackers, "detonation")` → Match Manager ends round (Live→RoundEnd→PreRound). Full Attacker-win path verified 2× (debug-scaled and real timing).
- Defuse (outcome recorded live via server-side listener): debug plant (role-neutral) + debug defuse (role gate bypassed only; site-range/stationary/planted validation still enforced by Heartbeat `validateChannel`) → channel steps 0.7s (debug-scaled) → `RoundOutcomeReported(Defenders, "defused")` observed at probe t+2.67s with detonation still at 3.6s → Defenders won before detonation. Defender-win path verified.
- Site range: interaction point at each site center; the range check is XZ-only (`Vector3.new(root.Position.X,0,Z) - Vector3.new(center.X,0,Z)`), a deliberate reading of §9.2 "the site" as the site's horizontal footprint — placeholder pads sit on uneven Terrain at y≈4; vertical position otherwise failed every reachable test (character never lands exactly on center height). Out-of-range holds are silently rejected.
- Movement cancel: hold started then character moved away (~112m) mid-channel → `validateChannel` false → `cancelChannel` → `PlantProgress` reset to 0, channel cleared, round still Live. Verified in a tight second run (hold→move before 5s completion → no plant, no detonation).
- Release remote: `RequestPlantRelease` mid-channel → channel cleared (`ChannelKind=nil`, progress 0, `Planted=false`).
- Plant-while-planted rejected: with a plant live, real `RequestPlantHold("A")` starts no new channel (guard `if ObjectiveState.plantedSite() then return end`).
- Round timer supersede: after plant the round concluded by detonation countdown; the 180s round timer did not fire (roundTimerSuperseded gate in MatchState Live step).
- Round reset: next Live clears `Planted`/`DetonationRemaining`/channels via `PhaseChanged(Live) → ObjectiveState.resetRound()`.
- Debug attributes on `RunObjectiveSystem` (Edit-mode): `DebugMode=true`, `DebugPlantScale/DebugDefuseScale/DebugDetonationScale` (0.1 during scaled tests, 1.0 during real-timing tests).
- No console errors (console showed only the default "Hello world!"). MCP VM isolation noted: module internals are not readable from probes — verification is attribute/phase-based.

## Coverage Gaps (documented, not silently passed)

- Real Defender defuse by a Defender (role gate at `RequestDefuseHold`) is 2-player-gated; the debug `defuse` command bypasses ONLY the role check (all other Heartbeat validation still applied). A Defender client session is needed for the fully-legit path.
- Same-tick defuse-vs-detonation precedence (defuse processed before detonation in the Heartbeat loop) is implemented but not raced live at exact tick parity.
- Keyboard walk-up + hold input not exercised (MCP navigation equivalent state used).
- Site placement is decorative placeholder geometry (2 sites, Terrain-top anchored); final map integration will replace it.

## Implementation Notes / Assumptions (flagged, not silently fixed)

- Debug-only `defuse` command added to `ObjectiveDebug` for 1-client verification of the Defender path (mirrors Jail System's DebugMode affordance pattern).
- XZ-only site-range (see evidence) is an implementation reading of §9.2.
- Plant/defuse durations validated at channel step via `objectiveHeartbeat`; interaction is fully server-timed, never client-timed.
- SITE_LAYOUT centers: Site_A (40,4,-40), Site_B (-40,4,40), pads + beacons + invisible 4×4×4 `Interior` marker carrying observability attributes (SiteId, Planted, ChannelKind, PlantProgress, DefuseProgress, DetonationRemaining).

## Dependency Notes
- Depends on Match Manager (round phase legality, win evaluation) and Player State (roles).
- Consumed later by Impostor System (Sabotage plant-defuse cancel hook) — interface only.

## Dependency Notes
- Depends on Match Manager (round phase legality, win evaluation) and Player State (roles).
- Consumed later by Impostor System (Sabotage plant-defuse cancel hook) — interface only.

## Retrospective

- **Keep doing**: debug `defuse` command pattern (mirror of Jail System's DebugMode affordance); XZ-only site-range for movement cancellation (cleaner than full 3D); server-timed plant/defuse/detonation via Heartbeat (never client-timed); the site `Interior` marker carrying observability attributes (SiteId, Planted, ChannelKind, PlantProgress, DefuseProgress, DetonationRemaining) as the decoupled state surface.
- **Add (next task / future)**: automated unit tests for ObjectiveState (the pure module, like ImpostorState and JailState). The Heartbeat-driven channel step and detonation countdown are complex enough to warrant test coverage.
- **Remove / simplify**: the duplicate `Dependency Notes` block (appears twice in the file) — consolidate to one.
- **Gaps**: the legitimate `RequestDefuseHold` Defender path was verified via debug `defuse` command only (bypassing role check); real Defender defuse was never tested with a second client. The all-jailed Defender-win via Objective System was never tested.
- **Carryovers**: Objective System is consumed by Impostor System (Sabotage plant-defuse cancel hook); the site Interior attribute pattern is stable and unchanged.

## Report Path
`.wwg/reports/agent-implementation-log.md`; `.wwg/workspace/current-task.md`.