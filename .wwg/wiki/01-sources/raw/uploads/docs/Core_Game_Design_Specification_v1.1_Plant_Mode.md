# Core Game Design Specification v1.1 — Plant Mode

**Status:** Sections 1–7 are LOCKED (carried over unchanged from v1.0). Sections 8–16 are NEW gap-fill content and are marked **DECIDED**, **RECOMMENDED**, or **UNDECIDED** per your review process. Nothing marked RECOMMENDED is final until you approve it.

---

## 1. Core Vision & Loop

The game combines four mechanical foundations into a single continuous experience:

| Foundation | Contribution |
|---|---|
| Taguan | Hiding and concealment |
| Patintero | Crossing defended territory |
| Agawan Base | Capture, Jail, and rescue |
| Social Deduction | Uncertainty about teammate trust |

### 1.1 Core Tension

> Hide → Observe → Move → Risk Exposure → Chase → Capture → Rescue → Pursue Objective → Question Teammates

### 1.2 Design Context

The game has no traditional voting meeting phase. Social deduction happens seamlessly during live gameplay, embedded inside the same continuous round that resolves the Plant objective.

---

## 2. Match Setup

| Parameter | Value |
|---|---|
| Team format | 5v5 |
| Team structure | Asymmetric: Attackers vs. Defenders |
| Role rotation | Roles swap at halftime |
| Pre-round phase duration | 15 seconds |
| Round duration | 3 minutes (180 seconds) |
| Cross-team collision | Disabled |

### 2.1 Design Context

Player collision is disabled between opposing teams to remove the ability to physically body-block chokepoints or the Jail door.

---

## 3. Player Mechanics & Information

### 3.1 Perspective

Strictly first-person for all players, all game states.

### 3.2 Movement

| Action | Rule |
|---|---|
| Walk | Available at all times |
| Crouch | Available at all times |
| Sprint | Consumes a regenerating stamina bar |

### 3.3 Vision & Information

| Rule | Value |
|---|---|
| Line-of-sight | Absolute |
| Teammate/enemy UI outlines through walls | None |

### 3.4 Disconnects During Interactions

If a player disconnects while performing a channeled interaction (plant, defuse, rescue), the interaction instantly cancels.

---

## 4. Capture & Jail System

### 4.1 Capture Rule

Defenders capture Attackers instantly by pressing interact within 1.5 meters. No cast time.

### 4.2 Jailing

Captured Attackers are instantly teleported to one of two Jails. Cannot leave through normal movement. Retain voice chat.

### 4.3 Active Breakout

| Parameter | Value |
|---|---|
| Method | Hold interact |
| Duration | 45 continuous seconds |
| Audio effect | Loud auditory warning |
| Reset condition | A Defender interacting with the cell exterior resets progress to zero |

### 4.4 Rescue Mechanic

| Parameter | Value |
|---|---|
| Who | Active Attackers |
| Method | Hold interact on Jail exterior |
| Duration | 3.0 seconds |

### 4.5 Rescue Reward

Releases all occupants of that Jail. Rescuer and every rescued player each get a 3-second speed buff and temporary capture immunity for that duration.

---

## 5. Plant Objective

### 5.1 Sites

2 to 3 designated plant sites.

### 5.2 Universal Planting

Any Attacker can initiate the plant. 5.0-second interaction. No physical "Bomb" item to carry.

### 5.3 Detonation & Defuse

| Parameter | Value |
|---|---|
| Detonation countdown | 45.0 seconds |
| Defuse | 7.0 seconds, uninterrupted |

### 5.4 Win Conditions

**Attackers win if:** the planted objective detonates.

**Defenders win if:** the 3-minute round timer expires before a plant occurs, OR Defenders defuse a planted objective, OR all Attackers are simultaneously jailed.

---

## 6. The Impostor System

### 6.1 Probability & Spawning

30% chance exactly one Impostor spawns, on either team.

### 6.2 The Warning

All players receive an "Impostor Warning" during pre-round, whether or not an Impostor spawned.

### 6.3 Mechanics

The Impostor plays as a normal player and additionally receives a secret sabotage objective.

### 6.4 The "Tell"

Completing the sabotage emits a localized spatial audio cue audible to nearby players.

### 6.5 Deception Strategy

The Impostor must separate from their team, sabotage out of earshot, and rejoin without detection.

### 6.6 Win Condition

The Impostor wins if their own team loses the round. Impostor identities are revealed only at round end.

*(Corrected from v1.0 draft, which contained a duplicated word in this line — meaning is unchanged: the Impostor's win condition is their own team's loss, consistent with their role as a saboteur.)*

