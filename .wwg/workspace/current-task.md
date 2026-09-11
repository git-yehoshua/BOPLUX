# Current Task

## Task 2026-09-11 #6: Requirements gaps (crouch) + crosshair visibility + hands attempt + map cleanup — DONE except hands (parked), awaiting owner Ctrl+S

- **Status**: DONE on the agent side, one item parked honestly. **Owner action: Ctrl+S, then hold C to crouch and check the crosshair.**
- **Context discovery (owner-directed)**: full-text search + cover read of GDD v1.1, design brief, Game Concept doc, truth, tasks, repo — **no weapon requirement exists anywhere**. Capture is touch/tag throughout (GDD §4.1 locked; §5.2 explicitly no bomb item). Verdict: no weapons BY DESIGN; adding any overturns locked truth and was NOT done. The felt needs (hands, feedback) were addressed inside the design instead — except hands, parked below.
- **Crouch (GDD §3.2 gap, now filled)**: hold-C via RequestCrouch, server-authoritative speed 8, suppresses sprint, cleared on jail/reset; camera dips client-side; 7 new unit tests (82/82 green); live-verified 16→8→denied→16.
- **Crosshair**: was present but a 4px speck (hence "HUD didn't change") → 6px dot + black outline + thicker ring (screenshot-verified visible) + hit-flash on capture (occupant++) and plant-channel start.
- **Hands (PARKED, no slop shipped)**: tried Tool holder (blocked view → shrunk → floated disconnected), box viewmodel (read as slop), real-arm probe (arm stays below frame; my own fade hid it). Root problem: composing first-person hands blind. Removed all attempts (repo + datamodel clean); beam-only flashlight stands. Needs a live-eyes session (~15 min with instant screenshot feedback loop).
- **Map slop audit**: 78 floaters/34 escapees investigated — all by-design except 2 real fixes (awning struts grounded, spawn lamp attached), verified numerically post-rebuild. Workspace clean (Camera + Terrain only).
- **Verified live**: crouch speeds, plant hint/color, plant → warning + red timer, full plant→win route on final build.

## Task 2026-09-10 #5: Remove assets + crosshair/HUD pass — VERIFIED LIVE, awaiting owner Ctrl+S + visual review

- **Status**: DONE on the agent side. Owner verdict: assets still glitchy → remove them all, improve crosshair + HUD instead. **Owner action: Ctrl+S, then review `ScreenCapture_HUD_Crosshair_Hint` and play.**
- **Removal**: MapDresser unwired from MapBuilder (file kept as history); `ServerStorage.AssetLibrary` (264 models) + broken `Tulay_v003` template deleted from the place; `Tulay_v004` (567 parts, structural + procedural art) rebuilt, audit 0 mismatches, 75/75 tests. Kit OBJs + tarball stay archived for any future retry. REC-0017 reopens as the standing "props need visual verification" item.
- **Crosshair (was entirely missing — setup never built it, controller block was dead)**: dot + UIStroke ring + hint label; states default/target(red, expands)/jail(amber)/site(blue); hint priority breakout > defuse/plant > rescue > capture, team-gated, sabotage deliberately unhinted. Ranges mirror server validation (capture 1.5 / jail interior 4.5 / site XZ 2.0 — caught and fixed a 3D-vs-XZ mismatch against RunObjectiveSystem during verification).
- **Detonation HUD**: planted site → team-specific warning banner once per plant; timer label switches to red detonation countdown (blinks <10s), restored after.
- **Verified live**: crosshair element presence, plant hint (blue), jail hint (amber), plant → warning + red timer + hint switch, full plant→detonation→win route (score advanced). Target state needs a 2nd player (REC-0004/0005).

## Task 2026-09-10 #4: Checkered-box investigation — ROOT CAUSE FOUND + FIXED, awaiting owner Ctrl+S + eyes verify

