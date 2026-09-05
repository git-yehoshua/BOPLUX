# WWG Agent Handoff

## Purpose

This file is the generic WWG Agent Handoff for a chosen implementation agent working from WWG project truth. The Codex compatibility artifact is written separately at `.wwg/reports/wwg-handoff-to-codex.md`.

This handoff applies to any implementation agent. `.wwg/reports/wwg-handoff-to-codex.md` remains a Codex compatibility artifact while Codex-specific flows require it.

Shared handoff logic is owned by `src/core/agent-handoff.ts`; `src/core/codex-handoff.ts` is a compatibility wrapper.

## Required Read Order

1. `.wwg/wiki/project-truth.md`
2. `.wwg/wiki/terminology.md`
3. `.wwg/wiki/principles/README.md`
4. Relevant `.wwg/wiki/principles/*.md` files when the task may affect durable reasoning
5. `.wwg/workspace/current-task.md`
6. `.wwg/workspace/context/project-context.md`
7. `.wwg/governance/drift-guard.md`
8. `.wwg/governance/quality-gates.md`
9. Root `AGENTS.md`
10. Relevant source, tests, templates, and docs

## Summary

Your WWG project is ready for a chosen implementation agent to continue from project truth, Workspace context, and Governance checks.

## Scenario

Validation Failure Handoff

## Current State

- The latest WWG validation report indicates blockers or required follow-up.
- PASS Required WWG directories exist - 1 finding(s)
- LOW runtime-skill-candidate-unknown-skill (.wwg/reports/runtime-skill-candidates.json): evidence=confirmed Candidate-only Runtime Skill Candidate id is unknown to the loaded Skill Registry. core.change-classifier is not present in the loaded Skill Registry. This remains warning-level while the record is candidate-only: WWG did not activate the skill, and Vorter owns any future runtime activation decision. Recommendation: Keep unknown IDs candidate-only unless they are intentionally added to the local registry; fail only if an unknown candidate claims active, approved, loaded, routed, or executed status.
- LOW runtime-skill-candidate-unknown-skill (.wwg/reports/runtime-skill-candidates.json): evidence=confirmed Candidate-only Runtime Skill Candidate id is unknown to the loaded Skill Registry. core.context-skill-maintenance is not present in the loaded Skill Registry. This remains warning-level while the record is candidate-only: WWG did not activate the skill, and Vorter owns any future runtime activation decision. Recommendation: Keep unknown IDs candidate-only unless they are intentionally added to the local registry; fail only if an unknown candidate claims active, approved, loaded, routed, or executed status.
- LOW runtime-skill-candidate-unknown-skill (.wwg/reports/runtime-skill-candidates.json): evidence=confirmed Candidate-only Runtime Skill Candidate id is unknown to the loaded Skill Registry. core.drift-detector is not present in the loaded Skill Registry. This remains warning-level while the record is candidate-only: WWG did not activate the skill, and Vorter owns any future runtime activation decision. Recommendation: Keep unknown IDs candidate-only unless they are intentionally added to the local registry; fail only if an unknown candidate claims active, approved, loaded, routed, or executed status.
- LOW runtime-skill-candidate-unknown-skill (.wwg/reports/runtime-skill-candidates.json): evidence=confirmed Candidate-only Runtime Skill Candidate id is unknown to the loaded Skill Registry. core.regression-guardrail-maintenance is not present in the loaded Skill Registry. This remains warning-level while the record is candidate-only: WWG did not activate the skill, and Vorter owns any future runtime activation decision. Recommendation: Keep unknown IDs candidate-only unless they are intentionally added to the local registry; fail only if an unknown candidate claims active, approved, loaded, routed, or executed status.
- Candidate counts: total 2, high-risk 0, requires-approval 0, truth 0, recommendations 1, current-task 1, warnings 0.

## Next Actions

1. Fix top validation blockers before implementation or release work.
2. Prioritize generated report contract findings, truth-sync field failures, then missing test/regression findings.
3. Regenerate or repair WWG-owned generated reports through the responsible WWG command.
4. Rerun validation and test-check after each focused fix.

## Commands To Run

```bash
wwg doctor --apply
wwg validate
wwg test-check --format plain
wwg reconcile --format plain --json
# Run repo-specific validation from package.json, for example:
npm run build
npm test
npm run lint
```

## Candidate / Truth Review

- Candidate counts: total 2, high-risk 0, requires-approval 0, truth 0, recommendations 1, current-task 1, warnings 0.
- If validation reports truth-sync field failures, update the report generator or explicit report classification instead of weakening validation broadly.
- Do not rewrite `.wwg/wiki` semantic truth to mask generated-report contract failures.
- Review reconciliation candidates only after validation blockers are understood.

