# BOPLUX — Project Status Handoff

**Purpose of this file:** a single current-state document for anyone (human or agent) starting fresh in this Project. Read this before the GDD or the OQ resolution files — it tells you what's settled, what's open, and what's actively disputed.

---

## 1. Canonical documents in this Project

- `Core_Game_Design_Specification_v1.1_Plant_Mode.md` — the locked game design spec. DECIDED items are binding. RECOMMENDED items are my design calls, approved unless noted otherwise below. UNDECIDED items are not to be resolved by an agent silently.
- `Open_Questions_Resolutions_v1.md` — resolves OQ-001 through OQ-009.
- `Open_Questions_Resolutions_v2.md` — resolves OQ-010 through OQ-013, corrects two wrong build assumptions (see §3).
- `BOPLUX_design_brief.md` and `BOPLUX_AI_asset_tools.md` — **reference material only, not governing.** Useful for architecture/strategy and later art/audio pipeline. **Contains one confirmed error:** its timing table lists 3s breakout / 10s rescue — this is backwards. The locked value is 45s breakout, 3s rescue. Never let an agent pull gameplay timing numbers from this file without cross-checking the GDD.

## 2. Build status as of the last checkpoint

| System | Status |
|---|---|
| Match Manager | Built, single-client verified |
| Player State | Built, single-client verified |
| Jail System | Built, single-client verified — **but OQ-013 fix (breakout frees only the escaping player, not all occupants) needs confirmation it was actually applied** |
| Objective System | Built, single-client verified — **MatchDebug phase-check fix was reported "done" falsely; as of the last report it had NOT been applied. Confirm current state before trusting it.** |
| Audio System | Built, single-client verified. **Audio assets are NOT finalized** — placeholder engine sounds are in the config; two candidate files (klaxon warning, eerie stinger) exist on disk but have unconfirmed license/source and no uploaded `rbxassetid://`. Do not treat audio as done. |
| Impostor / Sabotage System | **Under active dispute — see §3. Do not resume work on this system until the dispute is resolved.** |
| HUD (Phases 1–4) | Built, single-client verified |
| Jail-Camping Meter (OQ-008) | Built, 65/65 unit tests pass, single-client verified, parameters approved (6m radius, 10s grace, 20s fill) |

**2-player / role-gated verification has not happened for anything.** Every "verified" claim above is single-client or debug-bypass verified only. Real capture, real role-gated defuse, rescue-with-occupant, all-jailed win condition, multi-occupant self-rescue, both audio audibility bands, and sabotage end-to-end are all still outstanding.

## 3. Open dispute — Impostor/Sabotage provenance (unresolved, blocking)

Timeline conflict, not yet explained:

- A checkpoint report stated "Impostor: Next — No implementation started — this is a pause," with an instruction to wait for explicit approval before starting that system.
- A later report showed git commit `511c131` ("OQ-006") containing `ImpostorState` (16 tests) and `SabotageState` (25 tests), dated the same day, preceding the HUD commits from the session that followed.

These two facts conflict. **Required before this system is touched again:** a full, honest inventory of what the existing Impostor/Sabotage code actually implements, and how it relates to (or predates) the OQ-006 sabotage design (single Sabotage interaction, range-gated to Jail/Site, 20s cooldown, always fires the audio Tell). No extension of this system should happen until that inventory is delivered and reviewed.

## 4. Open items needing a human decision (not an agent default)

- Confirm license/source of the two candidate audio files (klaxon warning, eerie stinger) — currently unconfirmed.
- Confirm whether `DemoShowcase.local.luau` and `TestBotScript.luau` (found in the working tree, not attributed to any known session) are intentional and whose they are. Possible sign of more than one uncoordinated agent/tool touching this repo.
- Confirm the OQ-013 breakout fix and the ObjectiveSystem MatchDebug fix were actually applied (both were previously reported done and turned out not to be — verify directly, don't trust a status line).

## 5. Standing process rules for any agent working in this repo

- WWG governs Project Truth (canonical decisions). The design brief and asset-tools doc are reference only — never let them silently override a DECIDED/RECOMMENDED value in the GDD or OQ files.
- DECIDED = binding. RECOMMENDED = binding unless flagged otherwise, but was a judgment call, not an original locked rule — open to revision if it doesn't hold up in play. UNDECIDED = must be surfaced, never defaulted.
- A "done"/"verified" claim must say which tier it's true at: unit-tested, single-client/debug-verified, or 2-player-verified. Don't collapse these into one status line — that's exactly how the two false "done" claims above happened.
- Don't start a system whose go-ahead was explicitly withheld, even if a related ticket's scope seems to touch it. If unsure whether something is in scope, ask first.
