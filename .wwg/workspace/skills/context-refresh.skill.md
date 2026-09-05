# context-refresh Skill

## Purpose

Regenerate Workspace context from current Wiki truth.

## Trigger

- Use when canonical Wiki truth changed and active Workspace context should reflect the current state.
- Use when generated or compiled context is stale, missing, or unclear.
- Do not use as a substitute for deciding new project truth.

## Inputs

- Relevant Wiki pages.
- Selected agent or implementation-agent expectations.
- Selected profiles.
- Existing Workspace context files.
- Source evidence and current task notes.

## Preconditions

- Canonical Wiki truth has been reviewed.
- Missing or uncertain facts are marked as unknown instead of invented.
- Layer ownership is clear: Wiki stores truth, Workspace stores operating context, Governance stores checks.

## Steps

1. Inspect relevant Wiki pages and source evidence.
2. Identify the smallest coherent context update.
3. Apply the update in the correct Workspace location.
4. Link context back to source Wiki pages rather than copying long truth.
5. Update indexes, logs, or reports when meaningful context changed.
6. Summarize assumptions and unresolved questions.

## Required Checks

- Confirm updated context reflects current Wiki truth.
- Confirm no unverified facts were added.
- Confirm generated or compiled context did not become the only source of truth.

## Stop Conditions

- Stop when canonical Wiki truth is missing, contradictory, or unapproved.
- Stop when the task would turn context into a timeline dump or report archive.
- Stop when the change requires approval-gated truth updates before context can be refreshed.

## Output Contract

- Updated context files or a clear no-change decision.
- Refresh report or task note listing sources, assumptions, unresolved questions, and files changed.
- Index or log updates when the repository convention requires them.

## References

- `.wwg/workspace/skill-format.md`
- `.wwg/workspace/skills/skill-spec-template.md`