## Boundaries

- Do not approve, apply, or promote high-risk truth candidates automatically.
- Do not rewrite `.wwg/wiki` semantic truth during a governance-only pass.
- Do not treat Vorter runtime evidence as accepted WWG truth.
- Do not mutate `.vorter` unless the task is explicitly Vorter-owned.
- Do not mutate application source files during report-only, validation-only, upgrade-review, or governance-only passes.
- Reports and candidates are evidence; `.wwg/wiki` remains canonical truth.

## Commit Readiness

- Do not commit release or upgrade completion while `wwg validate` fails.
- `wwg validate` passes or has only documented acceptable warnings.
- `wwg test-check` has no unexplained blocker.
- Repo-specific build, tests, lint, smoke, or package checks pass.
- Boundary diff is reviewed for `.wwg/wiki`, `.vorter`, generated reports, and source changes.
- High-risk candidates are reviewed but not automatically applied.

## Stop Conditions

- `wwg validate` fails.
- High-risk truth candidates exist and have not been reviewed.
- Unexpected `.wwg/wiki` changes appear.
- Unexpected `.vorter` changes appear.
- Source code changes appear during a governance-only pass.
- Package dry-run is unsafe.
- Tests fail.

## Report Location

- .wwg/reports/wwg-validate-report.md

## WWG Readiness

Must Have items are required for agent-safe operation. Other Features are recommendations, not automatic authorization to expand task scope.

### Must Have

- [x] WWG workspace present (present)
  - Evidence: `.wwg`
- [x] Project config present (present)
  - Evidence: `.wwg/config/wwg.project.yaml`
- [x] Project Truth present (present)
  - Evidence: `.wwg/wiki/project-truth.md`
- [x] Terminology present (present)
  - Evidence: `.wwg/wiki/terminology.md`
- [x] Principles README present (present)
  - Evidence: `.wwg/wiki/principles/README.md`
- [x] Workspace current task present (present)
  - Evidence: `.wwg/workspace/current-task.md`
- [x] Governance drift guard present (present)
  - Evidence: `.wwg/governance/drift-guard.md`
- [x] Recommendation Registry present (present)
  - Evidence: `.wwg/governance/recommendation-registry.md`
- [x] Reports directory present (present)
  - Evidence: `.wwg/reports`
- [x] Root AGENTS.md present (present)
  - Evidence: `AGENTS.md`
- [x] Test enforcement governance present (present)
  - Evidence: `.wwg/governance/test-enforcement.md`
- [x] Regression guardrail governance present (present)
  - Evidence: `.wwg/governance/regression-guardrail-catalog.md`
- [x] Validation report present (present)
  - Evidence: `.wwg/reports/wwg-validate-report.md`
- [ ] Audit can run (available)
  - Reason: Run audit when structural or governance confidence matters.
  - CLI support: `wwg audit`
  - Evidence: `.wwg/reports/wwg-audit-report.md`
- [x] Agent handoff present (present)
  - Evidence: `.wwg/reports/wwg-agent-handoff.md`, `.wwg/reports/wwg-handoff-to-codex.md`
- [ ] Adoption regression baseline (not_applicable)
  - Reason: Only required for adopted existing projects.

### Other Features

- None detected.

### Recommended Next

- [ ] Continue from WWG truth and current task (available)
  - Reason: No relevant optional readiness gaps were detected.
  - Agent action: Proceed within the user's requested scope and keep the truth loop synchronized.

Agents should follow Must Have items first. Missing Other Features are not blockers unless the current task depends on them.

## Target Folder

C:\Users\Admin\Documents\BOPLUX

## GitHub Repository

Not published.

## Selected Profiles

- game

## Governed Skill State

- Skill manifest: `.wwg/config/skill-manifest.yaml` (valid/readable)
- Enabled core skills: 6
- Recommended domain skills: 7
- Recommended reference-only skills: creative.story, creative.storytelling, game-design, public.public-surface-update, software.bug-fix
- Creative/Business recommendations: creative.story, creative.storytelling (reference-only; no skill files copied)
- Local project skills: 4
- Disabled skills: 0
- Skill materialization: none 2, reference 6, copied 5, local 0
- Skill policy: manifest present, no policy violations
- Detected domains: business.compliance, creative.story, game-design, software.security
- Legacy copied skills: 5 compatibility-core, 0 compatibility-domain
- Runtime activation: not performed by WWG; future Vorter responsibility.

## Runtime Skill Candidates

WWG generated runtime skill candidates only. WWG did not activate these skills. Vorter is responsible for runtime activation, task-level context loading, tool routing, permissions, and token budgeting. HomeDesk is responsible for user visibility, approval, disabling, and override controls.

