# BOPLUX: Comprehensive Game Design Brief

**Version:** 1.0  
**Prepared by:** Manus AI  
**Scope:** 5v5 round-based first-person Roblox game combining Taguan, Patintero, Agawan Base, and hidden-role social deduction.

## 1. Executive design decisions

BOPLUX should use a **single Roblox place with one authoritative server simulation and one active map at a time**. Maps should be stored as versioned model packages in `ServerStorage`, cloned into a dedicated `Workspace.MapRuntime` container during a match, and destroyed after the match. This is preferable to maintaining separate Workspaces because Roblox exposes one live `Workspace`; multiple parallel map roots would increase memory, replication, debugging, and streaming complexity.

The game should be **server-authoritative**. The client may request an action, display local feedback, and play cosmetic effects, but the server must decide whether a player is in range, alive, eligible, holding the input long enough, and allowed to affect a Jail, Site, player, or sabotage state. `RemoteEvent` is the appropriate client-server transport for asynchronous requests and notifications; its documented API includes `FireServer`, `OnServerEvent`, `FireClient`, and `OnClientEvent`.[1]

The game should target **stable 60 FPS on mid-range desktop and 30 FPS on mid-range mobile**, with frame-time consistency treated as more important than a headline peak FPS. Roblox documents 16.67 ms as the frame time for 60 FPS and 33.33 ms for 30 FPS, and recommends using MicroProfiler to identify frame spikes.[2]

The map should be designed around compact, readable combat spaces rather than a large seamless world. The requested 619+ instance count is manageable if most instances are anchored, reused, streamed, and free of unnecessary scripts, constraints, lights, and unique materials. Roblox documentation specifically recommends instance streaming, reuse of identical mesh asset IDs, appropriate render fidelity, and selective shadow casting.[3]

## 2. Game model and assumptions

Each round has two teams of five. The core loop is: pre-round assignment, movement and crossing objectives, capture or jail events, rescue and breakout opportunities, plant/defuse pressure, and a decisive round-end reveal. One player has a **30% round-level probability** of receiving the secret Impostor role. The role should be assigned on the server and replicated only to the selected player through a private client event.

A two-player development session should remain playable as a **2-player test mode**, but it should not be treated as evidence that the 5v5 balance is correct. In test mode, bots or simplified role quotas can stand in for missing players. Production matchmaking should enforce the intended population or use a clearly labeled reduced-player ruleset.

The design should distinguish four kinds of state:

| State class | Examples | Authority | Persistence |
|---|---|---|---|
| Match state | phase, round timer, map ID, winning team | Server | Round only |
| Player state | team, alive, jailed, carrying objective, role | Server | Match or round |
| Objective state | Site A planted, Jail B open, rescue progress | Server | Round only |
| Presentation state | banner text, pulses, camera shake, local audio | Client | Ephemeral |

Use attributes for small, inspectable replicated facts such as `MatchPhase`, `RoundId`, `JailId`, `SiteId`, `IsJailed`, and `ObjectiveState`. Keep authoritative transitions inside pure server modules rather than allowing arbitrary scripts to mutate attributes.

## 3. Prioritized assets and content pipeline

### 3.1 Prioritized asset list

| Priority | Asset group | Roblox representation | Minimum viable content | Production requirement |
|---|---|---|---|---|
| P0 | Greybox map | `Part`, `Model`, folders, attachments | One readable arena with two Jails and two Sites | Modular walls, landmarks, collision pass, visibility and route polish |
| P0 | Player readability | Character accessories, `BillboardGui`, icons | Team color, name, jailed marker | Distance-limited nameplates, role-safe presentation, accessibility colors |
| P0 | Objective interactables | `Model`, `ProximityPrompt` or custom raycast UI, attachments | Jail doors, Site terminals, rescue markers | State-driven models with active, blocked, planted, defused, and reset states |
| P0 | Core audio | `Sound` objects and uploaded audio assets | Countdown, plant, defuse, jail, rescue, reveal, warning | Variants, attenuation, priority mixing, mobile-safe loudness |
| P1 | Materials and decals | `MaterialVariant`, `Texture`, `Decal` or surface textures | Team and objective markings | Small reusable texture atlas, consistent palette, low duplicate count |
| P1 | VFX | `ParticleEmitter`, `Beam`, `Trail`, `Highlight`, attachments | Plant glow, warning pulse, jailbreak spark | Short-lived pooled effects and state-specific color language |
| P1 | Animation | `Animation`, `Animator`, animation tracks | Hold, capture, rescue, plant, defuse | Interruptible animation states with server-confirmed completion |
| P2 | UI art | `ImageLabel`, `ImageButton`, vector-like shapes, icons | Banner, timer, objective card | Responsive layouts, controller and mobile touch states |
| P2 | Optional cinematic | `VideoFrame` only if justified | Menu or reveal sequence | Avoid during live objective play unless tested on low-end devices |

