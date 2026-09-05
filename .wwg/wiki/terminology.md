# Terminology

This file defines canonical project language.

Use `terminology-summary.md` for compact high-priority terminology before routine agent work. This full file remains canonical for official names, definitions, vocabulary, and naming boundaries.

Agents must preserve these terms across:

- UI copy
- code names
- documentation
- reports
- tests
- governance files

| Concept | Canonical Term | Allowed Internal Terms | Discouraged / Forbidden Unless Approved |
|---|---|---|---|
| The team objective | Plant | plant the objective | bomb, spike, charge (no carryable item exists — planting is a stationary channeled interaction) |
| Match-level unit (6 rounds, roles swap after round 3) | Match | bout, game | n/a |
| Three-round team side within a match | Half | side | n/a |
| Point where roles swap (after round 3 of 6) | Halftime | side swap, mid-match | n/a |
| Instant arrest of an Attacker | Capture | tag, catch | n/a |
| Detention location | Jail | cell, cage | n/a |
| Self-release by a jailed player | Breakout | jailbreak | n/a |
| Defender resetting breakout progress | Breakout reset | jail reset | n/a |
| Freeing jailed players by an active Attacker | Rescue | jail pickup | n/a |
| Reward after a successful rescue | Rescue reward | buff | n/a |
| Objective time-to-detonation | Detonation countdown | bomb timer | n/a |
| Defender time-to-cancel-plant | Defuse | disarm | n/a |
| Round setup period | Pre-round | setup phase | n/a |
| Live gameplay period | Round | round timer | n/a |
| Impostor-specific action that resets breakout or cancels a teammate's plant/defuse | Sabotage interaction | sabotage (verb only) | n/a |
| Secret saboteur | Impostor | imposter (misspelling), traitor, saboteur | n/a |
| Pre-round broadcast | Impostor Warning | warning | n/a |
| Spatial sabotage cue | Impostor "Tell" | tell, tell cue | n/a |
| Anti-snowball jail system | Jail-camping meter | anti-facecamp meter | n/a (approved via OQ-008; own Workspace item) |
| Spot where a plant is placed | Plant site | site | n/a (2 sites for v1.0 per OQ-004) |
| Project history | Changelog | CHANGELOG.md, release subtext | Raw commit log as project memory |
| Project front door | README Front Door | README.md | Full manual or implementation archive |
| Documentation ownership | Documentation Routing | doc routing | README dumping ground |
| Release memory | Release Subtext | changelog meaning, project memory | Unexplained technical release notes |
| Change significance | Meaningful Change | material project change | Formatting-only or noise-only change |

## WWG Terms

- Changelog: A non-technical project history file that records meaningful changes in a way users, owners, developers, and agents can understand.
- README Writer: A WWG feature that generates, validates, repairs, and maintains a concise root README.md from project truth, repository evidence, docs, commands, governance rules, and current project status.
- README Front Door: The root-level README.md that introduces the project and routes readers to the right next document or command.
- Documentation Routing: The process of deciding what belongs in README.md versus docs/, CHANGELOG.md, AGENTS.md, Wiki, Governance, or reports.
- README Bloat: A README condition where the root README contains too much detail that should live in focused docs.
- Phase Pollution: Stable user-facing docs containing internal implementation pass labels or builder-only history.
- README Continuity: The ability for a future human developer or agent developer to quickly understand what the project is, how to start, what is current, and where deeper documentation lives.
- Release Subtext: The documented memory of what changed, why it matters, and what future agents should know before acting.
- Meaningful Change: A change that affects project behavior, user experience, governance, safety, reliability, workflows, commands, templates, documentation truth, or agent behavior.

## Role Names

| Role Concept | Canonical User-Facing Name | Code-Facing Name | Discouraged / Forbidden Unless Approved |
|---|---|---|---|
| Offense team role | Attacker | Attacker | n/a |
| Defense team role | Defender | Defender | n/a |
| Hidden saboteur role | Impostor | Impostor | traitor, spy |
| Offense/defense teams split at halftime | Attacker team / Defender team | attackerTeam / defenderTeam | n/a |

## Match / Round Terms

| Domain Concept | Canonical Term | Notes |
|---|---|---|
| Full competitive unit | Match | 6 rounds total per Open Question Resolutions v1 |
| Team side before the swap | Half | 3 rounds per side |
| Role swap point | Halftime | Roles swap after round 3 of 6 |
| Single competitive unit | Round | 180s + 15s pre-round |
| Setup window | Pre-round | 15s; full movement, no capture/plant/rescue interactions |

## Domain Terms

| Domain Concept | Canonical Term | Notes |
|---|---|---|
| Hide-and-seek foundation | Taguan | Filipino hide-and-seek; drives hiding/concealment layer |
| Defended-ground crossing foundation | Patintero | Filipino field-crossing game; drives crossing defended territory |
| Capture/jail/rescue foundation | Agawan Base | Filipino capture-the-base game; drives Capture & Jail system |
| Absolute line-of-sight with no through-wall outlines | Line-of-sight | No enemy/teammate UI outlines through walls (GDD §3.3) |
| Regenerating sprint resource | Stamina | Sprint consumes a regenerating stamina bar (GDD §3.2); 6s continuous sprint, 1s capacity per 3s not sprinting (OQ-007) |
| Stationary progress action | Channeled interaction | Plant, defuse, breakout, rescue; cancelled by player movement, capture, or disconnect |
| Impostor channeled cancel action | Sabotage interaction | 20s cooldown; contextual effect (breakout reset at Jail / cancel teammate plant-defuse at site); always fires the audio Tell |
| Temporary post-rescue protection | Capture immunity | 3s, also grants 3s speed buff |
| Team cross-collision disabled | Cross-team collision | Disabled between opposing teams (GDD §2.1) |
| Enclosed, single-exit team spawn | Spawn room | Opponent-inaccessible for the entire round (GDD §8.1) |
| Interaction target occupancy | One-active-interactor-per-target | Only the first interactor progresses an interaction on a site/jail (GDD §9.4) |

## Rules

- Do not rename core concepts casually.
- If a prompt introduces a synonym, decide whether it is canonical before using it broadly.
- If terminology changes, update this file and reconcile code, docs, reports, tests, and governance files.
- Keep user-facing vocabulary and code-facing vocabulary intentionally mapped when they differ.
- Never use "Impostor" to refer to an actual game role in code/data before it is approved as canonical scope (it is canonical scope — GDD §6 — so use it consistently).
- Terms marked UNDECIDED (late join, spawn geometry) remain open; do not introduce synonyms as if decided.