# Project Master Context

## Purpose

Provide a compact active overview and routing map for generated-project agents and developers.

## Scope

This file is active context, not full canonical truth. It should point agents to the right canonical sources before work begins.

Use this file for global orientation. Use dedicated Wiki pages, Project Truth, Terminology, and Governance for durable detail.

## Current State

- Project-specific facts are not defined until the generated project owner fills Wiki truth.
- `project-truth-summary.md` and `terminology-summary.md` are compact loading surfaces when present.
- `project-truth.md` and `terminology.md` remain the full canonical sources.
- Detailed domain, UX, architecture, operations, requirements, and decisions live in dedicated Wiki folders.
- Implementation reports and temporary notes are reference history until promoted.

## Canonical Terms

- **Project Truth**: accepted current product truth in `project-truth.md`.
- **Terminology**: accepted canonical language in `terminology.md`.
- **Active context**: compact operating context used before work.
- **Canonical truth**: durable Wiki truth that wins over generated notes, reports, and stale docs.
- **Workspace**: agent operating context compiled from Wiki truth.
- **Governance**: checks, gates, evidence rules, validation, and drift control.

## Decisions

- Agents should read this file for routing, then load the relevant canonical source.
- Agents should not overload this file with every implementation detail.
- Dedicated canonical context files should hold deep recurring domain detail.
- Dated incidents and temporary reports should stay in reports unless promoted.
- When canonical behavior changes, update the dedicated canonical file first.

## Constraints

### Must

- Link to canonical truth instead of duplicating long truth.
- Keep this file current-state oriented.
- Use the maintenance matrix to decide which dedicated context files need review.
- Preserve Wiki, Workspace, and Governance boundaries.

### Must Not

- Treat this file as a timeline dump.
- Import upstream-maintainer-only truth into generated-project defaults.
- Let generated context override Project Truth or Terminology.

### Prefer

- Compact summaries.
- Explicit placeholders such as `Not yet defined` until the project owner supplies truth.
- Dedicated files for architecture, domain, UX, operations, and validation detail.

### Avoid

- Phase/pass history.
- Long doctrine.
- Ambiguous pronouns.
- Duplicate truth.

## References

- `../project-truth-summary.md`
- `../terminology-summary.md`
- `../project-truth.md`
- `../terminology.md`
- `../principles/README.md`
- `canonical-context-policy.md`
- `runtime-context.md`
- `public-discovery-context.md`
- `codex-context.md`
- `claude-context.md`
- `cursor-context.md`
- `../12-maintenance/context-maintenance-matrix.md`
