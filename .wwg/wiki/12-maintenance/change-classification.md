# Change Classification

## Purpose

Classify natural developer requests into structured change categories before implementation.

## Compiled Truth

Natural prompts are welcome, but agents must convert them into structured execution.

## Required Change Categories

- `bug-fix`
- `feature-implementation`
- `mechanics-or-domain-rule-change`
- `architecture-change`
- `data-model-change`
- `security-review`
- `ui-ux-change`
- `public-content-update`
- `cloud-infra`
- `test-generation`
- `documentation-update`
- `context-maintenance`
- `skill-maintenance`
- `governance-change`
- `release-signoff`
- `incident-postmortem`
- `runtime-infrastructure`
- `public-discovery-maintenance`
- `production-monitoring`
- `truth-conflict-resolution`
- `canonical-context-maintenance`

## Task Routing

Task routing selects the primary workflow, secondary workflows when useful, execution mode, canonical artifacts to inspect, validation expectations, public surfaces to review, and context/skill maintenance requirements.

Execution-first is the default when the user asks to fix, implement, investigate, debug, update, create, add, test, commit, or push and the agent has the required access.

Ticket-only mode applies only when the user explicitly says: create a prompt, draft a task ticket, ticket only, do not execute, or planning only. In ticket-only mode, output the actual execution-ready prompt or ticket, not meta commentary.

## Execution Mode Taxonomy

### execution-first

Use when the user asks to fix, implement, debug, investigate, update, create, add, test, commit, push, or deploy. Behavior: classify -> route -> implement -> validate -> maintain context/skills/governance -> report -> commit/push if allowed.

### ticket-only

Use only when the user explicitly asks to create a prompt, draft a task ticket, ticket only, planning only, or do not execute. Behavior: produce execution-ready ticket/prompt only; do not implement.

### read-only-audit

Use when the user asks to monitor, inspect, review, assess, check health, audit production, summarize logs, analyze performance, or look for issues. Behavior: gather evidence -> write report -> recommend next steps; do not modify code/config/deployments unless explicitly requested.

### approval-gated

Use when work affects production configuration, compliance-sensitive behavior, pricing, billing, permissions, security posture, legal/trust messaging, public customer notices, data deletion or migration, or irreversible operations. Behavior: prepare plan/draft/recommendation and require explicit approval before release-impacting change.

Use Wiki-first flow for:

- New features
- Product decisions
- Architecture changes
- Domain rules
- UX standards
- Governance changes
- Unclear requests

Wiki-first flow:

1. Wiki / decision / context first
2. Workspace update if needed
3. Implementation
4. Post-change reconciliation
5. Governance validation

Use code-investigation-first flow for:

- Bugs
- Regressions
- Incidents
- Performance problems
- Production issues
- Root-cause analysis
- Runtime infrastructure investigation

Code-investigation-first flow:

1. Inspect code, logs, and tests first
2. Fix implementation
3. Add or update tests
4. Update Wiki, Workspace, and Skills with discovered truth
5. Governance validation

Context before code is for orientation. Context after code is for synchronization.