---

## 7. Systems Required (Design-Level)

| System | Responsibility |
|---|---|
| Match Manager | Round phases, timer, halftime swap, win evaluation |
| Player State | Movement, stamina, capture/jail status |
| Jail System | Jail instances, breakout, rescue |
| Objective System | Plant sites, plant/detonate/defuse |
| Audio System | Breakout warning, Impostor "Tell" |

*(Expanded into full implementation contracts in Section 15.)*

---

# NEW SECTIONS — GAP-FILL (v1.1)

## 8. Spawn & Round Start Rules

**8.1 Spawn location — DECIDED.** Each team spawns in a dedicated, enclosed spawn room with a single exit, inaccessible to the opposing team for the entire round (not just pre-round). This is a map-geometry solution rather than a timer/buff solution.

> **Precedent:** Level-design guides for spawn camping in team shooters (e.g., classic Day of Defeat mapping conventions) recommend physically blocking enemy entry to spawn over timed invulnerability, because a geometric block can't be exploited or ignored the way a buff can.

**8.2 Spawn protection — RECOMMENDED.** No timed invulnerability buff is needed given 8.1, since opposing players cannot physically reach a spawn room. If future maps place spawns in open, contestable areas instead of enclosed rooms, a 3-second post-spawn invulnerability that cancels on the player's first interaction (movement, sprint, or interact input) should be added for that map only. **UNDECIDED until map geometry is finalized.**

**8.3 Pre-round control — DECIDED.** Players gain full movement control immediately at the start of the 15-second pre-round phase. Capture, plant, and rescue interactions are disabled until the round timer starts (i.e., until the pre-round phase ends). This lets players position without any team being able to capture or plant during setup.

**8.4 Impostor selection timing — DECIDED (see Section 12).**

---

## 9. State Transition & Interrupt Rules

**9.1 Capture interrupts all channeled interactions — RECOMMENDED.** If a player performing a plant, defuse, or rescue is captured, the interaction instantly cancels and progress resets to zero. This extends the existing disconnect-cancellation rule (Section 3.4) to capture, for consistency — a captured player is removed from the interaction the same way a disconnected one is.

**9.2 Plant/defuse have no progress checkpoint — DECIDED, restated for clarity.** Both the 5.0-second plant and the 7.0-second defuse are single uninterrupted attempts. If broken for any reason (capture of the interactor, or the interactor moving off the interaction point), progress resets to zero on the next attempt.

> **Precedent:** Valorant's spike defuse *does* offer a 3.5-second progress checkpoint specifically to reduce frustration from repeated interruptions in a game with many interruption sources (gunfire, utility). Your game has only two interruption sources (capture, movement-off-site) and a shorter 7s defuse, so a checkpoint is not recommended — it would let a single Defender chip away at a defuse indefinitely without real risk, undermining the "protect the planter" tension in Section 5.4.

**9.3 Movement cancels interaction — DECIDED, restated for clarity.** Plant, defuse, breakout, and rescue are all stationary channeled interactions. Any player movement input cancels the interaction in progress for that player.

**9.4 Only one active interactor per site/jail — RECOMMENDED.** Multiple players standing at the same plant site, jail exterior, or defuse point does not stack or accelerate the interaction. Only the first player to begin the interaction is progressing it; a second player attempting the same interaction on the same target does nothing until the first finishes, cancels, or is captured. This prevents "rescue zerging" or "plant zerging" from trivializing the risk the mechanic is meant to create.

---

## 10. Simultaneity & Edge Cases

| Scenario | Ruling | Status |
|---|---|---|
| Round timer hits 0 while a plant interaction is in progress but not complete | Defenders win. The plant did not occur. | DECIDED — direct reading of Section 5.4 |
| Round timer hits 0 after a successful plant | Irrelevant — the 3-minute round timer is superseded by the 45-second detonation countdown the instant a plant succeeds, matching Section 5.4's Attacker/Defender win conditions | DECIDED, restated for clarity |
| Round timer hits 0 during a rescue attempt | The round has already ended per the win conditions in 5.4 (defenders win once time expires with no successful plant); the rescue attempt is cancelled along with the round | RECOMMENDED |
| Two Defenders interact with the same Jail exterior at once (one resetting breakout, one guarding) | No conflict — breakout reset is instant and re-triggerable by any Defender at any time; it is not a channeled interaction | DECIDED, restated for clarity |
| Plant and a capture attempt happen on the same player in the same instant | Capture resolves first (it is instant, per 4.1); the plant interaction cancels as a result (per 9.1) | RECOMMENDED |
| Impostor is captured and jailed | Treated identically to any other player. Being jailed is not evidence of Impostor status. | DECIDED, restated for clarity |
| Impostor is rescued | Treated identically to any other player. | DECIDED, restated for clarity |
| Impostor disconnects mid-round | The round continues normally. No replacement Impostor is assigned. The Impostor's win condition (Section 6.6) still resolves based on their team's result at round end, even though they are no longer present. | RECOMMENDED |
| All Attackers simultaneously jailed | Defenders win immediately per 5.4 — the round does not wait for the timer. | DECIDED, restated for clarity |
| Late join mid-round | **UNDECIDED.** Options: (a) no late join, player waits for next round; (b) late join fills an empty player slot only if the round is still in progress and that team has fewer than 5 active players. Recommend (a) for the first playable build — simpler, and avoids a late-joining player receiving an Impostor role with no pre-round warning context. |

