# Changelog

All notable changes to BOPLUX are recorded here in non-technical, outcome-based language.

## [0.1.4] - 2026-09-05

### Added

- The plant and detonation system is now live: Attackers can claim a bomb site by holding a stationary 5-second interaction (only one teammate's hold counts at a time, measured server-side). A completed plant starts a 45-second detonation countdown that takes over from the round clock, and the Attackers win the round when it hits zero.
- Defenders can reverse a plant by holding a stationary 7-second defuse at the site; a completed defuse ends the round immediately with a Defender win.
- Two sites exist in the scene (placeholder geometry until the real map is built), each showing live plant/defuse/detonation state for later UI.
- Any movement, the wrong team trying to interact, or a second player submitting to the same site aborts an interaction and wipes its progress; a second plant is refused while one is already active.

### Notes

- Three interpretation points surfaced during implementation for owner confirmation: the site's interaction range is treated horizontally (standing on a site's footprint, not a magic height), and on the same tick a last-instant defuse is judged before detonation resolves.
- The Defender defuse was verified live with the only-role check bypassed through a debug command; a full two-player session is still needed to exercise it through the normal route.
- Remaining §15 systems (Audio, Impostor) are still queued as tracked Workspace tasks. Unit-test harness is still pending.

## [0.1.3] - 2026-09-05

### Added

- The capture and Jail system is now live: Defenders capture Attackers within 1.5 meters into one of two Jails; a captured player is held at zero speed and jump height and cannot leave normally.
- Jailed Attackers can attempt a breakout by holding a stationary 45-second interaction; any active interacting teammate no longer stacks progress (only the first interactor counts). The server measures the whole hold, never trusting the client clock.
- A Defender standing at a Jail's exterior resets any in-progress breakout progress back toward zero.
- Teammates can rescue a Jail by holding a stationary 3-second interaction at its exterior; a completed rescue frees everyone in that Jail at once and gives the rescued players and the rescuer a 3-second speed bonus and temporary capture immunity.
- Round 0-specific enforcement: if every Attacker is jailed at once the round ends immediately with a Defender win.

### Notes

- The Jails in the scene are temporary placeholder geometry until the real map is built.
- One design point surfaced during implementation for owner confirmation: a completed breakout frees everyone in that Jail (rewardless), matching how rescue frees everyone — tracked as OQ-013.
- Three victory conditions still need two real players to fully live-verify (real Defender capture, Defender reset-on-touch, and a rescue that actually frees an occupant); the single-client session verified everything else.
- Remaining §15 systems (Objective, Audio, Impostor) are still queued as tracked Workspace tasks. Unit-test harness is still pending.

## [0.1.2] - 2026-09-05

### Added

- Player State is live: the server now owns each player's movement and stamina. Sprint drains the full 6-second stamina bar, auto-stops when exhausted, and refills while not sprinting (1 unit per 3 seconds, no lockout). Requests come through a server-validated remote, so stamina is never client-trusted.
- Team/world collision is now enforced: Attackers and Defenders can't walk through each other, teammates can, and all characters collide with the map.
- All player views are locked to first-person, matching the capture/jail game's fixed camera rule.

### Notes

- Two bugs caught during verification (character-spawn callback was handed a model instead of a player; deprecated collision API) were fixed before release.
- Remaining §15 systems (Jail, Objective, Audio, Impostor) are still queued as tracked Workspace tasks. Unit-test harness is still pending.

## [0.1.1] - 2026-09-05

### Added

- First server-authoritative system is now live in the workspace: the Match Manager drives the full match lifecycle — 6 rounds, roles swap after round 3, 15-second pre-rounds and 180-second rounds, per-round win tracking, and match-end evaluation (rounds won per team).
- Nine previously-open design points are now closed decisions (late join, spawn rooms, site count, halftime semantics, Impostor sabotage, stamina tuning, Jail-camping meter, first-interactor rule) and are bound into Project Truth and Terminology.
- The only remaining open design point is a tied match (3–3): the Match Manager deliberately reports it as unresolved instead of guessing a winner.

### Notes

- Two implementation assumptions were surfaced for owner confirmation (team assignment order, and what "no late join" waits for): tracked as OQ-011 and OQ-012.
- Remaining §15 systems (Player State, Jail, Objective, Audio, Impostor) are queued as tracked Workspace tasks. Unit-test harness is still pending.

## [0.1.0] - 2026-09-05

### Added

- Initial WWG-native project foundation: the repository is now governed by a Wiki → Workspace → Governance operating layer with the `game` profile and standard governance.
- The authoritative **Core Game Design Specification v1.1 (Plant Mode)** has been ingested as the canonical design source of truth and is now bound into Project Truth and Terminology.
- Design truth now covers the 5v5 Plant Mode fundamentals: capture/jail/rescue, plant/detonate/defuse, the hidden Impostor system, round structure, and the server-authoritative Roblox implementation contract.
- Nine undecided or ambiguous design items (late join, spawn geometry, spawn protection, site count, halftime semantics, Impostor sabotage objectives, stamina tuning, Jail-camping meter parameters, jail interaction priority) are tracked as open questions awaiting owner decisions.

### Notes

- No game code was written yet. Implementation of the capture, jail, and plant systems will be tracked as Workspace tasks after the open design questions are resolved.