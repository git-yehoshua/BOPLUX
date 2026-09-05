# Task Ticket — §15 Audio System (server-owned)

## Change Category
Meaningful feature — system implementation (Roblox Luau, server-side).

## Goal
Server-owned audio cues with position-only payloads. Never carries role/identity information.

## Scope
- `PlayBreakoutWarning` (§4.3): loud auditory warning during an in-progress breakout; server computes audibility radius.
- `PlayImpostorTell` (§6.4): localized spatial cue that always fires when the Sabotage interaction completes; server computes nearby listeners.
- RemoteEvent(s) placed in `ReplicatedStorage`, fired only by the server (§15).
- The event payload is "play this sound at this world position" only — on-demand no role attribution, no Impostor identity leakage.

## Constraints
- Server determines which clients are within audible range before firing; the event itself carries no role information.
- Must remain fully decoupled from Impostor System internals (never queries/exposes role state).

## Inputs
- `.wwg/wiki/project-truth.md`, `.wwg/wiki/terminology.md`
- GDD §4.3, §6.4, §7 Audio System row, §15 Audio System row
- OQ-006 (Tell must always fire on Sabotage completion)

## Acceptance Criteria
- Breakout warning and Impostor Tell fire with correct spatial parameters.
- Payload contains no role or identity data.
- Sabotage-driven Tell fires unconditionally on Sabotage completion (hook consumed by the Sabotage item).

## Validation / Test Plan
- Behavior changed: YES
- Unit tests added/updated: payload shape (no role fields), server-only firing guard
- Regression tests added/updated: YES
- Manual verification: Studio play session (audios only audible in range)
- Test command run: TBD
- Result: TBD

## Dependency Notes
- Depends on Jail System (breakout state) and the Sabotage item (Tell trigger), both via interface hooks.

## Report Path
`.wwg/reports/agent-implementation-log.md`; `.wwg/workspace/current-task.md`.