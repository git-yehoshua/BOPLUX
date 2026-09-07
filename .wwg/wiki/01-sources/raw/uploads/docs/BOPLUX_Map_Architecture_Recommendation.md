# BOPLUX — Map & Place Architecture Recommendation

**Status:** RECOMMENDATION ONLY. Not yet part of Project Truth. Neither the GDD nor the OQ resolutions currently specify place/map topology — this fills that gap. It should be reviewed and, if accepted, promoted into `project-truth.md` under Architecture Truth rather than left as an inferred assumption.

**Basis:** Roblox platform documentation (Experiences & Places, Studio/Instance model) + `BOPLUX_design_brief.md` §1 and §6.1 (reference material, cross-checked against the platform docs rather than taken on faith).

---

## 1. The recommendation, in one sentence

**One experience. One place. One live server simulation. Maps are content packages that get cloned in and destroyed out of that single place — they are never separate places or separate experiences.**

## 2. Why not multiple places

Roblox's own model: an **experience** can contain multiple **places**, each a fully separate server-hosted data model — comparable to separate levels in another engine. Moving a player between places is a genuine **server-to-server teleport**: reconnect, loading screen, new server instance.

That pattern is the right tool for a hub-and-spoke structure (a lobby place linking out to distinct minigame-arena places). It is the wrong tool for BOPLUX because:

- A match is one continuous session with server-owned timers, scores, round counters, and role state (Impostor). Splitting maps across places would mean rebuilding all of that continuity through teleport data on every map — real engineering cost for zero player-facing benefit.
- Round-based competitive games (the genre BOPLUX is modeled on) keep the whole match, across every map/round, inside one server instance. Reconnecting players between rounds would introduce loading breaks the design has no reason to want.
- Your current template (`template.rbxl`) is already a single place with a single Workspace — this recommendation requires no migration, it just gives a name and a lifecycle to what you're already doing.

**When multiple places would make sense later (not now):** a separate main-menu/lobby experience in front of the matchmaking place, once BOPLUX has real matchmaking. That's a future, optional addition — not a reason to split maps today.

## 3. Map lifecycle inside the one place

```
ServerStorage
  └── Maps
      ├── Courtyard_v001      (inactive — never sent to clients)
      └── Schoolyard_v001     (inactive — never sent to clients)

Workspace
  └── MapRuntime
      └── ActiveMap           (clone of the selected map, live for the match)
```

- Map templates live in `ServerStorage`, which is **server-only** — Roblox never replicates it to clients, so inactive maps cost clients nothing.
- At match start, Match Manager clones the selected template into `Workspace.MapRuntime.ActiveMap`.
- At match end, that clone is destroyed. The next match clones fresh.
- This is a straightforward `ServerStorage → Workspace` clone/destroy pattern — no new Roblox mechanism, no custom streaming logic, no place teleporting.

**Why this is the "simple but optimized" answer:** it uses exactly the two services Roblox already gives you for this job (`ServerStorage` for inactive content, `Workspace` for live content) and one already-planned system (Match Manager) to drive it. Nothing exotic, nothing to build from scratch.

## 4. The map contract — what every map must provide

This is the actual reusable unit, not "a jail map" or "a plant map." Every map package, regardless of theme, must satisfy the same contract so gameplay systems never need to know which map is loaded:

| Element | Requirement | Owned by |
|---|---|---|
| Two Jails | `JailId = A` / `B` attribute; `InteriorMarker`, `ExteriorMarker`, `BreakoutMarker`, `SabotageMarker` attachments at stable names | Map package (geometry + placement) |
| Two Plant Sites | `SiteId = A` / `B` attribute; `PlantMarker`, `DefuseMarker`, `SabotageMarker` attachments | Map package |
| Two enclosed spawn rooms | Single exit each, opponent-inaccessible for the whole round (per OQ-002) | Map package |
| Jail logic (capture, breakout, rescue, camping meter) | Map-agnostic; identical code regardless of which map is loaded | `ServerScriptService`, built once |
| Objective logic (plant, defuse, detonation) | Map-agnostic | `ServerScriptService`, built once |

**This directly answers the jail question:** Jail is not a standalone map, mode, or experience. It's a per-map authoring requirement — every map ships its own two Jail *models* satisfying the same *contract* — while the Jail *system* (all the actual rules) is written once and never touched again when a new map is added. Adding a tenth map means placing two Jail models with the right attributes and markers, not writing any new logic.

## 5. What this buys you going forward

- Adding Map #2 (Schoolyard, Rice Fields, etc.) is a content task: build geometry, place two Jails and two Sites that satisfy the contract above, register it in `ServerStorage.Maps`. Zero changes to Match Manager, Jail System, Objective System, or Impostor System.
- An art pass or AI-assisted asset replacement (per `BOPLUX_AI_asset_tools.md`) can swap map visuals freely as long as it never renames a marker or drops a `JailId`/`SiteId` attribute — this is the same "art replacement must not break the contract" principle already noted in the design brief.
- Nothing here touches server-authoritative validation, remotes, or any DECIDED/RECOMMENDED item in the GDD or OQ resolutions — this is purely the container-and-content-lifecycle layer those systems run inside.

## 6. Open item for the owner

This document is a recommendation, not truth. If accepted, the concrete addition to `project-truth.md` → Architecture Truth would be one line: *"BOPLUX uses a single experience, single place, single live server simulation; maps are versioned packages in `ServerStorage` cloned into `Workspace.MapRuntime` per match and destroyed after."* Flag if any part of this doesn't hold up once a second map is actually built.
