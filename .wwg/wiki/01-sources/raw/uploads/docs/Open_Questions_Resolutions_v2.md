# Open Question Resolutions — v2

Resolves OQ-010 through OQ-013 from the Match Manager → Audio checkpoint. Also sets priority on two gaps flagged in that checkpoint that should happen before, not after, the Impostor System.

| ID | Resolution | Status |
|---|---|---|
| OQ-010 | Tied match (3–3) triggers a single sudden-death round 7, same 3-minute format. Roles continue the normal alternation from round 6 (i.e., round 7 is just round 7 of the swap pattern, not a special case). Winner of round 7 wins the match outright — no further tiebreak needed. | DECIDED |
| OQ-011 | Reject the "first 5 join = Attackers" assumption — join order shouldn't determine role, since it lets early joiners guarantee a side every match. Randomize team assignment (shuffle all 10 players into two groups of 5) at match start instead. | DECIDED — correction, not confirmation |
| OQ-012 | Confirmed: matches the existing OQ-001 ruling (no late join). A player joining mid-match sits out and enters the next match. No change needed. | DECIDED (confirmed) |
| OQ-013 | Reject the "frees all occupants, rewardless" assumption. Active Breakout frees **only the player who completed the 45-second hold** — it does not release other occupants of that Jail, and grants no buff. This preserves the intended gap between the solo/slow path (§4.3) and the team/rewarded path (§4.5, rescue frees everyone). | DECIDED — correction, not confirmation |
| OQ-006 (restated) | Confirmed as previously resolved: Sabotage completion always fires the Impostor Tell. No change. | DECIDED (already closed) |

## Priority direction before Impostor System work

Two of the flagged gaps should happen **before or alongside** Impostor System, not after — because the Impostor System is the one place where the current gaps actually block validating the design, not just code correctness:

1. **Wire up a basic client audio listener now (even placeholder sound).** The entire point of the Breakout warning and the Impostor Tell is that players *hear* them and react — that's the core deception mechanic. Right now there's no way to actually playtest whether the audio design (range, recognizability, whether a player can tell direction) works, and the Impostor System is what makes that mechanic matter for the first time. Don't build Impostor logic against an audio system nobody can verify is audible.

2. **Start the unit-test harness (REC-0002) before Impostor System, not after.** Impostor is explicitly described as consuming hooks from every other system (`PreRoundStarted`, `AudioEvents.ImpostorTellRequested`, plus implicit dependencies on Jail/Objective state). That's the highest-interdependency system in the build — the worst possible one to build without a regression safety net under the systems it depends on.

Two-player verification (REC-0004/0005) can stay deferred — those are role-gated correctness checks, not design-validation blockers, and don't need to happen before Impostor work starts.

## Next step

Once the audio listener and a minimal test harness exist: continue with the Impostor System.
