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
- Test command run: TBD
- Result: TBD

## Dependency Notes
- Depends on Jail System (occupant tracking + rescue reward path) and Player State (positions + immunity state).
- Independent validation pass required.

## Report Path
`.wwg/reports/agent-implementation-log.md`; `.wwg/workspace/current-task.md`.