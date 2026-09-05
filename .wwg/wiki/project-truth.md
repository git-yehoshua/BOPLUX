# Project Truth

This file is the highest-priority WWG truth source for this project.

Use `project-truth-summary.md` for compact active orientation before routine agent work. This full file remains canonical when details, conflicts, or durable behavior changes need review.

If this file conflicts with lower-priority reports, generated notes, task files, reference history, or stale documentation, this file wins.

Project Truth must not be silently overwritten. Requirement evolution is allowed when the user requests or accepts it and the change is documented in Project Truth, requirements, decisions, terminology, governance, or another canonical Wiki artifact.

Keep this file short and canonical. It should describe current accepted truth, not implementation history, investigation notes, or temporary ideas.

Agents must update this file when prompts, uploaded assets, code investigation, or implementation discoveries change accepted project truth. After the first meaningful implementation, this file must not remain mostly `TBD`.

## Canonical Design Source

The authoritative game design source is **Core Game Design Specification v1.1 — Plant Mode**, ingested as a raw canonical source:

- Raw file: `wiki/01-sources/raw/uploads/docs/Core_Game_Design_Specification_v1.1_Plant_Mode.md`
- Source ID: `src_20260905_072128_core_game_design_specification_v1_1_plant_mode`
- Status: sections 1–7 are LOCKED; sections 8–16 items are DECIDED, RECOMMENDED, or UNDECIDED. DECIDED and RECOMMENDED are binding project truth. UNDECIDED items are open questions owned by the project owner — do not silently resolve them.

**Open Question Resolutions v1** (source `src_20260905_073942_open_question_resolutions_v1`, raw file `wiki/01-sources/raw/uploads/docs/Open_Questions_Resolutions_v1.md`) resolves OQ-001 through OQ-009 plus the match-length/halftime gap. All nine entries are now owner-DECIDED. Permanent truth from that source:

- OQ-001: No late join for v1.0.
- OQ-002: Enclosed, single-exit spawn rooms, opponent-inaccessible for the entire round.
- OQ-003: No spawn-protection buff needed (closed by OQ-002).
- OQ-004: 2 plant sites for v1.0; a third only after 2-site rounds are validated.
- OQ-005 + match length: A match is 6 rounds total; roles swap after round 3 (3 rounds per side); match winner is the team with most rounds won across all 6.
- OQ-006: Impostor gets one dedicated Sabotage interaction — approved, tracked as its own Workspace item with independent validation.
- OQ-007: Stamina tuning: 6s continuous sprint, 1s sprint capacity per 3s not sprinting, no extra lockout. Flag for playtest tuning.
- OQ-008: Jail-camping meter approved with parameters — tracked as its own Workspace item with independent validation.
- OQ-009: Only the first interactor progresses a rescue/breakout attempt; additional present teammates do not stack or accelerate it.

**Open Question Resolutions v2** (owner, in-chat 2026-09-05; raw note in `wiki/01-sources/raw/notes.md`) adds and confirms:

- OQ-010: A 3–3 tied match (most rounds won equal after 6) goes to a 7th sudden-death round in the same 3-minute format; roles follow the normal alternation (round 7 = block-boundary swap, matching rounds 1–3 arrangement); the round-7 winner wins the match outright. Ties are now fully decided.
- OQ-011: Team assignment is randomized at match start — all players are shuffled, split into two groups, first half initial Attackers and second half initial Defenders (join order is NOT used).
- OQ-012: "No late join" confirmed as match-level — a late join sits out the current match and enters the next one (no round-level joining).
- OQ-013: A completed breakout frees ONLY the completing player, rewardless (rejects release-all). Rescue still releases all occupants with rewards.
- OQ-006 re-confirmed: Sabotage completion always fires the audio Tell.

## Product Identity

- Product name: BOPLUX
- Product category: Multiplayer, competitive, round-based first-person Roblox game
- One-line description: A 5v5 "Plant Mode" game combining Taguan (hide-and-seek), Patintero (crossing defended ground), Agawan Base (capture/jail/rescue), and social deduction via a hidden Impostor
- Primary user value: Tense asymmetric hide–observe–move–risk–chase–rescue rounds with a secret saboteur and no voting phase

## Primary Users and Roles