Roblox asset classes should be selected by purpose. Use `MeshPart` or modular `Model` assets for geometry, `Decal` and image content for markings, `Sound` for audio, `Animation` for character motion, `ParticleEmitter` and `Beam` for effects, and `ScreenGui` or `BillboardGui` for interface. Use `VideoFrame` sparingly because it adds a separate playback and memory path without improving the core round loop.

### 3.2 Placeholder-to-final pipeline

The recommended pipeline is: **rules greybox → traversal greybox → interaction prototype → visual blockout → optimized art pass → lighting and audio pass → device validation → release package**. Every stage should preserve stable logical markers. For example, an art replacement must not rename `Jail_A.InteriorMarker` or remove its `JailId` attribute.

Use a contract-first asset manifest. Each logical asset receives a stable internal key such as `map_courtyard.wall_modular_a`, while the manifest stores the Roblox content ID, version, owner, license note, fallback, and preload tier. Code references logical keys rather than scattering numeric IDs through scripts.

```lua
return {
    ['ui.round_banner'] = {
        contentId = 'rbxassetid://...',
        kind = 'Image',
        version = 3,
        preloadTier = 'RoundStart',
    },
}
```

The budget-friendly approach is to reuse a small modular kit, duplicate identical meshes rather than re-uploading them, use trim sheets or compact texture atlases, reserve custom meshes for silhouettes that affect recognition, and commission or create a limited sound library with several parameterized variations. Roblox notes that duplicate uploads with different IDs can load the same content multiple times, while identical underlying asset IDs can improve draw-call reuse.[3]

Preload only the assets needed for the immediate state. `ContentProvider:PreloadAsync()` can preload a list of instances and expose fetch status and failures.[4] Preload the lobby shell, current map landmarks, first-round UI, and core audio before spawning players. Do not preload every future map, every cosmetic, or every sound variant at join time.

## 4. Architecture and communication

### 4.1 Layered architecture

The recommended server dependency direction is:

```text
MatchManager
  ├── RoundRules
  ├── PlayerStateService
  │     ├── Team and role assignment
  │     ├── Alive, jailed, captured, rescued states
  │     └── Spawn and reset contracts
  ├── JailService
  │     ├── Cell A / Cell B state
  │     ├── Breakout validation
  │     └── Rescue validation
  ├── ObjectiveService
  │     ├── Site A / Site B plant state
  │     ├── Defuse state
  │     └── Detonation timer
  ├── ImpostorService
  │     ├── 30% assignment roll
  │     ├── Private objective delivery
  │     └── Sabotage authorization
  ├── AudioCueService
  └── TelemetryService

Client presentation layer
  ├── HUDController
  ├── BannerController
  ├── ObjectiveController
  ├── NameplateController
  ├── InputController
  └── Audio/VFX controllers
```

`MatchManager` owns phase transitions and calls lower-level services. Lower-level services return explicit results such as `Accepted`, `OutOfRange`, `WrongTeam`, `AlreadyBusy`, or `Interrupted`. They should not directly decide the next match phase.

### 4.2 Communication bus

Use `RemoteEvent` for client requests and server-to-client presentation messages. Recommended remotes are `ActionRequest`, `MatchSnapshot`, `ObjectiveEvent`, `PrivateRoleEvent`, and `PresentationEvent`. Keep payloads small and semantic. Send `ObjectiveEvent {id='SiteA', state='Planted', endsAt=serverTime}` rather than replicating a large object graph.

Use `BindableEvent` or direct module calls for server-to-server events only when a typed return value is not needed. Prefer direct module APIs for state transitions because they are easier to test. Do not treat a client `BindableEvent` as security-relevant communication.