- **Status**: DONE on the agent side. Owner's screenshots showed checkered/glitchy/flat props. **Owner action: Ctrl+S, then look at the props in DAY light (your checkered shot was day) — boxes, plants, bookcases, walls should all read as proper 3D now. Proof shots: `ScreenCapture_Rebake_Plant_Closeup`, `ScreenCapture_Texture_Test_Lit`, `ScreenCapture_Foliage_Fixed`.**
- **Root cause (proven numerically)**: `AssetLibraryBuilder` negated Z to face models forward — a mirror, not a rotation — flipping every triangle's winding. Signed-volume forensics: bookcase +0.0417 raw → −0.0417 baked (inside-out); dumpster +0.2209 → −0.2209. Inside-out meshes glitch under BOTH DoubleSided settings, which is why every past "fix" only moved the symptom. The old "UV corruption" verdict is now suspect as a second misattribution of the same bug (the agent had no vision; the owner's repeated "still looks wrong" reports fit).
- **Fix**: builder now rotates 180° about Y (negate X+Z, winding preserved; signed volumes stay positive). Entire 264-model library rebaked (0 errors). Dresser: solids single-sided (correct faces), foliage materials (leaf/leaves/plant/treeA/treeB/grass) double-sided (crossed planes need both sides — the green-checker symptom).
- **Texture question closed**: UV audit across all 264 OBJs — kit UVs are integer TILING coords (e.g. wall (2,1)-(3,2)), valid authoring for repeating textures. Live experiment (textured wall module placed unmodified): renders flat gray → engine smears out-of-range UVs instead of tiling. Flat-pass stays; real textures need a UV-island normalization rebake (future work, not started).
- **Verified**: v003 rebuilt (731 parts, 84 props), symmetry 0 mismatches, 75/75 tests, live night session (no checker anywhere, boxes read 3D, beacon glows, foliage solid). Builder/dresser header comments corrected to record the true history.

## Task 2026-09-10 #3: Tulay v003 "real props" pass + flashlight/banderita fixes — VERIFIED LIVE, awaiting owner Ctrl+S + visual review

- **Status**: DONE on the agent side. Owner's verdict on v002 (procedural stand-ins read as nonsense up close) answered with real assets. **Owner action: Ctrl+S, then review `ScreenCapture_TulayV3_ScreenCladding`, `ScreenCapture_TulayV3_Cladding_Lit`, `ScreenCapture_TulayV3_Bridge_Fiesta` and walk the map.**

## What was built

- **AssetLibrary rebuilt in-place**: all 264 models (140 FurnitureKit + 124 RetroUrban) built from the surviving kit OBJs via the proven relay pipeline — 0 build errors, all dresser-critical models present. Library lives in `ServerStorage.AssetLibrary` (2 category folders). Old UV-corruption finding respected: dresser applies the flat-pass (textures stripped, exact Kenney palette).
- **New TulayDresser** (`MapDresser.luau` rewrite, hardened mechanics kept: bottom-snap, flat-pass, winding + overlap fixes): 84 real props — dumpster/crates/plants/tree per site, window-module cladding on approach screens, pallets/boxes/trashcan/tree/shrub/bench in yards, pallet cargo on docks, dumpsters/pallets/trees/brick stacks in the ring, trashcan + wall lamp per cell, fully furnished spawn rooms, awnings.
- **Mirror-rule fix found by the audit**: yawed models need partner yaw+180 (same-yaw put cladding windows inside the wall and offset dumpster lids); 8 mismatches → 0 after the one-line fix in `P()`.
- **Procedural cleanups** (the nonsense shapes): wells, market stalls, algae patches, floor drains, spawn posters REMOVED; dock bollards shrunk to iron cylinders; spawn rooms gained a NightLamp bulb.
- **Flashlight close-range fix**: beam now emits from a `FlashlightMount` Attachment 1.5 studs in front of the head face (was: inside the head) — verified live (mount present, clean removal on toggle, wall lit at close range in screenshot).
- **Banderitas raised**: rope y 6.2–6.5 → 8.0–8.2 (verified numerically: 8.0–8.1, ~3 studs above head).
- **Verified**: v003 template 731 parts; symmetry 0 mismatches (726 paired + 16 tint pairs + 5 pivot); contract intact; 75/75 tests; live night session — 28 lights, plant channel real-route (score went 1-0 via detonation), screenshots ×3.

## Task 2026-09-10 #2: Tulay v002 "Estero canal-town" art pass — VERIFIED LIVE, awaiting owner Ctrl+S + visual review

