# Task Ticket — §15 Impostor System (server-only) — LAST in the sequence

## Change Category
Meaningful feature — system implementation (Roblox Luau, server-only). Highest privilege/security surface in the game.

## Goal
The Impostor exists only server-side; role state is never replicated except to the Impostor's own client (§15 design note — decompilable clients mean an on-mesh/encrypted/unused flag on other clients is still extractable).

## Scope
- Selection & timing (§6.1, §12): 30% chance exactly one Impostor on either team; selected + objective generated at start of the 15s pre-round, before movement control is granted. Subscribes to the Match Manager "pre-round begins" hook.
- No-Impostor parity (§12.2): all three cases (no impostor / other team / own team) emit the identical pre-round Impostor Warning to every player.
- Role delivery: role + secret sabotage objective sent to the Impostor's own client only.
- Win condition (§6.6): the Impostor wins if their own team loses the round; identity revealed to all only at round end.
- Edge cases (§10): jailed/rescued/disconnected Impostors are handled identically to normal players; no replacement Impostor on disconnect.
- Sabotage interaction (OQ-006) is implemented as a SEPARATE tracked item (s15-sabotage-interaction-oo006.task.md) — Impostor System owns role state and delivery here; the Sabotage item owns the interaction/cooldown/contextual effect.
- No client-fired remotes carry role state (§15).

## Constraints
- Role state must never appear in: ReplicatedStorage values, attributes, shared ModuleScripts, or any replication path outside the Impostor's own client.
- Round timeline: selection before movement control; reveal at round end only.
- This item is last — every other system must exist first (it depends on Match Manager phases, Player State transitions like capture/jail, Objective plant/defuse state, Audio Tell hook, and the Sabotage item's interaction surface).

## Inputs
- `.wwg/wiki/project-truth.md`, `.wwg/wiki/terminology.md`
- GDD §6, §10, §12, §15 Impostor System row
- OQ-006 (Sabotage interaction exists, Tell always fires) — interface consumed

## Acceptance Criteria
- Exactly one Impostor at 30% or none; selection happens before movement control each round.
- Every player receives the identical Impostor Warning each pre-round, including non-Impostor rounds.
- Only the Impostor's client can ever observe role state; a memory/attribute scan by any other client must find nothing.
- Round-end reveal fires once, server-side, to all.
- Disconnect mid-round leaves the round and win-condition resolution unchanged (§10 ruling).

## Validation / Test Plan
- Behavior changed: YES
- Unit tests added/updated: role replication isolation (scan replication paths for role leakage), selection parity (warning identical across cases), timing (selection pre-movement, reveal post-round)
- Regression tests added/updated: YES
- Manual verification: Studio play session + introspection script asserting no role data outside ServerScriptService
- Test command run: TBD
- Result: TBD

## Dependency Notes
- Depends on EVERY other system: Match Manager (phases/pre-round hook), Player State (capture/jail/disconnect transitions), Jail System (jail/rescue), Objective System (plant/defuse), Audio System (Tell), Sabotage item.
- OQ-010 tie-handling does not affect this system beyond Match Manager's round-end reveal signal.

## Report Path
`.wwg/reports/agent-implementation-log.md`; `.wwg/workspace/current-task.md`.