# WWG Generate Workspace Report

## Summary

Generation completed using safe generated-section and WWG-owned file rules.

## Command

`wwg start . --profile game --agent generic --governance standard --force`

## Target

.

## Source Artifacts Read

- wiki/02-project/README.md
- wiki/02-project/agent-team-governance.md
- wiki/02-project/business-model.md
- wiki/02-project/glossary.md
- wiki/02-project/product-vision.md
- wiki/02-project/project-brief.md
- wiki/02-project/success-metrics.md
- wiki/02-project/target-users.md
- wiki/03-requirements/README.md
- wiki/03-requirements/acceptance-criteria.md
- wiki/03-requirements/constraints.md
- wiki/03-requirements/functional-requirements.md
- wiki/03-requirements/non-functional-requirements.md
- wiki/03-requirements/user-stories.md
- wiki/05-architecture/README.md
- wiki/05-architecture/api-map.md
- wiki/05-architecture/data-model.md
- wiki/05-architecture/deployment-model.md
- wiki/05-architecture/integration-map.md
- wiki/05-architecture/security-model.md
- wiki/05-architecture/system-overview.md
- wiki/06-domain/README.md
- wiki/06-domain/edge-cases.md
- wiki/06-domain/entities.md
- wiki/06-domain/rules.md
- wiki/06-domain/workflows.md
- wiki/07-ux/README.md
- wiki/07-ux/content-guidelines.md
- wiki/07-ux/design-preferences.md
- wiki/07-ux/design-principles.md
- wiki/07-ux/reference-screenshots.md
- wiki/07-ux/screens.md
- wiki/07-ux/user-journeys.md
- wiki/08-operations/README.md
- wiki/08-operations/incident-log.md
- wiki/08-operations/known-issues.md
- wiki/08-operations/monitoring.md
- wiki/08-operations/operations-report-template.md
- wiki/08-operations/public-discovery.md
- wiki/08-operations/public-surface-updates.md
- wiki/08-operations/qa-checklists.md
- wiki/08-operations/runbooks.md
- wiki/08-operations/signoff-learnings.md
- wiki/09-agent-context/README.md
- wiki/09-agent-context/canonical-context-policy.md
- wiki/09-agent-context/claude-context.md
- wiki/09-agent-context/codex-context.md
- wiki/09-agent-context/cursor-context.md
- wiki/09-agent-context/project-master-context.md
- wiki/09-agent-context/public-discovery-context.md
- wiki/09-agent-context/reusable-prompts.md
- wiki/09-agent-context/runtime-context.md
- wiki/12-maintenance/README.md
- wiki/12-maintenance/change-classification.md
- wiki/12-maintenance/context-maintenance-matrix.md
- wiki/12-maintenance/drift-policy.md
- wiki/12-maintenance/maintenance-contract.md
- wiki/index.md
- wiki/principles/README.md
- wiki/principles/accessibility-principles.md
- wiki/principles/ai-agent-interface-principles.md
- wiki/principles/changelog-product-memory-principle.md
- wiki/principles/readme-front-door-principle.md
- wiki/principles/ui-ux-simplicity-principles.md
- wiki/profiles/README.md
- wiki/profiles/game/README.md
- wiki/profiles/game/governance-additions.md
- wiki/profiles/game/wiki-additions.md
- wiki/profiles/game/workspace-additions.md

## Files Created

- workspace/skills/context-refresh.skill.md
- workspace/skills/task-ticket-writer.skill.md
- workspace/skills/wiki-ingest.skill.md
- workspace/skills/wiki-lint.skill.md
- workspace/skills/skill-index.md

## Files Updated

- workspace/context/project-context.md
- workspace/context/architecture-context.md
- workspace/context/domain-context.md
- workspace/context/ux-context.md
- workspace/context/governance-context.md
- workspace/context/context-maintenance-matrix.md
- workspace/AGENTS.md
- AGENTS.md
- AGENTS.md
- workspace/skills/README.md
- .wwg/config/skill-manifest.yaml

## Files Skipped

- None.

## Generated Sections Updated

- workspace/context/project-context.md#COMPILED_CONTEXT
- workspace/context/architecture-context.md#COMPILED_CONTEXT
- workspace/context/domain-context.md#COMPILED_CONTEXT
- workspace/context/ux-context.md#COMPILED_CONTEXT
- workspace/context/governance-context.md#COMPILED_CONTEXT
- workspace/context/context-maintenance-matrix.md#COMPILED_CONTEXT
- workspace/AGENTS.md#PROJECT_CONTEXT
- AGENTS.md#PROJECT_CONTEXT
- AGENTS.md#MAINTENANCE_CONTRACT
- workspace/skills/README.md#SKILL_INDEX

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

- .wwg/config/skill-manifest.yaml: Skill Manifest records project skill state only; recommended/reference-only skills are not runtime-active.
- workspace/AGENTS.md: Generated section PROJECT_CONTEXT was not found.
- workspace/context/architecture-context.md: Generated section COMPILED_CONTEXT was not found.
- workspace/context/context-maintenance-matrix.md: Generated section COMPILED_CONTEXT was not found.
- workspace/context/domain-context.md: Generated section COMPILED_CONTEXT was not found.
- workspace/context/governance-context.md: Generated section COMPILED_CONTEXT was not found.
- workspace/context/project-context.md: Generated section COMPILED_CONTEXT was not found.
- workspace/context/ux-context.md: Generated section COMPILED_CONTEXT was not found.
- workspace/skills/README.md: Generated section SKILL_INDEX was not found.

## Governed Skill Copy Plan

Governed skill copy plan:
- Will copy 5 core/compatibility-core skills for new projects.
- Will reference 6 compatibility-domain skills instead of copying them for new projects.
- Existing projects will preserve copied compatibility-domain files.
- Cleanup runs only when `wwg maintain --apply-skill-cleanup` is explicitly requested.
- Recommended/reference-only skills are not runtime-active skills.
- Preserved copied compatibility-domain skills detected for this project: none.


## Validation Performed

- Verified wwg.project.yaml exists and can be parsed.
- Compiled generation inputs deterministically without LLM calls.
- Applied generated-section safety rules.
- Recorded markdown and JSON generation reports.
- Generated project-local Skill Manifest from profile recommendations, registry metadata, local evidence, and governed compatibility copy policy without activating skills.

## WWG Truth Synchronization

- Task mode: generation
- New truth detected: NO
- Wiki updated: NO / N/A
- Workspace updated: YES
- Governance review completed: NO / N/A
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