A request contract should look like this:

```lua
ActionRequest:FireServer({
    action = 'StartHold',
    targetId = 'SiteA',
    clientSequence = 42,
})
```

The server then checks the player, round phase, role, target existence, line-of-sight or range, cooldown, occupancy, and elapsed server time. The client cannot set `PlantProgress`, `JailOpen`, `Role`, `DetonationEndsAt`, or `IsJailed` directly.

### 4.3 State transition principles

Represent each hold interaction as a server-owned transaction. On start, store the actor, target, action, start time, and required duration. On each validation tick or at completion, verify that the actor remains alive, in range, eligible, and not interrupted. Cancel on death, stun, target state change, distance break, round transition, or conflicting action.

Use `Workspace:GetServerTimeNow()` or another server-synchronized time source for timer display, while retaining the server as the source of truth. Do not trust a client-supplied elapsed duration.

## 5. Optimization strategy

### 5.1 Budgets and targets

| Area | Target | Validation method |
|---|---:|---|
| Client frame rate | 60 FPS desktop; 30 FPS mid-range mobile | MicroProfiler and device matrix |
| Frame time | Prefer under 16.67 ms desktop and under 33.33 ms mobile | Frame-time percentile, not only average |
| Server simulation | Stable heartbeat with no recurring spikes | Server MicroProfiler and custom timings |
| Remote traffic | Event-driven; no per-frame remotes | Network capture and payload counters |
| UI updates | Event-driven; local countdown interpolation | Script profiling |
| Physics | Mostly anchored map; only necessary moving assemblies | Awake-part counts and physics timings |
| Dynamic lights | Few, localized, mostly non-shadow-casting | Low-end device visual test |

Roblox’s MicroProfiler reports engine timing for animation, physics, scripts, rendering, and network-related work. It should be used on representative mobile hardware because powerful desktop hardware can conceal frame spikes.[2]

### 5.2 Managing 619+ instances

A count of 619 instances is not itself a performance failure. The risk comes from the composition: unique meshes, high-resolution textures, unanchored assemblies, per-instance scripts, excessive lights, particle overdraw, frequent property replication, and repeated raycasts.

Use these rules:

1. Keep map geometry modular and anchored.
2. Replace repeated decorative Parts with shared MeshParts or packages where appropriate.
3. Remove scripts from decorative descendants; one controller should manage a collection.
4. Use collision groups so decorative and trigger geometry do not generate unnecessary contacts.
5. Disable `CastShadow` on small or distant props when shadows are not gameplay-relevant.
6. Use `MeshPart.RenderFidelity` appropriately and avoid large imported monolithic maps.
7. Pool temporary VFX and UI objects instead of creating and destroying them repeatedly.
8. Use collection tags or registries for interactables rather than scanning all descendants each Heartbeat.
9. Run proximity checks at a bounded cadence, such as 5–10 Hz, and only for players near the active interaction zone.
10. Batch telemetry and avoid printing in production loops.

Roblox documents that instance streaming can reduce memory, loading time, and synchronization work, while excessive `Persistent` models, duplicate assets, high-resolution textures, and unnecessary audio loading can increase memory pressure.[3]

### 5.3 UI, audio, and network

Use `ScreenGui` for the HUD because it remains stable relative to the screen and does not require world replication. Use `BillboardGui` for player names and world markers, with distance limits, occlusion-aware visibility, and a maximum number of simultaneous nameplates. Use world-space UI only for objective terminals and diegetic indicators that benefit from spatial placement.

Audio should be event-driven. Place positional sounds at the relevant Jail or Site, set a deliberate roll-off range, and avoid duplicating the same looping sound under every part. Use a small number of global UI sounds for banners and countdowns. Load map-specific audio by tier instead of loading the entire catalog at join.

Network payloads should be compact enums, IDs, booleans, and timestamps. Do not send continuous `Heartbeat` state to every client. Clients can interpolate a countdown locally from a server-approved end time. Throttle repeated requests by player and action type, and reject impossible request rates server-side.

## 6. Map and Workspace architecture

### 6.1 Recommended hierarchy