- **Attacker**: plants the objective; can be captured and jailed; performs 3s rescues; can be the Impostor
- **Defender**: instantly captures attackers within 1.5m; guards Jails and plant sites; defuses; resets breakout progress; can be the Impostor
- **Impostor**: secret sabotage role (30% chance per round, on either team); wins if their own team loses; identity revealed only at round end

## Canonical Scope

This project currently includes:

- 5v5 asymmetric match format: a **match is typically 6 rounds** (180s each, 15s pre-round); roles swap after **round 3** (true halftime, 3 rounds per side); match winner = most rounds won across all 6; a 3–3 tie triggers a **7th sudden-death round** (same 180s format) that decides the match outright; cross-team collision disabled
- Capture & Jail: instant capture ≤1.5m, two Jails, 45s continuous breakout that frees **only the completing player without reward** (OQ-013), 3s rescue that frees all occupants with rescue reward (speed buff + temporary capture immunity)
- Plant objective: **2 plant sites for v1.0** (a third deferred until 2-site rounds are validated), 5s plant, 45s detonation countdown, 7s defuse
- Round win conditions (GDD §5.4): plant detonates = Attacker win; timer expiry pre-plant, defuse, or all Attackers jailed = Defender win
- Impostor system: 30% spawn, pre-round warning, spatial "Tell" cue, server-only role state, plus the approved **Sabotage interaction** (20s cooldown; contextual: resets an in-progress breakout when used near a Jail, or silently cancels a teammate's active plant/defuse when used near a plant site) — tracked as its own Workspace item with independent validation
- **Jail-camping meter** (approved): 6m proximity radius, 10s grace period, fills over 20s continuous camping, depletes when the Defender leaves the radius — tracked as its own Workspace item with independent validation
- Sprint/stamina: 6s continuous sprint, regen 1s sprint capacity per 3s not sprinting, no lockout (flagged for playtest tuning)
- No late join for v1.0 (players who arrive mid-match wait for the next match — OQ-012)
- Systems: Match Manager, Player State, Jail System, Objective System, Audio System, Impostor System (GDD §7, expanded in §15)
- Server-authoritative Roblox implementation contract (GDD §15) — clients only request; server validates range, timing, state

This project explicitly does not include unless approved:

- A formal voting/accusation UI (GDD §11.4 — suspicion is expressed via team voice chat only)
- Proximity or cross-team voice chat (GDD §11.3)
- A "Bomb"/carryable item — planting is a stationary channeled interaction, no physical item (GDD §5.2)
- Late join (DECIDED out for v1.0)
- A spawn-protection invulnerability buff (DECIDED not needed — spawn rooms are enclosed per OQ-002)
- A third plant site until 2-site rounds are validated

## Canonical Terminology

Use `.wwg/wiki/terminology.md` for detailed terms. If this project also has `.wwg/wiki/02-project/glossary.md`, reconcile glossary detail against this file.

Critical terms:

- Plant, Defuse, Detonation countdown, Plant site (2 sites for v1.0)
- Capture, Jail, Breakout, Breakout reset, Rescue, Capture immunity
- Impostor, Impostor Warning, Impostor "Tell", **Sabotage interaction**
- Pre-round, Round timer (180s), **Match (6 rounds)**, **Half (3 rounds per side)**, Halftime (swap after round 3), Stamina
- Jail-camping meter (approved via OQ-008 — own Workspace item, independent validation)

## Architecture Truth

Accepted architecture:

- Roblox client–server, server-authoritative for all gameplay-affecting state. The client only fires request remotes: `RequestSprint`, `RequestCapture`, `RequestBreakoutHold`, `RequestBreakoutRelease`, `RequestJailReset`, `RequestRescue`, `RequestPlantHold`, `RequestPlantRelease`, `RequestDefuseHold`, `RequestDefuseRelease`, `RequestSabotage`. Server validates range ≤1.5m (capture), stationarity, team/state, hold durations (server-measured), sabotage cooldown/context (plant-site or Jail-exterior adjacency, targeted interaction exists), and one-active-interactor-per-target (GDD §15 + OQ-006)
- Match structure drives phases/timer/win conditions server-side: per-round phases (pre-round 15s → round 180s) and match-level state (typically 6 rounds, roles swap at block boundaries after round 3 and at round 6→7 for sudden death, match winner by most rounds won, tied 3–3 → sudden-death round 7)
- Audio System in `ReplicatedStorage`: server fires `PlayBreakoutWarning`, `PlayImpostorTell`, and the Sabotage "Tell" with position-only payload after computing audibility; never role information
- Impostor System lives exclusively in `ServerScriptService`; role state is never replicated to any client except the Impostor's own client (GDD §15 design note)
- Jail-camping meter is server-evaluated proximity logic (6m/10s grace/20s fill per OQ-008), handled as its own system item

Do not introduce without approval:

- Any client-trusted gameplay state or RemoteEvent that skips server validation
- Replication of Impostor role state beyond the Impostor's own client
- Proximity/cross-team voice or accusation UI

## Safety and Production Boundaries

Current safety boundaries:

- Client-fired events are requests, never truth — server validates everything
- Impostor role data must never be readable by non-Impostor clients, even unused/encrypted in memory (client can be decompiled)
- Interaction interruption rules are canonical (GDD §3.4, §9): any player movement cancels channeled interactions; capture/disconnect cancels plant/defuse/rescue and resets progress

Mock/demo-only areas:

- None defined yet

Do not claim or imply production readiness for:

- This project is a prototype-stage game whose design is governed by the GDD; no production deployment, monetization, or live-service posture exists yet

## Current Product Direction

Current direction:

- Implement the six §15 server-authoritative systems as tracked Workspace tasks, in order: Match Manager → Player State → Jail System → Objective System → Audio System → Impostor System (last, due to dependencies) — **all six now implemented and verified; OQ-006 Sabotage interaction also implemented; remaining work: release-prep items (CuePlayer fix, HUD pass, 2-player session, audio tuning)**
- OQ-006 Sabotage interaction and OQ-008 Jail-camping meter are each their own Workspace task with independent validation (not folded into the existing Jail/Objective tasks)
- All previously UNDECIDED items and all surfaced implementation assumptions (OQ-001 … OQ-013) are owner-resolved (Open Question Resolutions v1 + v2); no open design questions remain
- Track playtest flags: sprint tuning (OQ-007), objective rushing and single-player isolation behaviors (GDD §16.4)

Avoid drifting into:

- Adding mechanics not in the GDD or unauthored resolutions without owner approval
- Treating WWG as a Roblox import/runtime — WWG is the repo/workspace governance layer only

## Current vs Historical Notes

- Current canonical truth belongs in this file.
- Historical decisions belong in ADRs, logs, or reports.
- Root README belongs at `README.md` as the concise project front door: what the project is, why it exists, how to start, and where to go next.
- Meaningful release memory belongs in root `CHANGELOG.md` as non-technical project history and release subtext.
- Temporary investigation notes belong in reports until promoted.
- Documentation lag should be surfaced and reconciled, but not every lagging doc is harmful drift.
- Implementation, reports, generated outputs, or handoff notes that contradict Project Truth should be flagged before close-out.

## Truth Alignment Expectations

- Green / Aligned: continue.
- Yellow / Mild Truth Drift: warn and recommend sync or review.
- Orange / Significant Truth Drift: pause for planning or reconciliation.
- Red / Critical Alignment Break: stop and resolve the conflict, regression, high-risk issue, unsafe overwrite, or weakened verification first.

High-risk changes require planning, Project Truth or governance updates, and verification before they are treated as aligned. High-risk areas include payment, auth, authorization, security, persistence, database or user data, production deployment, destructive or irreversible actions, and regulated or compliance-sensitive behavior.

## Update Rules

Update this file when:

- Product category changes.
- User roles change.
- Canonical terminology changes.
- Architecture boundaries change.
- Safety boundaries change.
- Production-readiness boundaries change.
- Major product decisions become accepted truth.
- An UNDECIDED open question is resolved by the project owner.
- High-risk behavior, production claims, approval requirements, or verification expectations change.

Also evaluate `CHANGELOG.md` when meaningful behavior, workflow, governance, template, documentation truth, safety, reliability, command, or agent behavior changes. Patch-level changelog updates may be automated when apply is explicit. Minor and major version bumps require an explicit user command.

Also evaluate `README.md` when meaningful behavior, workflow, governance, template, documentation truth, safety, reliability, command, or agent behavior changes. Keep README concise and route detailed command, governance, changelog, wizard, infrastructure, maintenance, phase history, agent instruction, canonical truth, validation, and report content to the correct project surface.

Unresolved placeholders are acceptable during initial planning, but not after meaningful implementation proves or changes project truth.