- Status: candidate-only contract generated
- Artifact: `.wwg/reports/runtime-skill-candidates.json`
- Activation owner: Vorter
- Candidate count: 13
- Creative/Business candidates: creative.storytelling (reference-only; Vorter activation candidate only)

| Skill | State | Confidence | Activation Status | Reason |
| --- | --- | --- | --- | --- |
| local.context-refresh | local | high | candidate_only | Existing project-local Workspace skill file. |
| local.task-ticket-writer | local | high | candidate_only | Existing project-local Workspace skill file. |
| local.wiki-ingest | local | high | candidate_only | Existing project-local Workspace skill file. |
| local.wiki-lint | local | high | candidate_only | Existing project-local Workspace skill file. |
| core.change-classifier | enabled | high | candidate_only | Core WWG change classification behavior. |
| core.context-skill-maintenance | enabled | high | candidate_only | Core WWG context and skill synchronization behavior. |
| core.drift-detector | enabled | high | candidate_only | Core WWG drift detection behavior. |
| core.regression-guardrail-maintenance | enabled | high | candidate_only | Core WWG regression guardrail behavior. |
| core.task-router | enabled | high | candidate_only | Core WWG task routing behavior. |
| core.truth-loop | enabled | high | candidate_only | Core WWG governance behavior. |
| creative.storytelling | recommended | medium | candidate_only | Story, narrative, lore, campaign, or game profile evidence detected. |
| public.public-surface-update | recommended | high | candidate_only | Public or customer-facing communication evidence suggests this skill may help. |

## Project Summary

- Project: BOPLUX
- Summary: TBD
- Status: initialized

## Key Decisions

- Use Wiki truth as the source of planning and implementation context.
- Use Workspace context, prompts, and skills as generated agent operating material.
- Use Governance checks for validation, release, evidence, and approval gates.
- Keep secrets out of Wiki truth, reports, Workspace, and commits.

## Users and Roles

TBD

## MVP Features

TBD

## Pages / Screens

Track screens and their purpose.
Screen notes should list users, primary actions, states, empty states, errors, and data shown.
For each meaningful screen, capture:
- Primary user and goal
- Main actions
- Data shown
- Loading state
- Empty state

## Architecture and Hosting Preferences

Describe environments and release topology.
The deployment model should capture environments, hosting, configuration, rollout, rollback, and observability.
Deployment work must distinguish local behavior from deployed behavior. "Works locally" is not sufficient proof of architectural correctness.
Runtime configuration must be explicit, validated, and documented. Deployment fixes must not mask authoritative backend defects with client-side workarounds.
Validation should cover config present at runtime, secrets loaded correctly, database connection, migration/schema state, worker/queue flow if touched, cache/projection consistency, startup paths, request-time paths, and normal backend/API flows.

## Design Preferences

Design direction inferred from user answers and visual references.
Generated design reference summary here.

## Sources and References

- .wwg/reports/wwg-sources-report.md
- .wwg/wiki/01-sources/source-index.json
- .wwg/wiki/01-sources/source-index.md

Accessible external-chat files, screenshots, docs, and images should be registered through WWG source intake so they land under `.wwg/wiki/01-sources/raw/uploads/`. If a chat-only reference is not accessible as a file or upload, add a raw source note documenting the missing artifact.

Keep raw originals in `.wwg/wiki/01-sources/raw`; use `.wwg/wiki/01-sources/processed` only for later cleaned extracts or summaries.

## Infrastructure Readiness

Not checked yet.

## Governance Level and Approval Gates

Level: standard. Approval gates should follow AGENTS.md and governance checklists.

## Current Native Structure

- Canonical WWG metadata lives under `.wwg/`: `.wwg/config`, `.wwg/wiki`, `.wwg/workspace`, `.wwg/governance`, and `.wwg/reports`.
- `.wwg/config/wwg.project.yaml` is the canonical native registry.
- Root `wwg.project.yaml` is a legacy compatibility mirror/fallback when present.
- `.wwg/reports/` is canonical for generated WWG reports.
- Root `reports/` may remain for historical, release, package, external-upload, or human-facing reports.
- Config fallback/mirror status: canonical config present; no root fallback detected.

## Truth Loop

Implementation changes must reconcile code, project truth, terminology, principles, Workspace context, Governance checks, templates, tests, generated outputs, and reports when relevant.

## Principle Review

- Principles reviewed:
  - No principle-impacting changes detected.
- Principles updated:
  - None.
- Candidate principle changes:
  - None.
- Principle drift concerns:
  - None.

No principle-impacting changes detected.

## Truth Loop Review

