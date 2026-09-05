# WWG Generate Governance Report

## Summary

Generation completed using safe generated-section and WWG-owned file rules.

## Command

`wwg start . --profile game --agent generic --governance standard --force`

## Target

.

## Source Artifacts Read

- governance/profiles/README.md
- governance/profiles/game/governance-profile.md
- wiki/profiles/README.md
- wiki/profiles/game/README.md
- wiki/profiles/game/governance-additions.md
- wiki/profiles/game/wiki-additions.md
- wiki/profiles/game/workspace-additions.md

## Files Created

- None.

## Files Updated

- governance/README.md
- governance/quality-gates.md
- governance/test-plan.md
- governance/security-review.md
- governance/release-checklist.md
- governance/audit-log.md
- governance/drift-detection.md
- governance/human-approval-matrix.md
- governance/maintenance-review-checklist.md
- governance/canonical-artifact-review.md
- governance/context-drift-detection.md
- governance/public-surface-review.md
- governance/public-discovery-review.md
- governance/regression-guardrail-catalog.md
- governance/operational-readiness-review.md
- governance/truth-conflict-resolution.md
- governance/enforcement-levels.md
- governance/evidence-standards.md

## Files Skipped

- governance/project-readiness-checklist.md - Generated section SELECTED_PROFILE_GATES was not found.
- governance/project-readiness-checklist.md - Generated section APPROVAL_GATED_AREAS was not found.
- governance/project-readiness-checklist.md - Generated section EVIDENCE_STANDARDS_SUMMARY was not found.

## Generated Sections Updated

- governance/README.md#SELECTED_PROFILE_GATES
- governance/quality-gates.md#SELECTED_PROFILE_GATES
- governance/test-plan.md#SELECTED_PROFILE_GATES
- governance/security-review.md#SELECTED_PROFILE_GATES
- governance/release-checklist.md#SELECTED_PROFILE_GATES
- governance/audit-log.md#SELECTED_PROFILE_GATES
- governance/drift-detection.md#SELECTED_PROFILE_GATES
- governance/human-approval-matrix.md#SELECTED_PROFILE_GATES
- governance/maintenance-review-checklist.md#SELECTED_PROFILE_GATES
- governance/canonical-artifact-review.md#SELECTED_PROFILE_GATES
- governance/context-drift-detection.md#SELECTED_PROFILE_GATES
- governance/public-surface-review.md#SELECTED_PROFILE_GATES
- governance/public-discovery-review.md#SELECTED_PROFILE_GATES
- governance/regression-guardrail-catalog.md#SELECTED_PROFILE_GATES
- governance/operational-readiness-review.md#SELECTED_PROFILE_GATES
- governance/truth-conflict-resolution.md#SELECTED_PROFILE_GATES
- governance/enforcement-levels.md#SELECTED_PROFILE_GATES
- governance/evidence-standards.md#SELECTED_PROFILE_GATES

## Principle Review

- Principles reviewed:
  - Source Wiki artifacts and generated agent/governance outputs were checked for principle references.
- Principles updated:
  - None by generation.
- Candidate principle changes:
  - None.
- Principle drift concerns:
  - Review warnings above if principle source artifacts were skipped.

## Conflicts / Warnings

- governance/README.md: Generated section SELECTED_PROFILE_GATES was not found.
- governance/audit-log.md: Generated section SELECTED_PROFILE_GATES was not found.
- governance/canonical-artifact-review.md: Generated section SELECTED_PROFILE_GATES was not found.
- governance/context-drift-detection.md: Generated section SELECTED_PROFILE_GATES was not found.
- governance/drift-detection.md: Generated section SELECTED_PROFILE_GATES was not found.
- governance/enforcement-levels.md: Generated section SELECTED_PROFILE_GATES was not found.
- governance/evidence-standards.md: Generated section SELECTED_PROFILE_GATES was not found.
- governance/human-approval-matrix.md: Generated section SELECTED_PROFILE_GATES was not found.
- governance/maintenance-review-checklist.md: Generated section SELECTED_PROFILE_GATES was not found.
- governance/operational-readiness-review.md: Generated section SELECTED_PROFILE_GATES was not found.
- governance/project-readiness-checklist.md: Generated section APPROVAL_GATED_AREAS was not found.
- governance/project-readiness-checklist.md: Generated section EVIDENCE_STANDARDS_SUMMARY was not found.
- governance/project-readiness-checklist.md: Generated section SELECTED_PROFILE_GATES was not found.
- governance/public-discovery-review.md: Generated section SELECTED_PROFILE_GATES was not found.
- governance/public-surface-review.md: Generated section SELECTED_PROFILE_GATES was not found.
- governance/quality-gates.md: Generated section SELECTED_PROFILE_GATES was not found.
- governance/regression-guardrail-catalog.md: Generated section SELECTED_PROFILE_GATES was not found.
- governance/release-checklist.md: Generated section SELECTED_PROFILE_GATES was not found.
- governance/security-review.md: Generated section SELECTED_PROFILE_GATES was not found.
- governance/test-plan.md: Generated section SELECTED_PROFILE_GATES was not found.
- governance/truth-conflict-resolution.md: Generated section SELECTED_PROFILE_GATES was not found.


## Validation Performed

- Verified wwg.project.yaml exists and can be parsed.
- Compiled generation inputs deterministically without LLM calls.
- Applied generated-section safety rules.
- Recorded markdown and JSON generation reports.

## WWG Truth Synchronization

- Task mode: generation
- New truth detected: NO
- Wiki updated: NO / N/A
- Workspace updated: NO / N/A
- Governance review completed: YES
- Drift status: NONE / LOW / MEDIUM / HIGH
- Canonical files changed:
  - None by deterministic generation unless listed above.
- Implementation discoveries synced:
  - None.
- Remaining stale context:
  - Review skipped files and missing canonical sources above.

## Next Steps

- Review skipped files before using `--force`.
- Edit canonical Wiki truth before refreshing generated Workspace or Governance outputs.