---

## 11. Information & Communication Rules

**11.1 Voice chat scope — RECOMMENDED.** Team voice chat only; players cannot hear the opposing team. This is consistent with Section 3.3 (no enemy information through walls) — the same "no free information" principle should apply to audio, not just vision.

**11.2 Jailed players retain voice chat — DECIDED, restated (Section 4.2).** A jailed player can still call out what they saw before capture (enemy positions, suspected Impostor behavior). This keeps a jailed player meaningfully engaged rather than idle, consistent with your original design principle that capture is not elimination.

**11.3 No proximity/cross-team voice chat — DECIDED by omission.** The locked spec never mentions proximity chat between teams, and Section 3.3's "no free information" principle argues against adding it. Cross-team audio should be limited to the diegetic cues already defined: the breakout warning (4.3) and the Impostor "Tell" (6.4), both of which are spatial audio, not voice chat.

**11.4 No accusation/voting system — DECIDED, restated (Section 1.2).** Consistent with "no traditional voting meetings," there is no in-game formal accusation UI. Suspicion is expressed only through team voice chat.

---

## 12. Impostor Selection Timing

**12.1 — DECIDED.** The Impostor is selected, and their secret objective is generated, at the start of the pre-round phase (i.e., before the 15-second pre-round timer begins counting down), before any player has movement control for that round.

> **Precedent:** Among Us assigns the Impostor role before players gain control at the start of the round, so no player behavior during team/spawn selection can leak information about who was assigned the role. The same logic applies here.

**12.2 — DECIDED.** The Impostor receives their secret objective as private, client-only information at the same moment. Non-Impostor players never receive any signal distinguishing "no Impostor this round" from "Impostor is on the other team" from "Impostor is on my team" — all three produce the identical pre-round warning (Section 6.2).

---

## 13. Anti-Snowballing Rules

| Snowball risk (from your original review prompt) | Ruling | Status |
|---|---|---|
| Defenders camp both Jails, making rescue nearly impossible | A Jail-camping meter fills while any Defender remains within a fixed radius of a Jail with an occupant, past a grace period. Once full, all occupants of that Jail may self-rescue with full immunity, identically to a successful teammate rescue (Section 4.5). The meter depletes if the Defender leaves the radius. | RECOMMENDED |
| Attackers repeatedly rescue the same players, stalling the round | Not a problem under the current ruleset: rescue costs 3 seconds of exposure per attempt and grants only a temporary buff, not a permanent advantage. No additional rule needed. | RECOMMENDED (no change) |
| Attacker team rushes the objective immediately, skipping the Taguan/hiding layer entirely | Not restricted — this is a valid strategy the map should be able to punish through Defender positioning, not through an artificial rule. If playtesting shows rushing is dominant, the fix belongs in map/site design (more exposed approach routes), not in a new mechanic. | RECOMMENDED (no change; flag for playtest) |
| Defenders camp plant sites so heavily that Attackers can never approach | With 2–3 sites and only 5 Defenders, full-time camping of every site leaves Defenders unable to also guard both Jails — this is the intended trade-off. No additional rule needed beyond 13's Jail-camping fix above. | RECOMMENDED (no change) |
| Impostor intentionally feeds teammates to the enemy | This is the Impostor's intended function (Section 6.3) and is not a bug to be fixed. | DECIDED (by design) |
| One player becomes isolated and repeatedly captured | Not addressed by a mechanic — the buddy-system incentive (rescue reward, Section 4.5) is the intended soft counter-pressure. | RECOMMENDED (no change; flag for playtest) |

> **Precedent:** Dead by Daylight's anti-facecamp meter (added specifically to fix "killer camps the hook, survivors can't approach") is the direct model for the Jail-camping fix above: it is proximity-scaled, only activates under genuine camping conditions, and grants the same reward a normal rescue would rather than inventing a new one.

