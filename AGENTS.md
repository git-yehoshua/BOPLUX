# Generated Project Agent Guide

This root agent guide was created by WWG CLI. Human-written guidance may be added outside generated sections.

## Purpose

Provide the active operating contract for agents working in this generated WWG project.

## Project Context

<!-- WWG_GENERATED:PROJECT_CONTEXT:START -->
- Project: BOPLUX
- Slug: boplux
- Status: initialized
- Primary agent: generic
- Governance level: standard
- Wiki root: .wwg/wiki
- Workspace root: .wwg/workspace
- Governance root: .wwg/governance
<!-- WWG_GENERATED:PROJECT_CONTEXT:END -->

## Selected Profiles

<!-- WWG_GENERATED:SELECTED_PROFILES:START -->
- game
<!-- WWG_GENERATED:SELECTED_PROFILES:END -->

## WWG Layer Boundaries

Wiki is truth. It stores evidence, compiled project knowledge, decisions, requirements, architecture, domain rules, UX facts, operations knowledge, and synthesis.

Workspace is the agent operating system. It converts wiki truth into context files, prompts, skills, task templates, and agent-specific instructions.

Governance is enforcement. It defines validation, QA, release gates, audit trails, drift detection, security review, and human approval points.

## WWG Agent Operating Contract

Developers may prompt naturally. Agents must execute structurally.

WWG is not only a folder structure. WWG is the project truth, active workspace, governance, and learning loop for this repository.

## Required Reading

Use compact summaries first when present, then load full canonical sources when the task needs detail, conflict resolution, or durable behavior changes.

## Required WWG Reading Order

Before modifying code, always read in this order when the files exist:

1. `.wwg/wiki/project-truth-summary.md`
2. `.wwg/wiki/terminology-summary.md`
3. `.wwg/wiki/project-truth.md`
4. `.wwg/wiki/terminology.md`
5. `.wwg/wiki/principles/README.md`
6. Relevant `.wwg/wiki/principles/*.md` files when the task may affect durable reasoning
7. `.wwg/workspace/current-task.md`
8. `.wwg/governance/drift-guard.md`
9. `README.md`
10. Relevant source files

If these files exist, do not skip them. Treat `.wwg/wiki/project-truth.md` and `.wwg/wiki/terminology.md` as the full canonical sources. If lower-priority files conflict with them, preserve canonical truth and update stale docs only when appropriate.

## WWG Readiness

Before changing files, check WWG Readiness through `wwg status`, the latest agent handoff, or the current maintain/audit report.

- Must Have items are required for agent-safe operation.
- Other Features are recommendations, not automatic authorization to expand scope.
- Missing Other Features are not blockers unless the current task depends on them.
- Use CLI support commands when helpful, but for README, changelog, regression, infrastructure planning, migration, or publishing work, prepare handoff/review before finalizing judgment-heavy content.
- Do not publish, migrate, deploy, delete data, or change production/security posture without explicit approval.

## Principle Management

Principles live in `.wwg/wiki/principles/`.

Principles are durable, high-friction mutable guidance documents that explain why the project is designed a certain way and how agents should reason about future work.

Project Truth tells agents what is true. Principles tell agents how to think. Governance tells agents what to check. Workspace tells agents what to do now.

Before making changes that affect product architecture, naming, positioning, agent behavior, governance, project structure, UX philosophy, or long-term design direction, review relevant principle files.

Explicit principle updates are required when the user says something like:

- "This is a principle."
- "Add this to our guiding principles."
- "Save this as design doctrine."
- "This should guide future architecture."
- "This is how agents should think about the project."
- "This should be maintained going forward."

Implicit principle review is required when a task affects durable reasoning, such as changing product architecture, naming or terminology, major system relationships, governance behavior, agent behavior, positioning, project structure, or cross-project reusable rules.

Agents must not casually rewrite active principles for one-off implementation details, bug fixes, temporary experiments, or ambiguous user comments.

If a possible principle change is uncertain, record it as a candidate principle or mention it in a handoff/report instead of modifying an active principle directly.

## Task Mode Classification

Before meaningful implementation, classify the task as one of: copy-only, docs-only, meaningful feature, bug fix, regression repair, high-risk, non-software, or mixed. Also record whether delivery is AI-agent, traditional, or hybrid.

If the request contradicts Project Truth or touches high-risk areas, pause and plan before implementation. High-risk areas include payment, auth, authorization, security, persistence, database or user data, production deployment, destructive or irreversible actions, and regulated or compliance-sensitive behavior.

## Safety Gates

- Stop when Project Truth conflicts with the requested change.
- Pause for approval before production, compliance, billing, permissions, security, public notices, data deletion, migrations, or irreversible operations.
- Do not mutate `.vorter/` from WWG work.
- Do not claim WWG activates, loads, injects, mounts, routes, or executes runtime skills.
- Use candidate-only language for Vorter handoffs.

