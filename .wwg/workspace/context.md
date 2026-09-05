# Workspace Context Overview

## Purpose

Define the reusable shape for generated-project Workspace context.

## Scope

Use this file when assembling agent-ready project instructions from Wiki truth and Governance checks.

## Current State

- Active context files should stay compact and current-state oriented.
- Canonical truth belongs in `.wwg/wiki/`.
- Validation and enforcement rules belong in `.wwg/governance/`.
- Task-local state belongs in `.wwg/workspace/current-task.md`.

## Canonical Terms

- Wiki: truth.
- Workspace: active agent operating context.
- Governance: checks and enforcement.
- Active context: compact context used before work.
- Canonical truth: durable accepted truth that wins over generated notes and stale docs.

## Decisions

- Context files should follow the Context File Contract.
- Context should link to full canonical sources instead of duplicating long truth.
- History belongs in reports, changelog, roadmap, or dedicated history files.

## Constraints

### Must

- Include purpose, scope, current state, canonical terms, decisions, constraints, and references when creating durable context.
- Ground guidance in Wiki truth and Governance checks.
- Mark unavailable facts as `Not yet defined` or route them to open questions.

### Must Not

- Invent project truth.
- Hide procedures inside long prose.
- Treat context as a replacement for Governance.

### Prefer

- Bullets, contracts, examples, and explicit references.
- Short context files that load quickly.

### Avoid

- Timeline dumps.
- Ambiguous references.
- Duplicate sources of truth.

## References

- `.wwg/wiki/project-truth.md`
- `.wwg/wiki/terminology.md`
- `.wwg/wiki/09-agent-context/project-master-context.md`
- `.wwg/governance/drift-guard.md`
- `.wwg/workspace/current-task.md`