---

## 14. Anti-Stalemate Rules

| Stalemate risk | Ruling | Status |
|---|---|---|
| Attackers permanently hide and never approach a site | The 3-minute round timer already forces this to resolve — a team that never attempts a plant automatically loses when time expires (Section 5.4). No additional rule needed. | DECIDED (by existing rule) |
| Defenders permanently retreat and never engage | Same as above — Defenders gain nothing from avoiding contact, since Attackers can eventually plant unopposed. No additional rule needed. | DECIDED (by existing rule) |
| Impostor causes indefinite delay by refusing to engage with anything | Bounded by the round timer, same as above. An Impostor who does nothing still risks their team losing on the clock, which is itself their win condition (6.6) — so "doing nothing" is a partially valid Impostor strategy, not a stalemate bug. | RECOMMENDED (no change) |
| Objective becomes practically inaccessible (e.g., all Attackers jailed at the same moment near round end) | Already resolved: "all Attackers jailed" is an explicit Defender win condition (Section 5.4), not a hang state. | DECIDED (by existing rule) |

The round timer itself is the primary anti-stalemate mechanism; no sudden-death or overtime system is needed for a single 3-minute round with a hard timer-expiry win condition on both sides.

---

## 15. Implementation Contracts (Roblox-Specific)

All gameplay-affecting actions are server-authoritative. The client only *requests* an action; the server validates range, timing, and state before applying it. This follows standard Roblox client-server security practice — never trust a client-fired RemoteEvent to represent truth.

| System | Roblox Placement | Key Remotes | Server Validates |
|---|---|---|---|
| Match Manager | `ServerScriptService` | — (drives state, not player-invoked) | Phase transitions, timer, win conditions |
| Player State | `ServerScriptService` (authoritative state) / `ReplicatedStorage` (shared ModuleScript for stamina constants) | `RequestSprint` | Stamina availability |
| Capture System | `ServerScriptService` | `RequestCapture(targetPlayer)` | Distance ≤ 1.5m, target is an active Attacker, requester is an active Defender |
| Jail System | `ServerScriptService` | `RequestBreakoutHold`, `RequestBreakoutRelease`, `RequestJailReset`, `RequestRescue` | Player is inside the correct Jail, hold duration matches server-tracked time (not client-reported time) |
| Objective System | `ServerScriptService` | `RequestPlantHold`, `RequestPlantRelease`, `RequestDefuseHold`, `RequestDefuseRelease` | Player is an Attacker/Defender as appropriate, is stationary at the site, no other interactor is already active on that site (per 9.4) |
| Impostor System | `ServerScriptService` only — never replicated to any client except the Impostor's own | (no client-fired remotes for role state) | N/A — this system exists specifically to prevent the client from ever knowing another player's role |
| Audio System | `ReplicatedStorage` (RemoteEvent) fired by server | `PlayBreakoutWarning`, `PlayImpostorTell` | Server determines which clients are within audible range before firing — the event itself carries only "play this sound at this world position," never role information |

**Design note carried from the skill's core principle:** the Impostor System is the one place in this game where a client must never be told the truth about another player, even encrypted-and-unused in memory — Roblox clients can be decompiled/inspected by exploiters, so an Impostor flag replicated to all clients (even if the UI never displays it) would be extractable. It must live exclusively in `ServerScriptService` and only ever be told to the Impostor's own client.

---

## 16. Open Items Requiring Your Decision

1. **UNDECIDED — Late join.** Recommend no late-join for v1.0 (see Section 10).
2. **UNDECIDED — Spawn geometry.** Depends on final map layout (Section 8.2) — enclosed spawn rooms remove the need for a spawn-protection buff entirely.
3. **RECOMMENDED, needs your sign-off — Jail-camping meter (Section 13).** This is a new mechanic, not present in the v1.0 locked spec. It solves a real snowball risk your original review prompt flagged, using a proven precedent (Dead by Daylight), but it is a genuinely new system and should be explicitly approved rather than silently added.
4. **Flag for playtest, not a rule change — objective rushing and single-player isolation (Section 13).** These are marked "no change" because the existing systems already create soft counter-pressure, but they're worth watching once the prototype is playable.

---

## Sources Consulted

- Valorant Spike (plant/defuse timing precedent) — valorant.fandom.com/wiki/Spike
- Dead by Daylight anti-facecamp meter (Jail-camping precedent) — mein-mmo.de
- Day of Defeat spawn protection mapping guide (spawn design precedent) — twhl.info