- **Status**: DONE on the agent side. Owner-approved art direction (Estero canal-town) + code-only scope. MapBuilder bumped to **Tulay_v002** (v001 greybox kept as rollback in ServerStorage.Maps). **Owner action: Ctrl+S, then review `ScreenCapture_TulayV2_Jail_Night` + `ScreenCapture_TulayV2_Canal_Night` and walk the map in Play.**

## What was built (all procedural, zero assets)

- **Jail redesign** (contract markers/attrs/shell untouched — collision kept via invisible Shell walls): iron bar skin (27 bars/cell: back/sides + barred gate with seam), corner posts + rails, bunk bed (frames/mattresses/posts), wall bench, toilet+sink, floor drain, caged `NightLamp` ceiling bulb, SurfaceGui "CELL A/B" sign.
- **Estero dressing** (non-collide, 180° symmetric): fiesta banderitas (5 strings: pivot palindrome + 4 reversed-order pairs) with string-light bulbs (every 4th = NightLamp), 4 bancas (hull/bow/stern/floats/arms), 4 docks with 4 bollards each, 4 lamp posts (NightLamp), 2 market stalls (point-symmetric stock), 4 barrels (rotated cylinders), 3 reed clusters + 2 algae patches (point-symmetric sets), perimeter copings + pilasters, facade silhouettes (16 buildings in N/S + E/W rows: tint bands, terracotta roofs, rooftop water tanks where they clear the wall), gate-tower tiered roofs + team banners (red/blue tint pairs), site plinths + neon capture rings + 4 bollards + point-symmetric sandbags per site.
- **EnvironmentSystem night pass extended**: scans Workspace for `*NightLamp*` parts → PointLight (warm, range 11) at night; beacons keep Neon+light treatment; all restored on day. Live: 26 lights applied.
- **Verified**: template 601 parts; strict symmetry audit 0 mismatches (596 paired + 18 intentional tint pairs + 5 pivot); contract attrs intact; 75/75 tests; live night session — jail art + lights confirmed in ActiveMap (jails/sites hoisted to Workspace root as designed), plant channel real-route OK.
- **Gotchas hit + handled**: cached require() served stale MapBuilder twice → clone-swap pattern (REC-0003/0014); Jails/Sites hoisting made an early "missing jail art" reading a false alarm; several point-symmetry bugs caught by pre-audit review (z-side furniture, per-site decor sets, reed/stall/dock offsets) and fixed before the audit passed.
- **Deferred (REC-0017)**: optional AssetLibrary (Kenney prop) dressing pass on top of v002 — needs kit downloads + relay rebuild; the procedural pass may be enough pending owner review.

## Task 2026-09-10: Fresh-place rebuild (BOPLUX.rbxl) + Tulay_v001 map + Day/Night & Flashlight — VERIFIED LIVE, awaiting owner Ctrl+S + visual review

- **Status**: DONE on the agent side. New place `C:\Users\Admin\Documents\BOPLUX\BOPLUX.rbxl` fully populated from the repo (45 scripts byte-verified via HTTP relay), Tulay_v001 template persisted in ServerStorage.Maps, suite 75/75 green, day AND night sessions verified live. **Owner action: Ctrl+S in Studio (persistence cannot be scripted), then review `ScreenCapture_Tulay_Day_Overview` + `ScreenCapture_Tulay_Night_Flashlight` and walk the map in person.** Natural next prompt: "Run the 2-player verification pass".

## Rebuild evidence (2026-09-10)

- **Pipeline**: repo → manifest (45 entries) → local relay (serve.js:8788) → Studio `HttpService:GetAsync` → `Source` writes; byte-identical check 45/45; relay stopped after use. Feasibility evidence: all remotes runtime-created, HUD built in code, audio = engine `rbxasset` sounds → no pre-placed assets needed.
- **Latent repo bugs found + fixed by the rebuild** (proof the repo-first approach works): MatchManager `MatchStateSync` created into a throwaway local (nil FireClient in fresh places); HUDSetup dead `leftSide/rightSide` block crashed the builder at line 321 (dropped StaminaPips/BatteryPips/Minimap). Both fixed in repo + re-synced.
- **Place setup**: Baseplate/SpawnLocation/template Atmosphere removed; chat input-bar + bubble shells disabled (`ChatWindowEnabled` property absent on this Studio build — CoreGuiToggles covers Chat); Lighting has no Atmosphere (classic fog config).
- **Verification**: Day session — flashlight denied, plant route Site A → planted → detonation → Attacker win (score 1-0). Night session — ClockTime 0 / fog 480 / 4 night lights, beacon Neon + jail lamps, flashlight beam on Head (shadows), battery drain 2/s exact + regen 5/s exact, clean toggle; console clean after fixes. Symmetry audit on template: 0 mismatches. Screenshots for owner eyes.