```text
Workspace
  ├── MapRuntime
  │   └── ActiveMap
  │       ├── Geometry
  │       ├── Gameplay
  │       │   ├── Jails
  │       │   │   ├── Jail_A
  │       │   │   │   ├── InteriorMarker
  │       │   │   │   ├── ExteriorMarker
  │       │   │   │   ├── BreakoutMarker
  │       │   │   │   └── Door
  │       │   │   └── Jail_B
  │       │   └── Sites
  │       │       ├── Site_A
  │       │       │   ├── PlantMarker
  │       │       │   ├── DefuseMarker
  │       │       │   └── DeviceModel
  │       │       └── Site_B
  │       ├── SpawnPoints
  │       ├── Audio
  │       └── VFX
  └── Characters

ServerStorage
  └── Maps
      ├── Courtyard_v001
      └── Schoolyard_v001
```

Store complete map templates in `ServerStorage` so clients do not receive inactive maps. Clone only the selected template into `Workspace.MapRuntime`. Roblox’s streaming system applies to descendants of `Workspace`; content held in containers such as `ReplicatedStorage` is not eligible for normal Workspace streaming.[5] This supports the recommendation to keep inactive maps out of Workspace.

### 6.2 Jail and Site contracts

Every Jail model should have `JailId` set to `A` or `B`, and every Site model should have `SiteId` set to `A` or `B`. Required attachments or markers should use stable names:

| Marker | Purpose | Range |
|---|---|---:|
| `InteriorMarker` | Determines whether a jailed player is inside the cell | `InteriorRange = 4.5` |
| `ExteriorMarker` | Determines whether a rescuer or breakout actor is at the outside interaction point | `ExteriorRange = 3` |
| `SabotageMarker` | Determines whether the Impostor can affect a Jail or reset a breakout | `SabotageRange = 3` |
| `PlantMarker` / `DefuseMarker` | Determines Site interaction origin | `SiteRange = 2` |

Use server-side distance checks from the character’s validated root position to the marker’s world position. Distance alone is not enough for enclosed geometry; add line-of-sight or marker-volume checks when a wall could otherwise be exploited.

### 6.3 Sabotage and camping meter

The Impostor’s sabotage actions should be objective-specific and reversible where possible. At a Jail, sabotage can reset an in-progress breakout or change the door state. At a Site, sabotage can cancel or interrupt a plant/defuse interaction, but it should not silently erase a completed plant unless that is an explicit, telegraphed rule.

The Jail-camping meter should be a server-side proximity and dwell-time system. Track a player’s time within a defined exterior ring around each Jail, exclude players who are jailed or in a valid rescue interaction, and decay the meter when they leave. Sample at 5–10 Hz rather than every render frame. Escalate feedback in stages: subtle local indicator, team-visible warning, then a gameplay consequence only if the design explicitly approves it. The meter must not reveal the Impostor’s identity by using a unique feedback channel.

## 7. UI/UX and micro-interactions

### 7.1 Production notification banner

Replace the simple `TextLabel` with a reusable `BannerController` containing a rounded panel, icon slot, title, body, severity color, progress or countdown slot, and accessibility-safe contrast. The banner should use a queue with priorities: emergency objective warnings supersede informational messages, while duplicate messages coalesce.

Recommended animation: 150 ms ease-out entrance, 2.5–4.0 seconds default hold, 200 ms ease-in exit. Use a small scale or vertical slide rather than a large camera movement. Pair color with icon and text so color is not the only signal. For urgent events, add a single pulse and a spatial audio cue, not a continuous screen shake.

### 7.2 HUD wireframe

```text
+-------------------------------------------------------+
| [Round phase] [Objective timer]       [Team status]   |
|                                                       |
|                                                       |
|                 FIRST-PERSON PLAYSPACE               |
|                                                       |
| [Context prompt: Hold E to rescue]                    |
|                                                       |
| [Banner: Site A planted]      [Crosshair]             |
|                                                       |
| [Role/objective card] [Cooldown ring] [Hint]          |
+-------------------------------------------------------+
```

Player names should be integrated through distance-limited `BillboardGui` nameplates. During ordinary play, show display name and team-safe status. Do not show the secret role. At round end, transition to a reveal card with the player’s role, key objective outcome, and a short timeline of decisive events.

### 7.3 Timing and feedback table