## Wiki-First Flow

Use for new features, architecture changes, product decisions, user role changes, terminology changes, UX standards, rules/policy changes, and uploaded files or images that introduce new requirements.

1. Read required WWG context.
2. Identify any new canonical truth introduced by the prompt or uploaded assets.
3. Update the relevant Wiki files before code when possible.
4. Update `.wwg/workspace/current-task.md`.
5. Implement the change.
6. Run checks.
7. Run governance review using truth capture and drift guard.
8. Sync implementation discoveries back into Wiki.
9. Close out only when code, wiki, workspace, governance, and reports agree.

## Code-Discovery Flow

Use for bugs, regressions, small fixes, production incidents, and cases where truth is discovered in existing code or runtime behavior.

1. Read project truth for orientation.
2. Investigate the code and failing behavior.
3. Fix minimally.
4. Capture discovered truth in Wiki.
5. Update `.wwg/workspace/current-task.md`.
6. Run checks.
7. Run governance review.
8. Close out only when implementation and context are synchronized.

## Truth Synchronization Rule

Code changes may reveal truth, but they must not become the only place truth lives. Update Wiki when a task introduces or discovers product identity, roles, terminology, feature scope, architecture, data model, payment/auth/security behavior, UX standards, operational rules, testing/release requirements, or production-readiness boundaries.

Project Truth must not be silently overwritten. Requirement evolution is allowed when documented and accepted. If terminology changes, update terminology docs. If accepted product behavior changes, update Project Truth or requirements docs. Governance changes should be merged carefully rather than overwritten.

## Non-Negotiable Close-Out Rule

A task is not complete if relevant canonical truth remains only in code, `project-truth.md` still has relevant unresolved `TBD`s, `current-task.md` does not describe the completed task, terminology changed without `terminology.md`, product scope changed without `project-truth.md`, mock/demo behavior is undocumented, governance drift review was skipped, meaningful changelog status was not evaluated, or generated reports contradict current canonical truth.

## Test Enforcement

Meaningful feature behavior requires meaningful tests. Bug fixes require regression tests whenever practical. Tests should verify behavior, not only file existence, static structure, or build smoke. Removed or weakened tests must be flagged. If no tests are added for meaningful work, document why.

Non-software work may use decision logs, manual verification, approval checklists, or Project Truth updates when software tests are not the right verification form. Copy-only changes should not be over-governed.

## Recommendation Capture

Before closing out meaningful work, check whether the task revealed future work outside the approved scope.

Examples: missing regression coverage, missing wiki truth, future feature, documentation gap, governance gap, security/compliance concern, UX improvement, technical debt, repeated manual work that should be automated, unclear ownership or decision history.

If yes, add or update an entry in `.wwg/governance/recommendation-registry.md`; keep it concise and evidence-based; leave status as `Proposed` unless explicitly instructed otherwise; do not implement it unless it belongs to the current task.

If no, state in closeout: "No new recommendations were identified."

Recommendations are candidate work only. They are not accepted project truth, active Workspace tasks, or commitments until reviewed and promoted.

Closeout must answer: Did this work reveal useful future work outside the current task scope? If yes, was a recommendation added or updated in `.wwg/governance/recommendation-registry.md`? If no, state: "No new recommendations were identified."

## Changelog Governance

`CHANGELOG.md` is project memory and release subtext. It should record meaningful changes in non-technical, outcome-based language that project owners, users, developers, and future agents can understand.

Before closing any task, check whether the work introduced a meaningful change. If yes, update `CHANGELOG.md` or run/report `wwg changelog update --target . --apply`. Do not automatically apply minor or major version bumps; recommend them only when user-visible capability, workflow, adoption/generation behavior, governance capability, breaking behavior, migration, or operating-model changes justify it.

Required closeout line:

```md
Changelog:
- Updated: yes/no
- Reason:
- Version affected:
- Minor/major recommendation: yes/no
```

## README Governance

`README.md` is the project front door. Keep it concise, stable, and useful to human developers and agent developers.

Do not add long implementation details, phase/pass history, full command references, governance doctrine, changelog rules, wizard details, infrastructure guides, or report archives to README.md.

Route command documentation to `docs/command-reference.md`, governance doctrine to `docs/governance.md`, release history to `CHANGELOG.md`, operating instructions to `AGENTS.md`, canonical truth to `.wwg/wiki/`, validation rules to `.wwg/governance/`, and generated findings to `.wwg/reports/`.

If README.md grows too long, run or recommend `wwg readme route-docs --target . --dry-run`.

Required closeout line:

```md
README:
- Updated: yes/no
- Reason:
- If not updated, why:
- Docs routing needed: yes/no
- README validation status:
```

## Output / Completion Guidance

