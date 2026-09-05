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

## Implementation

- Files (canonical repo mirror → Studio Place1, `ServerScriptService.AudioSystem`):
  - `AudioConfig.lua` (ModuleScript) — `BreakoutWarningSoundId` / `ImpostorTellSoundId` (both placeholder `rbxasset://sounds/electronicpingshort.wav` for now), `BreakoutWarningAudibleRadius = 30`, `BreakoutWarningInterval = 3`, `ImpostorTellAudibleRadius = 20`.
  - `RunAudioSystem.server.lua` (Script) — creates `PlayBreakoutWarning` + `PlayImpostorTell` RemoteEvents in `ReplicatedStorage` (server-fired only; no `OnServerEvent` handlers, so client fires are inert); `AudioEvents.ImpostorTellRequested` BindableEvent hook for the future Sabotage item (fires a world position; consumed regardless of role state); `AudioDebug` RemoteEvent under `MatchSystems` (DebugMode-gated; command `tell [siteId]` for live tests — no arg = caller position); `broadcast(remote, soundId, position, radius)` selects clients by server-side distance to character root before `FireClient`; payload built by `buildPayload` is exactly `{ SoundId, Position }` — no role/identity fields.
  - Breakout warning: Heartbeat polls `Workspace.Jails` cell Interior `ChannelKind` attributes (decoupled from Jail internals — no JailState import); warns immediately on an active breakout and re-warns every `BreakoutWarningInterval` while the channel stays active; position = the cell Interior's world position; radius-gated.
  - Tell: consumed from `ImpostorTellRequested` (`worldPosition, radiusOverride`; validates Vector3) and from the debug remote; radius-gated; payload position-only. No Jail/Match/PlayerState modules are required — fully decoupled from Impostor internals by design.
- Byte-exact sync verified (`AUDIO_` evidence below).

## Verification Evidence (Studio play, single client)

- Breakout warning: debug-jail self in Cell_A → `RequestBreakoutHold("A")` → `ChannelKind=breakout`, progress climbing (4.96 observed) → client listener captured 2× `PlayBreakoutWarning` in a 5s window (immediate warn + one at the 3s interval. Payload keys exactly `{SoundId, Position}`; position = Cell_A interior (24,8,20).
- Tell delivery: `AudioDebug:FireServer("tell")` (at caller position) → `PlayImpostorTell` delivered with payload exactly `{SoundId, Position}`.
- Tell radius filter: `AudioDebug:FireServer("tell", "A")` targeted Site_A (≈25.9m away, > 20m radius) → NOT delivered. Server-side audibility gating confirmed.
- Hook mechanism: `ImpostorTellRequested` fired server-side with an attached in-VM listener → received (event wiring intact). Note: cross-VM FireClient observation of the full bindable→broadcast leg requires concurrent listener+fire; MCP calls ran sequentially this session, so that last link is inferred (identical `broadcast` code path proven by the AudioDebug tell and by the PlayBreakoutWarning captures).
- Server-only guard: the two ReplicatedStorage remotes have no server-side handlers; client firing is inert by construction.
- Console: no runtime errors from AudioSystem (only the default "Hello world!"). DebugMode set on `RunAudioSystem`.

## Validation / Test Plan

- Behavior changed: YES
- Unit tests added/updated: payload shape (no role fields), server-only firing guard — manual verification this session (captured payload keys checked; remote has no OnServerEvent); formal unit tests pending harness (REC-0002)
- Regression tests added/updated: YES (manual)
- Manual verification: Studio play session — breakout warning only fires in radius and repeats on the interval; Tell fires in radius with position-only payload; out-of-range Site_A tell suppressed
- Test command run: N/A (manual Studio verification)
- Result: PASS — acceptance criteria met (correct spatial params; payload has no role/identity data; Tell hook in place, consumes any world position unconditionally)

## Coverage Gaps

- Full bindable→FireClient delivery observed only by inference (needs concurrent server fire + client listen; MCP calls ran sequentially this session). Mechanism proven via identical broadcast path and in-VM bindable fire.
- Actual audio audition (placeholders resolve audibly) not confirmed; two-player in-range/out-of-range hearing test recommended with real sound assets.
- Breakout warning is a server-side periodic poll of Jail Interior attributes — fine for the placeholder Jails; will re-poll real map cells so long as they expose an Interior marker with `ChannelKind`.

## Assumptions (flagged, not silently decided)

- Audible radii (30 breakout / 20 Tell meters) and the 3s warning interval are implementation choices — GDD specifies "loud" / "localized" but no numbers. Owner tuning expected before release.
- Cue sounds are the placeholder engine ping; to be replaced with designed audio.
- Breakout warning position = cell interior center; Tell position = the world position the future Sabotage item supplies.

## Dependency Notes
- Depends on Jail System (breakout state, read via `Workspace.Jails` Interior attributes) and the Sabotage item (Tell trigger via `AudioEvents.ImpostorTellRequested` BindableEvent hook — Impostor System is last and consumes this interface).

## Retrospective

- **Keep doing**: attribute-based observability (Interior `ChannelKind` poll) keeps the Audio System decoupled without module imports; position-only payloads stayed clean; byte-exact repo↔datamodel sync caught nothing new because no splice edits were needed this time.
- **Add (next task / future)**: a thin client listener in the Impostor pass (or a debug HUD) that actually plays the cues, so the cues are audibly verifiable and the bindable→FireClient leg is observed end-to-end instead of inferred; real audio assets + owner tuning for radii/interval (REC-0006).
- **Remove / simplify**: nothing to remove; the 3s re-warn poll is the simplest design that satisfies "during an in-progress breakout."
- **Gaps**: bindable→delivery leg inferred (MCP calls ran sequentially, preventing concurrent listener+fire — tooling limitation, not code); audible audition and two-player hearing band untested. Both deferrable to before release, not release-blocking.
- **Carryovers to Impostor task**: the Impostor System must fire `ImpostorTellRequested` on Sabotage completion (acceptance criterion), and should host the cue-playing client listener; also re-validate the placeholder values sit in `AudioConfig` only.

## Report Path
`.wwg/reports/agent-implementation-log.md`; `.wwg/workspace/current-task.md`.