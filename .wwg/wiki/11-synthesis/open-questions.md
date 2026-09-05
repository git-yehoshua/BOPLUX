# Open Questions

## Purpose

Track unanswered questions blocking clarity or delivery.

## Compiled Truth

Open questions should include owner, impact, likely resolution path, and date raised.

## Open Questions

All items below originate from the canonical design source **Core Game Design Specification v1.1 — Plant Mode** (source `src_20260905_072128_core_game_design_specification_v1_1_plant_mode`) or the follow-up **Open Question Resolutions v1** (source `src_20260905_073942_open_question_resolutions_v1`). Decided items were never resolved by agents — they were resolved by the project owner.

### Resolved (Open Question Resolutions v1)

| ID | Question | Resolution | Status | Resolved By | Date |
|---|---|---|---|---|---|
| OQ-001 | Late join policy: (a) no late join vs (b) mid-round slot fill? | No late join for v1.0. | DECIDED | Open Question Resolutions v1 (`src_20260905_073942_open_question_resolutions_v1`) | 2026-09-05 |
| OQ-002 | Spawn geometry: are spawns enclosed single-exit rooms? | Enclosed, single-exit spawn rooms; opponent-inaccessible for the entire round. | DECIDED | Open Question Resolutions v1 | 2026-09-05 |
| OQ-003 | Spawn-protection buff needed? | No buff needed — closed by OQ-002. | DECIDED (no build) | Open Question Resolutions v1 | 2026-09-05 |
| OQ-004 | Plant site count for v1.0? | 2 sites; add a third only after 2-site rounds are validated. | DECIDED | Open Question Resolutions v1 | 2026-09-05 |
| OQ-005 | Halftime semantics (round-level vs match-level)? | A match is 6 rounds total; roles swap after round 3 (3 rounds per side); match winner = most rounds won across all 6. Also resolves the match-length gap the GDD never specified. | DECIDED | Open Question Resolutions v1 | 2026-09-05 |
| OQ-006 | Impostor sabotage objective set? | One dedicated Sabotage interaction; usable only within range of a plant site or Jail exterior; 20s cooldown; always fires the audio Tell; contextual effect (near Jail: reset in-progress breakout; near plant site: silently cancel a nearby teammate's active plant/defuse). | DECIDED (approved as new mechanic; own Workspace item with independent validation) | Open Question Resolutions v1 + owner sign-off | 2026-09-05 |
| OQ-007 | Stamina tuning targets? | 6s continuous sprint; 1s sprint capacity per 3s not sprinting; no additional lockout. | DECIDED (flag for playtest tuning) | Open Question Resolutions v1 | 2026-09-05 |
| OQ-008 | Jail-camping meter parameters + sign-off? | Approved: 6m proximity radius, 10s grace period, fills over 20s continuous camping, depletes if the Defender leaves the radius. Own Workspace item with independent validation. | DECIDED | Open Question Resolutions v1 + owner sign-off | 2026-09-05 |
| OQ-009 | Only-first-interactor applies to rescue/breakout? | Confirmed: only the first interactor progresses a rescue or breakout attempt; present teammates do not stack or accelerate it (§9.4 applies). | DECIDED | Open Question Resolutions v1 | 2026-09-05 |

### Open

| ID | Question | GDD Reference | Owner | Impact | Likely Resolution Path | Date Raised |
|---|---|---|---|---|---|---|
| OQ-010 | Tied match outcome: what happens when all 6 rounds are split 3–3 ("most rounds won" is equal)? Requires a defined match result (e.g., a 7th deciding round, or draw declared a Defender-side tiebreak). | OQ-005 resolution ("most rounds won across all 6") — tie case unspecified by GDD or resolutions | Project owner | Blocks final Match Manager win/decisive-end implementation | Owner picks a tie-handling rule | 2026-09-05 |
| OQ-011 | Team assignment policy: how are players split into the two 5-player teams? The GDD defines 5v5 and halftime role swap but never specifies the assignment procedure or team-swap behavior. Match Manager v0.1 scaffold assumes join order: first 5 players initial Attackers, next 5 initial Defenders (applies even below a full roster). | GDD §2 (5v5) — no assignment procedure specified | Project owner | Team composition & match structure | Owner confirms or replaces the join-order assumption (e.g., team selection screen, queue-based matchmaking) | 2026-09-05 (assumption flagged from implementation, not a design resolution) |
| OQ-012 | "No late join" scope: does a player joining after a match has started wait only for the next round, or entirely for the next match? OQ-001 says "No late join for v1.0" without specifying the waiting granularity. Match Manager v0.1 scaffold assumes: sit out the current match, enter the next match (round-level joining disabled). | OQ-001 resolution wording | Project owner | Joining behavior and waiting-room UX | Owner confirms match-level vs round-level scope for v1.0 | 2026-09-05 (assumption flagged from implementation, not a design resolution) |
| OQ-013 | When a breakout completes, are ALL occupants of that Jail released, or only the breakout interactor? GDD §4.3 does not state per-interactor vs per-cell semantics; §4.5 rescue explicitly releases all occupants. Jail System v0.1 assumes breakout releases ALL occupants (rewardless, matching rescue's all-occupant behavior). Also assumed: breakout applies no speed-buff/immunity reward (only rescue rewards §4.4/4.5). | GDD §4.3 (breakout) — per-interactor target unspecified | Project owner | Breakout interaction payoff for teammates inside the same cell | Owner confirms all-occupants release (current behavior) or restrict to interactor | 2026-09-05 (assumption flagged from Jail System implementation, not a design resolution) |

## Notes

- GDD §16 also lists playtest flags (objective rushing, single-player isolation) — these are NOT open questions; they are flagged for playtest with "no change" rulings.
- OQ-006 (Sabotage interaction) and OQ-008 (Jail-camping meter) are new mechanics approved under Open Question Resolutions v1. Per owner instruction they are each tracked as their own Workspace item with independent validation, not folded into existing Jail/Objective system tasks.
- The match-length/halftime definition (OQ-005) resolved a gap the GDD itself never specified; it is treated as decided truth, not a future OQ. Its only remaining edge is the tied-match case, tracked as OQ-010.
- OQ-011 and OQ-012 are NOT design resolutions — they are implementation assumptions surfaced because the GDD does not specify the team-assignment procedure or the "no late join" waiting granularity. They are recorded here so the owner can confirm or replace them before Player State / matchmaking work deepens. Match Manager v0.1 behaves per the assumptions stated in the table.
- OQ-013 is NOT a design resolution — it is an implementation assumption surfaced by Jail System v0.1 because GDD §4.3 does not state breakout release semantics. Current behavior releases all occupants rewardlessly. Like OQ-011/012, the owner should confirm or replace before polish work deepens.
- Jail System v0.1 also interprets §4.2 "cannot leave through normal movement" as: captured player's WalkSpeed and JumpPower are held at 0 server-side every Heartbeat (not client-side); the vehicle for ejecting from the cell is the breakout channel, not physics exploits. This is the implementation's reading, not an official GDD ruling.