- Include a concise status or completion banner when governance alignment matters.
- Put the natural-language next step before any CLI backup command.
- Red outputs must clearly say stop.
- Orange outputs must clearly say pause or plan.
- Yellow outputs should guide review or sync.
- Green outputs should not over-warn.
- Final responses should include what changed, what truth/docs were updated, what tests were added or run, and whether any alignment warning remains.

## Handoff / Reporting Rules

- Report what changed, what was validated, what truth/context/governance surfaces were updated, and what risks remain.
- Include changelog and README closeout status for meaningful work.
- Record future work in `.wwg/governance/recommendation-registry.md` instead of expanding scope silently.
- State when no new recommendations were identified.

## Existing Project Adoption Rule

For new projects:
- Wiki leads code.

For existing projects:
- Code/docs/config reveal operational reality.
- WWG converts that reality into governed truth.
- Inferred truth must be labeled.
- Unclear or conflicting reality must be marked as `NEEDS_CONFIRMATION`, `CONFLICTING`, or `STALE`.

Do not treat adopted wiki content as fully confirmed until reviewed.

## Operating Rules

- Inspect current project truth before editing.
- Prefer additive changes and preserve user-defined project truth.
- Keep Wiki, Workspace, and Governance responsibilities separate.
- Update indexes and logs when adding meaningful files.
- Use clear markdown and avoid empty placeholder pages except `.gitkeep`.
- Treat runtime suspects as hypotheses until confirmed by evidence.
- Preserve human-written content outside `WWG_GENERATED` marker pairs.

## Maintenance Contract

<!-- WWG_GENERATED:MAINTENANCE_CONTRACT:START -->
Inspect project truth first. Execute by default for implementation requests. Use read-only-audit for inspection, ticket-only only when explicitly requested, and approval-gated mode for production, compliance, billing, permissions, security, public notices, data deletion, migrations, or irreversible operations.
<!-- WWG_GENERATED:MAINTENANCE_CONTRACT:END -->

## Task Routing

- Execute by default when asked to fix, implement, investigate, debug, update, create, add, test, commit, or push.
- Use ticket-only mode only when explicitly requested.
- Use read-only-audit mode for monitoring, inspection, production health, logs, performance, and issue hunting.
- Use approval-gated mode for production config, compliance-sensitive behavior, pricing, billing, permissions, security posture, legal/trust messaging, public customer notices, data deletion/migration, and irreversible operations.
- Users may prompt naturally, for example: "Sync Project Truth with the latest docs and reports.", "Reconcile this implementation back to Project Truth.", "Pause and create a planning review before implementation.", or "Add meaningful regression tests for the fixed bug." CLI commands are backup for technical users.
- Record meaningful implementation notes in `.wwg/reports/agent-implementation-log.md`. If `.wwg/reports/codex-implementation-log.md` exists from older work, treat it as legacy and prefer the agent-generic log.

## Context And Skill Maintenance

- Read `.wwg/wiki/09-agent-context/project-master-context.md` for orientation.
- Use `.wwg/wiki/12-maintenance/context-maintenance-matrix.md` to decide which context, prompts, skills, and governance checks apply.
- Sync `.wwg/workspace/` context after implementation when canonical truth changes.
- Keep reusable workflows in skills rather than one-off notes.

## Evidence Standards

Do not present hypotheses as confirmed causes. Root-cause and fix claims must map to code paths, logs, tests, config, database state, deployment output, or reproduction.

## Source Intake

- Register accessible external-chat files, screenshots, docs, and images through WWG source intake so they land under `.wwg/wiki/01-sources/raw/uploads/`.
- If an external-chat reference is not accessible as a local file or upload, add a raw source note documenting what was referenced and why the artifact is missing.
- Keep raw originals in `.wwg/wiki/01-sources/raw`; use `.wwg/wiki/01-sources/processed` only for later cleaned extracts or summaries.

## Agent Brief Instructions

- WWG-native projects should include root `AGENTS.md` and `.wwg/` with config, Wiki, Workspace, Governance, and reports.
- Do not claim agent readiness until an agent brief report exists. Prefer `.wwg/reports/wwg-agent-handoff.md`; current compatibility flows still use `.wwg/reports/wwg-handoff-to-codex.md`.
- Start your chosen coding agent with: Read AGENTS.md and .wwg/reports/wwg-agent-handoff.md. Follow the WWG operating loop, then continue from the WWG plan and begin implementation.

## Generated Project Note

This project was generated from WWG template assets. Do not import WWG template repository dogfood truth into this generated project unless it is explicitly promoted as reusable project truth.

## References

- `.wwg/wiki/project-truth-summary.md`
- `.wwg/wiki/terminology-summary.md`
- `.wwg/wiki/project-truth.md`
- `.wwg/wiki/terminology.md`
- `.wwg/workspace/current-task.md`
- `.wwg/governance/drift-guard.md`
- `.wwg/governance/test-enforcement.md`
- `.wwg/governance/recommendation-registry.md`
- `README.md`
