# Task Ticket — Jail-camping meter (OQ-008) — INDEPENDENT ITEM

## Change Category
Meaningful feature — new mechanic (approved via Open Question Resolutions v1, OQ-008). Treated as its own Workspace item with an independent validation pass, per owner instruction. NOT folded into the Jail system task.

## Goal
Anti-snowball Jail-camping meter (GDD §13, modeled on Dead by Daylight's anti-facecamp mechanic).

## Scope (from OQ-008 — parametrized and approved)
- Proximity radius: **6m**.
- Grace period: **10s** before the meter begins filling.
- **20s** of continuous camping within the radius fills the meter.
- Depletes if the Defender leaves the radius.
- Effect when full: all occupants of that Jail may self-rescue with full immunity, identically to a successful teammate rescue (§4.5 — 3s speed buff + capture immunity).
- Server-evaluated proximity logic only; no client trust.

## Constraints
- Only Defenders "camp"; occupants must exist in the Jail (meter does not fill on an empty Jail).
- The self-rescue shares the §4.5 reward semantics and the §9.4 first-interactor rule (only the self-rescuing occupant progresses).
- Independent validation pass — do not merge into Jail System task validation.

## Inputs
- `.wwg/wiki/project-truth.md`, `.wwg/wiki/terminology.md`
- OQ-008 in `11-synthesis/open-questions.md` (resolved with parameters)
- GDD §13 jail-camping ruling; §4.5 reward definition

## Acceptance Criteria
- Meter fills only under genuine camping (occupant present, continuous Defender presence, past grace), at the approved parameters.
- Meter depletes on Defender exit; refill restarts from correct state.
- Self-rescue on full meter behaves identically to a teammate rescue reward (immunity + speed buff, 3s).

## Validation / Test Plan
- Behavior changed: YES (new mechanic)
- Unit tests added/updated: delivery of meter fill/deplete against the 6m/10s/20s model, empty-Jail no-op, self-rescue reward parity
- Regression tests added/updated: YES
- Manual verification: Studio play session
- Test command run: TestFramework (RunTests) — 65/65 ALL PASS
- Result: PASS

## Dependency Notes
- Depends on Jail System (occupant tracking + rescue reward path) and Player State (positions + immunity state).
- Independent validation pass required.

## Report Path
`.wwg/reports/agent-implementation-log.md`; `.wwg/workspace/current-task.md`.

## Retrospective

### What went well / keep doing
- Pure-module + `now` parameter pattern for testable time logic (no `os.clock()` in modules).
- Proximity scanner iterates only jail exteriors (not all players), keeping the hot loop lightweight.
- `fillStart = graceStart + GracePeriod` correctly anchors fill起点 to grace end, not to the moment the scan detects camping.
- `selfRescue` reuses existing `JailState.releasePlayer` + `PlayerState.grantSpeedBuff`/`grantCaptureImmunity` — no reward-path duplication.

### What to add
- HUD indicator for the camping meter (currently server-only, no visual feedback to the camper or occupants). Tracked as a potential future REC.
- Configuration export to the datamodel (JailCampingMeterConfig is a ModuleScript, not tunable from Studio without code changes).

### What to remove, simplify, or stop doing
- The `hasOccupants` helper was initially included but removed because occupancy is checked per-cell in the runner; no dead code.

### Gaps found
- Single-player session only: self-rescue triggers but only one occupant can be verified. Full multi-occupant self-rescue needs a 2-player test.
- The runner accesses `JailState._cells` (private table) to get exterior positions. This is a fragile coupling — a future `JailState.exteriorFor(cellId)` accessor would be cleaner.

### Carryovers
- 2-player session needed for full end-to-end verification of multi-occupant self-rescue.
- HUD pass for camping meter visual feedback.
- JailState accessor refactor for exterior positions.
