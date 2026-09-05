# wiki-lint Skill

## Purpose

Check Wiki pages for missing sections, stale links, contradictions, and empty placeholders.

## Trigger

- Use during Wiki review, maintenance, validation, or truth synchronization work.
- Use when a Wiki page may contain stale context, missing references, contradictions, or empty placeholders.
- Do not use to rewrite compiled truth before evidence is gathered.

## Inputs

- Wiki folder path.
- Relevant Project Truth and Terminology files.
- Maintenance or validation findings.
- Source evidence when claims need confirmation.

## Preconditions

- The Wiki location and expected page family are known.
- Lint findings can be reported before broad rewriting.
- Canonical truth is preserved unless a verified update is approved.

## Steps

1. Inspect relevant Wiki pages and source evidence.
2. Check required sections, links, references, terminology, and placeholders.
3. Compare claims against Project Truth and Terminology.
4. Classify findings by severity and affected page.
5. Apply small safe fixes only when the task authorizes editing.
6. Summarize assumptions and unresolved questions.

## Required Checks

- Confirm findings are evidence-backed.
- Confirm contradictions are reported rather than silently resolved.
- Confirm empty placeholders are removed or converted into explicit unknowns only when safe.

## Stop Conditions

- Stop when a finding would require rewriting canonical truth without approval.
- Stop when source evidence is missing for an important claim.
- Stop when the lint run reveals a broader truth conflict that needs a report-first decision.

## Output Contract

- Lint findings and suggested fixes.
- Files reviewed and files changed when edits are authorized.
- Remaining risks, unresolved questions, and next action.

## References

- `.wwg/workspace/skill-format.md`
- `.wwg/workspace/skills/skill-spec-template.md`
