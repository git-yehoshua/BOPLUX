# Terminology Summary

## Purpose

Provide a compact active loading surface for high-priority project terminology.

This summary helps agents use consistent language quickly. The full canonical source remains `terminology.md`.

## Canonical Source

- Full canonical source: `terminology.md`.
- If this summary conflicts with `terminology.md`, `terminology.md` wins.
- Update this summary when accepted terminology changes affect active agent work.

## High-Priority Terms

- **Project Truth**: accepted current truth about the project.
- **Terminology**: accepted project language and naming boundaries.
- **Active context**: compact operating context used before work.
- **Canonical truth**: durable accepted Wiki truth.
- **Report**: evidence, outcome, validation, risk, and next action; not doctrine unless promoted.
- **Recommendation**: proposed future work; not accepted truth or active scope until reviewed and promoted.
- **Plant Mode**: the GDD-defined 5v5 objective round format (plant/detonate/defuse), the canonical game mode.
- **Match / Round / Half / Halftime**: a match is 6 rounds; roles swap after round 3 (3 rounds per side); each round is 180s + 15s pre-round; match winner has the most rounds won.
- **Impostor**: hidden sabotage role (30% per round); wins if its own team loses; identity revealed at round end; role state server-only.
- **Pre-round / Round / Halftime**: 15s setup no interactions → 180s live round → halftime swap after round 3 of 6.
- **Capture / Jail / Breakout / Rescue**: instant ≤1.5m capture; two Jails; 45s breakout; 3s rescue with speed buff + capture immunity.
- **Channeled interaction**: plant/defuse/breakout/rescue — stationary, cancelled by movement, capture, or disconnect.
- **Plant / Detonation countdown / Defuse**: 5s plant → 45s detonation → 7s defuse; no bomb item; 2 plant sites for v1.0.
- **Sabotage interaction**: Impostor-only, 20s cooldown, contextual (breakout reset near Jail / cancel teammate plant-defuse near site), always fires the audio Tell; own Workspace item.
- **Sprint stamina**: 6s continuous sprint; 1s capacity per 3s not sprinting; no lockout; flagged for playtest tuning.
- **Jail-camping meter**: approved via OQ-008 (6m / 10s grace / 20s fill); own Workspace item with independent validation.
- **OQ status**: OQ-001…OQ-009 resolved (DECIDED) via Open Question Resolutions v1; remaining open item is OQ-010 (3–3 tied match outcome) — do not resolve silently.

## WWG / Vorter / HomeDesk Terms

- **WWG**: Agent Governance layer. Defines truth, policy, standards, evidence, and candidate handoffs.
- **Vorter**: Agent Runtime layer. Owns runtime activation, defer, block, ignore, and reference-only decisions when Vorter is present.
- **HomeDesk**: Agent Runspace/UI layer. Future workspace where agents operate and users control or review work.

## Context and Skill Writer Terms

- **Context file**: tells agents what to know before doing a task.
- **Skill file**: tells agents how to perform a repeatable task.
- **Governance file**: tells agents what rules to follow.
- **Agent instruction**: compact active contract for what agents must load or follow before acting.
- **Output Contract**: expected result, artifact, or reporting shape.
- **Stop Conditions**: conditions that require the agent to pause, stop, ask, or switch workflow.
- **Required Checks**: validation or review steps that must happen before closeout.
- **Registry metadata**: canonical metadata for package-side bundled skills under WWG Option C.
- **Operational body**: the skill file content that explains the repeatable task.

## Runtime Boundary Terms

Preferred runtime and skill handoff wording:

- candidate
- eligible
- recommended
- restricted
- disabled
- reference-only
- handoff
- candidate runtime skill artifact
- activation plan when owned by Vorter
- runtime decision when owned by Vorter

Avoided WWG wording:

- WWG activates runtime skills
- WWG loads runtime skills
- WWG injects runtime skills
- WWG mounts runtime skills
- WWG routes runtime skills
- WWG executes runtime skills

## Governance Terms

- **Drift Guard**: governance contract that prevents implementation, documentation, context, and reports from drifting away from accepted truth.
- **Truth Synchronization**: reconciliation of code, Wiki, Workspace, Governance, tests, generated outputs, reports, README, and changelog.
- **Approval-gated**: work that requires explicit approval before proceeding.
- **Read-only-audit**: evidence gathering without mutation.
- **Ticket-only**: planning output only, used only when explicitly requested.

## Preferred Language

- Use explicit nouns when references may be ambiguous.
- Use canonical role, product, feature, architecture, and safety terms from `terminology.md`.
- Use `Not yet defined` for missing accepted truth.
- Use candidate-only language for Vorter handoffs.

## Avoided / Incorrect Language

- Unapproved synonyms for core project terms (e.g., "imposter", "bomb/spike" for Plant — there is no bomb item).
- Vague references such as `it`, `this`, `that`, or `they` when the referenced object is unclear.
- Production-readiness claims not backed by Project Truth.
- Runtime activation claims owned by Vorter.

## Load Full Terminology When

- A task changes naming, roles, UI copy, code-facing names, reports, tests, or governance language.
- A prompt introduces a synonym.
- Generated context or docs use inconsistent terms.
- This summary is incomplete for the task.

## References

- `terminology.md`
- `project-truth-summary.md`
- `project-truth.md`
- `02-project/glossary.md`
- Root `AGENTS.md`