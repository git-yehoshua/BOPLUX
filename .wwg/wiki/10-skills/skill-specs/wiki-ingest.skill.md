# wiki-ingest Skill

## Purpose

Convert raw notes and sources into filed Wiki entries while preserving evidence.

## Trigger

- Use when raw sources, notes, questions, or user-provided evidence should become Wiki truth candidates.
- Use when project knowledge needs filing, synthesis, or uncertainty labeling.
- Do not use to fabricate missing facts or silently promote unsupported claims.

## Inputs

- Raw sources.
- Inbox notes.
- Project questions.
- Existing relevant Wiki pages.
- Evidence paths, dates, owners, or source labels when available.

## Preconditions

- Source material is available for review.
- Sensitive or secret material is excluded or handled under Governance rules.
- Unknown, unverified, or conflicting facts can be marked clearly.

## Steps

1. Inspect raw sources and relevant Wiki pages.
2. Identify the smallest coherent Wiki update.
3. Preserve raw evidence links or source paths.
4. File current truth, open questions, assumptions, and conflicts separately.
5. Update indexes, logs, or reports as needed.
6. Summarize assumptions and unresolved questions.

## Required Checks

- Confirm raw evidence is preserved or referenced.
- Confirm uncertainty is labeled.
- Confirm no missing facts were invented.
- Confirm layer boundaries remain intact.

## Stop Conditions

- Stop when source material contains secrets, credentials, or sensitive data that should not enter Wiki.
- Stop when evidence conflicts with canonical truth and no owner decision exists.
- Stop when the task requires approval before a claim becomes accepted truth.

## Output Contract

- Processed source notes or updated Wiki pages.
- Log, index, or report entries when required.
- Open questions and assumptions separated from accepted truth.

## References

- `.wwg/workspace/skill-format.md`
- `.wwg/workspace/skills/skill-spec-template.md`
