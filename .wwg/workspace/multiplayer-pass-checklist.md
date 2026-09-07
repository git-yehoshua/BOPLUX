# Multi-Player Verification Pass — Checklist (Courtyard_v001)

Target: 4 players (2v2) via Studio Test tab → Clients and Servers. Fallback tier: 2 players (1v1). All items produce captured evidence (attribute values, console lines, remote payloads) — no status-line claims.

Roles: label clients A1/A2 (Attackers) and D1/D2 (Defenders) after team assignment is observed via MatchStateSync/HUD.

## 1. Match Manager
- [ ] All 4 spawn inside their team spawn rooms; randomized teams via HUD TeamBadge; cross-team collision disabled (walk-through test A1 vs D1)
- [ ] Pre-round 15s → Live 180s phases cycle on the HUD for all clients
- [ ] Roles swap at halftime (round 3 → 4 badge flip); 6-round match flow; (optional long-run) 3–3 tie → round 7

## 2. Jail System (real paths)
- [ ] Real capture: D1 within ≤1.5m of A1, `RequestCapture` fires → A1 jailed (Cell_A or B), WalkSpeed 0, occupant attribute = 1
- [ ] Capture immunity: A1 rescued, then D1 touches within 3s → capture rejected
- [ ] Breakout: A1 holds `RequestBreakoutHold` 45s → only A1 freed (A2 still jailed if both jailed), no buff/immunity on A1 (OQ-013)
- [ ] Breakout reset: D1 exterior + `RequestJailReset` → progress resets to 0
- [ ] Rescue: A2 exterior, 3s channel → frees ALL occupants + speed buff + immunity on each
- [ ] All-jailed: jail every Attacker → Defender round win fires ("all-jailed")

## 3. Objective System (real paths)
- [ ] Real plant: A1 5s hold in SiteRange → Planted=true, detonation countdown starts
- [ ] Capture cancels plant (D1 captures A1 mid-plant → progress 0)
- [ ] Real defuse: D1 7s hold while A2 contests (races) → one-active-interactor rule holds (OQ-009)
- [ ] Defuse completes → Defender win ("defused"); detonation completes → Attacker win
- [ ] Movement cancels channels (walk mid-defuse)

## 4. Impostor / Sabotage (end-to-end)
- [ ] 30% selection or forced via ImpostorDebug on ONE client only
- [ ] Secret objective renders ONLY on the Impostor's own HUD; leak scan from a DIFFERENT client (attributes + instances) = zero hits
- [ ] Sabotage near live breakout: resets progress, Tell audible (below)
- [ ] Sabotage near teammate plant/defuse: cancels it; wrong-context sabotage rejected; 20s cooldown enforced server-side

## 5. Audio (both audibility bands)
- [ ] Breakout warning: audible ≤30m, silent >30m from the jail
- [ ] Impostor Tell: audible ≤20m, silent >20m from sabotage position
- [ ] (Deferred to REC-0006) real asset upload + license — placeholders acceptable for this pass

## 6. Jail-camping meter (real conditions)
- [ ] D1 camps exterior 6m while A1 jailed: grace 10s → fill over 20s (attribute + HUD bar move)
- [ ] D1 leaves radius → meter depletes; grace restarts on re-entry
- [ ] Full meter → self-rescue frees occupant(s) with buff + immunity
- [ ] Impostor camping does NOT fill the meter (role excluded server-side)

## 7. HUD per client
- [ ] TopBar score/phase/timer sync on all clients; stamina drains per client; SPD/IMM badges appear on rescue
- [ ] Jails panel occupant counts + camping bars update live on all clients; Objectives panel tracks both sites

## Evidence capture
- Per item: the execute_luau probe output OR console line OR screenshot id. Log results in agent-implementation-log entry; update verification tiers in current-task.md + project-truth-summary.md.

## Notes
- Do NOT use start_stop_play while Clients-and-Servers mode runs.
- If the bridge exposes only one client window: run hybrid — owner plays one role, agent drives server + the exposed client.

## Pre-staged infrastructure (done 2026-09-06)
- `ServerScriptService/PassEvidence/RunPassEvidence.server.lua` (repo + Studio): mirrors main-VM game state every Heartbeat into `PassEvidence.PassEvidence.RunPassEvidence.PassEvidence` StringValue (phase/round, per-player team/jail/position, jail occupants+channels+camping fill, site plant/channel/detonation) + `LastTell` (most recent ImpostorTellRequested position/time). Verified live in solo play: probe VMs read live state through it (VM-isolation bridge). Harness 65/65.
- During the pass: probe `PassEvidence` after every checklist action instead of guessing; screenshot + archive key snapshots into the implementation-log entry.

## Input layer (discovered 2026-09-06, pre-pass blocker)
- The game had ZERO client input bindings - 4 real players could only walk/jump. Added `StarterPlayerScripts/PlayerInputs.local.luau` (repo + Studio):
  LMB capture(near)+plant-hold | RMB jail-reset | E rescue/defuse-hold | F breakout-hold+sabotage | Shift sprint.
  All fires are requests; server validates/rejects. Every verification-path action is now reachable by real client input.
- Collector now streams `[PassEvidence] ...` to console every 5s (evidence channel for spawned windows the bridge cannot attach to).
