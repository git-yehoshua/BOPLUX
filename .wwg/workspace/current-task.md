# Current Task

## Task Summary

- Status: **DONE — 2026-09-08 verification pass complete: breakout/defuse/plant round outcomes verified end-to-end via real client-server routes; the 3 suspected bugs from earlier in the session were proven to be tooling measurement artifacts (no game bugs); REC-0014 added; REC-0004/0005 still hold the 2-player-gated paths**
- Task mode: bug-fix investigation → verification (code-discovery flow) — AI-agent delivery
- User request: root-cause the 3 suspected bugs "properly", then complete the verification pass the owner started

## What Was Found (root cause, evidence-backed)

- **Suspect #1 "jail cells never register"** — RETRACTED. Evidence: canary test — a cell registered via agent-context `require()` appeared ONLY in the agent's module copy while PassEvidence (real script) kept iterating real JailA/JailB from session start. `execute_luau` `require()` returns an isolated module instance per execution.
- **Suspect #2 "MatchDebug remote no-op"** — RETRACTED. Same isolation cause: success was checked via the isolated `JailState` copy. When re-checked via the PassEvidence mirror, MatchDebug jail worked first try (`jailed=true occ=1`).
- **Suspect #3 "stale/drifted script copies (phantom line numbers)"** — RETRACTED. The line drift (435 vs 480) was the agent's own blank-line-skipping line counter; running `.Source` is the canonical source.
- Net: **zero game-code changes**. Tooling rules captured in REC-0014 (trust PassEvidence mirror / console / client-context reads; never trust require()-read module state; synthetic keyboard doesn't reach UserInputService — use Client-datatype FireServer).

## Verification Matrix (2026-09-08, live, evidence = PassEvidence StringValue)

| Path | Route | Result |
|---|---|---|
| Jail via MatchDebug | real remote | `jailed=true`, `occ=1`, teleport into Cell A |
| Breakout channel | RequestBreakoutHold (real remote) | `channel=breakout progress` 0→22+; MoveCancelRange validation ran (no false cancel) |
| Round-end cleanup | automatic | channel canceled + `resetRound` on phase change (`jailed=false occ=0` at next Live) |
| Defuse → Defender win | RequestDefuseHold (real remote, Defender at planted Site A) | 7s channel → round outcome `defused` → MatchEnd |
| Plant → detonation → Attacker win | RequestPlantHold (real remote, Attacker on Site A) | 5s channel → `planted=true` det 45→0 → round won, PreRound r3 |
| Timer supersede | ObjectiveDebug plant path | detonation countdown keeps round alive past 180s |

Not coverable with 1 real player (remain with REC-0004/0005): real LMB capture on a victim, RMB jail-reset on a live breakout, teammate rescue freeing occupants, camping meter under a real Defender, impostor sabotage via F.

## Changelog Plan

- Meaningful change introduced: YES (verification evidence, no behavior change)
- CHANGELOG.md updated: YES — 0.1.16 ("Verified, no gameplay changes")
- Version affected: 0.1.16 (pre-release)
- Minor/major recommendation: NO

## README Plan

- README.md updated: NO — no front-door change
- Docs routing needed: NO
- README validation status: not run (no README change)

## Close-Out Notes

- Truth Alignment Status: GREEN — code unchanged; workspace/governance updated to reflect what is (and is not) verified.
- Drift Result: none — no canonical truth change; verification tier status refined in project-truth-summary.
- Recommendations: REC-0014 added (MCP verification traps); REC-0003 remains relevant.
- Retrospective: the agent nearly shipped 3 false bug reports before switching to ground-truth evidence channels — keep the "trust the system's own evidence output, not your require()" rule for every future session.
- Natural next prompt: "Run the 2-player verification pass" (owner plays both clients; REC-0004/0005 checklist in the jail/objective tickets), or "Close out release-prep items".

## Historical: SunGraphica HUD restyle task (DONE — see follow-ups below)

## Kit Choice (and why)

- **Chosen: SunGraphica "FREE Sci-Fi UI"** (itch.io, CC BY 4.0 — free, commercial use with attribution). Acquired end-to-end by agent via scripted itch.io download flow (CSRF handshake → presigned R2 download). Owner action required: NONE.
- Rejected "Project Adroit" (the user's candidate): $2.50 minimum purchase requires owner payment details, and per its store page it is a **main-menu kit** (home/deploy/store/profile screens), not a HUD component kit — weaker fit for this task even if purchased.
- Rejected Creator Store: searches ("tactical HUD", "military UI", "Project Adroit", angled panels) returned vehicles/decals/overhead UIs — no genuine tactical HUD kit.

## What Was Built

- **Asset pipeline** (Node, no new runtime installs beyond npm packages in temp): `ag-psd` + `@napi-rs/canvas` + `pngjs` used to parse the kit PSD, export 42 pixel layers, and analyze them (alpha corner/hole topology) to find HUD-scale assets:
  - Panel frame = kit menu-frame layer (measured: ~10px stroke, ~10px chamfered corners at half scale, clean edges) → downscaled 0.5x, recolored white (tintable), interior baked with translucent dark navy fill (alpha 168 ≈ old 0.35 panel transparency), SliceCenter `Rect.new(20, 20, 269, 270)`, SliceScale 0.3.
  - Icons chosen by alpha-topology (padlock = dual enclosed-hole signature; reticle = 4-fold symmetric ring gaps + center dot). 5 alternates uploaded.
  - Accent underline = kit separator line, recolored white.
- **9 images uploaded** to Roblox Asset Server via MCP `upload_image` (localhost HTTP relay) — IDs recorded in the kit source note.
- **`StarterGui/BOPLUX_HUDSetup`** (Studio datamodel + repo mirror): JailPanel/ObjectivePanel converted `Frame + UICorner` → kit `ImageLabel` (`ScaleType.Slice`), `ImageColor3` red (`220,80,80`) for Jails / blue (`80,160,220`) for Objectives; added `HeaderIcon` (lock 12x13 / target 13x13, LIGHT tint) + `AccentLine` (2px, accent-tinted) via new `kitHeader()` helper; Title shifted right of icon. All HUDController-consumed names preserved (JailPanel, ObjectivePanel, Title, CellA, CellB, CampingA/B+Fill, SiteA, SiteB).
- **`HUDController.local.luau`**: ZERO changes (verified via git status — only BOPLUX_HUDSetup changed). Status indicator pattern kept (kit has no status-bar component; existing attribute-driven labels/bars are better suited).

## Verification

- Live play session (Studio Play): console clean — no script errors; HUD built; round progressed Idle→PreRound→Live.
- Structural inspection via Client execute_luau: JailPanel/ObjectivePanel are ImageLabels with correct Image/Slice props; HeaderIcon + AccentLine present with correct asset IDs; Title repositioned (x=21); both panels Visible=true with map data (Courtyard_v001 Jails/Sites present).
- Screenshot `ScreenCapture_KitHUD_1` captured for owner review.
- **Limitation (disclosed)**: the agent could not visually inspect images this session (no image input support) — icon picks are topology-based and need owner eyes (REC-0012). Panel frame geometry was verified numerically instead (stroke/chamfer/fill measurements + slice math).
- Test harness: not re-run — server systems untouched; HUD asset integration verified by the live structural check above (no unit-testable behavior change; GUI has no test harness in this project).

## Truth / Docs Updated

- `.wwg/wiki/01-sources/raw/uploads/kits/` — kit zip + derived assets + source note (license, asset IDs, selection provenance); `source-index.md` row added; wiki log updated.
- `.wwg/governance/recommendation-registry.md` — REC-0012 added (owner icon confirmation + kit polish extension candidate).
- `CHANGELOG.md` — 0.1.12 added.
- `project-truth.md` — deliberately NOT edited (cosmetic restyle, no gameplay/architecture truth change; kit facts live in source intake).
- `terminology.md` — no terminology change.

## Changelog Plan

- Meaningful change introduced: YES
- CHANGELOG.md updated: YES — 0.1.12
- Version affected: 0.1.12 (pre-release)
- Minor/major recommendation: NO (visual polish slice, pre-release accumulation)

## README Plan

- README.md updated: NO — no front-door change
- Docs routing needed: NO
- README validation status: not run (no README change)

## Close-Out Notes

- Truth Alignment Status: GREEN — code, datamodel, workspace, governance, and reports agree; kit provenance + license recorded in source intake.
- Drift Result: Truth Sync Decision = No canonical truth change (cosmetic). Source intake updated (kit + license + asset IDs).
- Recommendations: REC-0012 added. No other new recommendations.
- License obligation: CC BY 4.0 — "SunGraphica" credit must appear in in-game credits before public release (noted in REC-0012 source note + changelog).
- Remaining concerns (deferred): owner visual review of icon semantics; extending kit styling to banners/TopBar (optional polish); the standing 2-player verification pass (REC-0004/0005) is unrelated to this change.
- Natural next prompt: "Confirm the new HUD icons look right" (screenshot ScreenCapture_KitHUD_1 / next play session), then resume "Run the 2-player verification pass".

## Retrospective

- **What went well / keep doing**: scripted acquisition (no owner manual work) + numeric geometry verification carried the task despite no image vision; recording every uploaded asset ID in a source note made swaps trivial.
- **What to add**: an owner-facing contact sheet of kit icons (one PNG grid) would speed visual confirmation; consider `Assets/UI/` mirror in repo for future kit assets (this time they live in wiki intake + Roblox).
- **What to remove/simplify/stop**: nothing — panel children contract (names) proved the value of the controller/setup separation; keep HUDController logic-untouched rule.
- **Gaps found**: icon semantic identification without vision is the only gap — deferred to REC-0012 (owner review), not release-blocking. PSD layer names were generic (Layer-NN), so name-based selection was impossible — topology analysis filled it.
- **Carryovers**: none added to current scope; REC-0012 holds the follow-ups.

## Follow-up 2026-09-06: CoreGui toggles + stamina pip merge (owner-directed, DONE)

- CoreGui Health+Backpack disabled via new StarterPlayerScripts/CoreGuiToggles.local.luau (PlayerList/Chat default, verified). Stamina pip row added bottom-center (BOPLUX_HUD.StaminaPips, 12 pips, cyan) wired to server stamina via client attribute mirror (LocalPlayer.Stamina, set from existing PlayerStateSync handler; pips use GetAttributeChangedSignal - no polling). Old top-right StaminaLabel/StaminaBar removed after parallel-run verification. Real sprint drain + regen verified live (attr 6 -> 5.3 -> 6; pips tracked). Health CoreGui vs custom-health-pips conflict flagged to owner (no pip-style health component exists in codebase; default health display disabled per instruction - revert is one line if owner prefers default). Jails/Objectives untouched. Changelog 0.1.13.

## Follow-up 2026-09-06 #2: Health display + diamond statuses + crosshair + notification fix (owner-directed, DONE)

- Health display built fresh (confirmed none existed): HealthNumber + HealthPips (white pips) bottom-center above StaminaPips; Humanoid.HealthChanged-driven; verified live 100->50.
- Diamond status glyphs REBUILT FRESH (git pickaxe: no prior diamond/Rotation/HUDStatusTypes history exists; owner told explicitly). Local STATUS_COLORS map in HUDController (no HUDStatusTypes module exists). Slots replace Cell/Site text rows; verified server-side planted/occupied -> red, cleared -> green.
- Crosshair dot + MouseIconEnabled toggling with menu detection; verified false cursor in play.
- BottomNotify raised -64 -> -154 (10px above vitals stack) — fixes "Cancel an active plant..." overlap.
- Bug caught & fixed live: undeclared gui var killed HUDController at line 200 (all post-crosshair connections dead). PlayerGui fix applied both copies; re-verified full chain.
- TextChatService translation notice: docs verified (TranslationEnabled = user preference, read-only; OnIncomingMessage can't filter system notices) — NO clean suppression; Chat-disable fallback NOT applied, awaiting owner decision.
- Changelog 0.1.14. Screenshot ScreenCapture_VitalsDiamonds_1.

## Follow-up 2026-09-06 #3 (owner decision applied): Chat CoreGui disabled

- Owner chose the blunt fallback via explicit question: CoreGuiType.Chat = false added to CoreGuiToggles (repo + datamodel, with comment recording the decision). Live-verified: Health=false Backpack=false Chat=false PlayerList=true. No custom chat exists; text chat is fully off until one is built. Changelog 0.1.14 wording updated.

## Follow-up 2026-09-06 #4: Minimap + health bar + notification coords + banner ID + sound audit (DONE)

- Black banner IDENTIFIED via owner's live scan: CoreGui.ExperienceChat.appLayout (chat UI shell; persists despite Chat CoreGui=false). Shipped TextChatService config disables (window/input/bubbles); Studio still mounts the shell (flagged UNCERTAIN for Studio playtests, confident for live clients per docs). BottomNotify was NOT the bar.
- Minimap built: 2D projection (world X/Z -> 150px, map = flat 224x224 courtyard); top-right; 4 diamond markers positioned from real Workspace interiors + player dot w/ facing; driven by the existing status loop (single data path); live-verified positions/colors/movement; planted->red confirmed. Old JailPanel/ObjectivePanel/LeftSide/RightSide + camping bars REMOVED after confirmation (camping indicator candidate for future request).
- Health: pips -> continuous bar + overlaid number (stamina pips kept); verified 50%.
- BottomNotify: AnchorPoint (0.5,0), Position (0.5,0,0.16,0) — owner-specified, verified live.
- Sound audit: pipeline EXISTS (AudioConfig/RunAudioSystem/CuePlayer), plays engine placeholder ping only; real assets never uploaded (REC-0006). Report-only, no changes.
- Changelog 0.1.15. Screenshot ScreenCapture_MinimapRound_1.

## Follow-up 2026-09-08: Verification pass — 1-player MCP-driven, real remote routes (DONE)

- Owner ran a 2-player Clients-and-Servers session first; those windows are unreachable by the MCP bridge (never appear in `list_roblox_studios`), so verification was done in the MCP-visible main window with 1 real player + debug remotes (real client→remote→server route, debug only removes role/state gating per system's own design).
- **Tooling root-cause (major finding, 3 earlier "bugs" retracted)**: MCP `execute_luau` `require()` returns an ISOLATED module instance per command execution — `JailState.cellIds()`, `MatchState.liveState()`, attribute reads through fresh requires, and MatchDebug "no-ops" were all measurement artifacts. Ground-truth channels are (a) `PassEvidence` StringValue mirror (updated by the real script's Heartbeat), (b) console prints, (c) client-datatype reads. Phantom line numbers (err at "line 224/228" in shorter files) were the assistant reading `.Source` with a line-splitter that skipped blank lines — the running source IS the repo source (480 vs 435 was the same cause). No game-code changes were needed; REC-0003 already documented the isolation half of this.
- **Verified live via real remote routes (evidence = PassEvidence mirror)**: breakout channel `progress` 0→22+ (canceled by round end; resetRound cleanup confirmed); debug-jail → `jailed=true occ=1` at Cell A; real-route defuse hold at Site A → `Defenders win` round outcome → MatchEnd; real-route plant (5s) → `planted=true` + detonation countdown 45→0 → round 3 PreRound with round-2 win recorded; PlantDebug `plant` also confirmed `supersedeRoundTimer` behavior.
- **Synthetic keyboard gap**: `user_keyboard_input` keyDown/keyPress did NOT trigger `UserInputService.InputBegan` in this Play window (no channel started despite correct jail state) — direct `RemoteEvent:FireServer` from the Client datamodel works. MCP-driven input cannot substitute for real keypresses; flagged in REC-0014.
- Not testable with 1 real player (unchanged, still gated by REC-0004/0005): real Defender-on-Attacker LMB capture, RMB jail-reset on a live breakout, teammate rescue freeing an occupant, camping meter fill (needs real Defender within 6m), impostor sabotage through the real F route.
- Changelog 0.1.16. No screenshots (state evidence captured via PassEvidence mirror readings in-session).

## Follow-up 2026-09-08 #2: Automated play test — auto-moved player, new coverage, REAL defect fixed (DONE)

- **Real defect found & fixed**: datamodel `CuePlayer` was the pre-0.1.11 copy (DopplerMode crash) — the place file had silently regressed audio cues (repo mirror was already fixed). Synced the source; verified in a fresh session: full 45s breakout with warning cues + tell, console clean, zero crashes. Other runtime HUD scripts spot-checked against repo markers — current.
- **New verifications (real routes, PassEvidence evidence)**: breakout move-cancel (2m shift → cancel); WalkSpeed-0 jail enforcement; **full 45s breakout run → auto-release** (twice); sabotage range-gating negative case (4.71m > 3m → ignored); impostor selection via debug + objective; halftime role swap; SabotageRange/SiteRange config matches behavior.
- **Not completed**: RequestJailReset real-route fingerprint test (startPos=nil survival) — rounds rolled over mid-test each attempt; gates are individually verified + unit-tested; deferred to the 2-player pass (REC-0004).
- Changelog 0.1.16 wording extended; REC-0003 (Script Sync hardening) re-flagged by the CuePlayer regression evidence.

## Follow-up 2026-09-08 #3: Extended automated pass — reset + rescue routes verified (DONE)

- **RMB jail-reset VERIFIED** via differential fingerprint: reset channel survived a 1.5m displacement (startPos=nil disables move-cancel — only explanation for survival); control channel without reset died on 1.6m shift. Round-4 Defender half, real remote routes.
- **Rescue channel VERIFIED**: full 3s run captured at 10Hz sampling (0.08→2.98→complete), real `RequestRescue` route, door-zone placement. Empty-cell rescue completes cleanly; freeing a real teammate stays 2-player.
- **Camping meter**: deferred — genuinely needs 2 real players (camper scan excludes jailed players; occupants must be real Player objects). REC-0004.
- **Method recorded**: 10Hz evidence sampler (task.spawn → attribute buffer) for sub-5s channel windows; fast-forward via the real `RoundOutcomeReported` bindable to reach Defender rounds.

## Task 2026-09-08 #4 (owner-directed, overnight): bug-fix + re-test + map design pass (DONE)

- Owner directive: fix found issues, re-test, then improve the map; "I'm confirming every recommended decisions you come up to."
- **Fix 1 — REC-0013 (camping visibility)**: amber `CampingRing` UIStroke on minimap Jail markers, driven from the server `CampingMeterFill` attribute by `updateCampingRing` (thickness 1+fill×3px, hidden at ~0). Live wiring test: fill 0.6 → on @2.8px; 0 → off. Meter logic untouched.
- **Map design pass — `Courtyard_v002`** (contract v2, v001 retained as rollback): central monolith + pillars (breaks spawn-spawn diagonal), lane cross with mid gates, per-site L-cover + low planter walls, spawn exit screens, yard/ring crates + low walls, warm/cool half tints. Strict 180° rotational symmetry preserved (team fairness); footprint/jails/sites/spawns coordinates unchanged → minimap, CELL_LAYOUT, SPAWN_POINTS all valid with zero gameplay-code changes. Full source in `MapBuilder.luau` (repo) synced to datamodel.
- **Re-test results (fresh session)**: v002 activates + contract registers (2 jails/2 sites, positions identical); symmetry audit 0 mismatches (41 children); real-route plant on Site A → planted → detonation → Attackers win (client score 1-0); minimap markers correct px positions; camping ring wiring verified; console clean.
- **Deferred (unchanged)**: 2-player-gated items (REC-0004/0005); camping meter gameplay under real play.
- Changelog 0.1.17; REC-0013 → Done; project-truth map line updated to v002-active.
- Screenshot `ScreenCapture_MapV002_Top` captured for owner morning review (agent cannot view images — owner eyes required).
- Natural next prompt: review the v002 map screenshot + in-person walk, then the 2-player pass on the new layout.