| Interaction | Server rule | UI feedback | Audio/VFX |
|---|---|---|---|
| 15s pre-round | Lock combat actions; assign roles | Large countdown, team spawn card | Tick at 5s, stronger tick at 3s, start sting |
| 5s plant hold | Must remain eligible and within `SiteRange` | Radial progress and cancel reason | Low loop, progress pulse, completion confirmation |
| 7s defuse hold | Same validation; planted device must exist | Defuse progress, threat status, interruption flash | Tension loop, escalating beeps |
| 45s detonation | Server-owned end timestamp | Site-specific countdown and route warning | Periodic beeps, final warning burst |
| 3s breakout hold | Jailed player or authorized actor meets Jail contract | Cell progress ring and door state | Metal strain loop, open snap |
| 10s rescue hold | Rescuer remains in exterior range and valid state | Rescue progress and target name | Team-safe rescue tone, interruption stinger |

> **CORRECTION (2026-09-06):** the two rows above are backwards. The locked values are **45s breakout hold** and **3s rescue hold** (GDD §7 / JailConfig: `BreakoutSeconds = 45`, `RescueSeconds = 3`). Do not pull breakout/rescue timings from this table — cross-check the GDD.
| 20s cooldown | Block repeated action on the server | Radial cooldown or compact timer | Soft cooldown completion cue |

Screen shake should be reserved for detonation or major round-end events, scaled by accessibility settings. Hold actions should show exactly why they are blocked: out of range, interrupted, wrong team, target unavailable, or cooldown. This reduces perceived input failure.

The Impostor Warning should be private, high-confidence, and brief: a dark accent card with the role title, one-sentence rule reminder, and the first secret objective. The Secret Objective card should avoid exposing a full future plan to other players through replicated UI. The Round-End Reveal should intentionally delay role reveal until the outcome is locked, then show role, completed sabotage, failed sabotage, and team result.

## 8. Implementation roadmap

| Phase | Deliverable | Exit criteria |
|---|---|---|
| 0. Contracts | State enums, marker naming, asset manifest, remote schemas | Unit tests pass; no numeric IDs in gameplay code |
| 1. Greybox loop | One map, two Jails, two Sites, spawning, round phases | Two players can complete a full round without manual intervention |
| 2. Authority and actions | Server validation, plant, defuse, breakout, rescue, jail state | Invalid range, spoofed duration, duplicate request, and stale request tests pass |
| 3. Impostor | 30% assignment, private objective, sabotage rules, reveal | Role secrecy validated with network inspection and replay tests |
| 4. Production HUD | Banner, countdowns, names, role card, progress feedback | All requested timings are visible, interruptible, and accessible |
| 5. Art and audio | Modular kit, VFX, sound mix, lighting | Art replacement preserves gameplay markers and performance budgets |
| 6. Optimization | Streaming, pooling, reduced scans, payload instrumentation | Mobile and desktop targets meet frame-time and memory gates |
| 7. Scale and release | 5v5 load tests, reconnect behavior, analytics, moderation hooks | Match reset, player leave/join, map swap, and round-end flows are robust |

## 9. QA, telemetry, and risk controls

Test the game with deterministic server tests for every state transition. Add integration tests for a player leaving during a hold, a target streaming out, a round ending during detonation, a duplicate request, a client clock mismatch, and two players attempting the same objective simultaneously.

Telemetry should record round duration, objective completion, interruption reason, Jail occupancy time, rescue success, plant-to-defuse time, server heartbeat spikes, remote rejection counts, asset fetch failures, and client frame-time percentiles. Do not log the Impostor role in player-visible analytics or expose it through client state.

The primary design risks are role frustration, Jail camping, unreadable objective states, low-population balance, and mobile performance. Mitigate them with private but explicit role instructions, a decaying camping meter, consistent state language, a labeled 2-player test ruleset, server-side validation, and device-first profiling. Do not expand the map until the compact arena produces reliable decisions and readable routes.

## 10. Final checklist

- [ ] One active map under `Workspace.MapRuntime`; inactive maps remain in `ServerStorage`.
- [ ] All Jails and Sites have stable IDs, markers, attributes, and validation contracts.
- [ ] Client requests are treated as untrusted intents.
- [ ] All action durations are measured from server time.
- [ ] The Impostor role is delivered privately and never stored in public replicated attributes.
- [ ] Remote payloads contain IDs, enums, booleans, and timestamps rather than large state trees.
- [ ] UI uses `ScreenGui` for HUD and bounded `BillboardGui` for names.
- [ ] Audio uses spatial roll-off and tiered loading.
- [ ] Identical assets reuse the same Roblox IDs.
- [ ] MicroProfiler captures are taken on representative mobile hardware.
- [ ] 2-player tests are separated from 5v5 balance claims.
- [ ] Round reset and map unload are idempotent.

