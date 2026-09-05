# Project Truth Summary

## Purpose

Provide a compact active loading surface for current high-priority Project Truth.

This summary helps agents orient quickly. The full canonical source remains `project-truth.md`.

## Canonical Source

- Full canonical source: `project-truth.md`.
- If this summary conflicts with `project-truth.md`, `project-truth.md` wins.
- Update this summary after accepted Project Truth changes that affect active agent work.

## Current State

- Product identity: BOPLUX — multiplayer round-based first-person Roblox game; 5v5 Plant Mode combining Taguan, Patintero, Agawan Base, and a hidden Impostor.
- Primary users and roles: Attackers, Defenders, and a secret Impostor (30% chance per round).
- Canonical scope: 6-round matches (halftime after round 3), capture/jail/rescue, plant objective (2 sites v1.0), Sabotage interaction, Jail-camping meter, round win conditions, Impostor system, server-authoritative Roblox architecture (GDD §15).
- Architecture truth: server-authoritative; client requests via GDD §15 RemoteEvents; Impostor role state never replicates except to the Impostor's own client.
- Safety and production boundaries: never trust client RemoteEvents; prototype-stage, no production posture.
- Current product direction: implement playable v1.0 per the GDD and Open Question Resolutions v1; six §15 systems tracked as Workspace tasks (Match Manager → Player State → Jail → Objective → Audio → Impostor); OQ-010 (tied match) awaits owner decision.

## Canonical Terms

- Plant Mode: the game's objective-based round format defined by the GDD.
- Impostor: hidden sabotage role that wins if its own team loses.
- Pre-round / Round timer / Halftime: round structure phases.
- Capture, Jail, Breakout, Rescue, Capture immunity: jail-system mechanics.
- Canonical design source: `Core Game Design Specification v1.1 — Plant Mode` (source `src_20260905_072128_core_game_design_specification_v1_1_plant_mode`); DECIDED and RECOMMENDED items are binding, UNDECIDED items are owner-owned open questions.

## Decisions

- The GDD is the authoritative game design truth; its DECIDED and RECOMMENDED items bind implementation.
- Open Question Resolutions v1 (source `src_20260905_073942_open_question_resolutions_v1`) resolves OQ-001…OQ-009 and the match-length/halftime gap; all nine entries are owner-DECIDED.
- Remaining open item: OQ-010 (3–3 tied match outcome) — do not resolve silently.
- Full Project Truth remains canonical.
- This summary is for active loading and should stay compact.
- Historical notes belong in reports, changelog, ADRs, logs, or history docs.
- Implementation details become Project Truth only when accepted or documented as requirement evolution.

## Constraints

### Must

- Preserve accepted project identity, scope, terminology, architecture, and safety boundaries.
- Keep unknowns explicit until the project owner supplies truth.
- Link to full Project Truth for detail.
- Reconcile code, README, Workspace, Governance, and reports when accepted truth changes.

### Must Not

- Invent product truth.
- Let reports or generated notes override `project-truth.md`.
- Duplicate the full canonical body here.

### Prefer

- Short current-state bullets.
- Explicit `Not yet defined` placeholders.
- References to canonical files.

### Avoid

- Timeline dumps.
- Phase/pass history.
- Ambiguous pronouns.

## Must Not Drift

- Product identity.
- Primary users and roles.
- Canonical scope.
- Canonical terminology.
- Architecture boundaries.
- Safety and production-readiness boundaries.
- Validation and closeout expectations.

## Load Full Truth When

- A task changes accepted project behavior.
- A task touches product scope, roles, terminology, architecture, payments, auth, security, persistence, deployment, data ownership, or production-readiness claims.
- Compact summary content appears stale or incomplete.
- A report, implementation, generated output, or README conflicts with Project Truth.

## References

- `project-truth.md`
- `terminology-summary.md`
- `terminology.md`
- `09-agent-context/project-master-context.md`
- `12-maintenance/context-maintenance-matrix.md`
- Root `AGENTS.md`
- `.wwg/governance/drift-guard.md` in generated projects