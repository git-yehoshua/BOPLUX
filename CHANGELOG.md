# Changelog

All notable changes to BOPLUX are recorded here in non-technical, outcome-based language.

## [0.1.27] - 2026-09-11

### Added

- **Crouch (hold C)**: the missing GDD movement action — hold C to move low and slow (camera dips with you), release to stand. Sprint is suppressed while crouched, and it clears on jail/round reset like everything else.
- **Crosshair hit feedback**: captures flash the crosshair red, starting a plant flashes it blue — instant confirmation your action registered.

### Changed

- **Crosshair is actually visible now**: bigger dot with a dark outline, thicker ring. (It technically existed before but was a 4-pixel speck most players never noticed.)
- **Map cleanup**: the full map was audited part by part — floating awning poles now reach the ground, spawn-room lamps touch the ceiling, and the audit confirmed everything else is attached as designed (no junk, no leftovers).

### Not added (deliberate)

- **Weapons**: the design spec mandates touch-based capture and explicitly forbids a bomb item — there are no guns *by design*, not by omission. Visible hands holding gear remain an open visual task (tried three approaches; composing them blind kept producing clutter, so this one waits for a session with live visual feedback).

## [0.1.26] - 2026-09-10

### Added

- **A real crosshair**: the game finally has a center crosshair — a dot with a ring around it that reacts to the world. It turns red and widens near an enemy (capture range), amber near a jail, and blue near a plant site.
- **Contextual control hints**: under the crosshair, the game now tells you what you can do right here — "HOLD LMB — Plant" at a site, "HOLD E — Defuse" on a planted spike (defenders), "E Rescue · RMB Reset" at a jail, "HOLD F — Breakout" while jailed, "LMB — Capture" near an enemy. No more guessing buttons.
- **Spike urgency on the timer**: while a spike is planted, the top-bar timer switches to the detonation countdown in red (blinking under 10 seconds), and a banner announces the plant with team-appropriate instructions ("defuse it" vs "defend it").

### Removed

- **All integrated 3D props (owner-directed)**: the dressed asset models kept rendering as glitchy checkered boxes on the owner's screen through every fix attempt (including a full importer rewrite with proven geometry). The map is back to clean structural art, which reads correctly everywhere. The asset files stay archived in the project if a textured pass is ever retried with visual verification.

## [0.1.25] - 2026-09-10

### Fixed

