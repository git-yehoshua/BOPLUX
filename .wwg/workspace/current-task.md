# Current Task

## Task Summary

- Status: **DONE — Jails/Objectives panels restyled with the SunGraphica "FREE Sci-Fi UI" kit (angled tactical 9-slice panels + header icons + accent lines); logic layer untouched**
- Task mode: meaningful feature (visual/UX polish slice) — AI-agent delivery
- User request: source a free/low-cost military/tactical Roblox UI kit, import it end-to-end without owner manual work, and rebuild the Jails/Objectives panel visuals with angled kit panels (red Jails / blue Objectives) + lock/target icons, leaving HUDStatusTypes/ServerHUDState/ServerHUDInit/RemoteEvent logic untouched.

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
