---
type: principle-brief
status: active
mutability: high-friction
scope: "ai-agent-interface"
last_reviewed: 2026-05-20
---

# AI Agent Interface Principles

## Purpose

Define interface principles for products where agents, tools, automation, receipts, evidence, approvals, or model/tool choices are visible to humans.

Canonical WWG source: `.wwg/wiki/principles/ai-agent-interface-principles.md` in the WWG template repository.

## Core Rule

Simplicity must not hide accountability.

## Principles

1. Show what the agent is doing.
2. Show what the agent used as evidence.
3. Separate accepted truth from runtime evidence.
4. Require approval for risky actions.
5. Make actions reversible where possible.
6. Provide receipts for meaningful actions.
7. Use progressive logs:
   - human summary
   - steps and artifacts
   - receipts, logs, and tool details
8. Make model/tool routing explainable through Right-Fit Intelligence receipts when that concept exists in the project.
9. Avoid fake certainty.
10. Escalate to human review when evidence is insufficient.

## HomeDesk Interpretation

- Project Room status.
- Approval queue.
- Artifact gallery.
- Readiness panel.
- Vorter runtime evidence panel.
- WWG truth panel.

## Non-Goals

- WWG does not execute agents.
- WWG does not route tools or models.
- WWG does not mutate runtime evidence into accepted truth automatically.

## Related Generated Surfaces

- `.wwg/wiki/design-system/agent-interface-guidelines.md`
- `.wwg/workspace/checklists/agent-interface-review-checklist.md`