## 11. AI-assisted asset production

AI should accelerate BOPLUX’s concept-to-first-pass workflow, but it should not bypass human cleanup, Roblox import testing, or license review. The recommended stack is Roblox Cube or Studio Assistant for quick native prop experiments, Meshy for general text/image-to-3D props and PBR texturing, 3D AI Studio with Tripo P1 for low-poly Roblox-oriented exports, Blender for topology and collision cleanup, Adobe Firefly for short sound effects, ElevenLabs for carefully licensed voice or music needs, and Recraft for UI icon exploration. Roblox describes Cube as a text-to-3D foundation model intended to generate compatible 3D objects and accelerate creator workflows.[7]

Use AI to generate a modular environment kit rather than a complete map. Generate wall segments, doors, fences, crates, lamps, signs, and landmarks as separate assets. Build the actual Jails, Sites, interaction volumes, marker attachments, and collision contracts in Studio. This preserves the server-authoritative gameplay structure when visual assets are replaced.

Mesh generation tools can produce useful first passes, but generated geometry still requires retopology, UV inspection, material validation, scale correction, pivot correction, collision proxy creation, and mobile performance testing. Meshy documents a broad text/image-to-3D, texturing, remeshing, rigging, and export workflow while also noting that post-processing may be required.[8] A Roblox-focused workflow from 3D AI Studio advertises FBX/OBJ export and low-poly output for Studio’s 3D Importer, but each generated asset should still be tested against the project’s own budgets.[9]

For audio, prefer short layered effects over long generated music. Adobe Firefly advertises text, reference-audio, and performed-input sound-effect generation and describes its output as commercial-ready under its product terms.[10] ElevenLabs provides voice, music, and sound-effect capabilities, but its site notes that music rights vary by subscription tier.[11] Re-check the applicable terms before release.

Maintain provenance for every shipped AI-assisted asset. Store the tool, account or plan, prompt or source reference, output date, source files, human edits, and license terms in the asset manifest. Do not clone recognizable voices or use third-party characters, logos, or trademarks without permission.

For the full tool comparison, pipeline, acceptance checklist, budget plan, and 30-day pilot, see [BOPLUX AI Asset-Tool Recommendations](BOPLUX_AI_asset_tools.md).

## References

[1]: https://create.roblox.com/docs/reference/engine/classes/RemoteEvent "RemoteEvent | Roblox Creator Hub"

[2]: https://create.roblox.com/docs/performance-optimization/microprofiler "MicroProfiler | Roblox Creator Hub"

[3]: https://create.roblox.com/docs/performance-optimization/improve "Improve performance | Roblox Creator Hub"

[4]: https://create.roblox.com/docs/reference/engine/classes/ContentProvider "ContentProvider | Roblox Creator Hub"

[5]: https://create.roblox.com/docs/workspace/streaming "Instance streaming | Roblox Creator Hub"

[6]: https://create.roblox.com/docs/reference/engine/classes/Workspace/StreamingEnabled "Workspace.StreamingEnabled | Roblox Creator Hub"

[7]: https://about.roblox.com/newsroom/2025/03/introducing-roblox-cube "Introducing Roblox Cube: Our Core Generative AI System for 3D and 4D"

[8]: https://www.meshy.ai/blog/best-ai-tools-for-3d-game-assets "Best AI Tools for 3D Game Assets (2026 Compared)"

[9]: https://www.3daistudio.com/UseCases/Roblox "AI Roblox Model Maker | 3D AI Studio"

[10]: https://www.adobe.com/products/firefly/features/sound-effect-generator.html "Adobe Firefly AI Sound Effects Generator"

[11]: https://elevenlabs.io/ "ElevenLabs Creative and Audio AI Platform"

> **Implementation note:** Numeric performance targets and gameplay ranges in this brief are design targets for BOPLUX, not Roblox platform guarantees. Validate them through profiling, playtests, and device-specific acceptance tests before release.
