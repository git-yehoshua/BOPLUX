# Wiki Layer Agent Instructions

## Purpose

Guide agents that maintain generated-project Wiki truth.

## Required Reading

Read these files before changing durable project truth:

1. `project-truth-summary.md` when present.
2. `terminology-summary.md` when present.
3. `project-truth.md`.
4. `terminology.md`.
5. `principles/README.md` and relevant principle files when durable reasoning may change.
6. `12-maintenance/context-maintenance-matrix.md`.
7. Root `AGENTS.md`.

## Operating Rules

### Must

- Preserve user-defined Project Truth.
- Keep raw sources immutable unless the source file is explicitly being corrected.
- Keep compiled Wiki pages current when accepted truth changes.
- Keep contradictions visible until resolved.
- Use `12-maintenance/context-maintenance-matrix.md` to route meaningful changes.
- Update `index.md` and `log.md` when adding meaningful Wiki files.
- Use `12-maintenance/maintenance-contract.md` in reports for meaningful changes.
- Treat runtime suspects as hypotheses until evidence confirms them.

### Must Not

- Silently overwrite `project-truth.md`, `terminology.md`, principle files, or source evidence.
- Promote temporary reports, generated context, or investigation notes into canonical truth without acceptance.
- Merge upstream-maintainer-only truth into generated-project defaults.
- Claim WWG activates, loads, injects, mounts, routes, or executes runtime skills.

### Prefer

- Current-state truth over timeline history.
- Dedicated canonical pages for recurring domain, UX, architecture, and operations detail.
- Explicit nouns over vague pronouns when references may be ambiguous.
- Candidate principle notes or reports when a principle change is uncertain.

### Avoid

- Per-feature `AGENTS.md` files for cross-cutting concerns.
- Duplicating long Project Truth or Terminology in active context files.
- Phase/pass implementation history in stable Wiki pages.
- Synonym drift away from canonical terminology.

## Safety Gates

- Stop and report when a requested change conflicts with Project Truth or safety boundaries.
- Pause for approval before changing production configuration, permissions, security posture, billing, public notices, data deletion, migrations, or irreversible behavior.
- Keep `.vorter/` untouched from WWG work.
- Preserve candidate-only language for Vorter handoffs.

## Handoff / Reporting Rules

- Record changed Wiki pages, index/log updates, source evidence, unresolved assumptions, and validation results.
- State whether Project Truth, Terminology, Principles, Workspace context, Governance, README, and CHANGELOG were evaluated.
- Record future work as recommendations instead of silently expanding scope.

## References

- `project-truth-summary.md`
- `terminology-summary.md`
- `project-truth.md`
- `terminology.md`
- `principles/README.md`
- `12-maintenance/context-maintenance-matrix.md`
- `12-maintenance/maintenance-contract.md`
- Root `AGENTS.md`
