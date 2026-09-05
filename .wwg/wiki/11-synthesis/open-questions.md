# Open Questions

## Purpose

Track unanswered questions blocking clarity or delivery.

## Compiled Truth

Open questions should include owner, impact, likely resolution path, and date raised.

## Open Questions

All items below originate from the canonical design source **Core Game Design Specification v1.1 — Plant Mode** (source `src_20260905_072128_core_game_design_specification_v1_1_plant_mode`), the follow-up **Open Question Resolutions v1** (source `src_20260905_073942_open_question_resolutions_v1`), and **Open Question Resolutions v2** (owner decisions delivered in-chat on 2026-09-05; raw note `wiki/01-sources/raw/notes.md` under "Open Question Resolutions v2"). Decided items were never resolved by agents — they were resolved by the project owner.

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

### Resolved (Open Question Resolutions v2)

| ID | Question | Resolution | Status | Resolved By | Date |
|---|---|---|---|---|---|
| OQ-010 | Tied match outcome (3–3 across 6 rounds): what defines the match result? | Sudden death: a 7th round in the same 3-minute format decides the match outright. Roles continue the normal alternation — round 7 is just round 7 of the existing swap pattern (block-boundary swap back to the rounds 1–3 arrangement). Winner of round 7 wins the match. 3–3 is now a normal, decided outcome. | DECIDED | Open Question Resolutions v2 | 2026-09-05 |
| OQ-011 | How are players split into the two teams? | Reject join-order assumption: teams are randomized at match start. All players are shuffled, then split into two groups; the first half are initial Attackers, the second half initial Defenders (applies below a full roster too: e.g., 5 players → 3/2). | DECIDED | Open Question Resolutions v2 | 2026-09-05 |
| OQ-012 | "No late join" waiting granularity | Confirmed: a player joining after a match has started sits out the current match and enters the next match (match-level joining; round-level joining disabled). | DECIDED (confirmed) | Open Question Resolutions v2 | 2026-09-05 |
| OQ-013 | When a breakout completes, are all Jail occupants released? | Reject release-all: breakout frees ONLY the completing player, with no speed-buff or capture-immunity reward. Rescue (3s exterior hold) still releases all occupants with rewards (§4.4/4.5 unchanged). | DECIDED | Open Question Resolutions v2 | 2026-09-05 |

### Open

No open questions remain. All design items raised by the GDD and resolutions, and all implementation assumptions surfaced during systems work (OQ-001 … OQ-013), are decided by the project owner.

## Notes

- GDD §16 also lists playtest flags (objective rushing, single-player isolation) — these are NOT open questions; they are flagged for playtest with "no change" rulings.
- OQ-006 (Sabotage interaction) and OQ-008 (Jail-camping meter) are new mechanics approved under Open Question Resolutions v1. Per owner instruction they are each tracked as their own Workspace item with independent validation, not folded into existing Jail/Objective system tasks. OQ-006's Sabotage-completion audio Tell was re-confirmed in Open Question Resolutions v2.
- The match-length/halftime definition (OQ-005) resolved a gap the GDD itself never specified; it is treated as decided truth. Its tie edge (OQ-010) is now decided: a 7th sudden-death round.
- OQ-011/012 were implementation assumptions surfaced because the GDD does not specify the team-assignment procedure or the "no late join" waiting granularity; both are now owner-decided (v2).
- OQ-013 was an implementation assumption surfaced by Jail System because GDD §4.3 does not state breakout release semantics; now owner-decided (v2): breakout frees only the completing player, rewardless.
- Jail System v0.1 also interprets §4.2 "cannot leave through normal movement" as: captured player's WalkSpeed and JumpPower are held at 0 server-side every Heartbeat (not client-side); the vehicle for ejecting from the cell is the breakout channel, not physics exploits. This is the implementation's reading, not an official GDD ruling.