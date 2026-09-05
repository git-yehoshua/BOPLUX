# Task Ticket — HUD Pass (REC-0007 expansion)

## Change Category
Meaningful feature — comprehensive UI overhaul (release-prep, no new mechanics).

## Goal
Replace placeholder console + TextLabel feedback with a proper HUD covering all server systems. Players need real-time visibility into match state, player status, jail/objective progress, and impostor signals.

## Scope (phased)

### Phase 1: Server Communication (new remotes/attributes)
- `MatchStateSync` remote — fires to all clients on phase change with: `{phase, round, timeRemaining, score: {Attackers, Defenders}, playerTeam}`
- `PlayerStateSync` remote — fires to each client on state change with: `{stamina, isSprinting, isJailed, hasSpeedBuff, hasCaptureImmunity}`
- `CampingMeterFill` attribute on Cell Interior parts (0.0–1.0) — clients poll like other cell attributes
- `SabotageFeedback` remote — fires to Impostor on success with: `{success, cooldownRemaining}`

### Phase 2: UI Framework
- Single `ScreenGui` in StarterGui with layout system (top bar, side panels, center notifications)
- Modular component architecture (each HUD element is a separate module)

### Phase 3: HUD Components
- **Match HUD**: phase banner, round counter, timer, score display, team badge
- **Player HUD**: stamina bar, sprint indicator, speed buff icon, capture immunity icon
- **Jail HUD**: jailed overlay (locked-screen effect), breakout/rescue progress bars, camping meter fill
- **Objective HUD**: site status badges (A/B), plant/defuse progress, detonation countdown
- **Impostor HUD**: warning banner (restyle), secret objective panel, reveal splash (restyle)
- **Sabotage HUD**: success notification, cooldown timer (Impostor only)

### Phase 4: Styling
- Consistent color palette (Attackers = red, Defenders = blue, Impostor = purple)
- Animations (fade, slide, pulse for warnings)
- Responsive layout (scales with screen size)

## Constraints
- Server-authoritative: no client-side game state computation
- Minimal network traffic: batch updates, fire on change not every frame
- Graceful degradation: HUD elements hidden when data unavailable
- No new mechanics — presentation only

## Acceptance Criteria
- Players can see match phase, round, timer, and score at all times
- Players see their team assignment and stamina status
- Jailed players see a clear overlay; defenders see jail progress bars
- Impostor warning/reveal are properly styled (not placeholder)
- All existing functionality preserved (no regressions)

## Validation / Test Plan
- Behavior changed: YES (UI overhaul)
- Unit tests added/updated: server sync modules (match state, player state)
- Regression tests added/updated: existing systems unaffected
- Manual verification: Studio play session — all HUD elements visible and updating
- Test command run: TBD
- Result: TBD

## Dependency Notes
- Depends on all existing server systems (Match, Player, Jail, Objective, Impostor, Sabotage, Audio, JailCampingMeter)
- Independent of OQ-008 (jail-camping meter is done; HUD just displays it)

## Report Path
`.wwg/reports/agent-implementation-log.md`; `.wwg/workspace/current-task.md`.