## Task plan (locked decisions)

- **Task mode**: mixed (rebuild + new feature) — AI-agent delivery.
- **Owner directive**: template.rbxl perceived corrupted → fresh start. Old place renamed `C:\Users\Admin\Documents\BOPLUX.rbxl` (kept as donor/backup). New place = **BOPLUX_v2.rbxl**, rebuilt entirely from the repo so the repo becomes the single source of truth (closes the REC-0003 stale-copy bug class: CuePlayer regression, HUD drift).
- **Feasibility evidence (verified)**: every system self-creates its remotes at runtime; BOPLUX_HUDSetup builds the GUI in code; AudioConfig uses only `rbxasset://` engine sounds → a fresh Baseplate place + repo scripts = complete game. Old file's non-repo state (AssetLibrary models, any unsaved edits) is intentionally left behind.
- **New map — `Tulay_v001`** ("tulay" = bridge, Filipino heritage fit): completely fresh canal-city layout, NOT derived from Courtyard. East–west canal (4 studs deep, wadeable, Glass water) splits warm-attacker/cool-defender banks; mid bridge + gate-tower plaza, two ring bridges; bank parapets with bridge-landing gaps; colonnade site compounds; approach screens; yard wells/blocks/crates. Contract anchors preserved exactly (jails ±(24,3,20) + axes, sites ±(40,2,∓40), spawn rooms ±(75,0,75), 224×224 footprint) → zero gameplay-code changes, minimap valid. 180° rotational symmetry kept. MapDresser NOT called (dressing deferred until owner approves layout). MatchManager spawn comment updated.
- **New feature — Day/Night + flashlight (owner-dictated, decisions locked)**:
  - Mode: 50/50 roll **once per match start** (PreRound round 1); Lighting snapshot applied (day = engine defaults; night = ClockTime 0, low brightness, cold ambient, fog 480) via new `ServerScriptService/EnvironmentSystem/` (Config + pure State + runner, §15 pattern).
  - Night readability: site beacons → Neon + PointLight, jail Interior lamps (night-only, restored on day).
  - Flashlight: **L key** (free bind; F is sabotage), `RequestFlashlight` remote, server grants → head-mounted SpotLight (range 60, 35°, shadows) visible to ALL clients (light reveals you). **Battery meter** (owner choice): 100 max, drain 2/s (50s), regen 5/s, empty latch re-enables at 15; mirrors stamina architecture (Heartbeat step → dedup'd `EnvironmentSync` snapshot). Day mode = denies; reset on respawn + each PreRound.
  - HUD: `ModeLabel` (TopBar right) + `BatteryPips` (10 amber pips above stamina, night-only); attributes MatchMode/FlashlightOn/Battery mirrored for future consumers.
  - Tests: `EnvironmentStateTests.luau` (10 cases) registered in RunTests (expect 75 total: 65 + 10).
- **Repo files written (not yet in any datamodel)**: EnvironmentSystem ×3, EnvironmentStateTests, RunTests + PlayerInputs + HUDController + BOPLUX_HUDSetup edits, fresh MapBuilder.luau (Tulay_v001).
- **Pending**: owner creates **BOPLUX_v2.rbxl** (File > New → Baseplate → Save As) and opens it → agent populates all services from repo, strips Baseplate/SpawnLocation, builds Tulay template into ServerStorage.Maps, runs tests (75/75), live-verifies day AND night matches (plant route, flashlight beam, battery drain HUD), screenshots → owner Ctrl+S.

## Fix 2026-09-09 #5 (owner: "still like that" + FIX everything) — DONE, awaiting owner review

- **Task mode**: bug fix + visual pass — AI-agent delivery.
- **Owner report**: after the pivot fix, the map still looked wrong ("it just surfaced, I don't see any 3D assets"); Asset Manager holds their assets; FIX everything.
- **Forensics (all evidence-backed, agent now has byte-level texture vision via a PS PNG decoder)**:
  1. Owner's Asset Manager images = the 20 Kenney atlas textures (Assistant_*.png) — all present, all assigned (240 dressed MeshParts carry TextureIDs). No meshes/models were ever uploaded (user + universe inventory hold zero Models/Meshes; all 661 place MeshParts are pipeline-built or CoreGui).
  2. Uploads are byte-correct: downloaded the wall_lines thumbnail from Roblox's CDN and pixel-decoded it — matches the kit source (border frame, bright band, trim stripes). No wrong-file upload.
  3. Textures LOAD in the render client: `ContentProvider:GetAssetFetchStatus` in the live Client returns Success for wall_lines/concrete/planks. (PreloadAsync always reports Failure in bridged sessions — even for engine assets — so it is not a valid probe; GetAssetFetchStatus is.)
  4. No z-fighting: parsed kit `wall-a.obj` — wall_lines covers the 4 sides, concrete the top/bottom; groups partition faces, UVs map exactly one tile per face.
  5. The "checkerboard/white boxes" ARE the textures: concrete.png decodes to near-uniform off-white noise (renders as plain white boxes); wall_lines is pale panel art that reads blocky at x7.14 with blue ambient in shadow. Nothing is missing — the dressing was just dwarfed: a single 7-stud row against 20-stud greybox walls, covering only half of each wall's length.
- **Fix — perimeter facade pass** (`MapDresser.luau`): full-length (k=0..15 both halves) 3-high facades (rows at y=0/7.14/14.28 = 21.4 studs ~= greybox 20), solid base + window band (`ru_wall-a-window`) + solid crown. Bottom-align stacks rows seamlessly. 214 -> 346 props, still strict rotational pairs, still zero collision.
- **Tooling trap hit**: Edit-require served the stale dresser (count came back 214) — busted via the REC-0003/0014 clone-swap (renamed OLDs, fresh instances, rebuilt, destroyed OLDs).
- **Verification**: Edit audit 346 models, window band 32, rows at pivots 3.6/10.7/17.9, north row x 0..107.1 (16/16); live Play ActiveMap 346, facade bottoms exactly 0.00/7.14/14.28 (208 models incl. monolith), console clean, round reached Live. Screenshots `ScreenCapture_4` (monolith) + `ScreenCapture_5` (site/perimeter) for owner eyes.
- **Owner action**: Ctrl+S, then Play and look at the walls — full-height buildings with a window band instead of a grey curb.

## Fix 2026-09-09 #4 (owner report: "assets isn't rendering on the map") — DONE, awaiting owner verification

- **Task mode**: bug fix — AI-agent delivery.
- **What the owner saw**: (1) Workspace is empty in Edit mode (just Camera + Terrain), and (2) in Play the map looks greybox-only with stunted/buried props. Also asked whether the local `C:\Users\Admin\Documents\BOPLUX` folder is syncing to Studio (prior session said no Rojo config found).
- **Finding 1 — Edit-mode emptiness is by design**: `MapRuntime.server.lua` builds `Courtyard_v003` and clones it into `Workspace.MapRuntime.ActiveMap` only at runtime. Edit-mode Workspace will always be empty; press Play to see the map.
- **Finding 2 — sync IS working**: a local edit to `MapDresser.luau` appeared in the Studio datamodel without any explicit write, so a file watcher is pushing local changes into the place. No Rojo action needed.
- **Root cause (real defect, evidence-backed)**: `AssetLibraryBuilder` claims bottom-center model pivots, but `CreateMeshPartAsync` centers the baked mesh on the Part Position, so all 202 library models actually carry bbox-CENTER pivots. `MapDresser.place()` assumed bottom-center and called `PivotTo(y = surface)`, sinking every ground prop by half its height (perimeter walls fully buried; monolith cladding at half height; verified numerically: wall pivot y=0, mesh span -3.57..+3.57).
- **Fix**: `MapDresser.place()` is now pivot-agnostic — after `PivotTo` it reads `Model:GetBoundingBox()` and lifts the model so the bbox bottom sits exactly at `y`. Stacked placements (crates on crates, boxes on pallets) and wall-mounted items (awning, lamps, lane lights) keep their authored `y` as the bottom. `AssetLibraryBuilder.luau` header documents the center-pivot reality so future rebuilds don't regress.
- **Template rebuilt in Edit**: stale `ServerStorage.Maps.Courtyard_v003` deleted and rebuilt via `MapBuilder.buildTemplate()` (214 props). Spot audit: wall bottom 0.000/top 7.140, stacked box bottom 3.020, grass bottom 0.030.
- **Live verification (Play session)**: `ActiveMap` activates with 214 dressing models, wall bbox bottom 0.000, console clean (no MapRuntime/MapDresser warnings, round Idle→PreRound→Live), before/after screenshots show full-height cladding/columns/covers vs the previous sunken half-height state. Contract untouched (Jails/Sites hoisted, gameplay collision unchanged).
- **Known remaining item**: retro-urban wall modules show a white/blue checkerboard (missing-texture fallback) — the atlas `rbxassetid`s in `TEXTURE_IDS` may not resolve in-game. Recorded as REC-0016 (Proposed), out of scope for this fix.
- **Owner action**: Ctrl+S to persist the rebuilt template, then Play and walk out of the spawn room (west door) to review.

## Task Summary (previous)

- Status: **DONE — 2026-09-09 Phase C complete: `Courtyard_v003` dressed map built, live-verified (real-route plant → detonation → Attacker win, halftime swap), symmetric (214 props, 0 mismatches), persisted in ServerStorage.Maps; awaiting owner visual review (screenshots) + Ctrl+S**
- Task mode: mixed (asset pipeline + map dressing) — AI-agent delivery
- User request: "go continue with your phases in order, do all of them"

## Phase C results (2026-09-09)

- **`Courtyard_v003` ACTIVE**: v002 contract geometry + `MapDresser` visual layer (214 props / 370 non-collidable parts). Dressing = perimeter wall modules, monolith cladding + columns, mid-gate awnings + columns, site props (dumpster/crates/plants/tree), yard + ring dressing (pallets, low walls, trees, shrubs, bricks), jail interiors (bench/trashcan/wall lamp), spawn-room interiors (bookcase/benches/rug/floor lamp/plants) + door awning, grass patches, lane lights. All props CanCollide=false → gameplay identical to v002. Placement code repo: `ServerScriptService/MapRuntime/MapDresser.luau` (datamodel synced via relay; JSON-escape mangled the first multi_edit attempt — relay `Source` write is the reliable route).
- **MapBuilder bumped to v003** (repo + datamodel): `MAP_NAME = "Courtyard_v003"`, `buildTemplate()` now calls `MapDresser.dress(map)`. v001/v002 templates untouched as rollback.
- **Live verification (Play session)**: template auto-built + activated; contract registered (Cell_A/Site_A attrs, Jails/Sites hoisted); symmetry audit 214/214 paired (first audit's 12 "unpaired" were a `-0.0` formatting artifact — normalized re-audit clean); console clean; **real-route plant on Site A (channel 0→2.0s → planted → det 45→0) → detonation → Attacker win** (rounds 2+3; client Score read `2 - 1`); halftime swap to Defender at round 4 correct per OQ rules. Note: `RequestPlantHold:FireServer("A")` takes a siteId arg (nil arg = silently rejected — that was the earlier no-channel mystery).
- **Persisted in Edit mode**: `ServerStorage.Maps.Courtyard_v003` rebuilt post-stop (214 props, 452 total parts, contract folders present). **Owner must Ctrl+S** — the save cannot be scripted.
- Screenshots for owner review (agent has no image input): `ScreenCapture_MapV003_Overview`, `ScreenCapture_MapV003_SiteA`.
- Tooling notes: cached `require()` again served stale module copies after source edits — cache-bust by clone+destroy (REC-0003/0014 pattern now proven twice).

## Phase A results (2026-09-09)

- **Import-error root cause (owner's manual attempt)**: 13 furniture-kit FBX files are **ASCII FBX** — Roblox's importer only accepts binary FBX → the errors. 10 retro-urban-kit FBX are binary 7700 and import fine. Fix: use the OBJ variants (identical geometry) — chosen pipeline is format-agnostic.
- **Scripted pipeline proven (no manual import needed at all)**: localhost Node relay (`serve.js`, port 8787, temp dir) → `HttpService:GetAsync` fetch OBJ text in Studio → Luau OBJ parser (v/vt/vn/f + usemtl groups, negative-index faces handled, polygon fan-triangulation) → `AssetService:CreateEditableMesh()` build → `AssetService:CreateMeshPartAsync(Content.fromObject(em))` → real MeshParts. Dead ends ruled out with evidence: `rbxasset://` local mesh read ("Failed to read mesh"), FileSystemService (not exposed to command context).
- **Scale verdict**: default 1:1 — **1 Kenney unit = 1 stud**, verified per-part exact (bench 0.400×0.470×0.200, wall 1.000×1.290×0.050, doorway 0.486×1.010×0.113, etc. = OBJ meters table exactly). Real-world scale factor for map dressing = **×7.14** (1 unit = 2 m = 7.14 studs; door = 7.14 studs tall ≈ R15 headroom).
- **Materials/colors**: per-`usemtl` groups split into separate MeshParts with `MTL_COLORS` name→Color3 mapping (wood/woodDark/metal/metalDark/fabric/glass/plant/soil/_defaultMat); MeshPart.Color works, untextured Kenney flat-color style preserved. UVs+normals imported and set.
- **Assembly gotcha solved**: each group mesh pivots at its own geometry; all parts must share ONE pivot = the model's global center (verified: every part Position equal, geometry offset around it — rendering correct; engine `GetBoundingBox` returned phantom bounds, so placement uses pre-computed OBJ bounds).
- Artifacts: `Workspace.CalibrationImport` (13 models, row at Y=0), screenshot `ScreenCapture_CalibRow_1` (owner eyes required — agent has no image input), relay + builder snippets in temp dir (`C:\Users\Admin\AppData\Local\Temp\opencode\boplux_serve`).

## Pending

1. Owner: **Ctrl+S in Studio** (persistence — cannot be scripted from this context); then review screenshots `ScreenCapture_MapV003_Overview` + `ScreenCapture_MapV003_SiteA` (dressed map) and `ScreenCapture_LibraryReview_1` (library lineup).
2. After reopen: verify library + v003 template durability (REC-0015) — sample MeshPart still renders; map activates dressed.
3. Natural next prompt: "Run the 2-player verification pass" (REC-0004/0005) or release-prep items.

## HUD polish 2026-09-09 (owner-directed) — DONE

- TopBar: removed the UICorner (full-bleed bar + rounded corners read as a floating slab), slimmed 44→36px, transparency 0.25→0.4, labels re-laid-out in two rows (timer moved beside phase).
- Minimap: 150→112px, transparency 0.3→0.5; HUDController MAP_PX 150→112 (markers verified in-bounds, pairs symmetric; camping-ring logic untouched).
- **Real bug found via screenshot**: the TopBar label fade tween used `reverses=true`, so labels faded in then straight back to invisible — the bar has been an empty slab. Fixed to one-way fade; verified live (all 5 labels at transparency 0.00, screenshot `ScreenCapture_HUDRestyle_2`).
- Naming/hierarchy contracts preserved (TopBar children + Minimap markers), so HUDController needed only the MAP_PX constant change.
- Note: repo `BOPLUX_HUDSetup` was stale vs datamodel (pre-existing divergence incl. dead leftSide/rightSide references — REC-0003 territory, out of scope); equivalent edits applied to both. Also observed: a datamodel edit to HUDController appeared in the repo file without an explicit write (possible Studio-side sync) — flagged for future sessions, repo edits still applied explicitly.
- Changelog 0.1.19.

## Fix 2026-09-09 #3 (owner report: "assets can't be seen anywhere") — DONE, awaiting owner verification

- **Root cause: OBJ→Roblox Z-axis mirror.** OBJ fronts face +Z; Roblox fronts face -Z. Importing raw coordinates mirrored the geometry, flipping every triangle's winding → backface culling rendered all props inside-out (invisible from outside, glitchy interiors). My numeric size checks couldn't catch it (dimensions are winding-agnostic); agent has no image input, so no visual confirmation had ever occurred — lesson recorded.
- **Fix: builder v3** — negate Z on vertices AND normals (restores correct winding), plus `MeshPart.DoubleSided=true` as a safety net. Full library rebuild (202 models, 429 parts, 0 degenerate, all DoubleSided); v003 rebuilt (214 props/452 parts); live session activated clean (0 strays).
- **REC-0015 durability RESOLVED (positive)**: after the owner's close/reopen, the saved library came back intact (202 models, sample part alive) — scripted meshes DO survive save/reload in this place.
- Note: v002 template is absent from `ServerStorage.Maps` (owner's save predates its build session); rollback = v001. v002 geometry = v003 minus dressing, so a v002-equivalent can be rebuilt on request.
- Screenshot `ScreenCapture_MapV003_Fixed_Overview` (owner eyes).

## Fix 2026-09-09 #2 (owner report: "glitchy unrecognizable things") — DONE

- **Root cause 1 (what the owner saw):** my calibration/review debug rows (`Workspace.CalibrationImport`, `Workspace.LibraryReview`, `CALIB_wall_test`) were never cleaned up and sat INSIDE the 224-stud play area. Removed.
- **Root cause 2 (real defect):** degenerate zero-thickness material groups (e.g. pottedPlant's 0.001-stud soil disc) → `CreateMeshPartAsync` produced garbage geometry with corrupted bounds (pottedPlant engine bbox 77.9 studs vs 4.7 expected) rendering as giant stretched glitch planes. **Fix: AssetLibraryBuilder v2** — flat groups (< 0.05 studs on any axis) are now built as plain `Part` blocks. Full library rebuild: 202 models, **0 degenerate mesh parts**; pottedPlant bounds now exact (1.51×4.67×1.72). Category routing corrected in the same pass (RetroUrban 110 / FurnitureKit 55 / Clutter 23 / Lighting 14; `fk_books` dedup, `ru_wall-b-detail` doesn't exist in the kit).
- v003 template rebuilt from clean library (214 props / 452 parts, contract intact); live session re-activated it with **0 strays in the play area**; fresh screenshot `ScreenCapture_MapV003_Clean_Overview` for owner review.
- Repo mirror `ServerStorage/AssetLibraryBuilder.luau` synced to v2.

## Phase B results (2026-09-09)

- **`ServerStorage.AssetLibrary` BUILT: 204 models, 0 build errors** — RetroUrban 111, FurnitureKit 55, Clutter 26, Lighting 12, all at ×7.14 (1 Kenney unit = 2 m = 7.14 studs; wall-a verified 7.14×7.14×7.14 studs).
- **Builder module `ServerStorage.AssetLibraryBuilder`** (reusable): fetch → parse → EditableMesh → MeshPart; per-`usemtl` part split; bottom-center pivot geometry (pivot = bbox center-bottom, parts offset around it); `LibBoundsSize` attribute per model; `build({names, scale, dest})` API; HTTP auto-enable inside `build()` (but see module-isolation note below).
- **Materials: exact + textured.** FK palette extracted from Kenney GLB `baseColorFactor` (wood/metal/carpet/lamp/plant etc., 15 materials) → 190 parts recolored exactly. RU walls use a shared texture atlas — fetched the official kit ZIP (kenney.nl direct URL), extracted the 22 `Textures/*.png`, uploaded via MCP relay → **218 parts textured with real Kenney atlas UVs** (`TextureID`), plus 2 late-mapped (concreteSmooth, wall_metal). Atlas rbxassetids recorded in builder `TEXTURE_IDS` (CC0, no attribution required).
- **Pipeline quirks solved (recorded for future sessions):** module edits don't reach a cached `require()` — re-load by cloning the module with fresh `Source` (REC-0003/0014 pattern); `ru_wall-b-detail` does not exist in the kit (A/B variants asymmetric); 16 `ru_` models initially mis-filed into FurnitureKit were re-sorted.
- Durability unverified until owner saves + reopens (REC-0015 has the 3 fallback routes if meshes don't survive).
- Screenshot `ScreenCapture_LibraryReview_1` (owner eyes — agent has no image input).

---



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
