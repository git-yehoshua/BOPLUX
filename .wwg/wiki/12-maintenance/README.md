# Maintenance

## Purpose

Define how a WWG project keeps code, wiki truth, workspace context, skills, governance checks, and reports synchronized after meaningful work.

## Compiled Truth

Developers may prompt naturally. Agents must execute structurally.

Every developer request should become a classified change request. Every meaningful change must reconcile:

- Code
- Wiki
- Workspace Context
- Skills
- Governance
- Reports

The standard lifecycle is:

1. Intent / Request
2. Classify change
3. Pre-change context check
4. Implementation
5. Post-change wiki/workspace/skill maintenance
6. Governance validation
7. Report / commit

Context before code is for orientation. Context after code is for synchronization.

The execution operating loop is:

```txt
Natural prompt
  ->
Change classification
  ->
Task routing
  ->
Execution mode decision
  ->
Implementation workflow
  ->
Validation
  ->
Context / skill / wiki maintenance
  ->
Governance checks
  ->
Report / commit / push or PR
```

Execution-first is the default when the user asks to fix, implement, investigate, debug, update, create, add, test, commit, or push and the agent has the required access. Ticket-only mode applies only when explicitly requested.

Production monitoring uses read-only-audit mode by default. Runtime and infrastructure changes may be approval-gated when they affect production configuration, secrets, data, deployment, compliance-sensitive behavior, security posture, or irreversible operations.

Current canonical truth, generated context, reference history, temporary notes, public surfaces, and machine-readable catalogs have different update rules. Use `09-agent-context/canonical-context-policy.md` before promoting findings into current guidance.

For established generated projects, compare upstream template defaults with local Project Truth before changing human-authored or accepted project files.
