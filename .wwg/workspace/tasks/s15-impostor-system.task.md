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
- Unit tests added/updated: YES — `ServerScriptService/Tests/ImpostorStateTests.luau` (16 tests): selection (full-chance exactly-one, below-chance miss, picks-a-present-player, records round team, empty roster), objective (build breakout/plant + attach), warning parity (no identity embedded in any case), win-condition (team loses→win, team wins→no, nil without impostor), reveal (once + clears store, no-impostor reveal, win from stored team, disconnected impostor reveals from stored identity)
- Regression tests added/updated: YES — harness now 29 tests total (13 prior + 16 new), ALL PASS
- Manual verification: Studio play session (live evidence below) + client-VM introspection scan asserting no role data on any client-visible instance
- Test command run: `require(game.ServerScriptService.Tests.RunTests)()` in Edit mode → total=29, failureCount=0
- Result: PASS

## Implementation Summary

- Files (repo mirror → Studio `ServerScriptService.ImpostorSystem`):
  - `ImpostorState.luau` (ModuleScript, pure/testable) — `SELECTION_CHANCE = 0.3`; `select(state, rows, chance, rng)` (chance gate then uniform pick; row = {userId, displayName, team}); `attachObjective`; `buildObjective(kind, targetId)` (text builders for breakout→"Jail X" / plant→"Plant Site X"); `winsFor(state, roundWinner)` (impostor wins iff stored team ~= round winner); `reveal(state, round, roundWinner)` → `{userId, displayName, impostorWon, round}` and clears the store; `WARNING_MESSAGE` constant (identical payload source for parity).
  - `RunImpostorSystem.server.lua` (Script) — subscribes to Match Manager `PreRoundStarted` + `RoundEnded` BindableEvents; per pre-round: snapshots roster rows (only players with a round team — late joiners per OQ-012 are never selectable), rolls selection via injected rng (30%), generates objective from world targets (`Workspace.Jails` Interior `CellId` / `Workspace.Sites` Interior `SiteId` — decoupled attribute reads, no module imports from Jail/Objective), fires `ImpostorWarning` (payload `{text, round}` — role-free, identical every round) to ALL, fires `ImpostorRole` ONLY to the selected player (`{objective}`); per round end: fires `ImpostorReveal` once to ALL (`{userId, displayName, impostorWon, round}`, userId nil when no impostor that round). Server-only observability attributes on the script (server-visible only): `CurrentImpostorUserId/Team/Objective` — set at selection, cleared at reveal. `ImpostorDebug` RemoteEvent (DebugMode-gated) commands: `select` (force caller as impostor), `reveal` (force round-end reveal). Role state lives only in the Script's local store + the pure module table — never in ReplicatedStorage, never in client-visible attributes.
- Client listener (repo `StarterPlayerScripts/`): `ImpostorClient.local.luau` (LocalScript) — shows warning / secret objective / round-over reveal via console + a ScreenGui label. Note: LocalScripts must live in StarterPlayerScripts to run — `CuePlayer` was relocated from `ReplicatedStorage.AudioCues` to `StarterPlayerScripts/CuePlayer.local.luau` (it previously could not execute at all; this closes the Audio System retro carryover).

## Verification Evidence (Studio play, single client)

- Harness: 29/29 unit tests pass (`require(RunTests)()` → total=29, failureCount=0) — includes 16 new Impostor tests.
- Selection timing: `CurrentImpostorUserId` attribute set while `MatchPhase=PreRound` (round 1) — before Live/movement (§12.1).
- Round 1 (30% roll HIT): console shows `[Warning] An Impostor is among you...` exactly once, then `[Secret Objective] Cancel an active plant or defuse at Plant Site A` — role + objective delivered to the impostor's own client only.
- Role replication isolation: client-VM scan of 619 instances (ReplicatedStorage, Workspace, StarterGui, StarterPack, StarterPlayer, Lighting, Teams, Players, PlayerGui) — zero attributes/values/names carrying role data; only hits were the five payload-only RemoteEvent names (`PlayImpostorTell`, `ImpostorWarning`, `ImpostorRole`, `ImpostorReveal`, `ImpostorDebug`).
- Reveal (round 1): fired Defenders win via `RoundOutcomeReported` (impostor on Attackers) → `[Round Over] <name> was the Impostor - the Impostor won!` — exactly once, at round end, to all; server attributes cleared at reveal (verified nil after).
- Round 2 (30% roll MISS): identical warning fired, no `[Secret Objective]` (parity confirmed for no-impostor case), no forced state.
- Debug forced selection (round 2, mid-round): `ImpostorDebug:FireServer("select")` → caller became impostor, objective regenerated ("Reset the in-progress breakout at Jail A"); fired Attackers win → `[Round Over] ... - the Impostor lost!` — win-condition FALSE path verified live.
- Round 3 pre-round: warning fired again (every pre-round). Round cycling continued cleanly (MatchPhase=Live, Round=2 observed mid-flow).
- Console otherwise clean (one harmless trace from a misfired MCP introspection call during the session).

## Coverage Gaps (single client)

- "Scan by ANY OTHER client" exercised as the same client scanning all replication paths it can see (structural guarantee: role state exists only inside `ServerScriptService` locals + the one FireClient to the impostor). A true second-client session remains for the pre-release 2-player pass.
- Disconnect-mid-round reveal verified via unit test (stored identity), not a live disconnect.
- Jailed/rescued impostor treated identically is structural (Impostor System holds no jail hooks; Jail System handles all players uniformly).

## Retrospective

- Keep: pure `ImpostorState` module with injected rng (made 16 deterministic tests possible), decoupled world reads via Interior attributes (no Jail/Objective imports), server-only attribute observability (invisible to clients by placement), the identical-`WARNING_MESSAGE`-constant approach to parity (impossible to desync), the `.local.luau` suffix convention for client scripts.
- Add: a real HUD pass — warning/objective/reveal are currently console + a single placeholder TextLabel; production UI should own presentation (REC-0007). Consider surfacing reveal history for spectating/next-round flavor later.
- Remove/simplify: nothing to remove; `winsFor` is only used by tests/observability today but is the correct pure seam for any future impostor scoring.
- Gaps: second-client scan and live disconnect are deferred to the pre-release 2-player session; audio Tell end-to-end (sabotage completion → `ImpostorTellRequested`) belongs to the Sabotage item (OQ-006), which is now UNBLOCKED — its role-store dependency exists.
- Carryovers: Sabotage interaction (OQ-006) is the only remaining §15-adjacent tracked item; HUD/UI pass (REC-0007); 2-player session before release.

## Report Path

`.wwg/reports/agent-implementation-log.md`; `.wwg/workspace/current-task.md`.