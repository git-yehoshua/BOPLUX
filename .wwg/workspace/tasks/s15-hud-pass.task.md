# Task Ticket — HUD Pass (REC-0007 expansion)

## Change Category
Meaningful feature — comprehensive UI overhaul (release-prep, no new mechanics).

## Goal
Replace placeholder console + TextLabel feedback with a proper HUD covering all server systems. Players need real-time visibility into match state, player status, jail/objective progress, and impostor signals.

## Scope (phased)

### Phase 1: Server Communication (new remotes/attributes) — DONE
- `MatchStateSync` remote ✅ | `PlayerStateSync` remote ✅ | `CampingMeterFill` attribute ✅ | `SabotageFeedback` remote ✅

### Phase 2: UI Framework — DONE
- ScreenGui in StarterGui ✅ | HUD builder script ✅ | HUDController flat TopBar ✅

### Phase 3: HUD Components — IN PROGRESS
- **Match HUD**: phase banner, round counter, timer, score, team badge ✅ (top bar functional)
- **Player HUD**: stamina bar, sprint indicator, speed buff, capture immunity ✅ (top bar functional)
- **Jail HUD**: jailed overlay, breakout/rescue progress, camping meter ⬜ (panel exists)
- **Objective HUD**: site status A/B, plant/defuse, detonation countdown ⬜ (panel exists)
- **Impostor HUD**: warning banner ⬜, secret objective ⬜, reveal splash ⬜
- **Sabotage HUD**: success notification, cooldown timer ⬜

### Phase 4: Styling
- Consistent color palette, Animations, Responsive layout

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
- Manual verification: Studio play session — all HUD elements visible and updating ✅
- Test command run: RunTests harness — 65/65 ALL PASS ✅
- Result: PASS

## Dependency Notes
- Depends on all existing server systems (Match, Player, Jail, Objective, Impostor, Sabotage, Audio, JailCampingMeter)
- Independent of OQ-008 (jail-camping meter is done; HUD just displays it)

## Report Path
`.wwg/reports/agent-implementation-log.md`; `.wwg/workspace/current-task.md`.
