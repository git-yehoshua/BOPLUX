# Changelog

All notable changes to BOPLUX are recorded here in non-technical, outcome-based language.

### Added

- **HUD Pass Phase 3**: ImpostorClient wired to unified HUD banners — removed `ImpostorClientGui` ScreenGui, now updates `BOPLUX_HUD` WarningBanner/RevealBanner directly via MatchSystems remotes. Task ticket and docs updated.
- **HUD Pass Phase 4**: Animations and styling polish — `TweenService` fade-in (top bar elements, 0.6s staggered), slide-in (side panels, Back easing), pulse animation for warning/reveal banners, `UICorner` polish on TopBar. Builder script rebuilt on every play session to ensure animations apply.

### Fixed

- **HUD builder sync**: `BOPLUX_HUDSetup.local.luau` now destroys existing HUD clone before rebuilding, ensuring animations always apply on every play session. Builder script synced to datamodel's StarterGui.

## [0.1.10] - 2026-09-06

### Added

- **Jail-camping meter (OQ-008)**: Anti-snowball mechanic that prevents Defenders from camping outside a Jail to守株待兔. When a Defender stands within 6 meters of a Jail exterior while occupants are inside, a server-tracked meter begins filling after a 10-second grace period. After 20 seconds of continuous camping, the meter is full and all occupants of that Jail may self-rescue — receiving a 3-second speed buff and capture immunity, identical to a successful teammate rescue. The meter depletes immediately when the Defender leaves the radius, and grace restarts on re-entry. Server-authoritative: all proximity checks, timing, and self-rescue execution happen server-side with no client trust.

## [0.1.9] - 2026-09-05

### Fixed

- **CuePlayer audio fix**: The audio cue listener (`StarterPlayerScripts/CuePlayer.local.luau`) was attempting to set `Sound.Position`, a property that does not exist in Roblox. This caused all audio cues (breakout warning and Impostor Tell) to fail silently with console errors. Fixed by creating a small anchored Part (`SoundAttachment`) at the target position, parenting the Sound to it, and destroying both after playback. Added proper 3D spatialization settings (`RollOffMode = InverseTapered`, `DopplerMode = Off`, `EmitterSize = 1`).

- **ImpostorClient banner fix**: The notification banner background (`StatusLabel` in `StarterPlayerScripts/ImpostorClient.local.luau`) persisted visible alongside the player name display after the notification text was cleared. Fixed by setting `label.BackgroundTransparency = 1` initially (invisible), `0.35` when text appears, and resetting to `1` after the 6s delay when text clears.

## [0.1.8] - 2026-09-05

### Added

- The Impostor's Sabotage interaction is now live. The Impostor can activate it near a Jail exterior or a plant site — never at arbitrary range, never without a valid target, never without a 20-second cooldown enforced server-side.
- Near a Jail with an active breakout, sabotage silently resets the breakout progress back to zero (the jailed player must start over). Near a plant site where a teammate is actively planting or defusing, sabotage silently cancels that teammate's channel.
- Every sabotage activation plays the localized audio Tell so nearby players hear the cue — the Impostor cannot sabotage silently.
- The server decides everything: whether the requester is actually the Impostor (read from server-only state, never from client claims), whether the target is in range, whether the cooldown has expired, and whether the targeted interaction actually exists. If any check fails, nothing happens.

### Notes

- All six core server systems plus the approved Sabotage interaction are now implemented and covered by 54 automated unit tests, all passing.
- Presentation is still placeholder (console + one simple text label); a proper HUD pass is queued before release.
- A pre-existing audio playback bug was identified during testing (sounds cannot be positioned in 3D space with the current approach); a fix is queued.

## [0.1.7] - 2026-09-05

### Added

- The hidden Impostor is now live. Every round has a 30% chance of one secret saboteur on either team, chosen before anyone gains control of the round. The Impostor plays as a normal teammate but also receives a private sabotage objective (either reset a breakout at a specific Jail or cancel a plant/defuse at a specific site), chosen from targets that actually exist on the map.
- Round-end identity reveal: each round ends with a single server-side broadcast naming the round's Impostor (if any) and whether the Impostor won or lost, so the social-deduction loop actually closes every round.
- The pre-round Impostor Warning is now a real, identical broadcast to every player every pre-round — including rounds with no Impostor — so no one can deduce role information from the warning itself.
- Role secrecy is enforced by construction: the Impostor's identity exists only inside server-only storage and is delivered solely to that one player's client. A client-side sweep of 619 replicated instances found no trace of role data.
- Sound cues now actually play: the cue listener lives in the player's script container where client scripts can execute (it previously sat where scripts never run, so no one could hear anything).

