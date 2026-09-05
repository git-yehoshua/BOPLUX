# Task Ticket — Sabotage interaction (OQ-006) — INDEPENDENT ITEM

## Change Category
Meaningful feature — new mechanic (approved via Open Question Resolutions v1, OQ-006). Treated as its own Workspace item with an independent validation pass, per owner instruction. NOT folded into the Jail or Objective system tasks.

## Goal
The Impostor's single dedicated Sabotage interaction.

## Scope (from OQ-006)
- One dedicated Sabotage interaction usable ONLY within range of a plant site or a Jail exterior.
- 20s cooldown.
- Always fires the localized audio Tell (§6.4) through the Audio System.
- Contextual effect:
  - Near a Jail → silently resets an in-progress breakout (progress back to zero).
  - Near a plant site → silently cancels a nearby teammate's active plant/defuse.
- Server-authoritative: server validates adjacency-to-site/jail, cooldown, existence of the targeted interaction, and Impostor role (role lookup comes from the Impostor System's server-only store — never from the client).

## Constraints
- Client never sends "I am Impostor" claims; only an anonymous request at a location. Server decides role + effect.
- Cancellation is silent to the victim's HUD mechanics defined in the GDD (no new global reveal) — only the positional audio Tell plays. If an effect can be observed, cancellation still follows §9.2 (progress resets to zero).
- Cooldown is server-measured per Impostor, never client-reported.
- Player State / Jail System / Objective System expose hooks (implemented in their tasks) so this item does not own their state.

## Inputs
- `.wwg/wiki/project-truth.md`, `.wwg/wiki/terminology.md` (Sabotage interaction term)
- OQ-006 in `11-synthesis/open-questions.md` (resolved)
- GDD §6.3/6.4, §15 contract pattern

## Acceptance Criteria
- Sabotage accepted only when the server confirms: requester is the Impostor, within range of a Jail exterior or plant site, off cooldown, and the targeted interaction exists.
- Breakout-reset and plant/defuse-cancel effects apply server-side and reset progress to zero.
- Tell fires every time, spatially, via Audio System.

## Validation / Test Plan
- Behavior changed: YES (new mechanic)
- Unit tests added/updated: range+cooldown gating, contextual effect selection, Tell-on-complete coupling, silence-of-role (no role data in any validation path)
- Regression tests added/updated: YES
- Manual verification: Studio play session
- Test command run: TBD
- Result: TBD

## Dependency Notes
- Depends on Impostor System (role store), Jail System (breakout state + reset hook), Objective System (plant/defuse cancel hook), Audio System (Tell).
- Independent validation pass required — do not merge into Jail or Objective task validation.

## Report Path
`.wwg/reports/agent-implementation-log.md`; `.wwg/workspace/current-task.md`.