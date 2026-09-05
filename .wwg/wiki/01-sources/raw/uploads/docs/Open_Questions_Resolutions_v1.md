# Open Question Resolutions — v1

Resolves: OQ-001 through OQ-009 from `.wwg/wiki/11-synthesis/open-questions.md`, plus one item those questions surfaced that the GDD itself never specified (match length / halftime definition).

| ID | Resolution | Status |
|---|---|---|
| OQ-001 | No late join for v1.0. | DECIDED |
| OQ-002 | Enclosed, single-exit spawn rooms; inaccessible to the opposing team for the entire round. | DECIDED |
| OQ-003 | No spawn-protection buff needed — closed by OQ-002. | DECIDED (no build) |
| OQ-004 | 2 plant sites for v1.0 (not 3). Add a third only after 2-site rounds are validated. | DECIDED |
| OQ-005 + match length | A match is 6 rounds total. Roles swap after round 3 (true halftime: 3 rounds per side). Win = most rounds won across all 6. | DECIDED |
| OQ-006 | Impostor gets one dedicated **Sabotage** interaction, usable only within range of a plant site or Jail exterior, 20s cooldown. Always fires the audio Tell (§6.4). Effect is contextual: near a Jail, silently resets an in-progress breakout; near a plant site, silently cancels a nearby teammate's active plant/defuse. | RECOMMENDED — new mechanic, needs explicit sign-off before implementation, same as OQ-008 |
| OQ-007 | Sprint: 6 continuous seconds before forced to walk pace. Regeneration: 1 second of sprint capacity per 3 seconds not sprinting. No additional cooldown/lockout beyond natural regen. | RECOMMENDED — flag for playtest tuning |
| OQ-008 | Approved. Jail-camping meter parameters: 6m proximity radius, 10s grace period before the meter starts filling, fills over 20s of continuous camping within radius. Depletes if the Defender leaves the radius. | DECIDED (mechanic + parameters approved) |
| OQ-009 | Confirmed: only the first interactor progresses a rescue or breakout attempt. Additional teammates present do not stack or accelerate it — consistent with §9.4's plant/defuse rule. | DECIDED |

## Notes for the agent

- OQ-006 and OQ-008 are both new mechanics not present in the original locked v1.0 spec. Both are approved above, but treat them as their own tracked Workspace items with their own validation pass — don't fold them silently into existing Jail/Objective system work.
- The match-length/halftime gap wasn't one of the nine OQs but was implied by OQ-005 — it's now resolved above and should be added to Project Truth alongside OQ-005's answer, not treated as a separate future OQ.
- Nothing above is a default — these are my design calls, made using the same precedent-grounded approach as the v1.1 GDD (Section 13's Jail-camping fix in particular is a direct continuation of that same reasoning). If any of these don't sit right once you see them in play, flag it and we'll revise before more Workspace items depend on them.
