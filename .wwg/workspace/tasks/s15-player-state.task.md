# Task Ticket — §15 Player State (server-authoritative)

## Change Category
Meaningful feature — system implementation (Roblox Luau, server-side).

## Goal
Authoritative per-player state: movement, stamina, team/role, capture/jail status, sprint requests.

## Scope
- `RequestSprint` remote (ReplicatedStorage per §15 placement note) validated against stamina.
- Stamina model per OQ-007: 6s continuous sprint capacity; regen 1s capacity per 3s not sprinting; no extra lockout. Flag for playtest tuning.
- Movement legality: walking/crouching available at all times; sprint consumes stamina; first-person only (§3).
- Team/role assignments applied from Match Manager (Attacker/Defender per half; Impostor flag lives ONLY in Impostor System — Player State must never store/replicate Impostor role).
- Cross-team collision disabled (§2.1) applied at role assignment.
- Capture/jail status flags consumed by Jail System; disconnect handling (§3.4).

## Constraints
- Server-authoritative; validate sprint requests against server-measured stamina, never client-reported.
- No Impostor role data here — that is Impostor System's exclusive surface.

## Inputs
- `.wwg/wiki/project-truth.md`, `.wwg/wiki/terminology.md`
- GDD §3, §7 Player State row, §15 Player State row
- OQ-007 stamina tuning

## Acceptance Criteria
- Sprint is denied when stamina is exhausted and re-enabled on regen per OQ-007 numbers.
- Client cannot move/sprint illegally regardless of high ping or forged events.
- Role swaps at halftime reflected in server state without leaking Impostor data.

## Validation / Test Plan
- Behavior changed: YES
- Unit tests added/updated: pending harness (REC-0002); module state isolated from MCP probe VM, so unit tests recommended before next harness iteration
- Regression tests added/updated: pending harness
- Manual verification: Studio play session — verified sprint accept (WS 25), exhaustion auto-stop after 6s (WS 16), no-lockout regen allows re-sprint, collision group Attackers applied, no console errors
- Test command run: N/A (manual Studio verification)
- Result: IMPLEMENTED + VERIFIED (play session, 2026-09-05)

## Implementation Notes
- Files (Script Sync roots → Studio Place1, `ServerScriptService.PlayerState`):
  - `PlayerStateModule.lua` (ModuleScript) — authoritative per-player state: register/unregister, `step` heartbeat (6s sprint drain; regen 1/3 per s not sprinting; auto-stop at 0), `requestSprint` (deny if jailed or stamina <= 0), `setJailed`/`isJailed`, `grantCaptureImmunity`/`hasCaptureImmunity`, `grantSpeedBuff` (rescue 21 for 3s), `resetPlayerRound`/`resetAllPlayers` (Live-phase hook).
  - `RunPlayerState.server.lua` (Script) — collision groups (Attackers/Defenders same-team collidable, cross-team disabled, Default collidable), applies group to character on spawn/role change; `RequestSprint` RemoteEvent created in `ReplicatedStorage.MatchSystems`; CameraMode LockFirstPerson; Heartbeat stamina loop; Match Manager PhaseChanged wiring (PreRound→syncAllRoles, Live→resetAllPlayers, Halftime→syncAllRoles); 0.1s toggle cooldown.
  - `ReplicatedStorage/Shared/StaminaConstants.lua` — client-visible stamina constants for future UI (server module self-contains its values).
- No Impostor role data anywhere in Player State surface (per constraint).
- Verification route learned: `RemoteEvent:FireServer` from Server data model throws "FireServer can only be called from the client"; use `execute_luau` with `datamodel_type=Client` to simulate the player (client can read its own replicated humanoid WalkSpeed).
- Studio Script Sync caveats observed this session: incremental file changes to already-imported ServerScriptService scripts stopped applying; the fix was to write instances directly into the datamodel (script.Source via execute_luau / multi_edit) and keep repo `.lua` files as the canonical mirror. A stale module instance from an earlier naming collision was removed and replaced with `PlayerStateModule`.
- Bug fixed during verification: `CharacterAdded` connects receive the character, not the player — `onCharacterAdded(player)` treated a Model as a Player, causing "UserId is not a valid member of Model"; signature now `onCharacterAdded(player, character)`. Also replaced deprecated `SetPartCollisionGroup` with `part.CollisionGroup`.

## Dependency Notes
- Depends on Match Manager (roles/halftime); consumed by Jail System and Objective System.

## Report Path
`.wwg/reports/agent-implementation-log.md`; `.wwg/workspace/current-task.md`.