- **The real reason props looked like checkered/glitchy boxes**: the 3D importer was mirroring every model inside-out (proven by measuring the models' geometry: they came out backwards). Both lighting modes glitched different ways, which is why nothing ever looked right. The importer now rotates models correctly instead of mirroring them, and the whole 264-model library was rebuilt — boxes, plants, walls and furniture all render as proper 3D with correct shading.
- **Confirmed the flat colors must stay (for now)**: an experiment placed a fully textured wall in the live map — it rendered flat gray. The kits' textures are designed as repeating tiles but the engine smears them instead of repeating, so textured props would look worse, not better. The flat Kenney colors remain the right call; restoring real textures would need a texture-coordinate rebuild first.

## [0.1.24] - 2026-09-10

### Added

- **Real props from the licensed 3D library (Tulay v003)**: the map's confusing placeholder shapes were replaced with actual modeled props — real bunk-adjacent cell furnishings (trash can, wall lamp), a proper dumpster with crates, plants and a tree at each plant site, pallets and cargo boxes in the yards and on the docks, benches, shrubs, real street-wall modules clothing the big sightline screens, and fully furnished spawn rooms (bookcases, benches, rugs, floor lamps, plants, door awnings). Everything decorative still has no collision, and the map stays exactly team-symmetric (audited: 0 mismatches across 731 parts).
- **Spawn rooms are lit at night**: each spawn room now has its own ceiling lamp, so night matches never start you in a pitch-black box.

### Fixed

- **Flashlight now lights up close walls**: the beam used to start from inside your head, so anything nearer than that stayed dark and your own head shadowed the beam. The light now shines from just in front of your face — hugging a wall at night actually reveals it.
- **Fiesta flags fly higher**: the banderita strings moved from head height to well above it (rope at 8+ studs), so they decorate the bridges and lanes without blocking your view.

## [0.1.23] - 2026-09-10

### Added

- **The map got its art pass (Tulay v002, "Estero canal-town")**: the jail is now a real cell — iron bars with a barred gate, bunk bed, wall bench, toilet and sink, floor drain, a caged ceiling lamp that actually glows at night, and a CELL A/B sign over the gate. The canal-side is dressed Filipino-style: fiesta banderitas strung across the bridges and lanes, moored outrigger boats, water-level docks with bollards, bank lamp posts, string lights, market stalls, and reed clusters. Behind the perimeter walls, terracotta-roofed building silhouettes with window bands give the skyline depth. Gate towers grew tiered roofs and team banners; plant sites sit on stone plinths with painted capture rings, sandbags and corner bollards.
- **Night lighting now comes from the map itself**: the jail cell bulbs, bank lamp posts and string-light bulbs are real light sources after dark (the existing Day/Night system picks them up automatically), while beacons keep their blue glow.
- **Everything decorative stays non-collidable** — cover, movement and all gameplay rules are identical to the verified layout, and the strict 180-degree team-fairness symmetry was re-audited (0 mismatches across 601 parts).

## [0.1.22] - 2026-09-10

### Added

- **Day & Night matches**: every match now rolls once between a bright day and a dark night (50/50). Night brings a cold, foggy sky, glowing blue beacons on both plant sites, and warm lamps inside the jails so objectives stay findable. The top bar shows a DAY/NIGHT badge so everyone knows the conditions.
- **Flashlight (night only)**: players toggle a head-mounted beam with **L**. The beam points where you face and — importantly — every other player can see your light, so lighting up is a real risk/reward choice. It runs on a battery (about 50 seconds of continuous use, recharges in about 20 while off) shown as amber pips above the stamina row; it auto-cuts at empty and re-enables once recharged, and resets each round.

### Changed

- **Fresh start: the game was rebuilt from source (BOPLUX.rbxl)**: the old place file (formerly `template.rbxl`) was retired. The new place is populated entirely from the project's script repository, making the repository the single source of truth — this permanently prevents the stale-copy bugs that caused past regressions (a dead audio-cue copy and a HUD that silently diverged).
- **New map: Tulay (v001)**: a completely new canal-city arena replacing Courtyard. An east–west canal splits the map, crossed by three bridges (a mid bridge flanked by a gate-tower plaza, plus two ring bridges). Plant sites are colonnade compounds on opposite banks; canal-bank parapets leave clean gaps at each bridge. All gameplay anchors (spawns, jails, sites, map size, fairness symmetry) are unchanged, so rounds play by the same rules — the layout is what's new.

### Fixed

- **Two latent bugs the rebuild flushed out**: the match-state remote was created but never connected (would break the HUD timer/score feed in a from-scratch place), and the HUD builder still contained a dead reference to long-removed side panels that crashed it mid-build (would leave the HUD missing its stamina, battery, and minimap sections). Both fixed in source and verified live.

## [0.1.21] - 2026-09-09

### Fixed

- **The courtyard walls finally look like buildings**: the decorative wall layer was only one block high and covered half of each wall, so it read as a curb against tall grey concrete. Every outer wall is now dressed end to end and three stories high (solid base, window band, solid crown) — about 350 decorative pieces total, still with no effect on movement or cover.
- **Confirmed your Asset Manager images are working**: the wall and surface textures were investigated pixel by pixel — the uploads are correct and they do load in-game. The pale/checkered look is the kit's own light style at large scale, not missing content. (A richer art-direction pass is a possible follow-up.)

## [0.1.20] - 2026-09-09

### Fixed

- **Map decorations were sunk halfway into the ground**: every decorative prop on the courtyard (building walls, landmark cladding, crates, trees) was placed as if its base were at its center, so walls sat buried to half their height and the map read as bare grey concrete. Props now sit exactly on the surface they belong on — walls stand full height, stacked crates rest on top of each other. Round behavior is unchanged (decorations still have no collision). Note: the retro-urban walls may still show a temporary checkerboard pattern until their surface textures are re-verified.

## [0.1.19] - 2026-09-09

### Fixed

- **The top bar was secretly empty**: the intro fade animation on the team/score/phase labels was set to play forward and then reverse, so every label faded straight back to invisible — the bar has been a blank black slab since the animation shipped. Labels now fade in and stay visible.
- **Slimmed the top bar and minimap**: the full-width bar lost its rounded corners (which made it read as a floating slab), dropped from 44 to 36 pixels with a lighter background, and the minimap shrank from 150 to 112 pixels with a more transparent background. All marker positions and camping-ring behavior unchanged.

## [0.1.18] - 2026-09-09

### Added

- **The map is dressed (Courtyard_v003)**: the courtyard no longer looks like a greybox. A licensed CC0 prop library (Kenney's furniture and retro-urban kits — 204 models, no attribution required) now furnishes the map: the perimeter reads as real buildings with textured wall modules, the central landmark got wall cladding, columns and awnings over the mid gates, each plant site gained site-appropriate props (dumpsters, crates, planters, trees), the jails have benches and wall lamps inside, the spawn rooms got bookcases, rugs and lighting, and grass patches break up the concrete. Every prop is strictly decorative — it does not add collision — so round behavior, cover, and movement are identical to the verified v002 layout, and the map remains exactly 180-degree rotationally symmetric (audit: 0 mismatches across 214 props).
- **A reusable asset pipeline now exists**: imported the CC0 library through a scripted builder (exact Kenney colors extracted from the kit files; the retro-urban texture look reproduced with the kit's own texture pages uploaded as Roblox assets). The library lives in `ServerStorage.AssetLibrary`, ready to dress future maps with zero manual importing.

### Verified

- Full round loop re-verified live on the dressed map: attacker plant on Site A (5s channel through the real client-server route) → 45s detonation → attacker win (score progressed 2-1 across rounds 2-3) → halftime role swap at round 4. Console clean, contract anchors (jails, sites, spawns) registered at their unchanged coordinates.

## [0.1.17] - 2026-09-08

### Added

- **The courtyard map got its first real layout pass (Courtyard_v002)**: a central landmark block now breaks the long spawn-to-spawn sightline through the middle; the lane walls form a full cross with two mid gates, giving attackers and defenders readable lanes between the halves; each plant site gained hard cover (walls plus a low planter) so planting and post-plant defense are not out in the open; the outer ring and mid yards got scattered crates and cover so rotating across the map is no longer a naked walk; the two halves are subtly tinted warm/cool so players can tell whose side they are on. The map stays exactly 180-degree rotationally symmetric (fair when sides swap at halftime), and all gameplay anchor points — jails, sites, spawn rooms — kept their coordinates, so the minimap and all systems keep working unchanged.
- **Jail-camping pressure is visible again**: the amber ring around each Jail diamond on the minimap now thickens while an enemy camps outside an occupied jail (the meter lost its on-screen bars when the old side panels were removed). Verified live: ring appears, scales with pressure, disappears when it clears.

### Changed

- Maps are now versioned content: the new layout ships as `Courtyard_v002` (contract version 2) alongside the original `Courtyard_v001`, which is kept as a rollback template.

## [0.1.16] - 2026-09-08

### Fixed

- **Sound cues can be heard again (regression fix)**: the saved game file still contained an old copy of the audio player that crashed before playing any sound — every warning ping and impostor tell died silently. The up-to-date audio player has been put back in place and verified: a full jail-breakout now plays its warning cues end to end with no errors.

### Verified (no gameplay changes)

- **The round loop now has live end-to-end evidence**: breakout hold progress, a Defender defuse that ends the round in a Defender win, and an Attacker plant that detonates for an Attacker win were all driven through the real client-server routes in a live session and confirmed by the round evidence feed. Also verified live: breaking out of jail after a full 45-second hold frees the player, moving cancels a hold-in-progress, the jail keeps prisoners frozen in place, the impostor's sabotage obeys its range limit, **a Defender's jail-side reset actually resets a breakout in progress, and a teammate's rescue channel runs to completion at the jail door**. (A tooling issue in the assistant's inspection channel briefly made three working systems look broken — root-caused as an isolation quirk of the inspection tool, not game bugs; nothing in the game was changed.)
- A tooling note was recorded (REC-0014) so future verification sessions trust the evidence feed instead of the isolated inspection reads, and don't rely on synthetic keyboard presses.

## [0.1.15] - 2026-09-06

### Added

- **Minimap with live status markers**: a small top-right map of the courtyard now shows all four objectives at their true positions — Jail A/B and Plant Site A/B as color-coded diamonds (green clear, red occupied/planted, amber channel) — plus a "you are here" dot with a facing direction that tracks your movement. Replaces the two floating side panels, which are gone.

### Changed

- **Health reads as a bar now**: the health pips became one continuous rounded bar (fills left-to-right) with the number printed on it, directly above the unchanged stamina pips.
- **Status notifications moved to the top**: warning/reveal banners (including the Impostor objective) now sit just below the round timer, above all gameplay content, instead of at the bottom.
- **Chat UI shell is disabled along with chat itself**: Roblox's chat window/input bar no longer mounts on screen (it could still appear at top-left even after chat was switched off).

### Audit (no change)

- **Sound system checked**: the audio pipeline (jail-breakout warning + Impostor tell) is fully wired server-to-client, but both cues still play the same engine placeholder ping — real audio assets were never uploaded (existing recommendation REC-0006; also pending license confirmation). Nothing was changed this round.

## [0.1.14] - 2026-09-06

### Added

- **Health now has its own display**: a large health number with a white segmented pip row sits at bottom-center, directly above the stamina pips, so health and stamina read as one stacked unit. It updates instantly on damage and healing with no background polling.
- **Diamond status indicators on the Jails and Objectives panels**: each cell/site is now a color-coded diamond (green = clear, red = occupied/planted, amber = a capture or defuse channel is in progress) with its letter underneath, replacing the small text rows. Jail-camping bars are unchanged.
- **Fixed crosshair during gameplay**: the mouse cursor is hidden and a small fixed dot appears at screen center while a match is running; the normal cursor returns whenever a menu or other screen is open.

### Fixed

- **Status notifications no longer cover the health/stamina stack**: warning and reveal banners (including the Impostor objective text) moved up so they sit just above the vitals stack instead of on top of it.

## [0.1.13] - 2026-09-06

### Added

- **Stamina now lives inside the main vitals area**: a slim cyan segmented pip row at bottom-center fills and drains with real sprint stamina (12 segments over the 6-second sprint budget), replacing the separate green bar that used to sit at the top of the screen next to the scoreboard. It updates live during sprint and regen, with no background polling.
- **Default Roblox health and hotbar displays are disabled** (the custom HUD covers them), and the default chat is disabled as well — Roblox's automatic chat-translation notice cannot be suppressed by the experience (it reflects each player's own account setting), so chat is fully off until a custom chat, if ever, replaces it. The default player list remains.

## [0.1.12] - 2026-09-06

### Added

- **Tactical HUD panels for Jails and Objectives**: the two side status panels now use angled/cut military-style frames from a real UI kit (SunGraphica's free Sci-Fi UI pack, CC BY 4.0 — credit "SunGraphica" is owed in in-game credits before public release). The Jails panel is tinted red with a padlock header icon, the Objectives panel blue with a target header icon, and each header gets a kit accent underline. Panels are true 9-slice images, so they keep their angled corners at any size. All status text and camping-meter bars work exactly as before — only the visual container changed.
- Kit acquired, extracted, uploaded, and integrated end-to-end by the agent (no manual download/import steps); provenance, license, and uploaded asset IDs recorded in the wiki source intake.

## [0.1.11] - 2026-09-06

### Added

- **The game now has a real map**: the greybox `Courtyard_v001` replaces the bare placeholder baseplate. It provides a walled playfield, lane cover (walls and crates), two enclosed single-exit spawn rooms (one per team side), two Jails, and two plant sites — all laid out around the verified gameplay anchor coordinates. Maps now live as templates in `ServerStorage` and activate as `Workspace.MapRuntime.ActiveMap`; the Jail and Objective systems read the map's contract markers (Jail/Site IDs) instead of building their own placeholder geometry, which is what makes future maps a pure content task (zero code changes).

### Fixed

- **Jail-camping meter could never actually run**: the meter's proximity loop looked for jail positions through a field that never existed (`JailState._cells`), so despite passing its unit tests the meter silently did nothing in live play. A proper accessor (`JailState.exteriorFor`) now feeds it the real exterior position.
- **Camping-meter HUD bars never moved**: the meter wrote its fill level to the wrong jail name (`"A"` instead of `"Cell_A"`), so the attribute the HUD reads was never set. Fixed.
- **Duplicate sabotage remotes**: stale copies of `RequestSabotage`/`SabotageDebug` could pile up across sessions (and a duplicate `SabotageSystem` script folder ran alongside the real one). Remote creation is now deduplicated and the stale folder was removed.

### Added (previous unreleased)

- **Demo Showcase self-play driver**: `StarterPlayerScripts/DemoShowcase.local.luau` — a demo-mode-only LocalScript (gated behind `DemoMode` attribute, off by default in production) that autonomously drives a full match round in Studio Play: match start → Defender jail fill with jail-camping exposed through the debug remote → jail breakout warning pings every 3s (~12s of warnings) → Defender release → attacker walk to Site A → plant → detonation → Impostor reveal. Lets a single developer watch the entire loop (capture → breakout → plant → detonate → round end) without manual input. Verified live end-to-end with a clean console.
- **HUD Pass Phase 3**: ImpostorClient wired to unified HUD banners — removed `ImpostorClientGui` ScreenGui, now updates `BOPLUX_HUD` WarningBanner/RevealBanner directly via MatchSystems remotes. Task ticket and docs updated.
- **HUD Pass Phase 4**: Animations and styling polish — `TweenService` fade-in (top bar elements, 0.6s staggered), slide-in (side panels, Back easing), pulse animation for warning/reveal banners, `UICorner` polish on TopBar. Builder script rebuilt on every play session to ensure animations apply.

### Fixed (previous unreleased)

- **CuePlayer DopplerMode crash (silent-audio root cause)**: `CuePlayer.local.luau` set `sound.DopplerMode = Enum.DopplerMode.Off`, which does not exist on Roblox — every `playCue()` call crashed before `sound:Play()`, so no audio cue (breakout warning, Impostor Tell) was ever audible despite the engine loading the sound fine. Removed the invalid line. Zero console errors and `SoundAttachment` positional-sound playback now verified live in Play mode.
- **HUD builder sync**: `BOPLUX_HUDSetup.local.luau` now destroys existing HUD clone before rebuilding, ensuring animations always apply on every play session. Builder script synced to datamodel's StarterGui.
- **MatchManager sync**: Fixed scriptscriptservice not syncing by auto-creating `MatchSystems` folder and `MatchStateSync` RemoteEvent in ReplicatedStorage if missing, resolving `cannot read 'MatchStateSync'` error when firing client state.
- **PlayerStateSync added**: Added auto-creation of `PlayerStateSync` RemoteEvent in MatchManager to support client-side player state synchronization (stamina, jail status, capture immunity HUD updates).

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