### Notes

- All six core server systems (match flow, player state, jail, objective, audio, impostor) are now implemented and covered by 29 automated unit tests, all passing.
- The Impostor's actual Sabotage interaction (the OQ-006 mechanic) is the last remaining tracked item — the system it depends on now exists.
- Presentation is still placeholder (console + one simple text label); a proper HUD pass is queued before release.

## [0.1.6] - 2026-09-05

### Added

- Tied matches are now decided: if the six rounds finish 3–3, the match continues to a 7th deciding round in the same format, and the team that wins it takes the match. Roles keep rotating exactly as before, so the 7th round plays under the same side arrangement as the first three.
- Teams are now randomized at the start of every match instead of being filled in join order — everyone present is shuffled and split evenly into Attackers and Defenders.
- A completed Jail breakout now frees only the player who finished the hold (with no bonus). Rescues still free everyone in the Jail and give the speed/immunity reward. The earlier behavior where a breakout freed an entire cell is gone.
- Sound cues are now actually audible: a small client listener plays the breakout warning and the Impostor "Tell" as positional sounds in the world, so the cue design can be heard and checked before the Impostor system lands. The listener just needs override sounds and volume tuning.
- The first automated test harness is in place: 13 behavior tests covering match states (round cycling, sudden death, randomized teams, win evaluation) and Jail release rules all pass. Future logic changes to these pure modules can be regression-checked without launching a play session.

### Notes

- "No late join" is now confirmed to mean: wait out the current match, join the next one. This was previously an assumption and is now a decided rule.
- No open design questions remain — the last four (tie handling, team assignment, late-join scope, breakout release scope) were decided by the project owner.
- Playing a character during the verification session was skipped this time (logic now covered by the automated harness); a two-player session for role-dependent paths is still planned before release.
- Impostor system — the last §15 system — remains queued and will use the Tell hook and the now-audible cue listener.

## [0.1.5] - 2026-09-05

### Added

- The server-owned audio system is live: an in-progress Jail breakout now emits a loud warning sound (a placeholder ping for now) from the Jail's location, repeating every few seconds while the breakout continues, and only players close enough are told to play it.
- A second cue, the Impostor "Tell", is now wired as a decoupled hook: whatever interaction the hidden Impostor system later triggers can request a localized spatial sound from any world position, and only nearby players are told to play it. Neither cue ever reveals who the Impostor is — the broadcast just says "play this sound here".
- All audio is server computed: the server decides who is in range before any sound instruction is sent, and the instructions carry only a sound and a position.

### Notes

- The sound files are placeholder engine beeps; real audio and the audible-distance/interval values (30 m, 20 m, 3 s) are expected to be tuned before release.
- The Impostor system — the last §15 system — still remains as a tracked task, and will consume the new Tell hook.
- Unit-test harness is still pending.

## [0.1.4] - 2026-09-05

### Added

- The plant and detonation system is now live: Attackers can claim a bomb site by holding a stationary 5-second interaction (only one teammate's hold counts at a time, measured server-side). A completed plant starts a 45-second detonation countdown that takes over from the round clock, and the Attackers win the round when it hits zero.
- Defenders can reverse a plant by holding a stationary 7-second defuse at the site; a completed defuse ends the round immediately with a Defender win.
- Two sites exist in the scene (placeholder geometry until the real map is built), each showing live plant/defuse/detonation state for later UI.
- Any movement, the wrong team trying to interact, or a second player submitting to the same site aborts an interaction and wipes its progress; a second plant is refused while one is already active.

### Notes

- Three interpretation points surfaced during implementation for owner confirmation: the site's interaction range is treated horizontally (standing on a site's footprint, not a magic height), and on the same tick a last-instant defuse is judged before detonation resolves.
- The Defender defuse was verified live with the only-role check bypassed through a debug command; a full two-player session is still needed to exercise it through the normal route.
- Remaining §15 systems (Impostor) are still queued as a tracked Workspace task. Unit-test harness is still pending.

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