- Project truth updated: N/A
- Terminology updated: N/A
- Principles updated: N/A
- Governance updated: N/A
- Workspace updated: N/A
- Templates/tests updated: N/A
- Reports updated:
  - .wwg/reports/wwg-agent-handoff.md
  - .wwg/reports/wwg-agent-handoff.json
  - .wwg/reports/wwg-handoff-to-codex.md
  - .wwg/reports/wwg-handoff-to-codex.json
  - .wwg/reports/runtime-skill-candidates.json
  - .wwg/reports/runtime-skill-candidates.md

No truth-loop-impacting changes detected.

## Native Structure Review

- `.wwg/config/wwg.project.yaml` present: yes
- `.wwg/reports/` present: yes
- Legacy root metadata folders present: none
- Config fallback/mirror status: canonical config present; no root fallback detected

## Maintenance Awareness

- Maintenance review recommended: no
- Reason: No maintenance review required by current checks.
- Suggested command: N/A

## Recommendation Capture

Review whether this task revealed useful future work outside the approved scope.
If yes, add or update `.wwg/governance/recommendation-registry.md`.
If no, state that no new recommendations were identified.

Recommendations are candidate work only. They are not project truth, active work, or commitments until reviewed and promoted.

## WWG Truth Synchronization

- Task mode: TBD
- New truth detected: YES / NO
- Wiki updated: YES / NO / N/A
- Workspace updated: YES / NO
- Governance review completed: YES / NO
- Drift status: NONE / LOW / MEDIUM / HIGH
- Canonical files changed:
  - TBD
- Implementation discoveries synced:
  - TBD
- Remaining stale context:
  - TBD

Reports cannot override `.wwg/wiki/project-truth.md`. If this handoff or another report conflicts with project truth, update the stale report or leave a drift finding.

## Open Questions

- Missing planning input: .wwg/wiki/11-synthesis/planning-summary.md.

## Generated WWG Files

- .wwg/config/skill-manifest.yaml
- .wwg/config/wwg.project.yaml
- .wwg/governance
- .wwg/governance/drift-guard.md
- .wwg/reports/truth-reconciliation-candidates.json
- .wwg/reports/truth-reconciliation-candidates.md
- .wwg/reports/wwg-generate-governance-report.md
- .wwg/reports/wwg-generate-workspace-report.md
- .wwg/reports/wwg-init-report.json
- .wwg/reports/wwg-init-report.md
- .wwg/reports/wwg-refresh-context-report.md
- .wwg/reports/wwg-refresh-skills-report.md
- .wwg/reports/wwg-sources-report.md
- .wwg/reports/wwg-validate-report.md
- .wwg/wiki
- .wwg/wiki/01-sources/source-index.json
- .wwg/wiki/01-sources/source-index.md
- .wwg/wiki/02-project/project-brief.md
- .wwg/wiki/03-requirements/functional-requirements.md
- .wwg/wiki/05-architecture/deployment-model.md
- .wwg/wiki/07-ux/design-preferences.md
- .wwg/wiki/07-ux/screens.md
- .wwg/wiki/11-synthesis/open-questions.md
- .wwg/wiki/principles/README.md
- .wwg/wiki/project-truth.md
- .wwg/wiki/terminology.md
- .wwg/workspace
- .wwg/workspace/current-task.md
- AGENTS.md

## Missing Inputs

- .wwg/config/intake.answers.yaml
- .wwg/reports/readme-validation.md
- .wwg/reports/wwg-audit-report.md
- .wwg/reports/wwg-doctor-report.md
- .wwg/reports/wwg-infra-check-report.md
- .wwg/reports/wwg-upgrade-history.md
- .wwg/reports/wwg-upgrade-plan.md
- .wwg/reports/wwg-upgrade-report.md
- .wwg/wiki/11-synthesis/planning-summary.md
- intake answers

## Validation Result

- Report: .wwg/reports/wwg-validate-report.md

## Audit Result

- Report: Not found. Run the command before implementation.

## Recommended First Agent Prompt

```txt
Read AGENTS.md and .wwg/reports/wwg-agent-handoff.md. Follow the WWG operating loop, then continue from the WWG plan and begin implementation with your chosen implementation agent.
```

## Implementation Log

Use `.wwg/reports/agent-implementation-log.md` for implementation notes across agents. Treat `.wwg/reports/codex-implementation-log.md` as a legacy name and prefer renaming or avoiding it in new work.

## Suggested First Implementation Tasks

```txt id="starter-tasks"
1. Read WWG project context and confirm assumptions.
2. Review open questions before building.
3. Create the initial app architecture plan.
4. Implement the first MVP page/screen.
5. Add tests and update WWG context after implementation.
```

## Next Steps

- Open VSCode.
- File -> Open Folder.
- Select: C:\Users\Admin\Documents\BOPLUX.
- Start your chosen coding agent.
- Use the recommended first prompt above.
