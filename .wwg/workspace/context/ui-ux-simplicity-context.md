# UI/UX Simplicity Context

## Purpose

Give agents a compact loading surface for applying the WWG-governed UI/UX Simplicity Principle Pack without reading every long-form design file first.

This context helps agents create, modify, or review user-facing and agent-facing interfaces while preserving WWG, HomeDesk, and Vorter boundaries.

## Scope

Use this context for UI/app workspaces that receive the governed UI/UX principle pack.

This context is not a design system by itself. The canonical principles, design-system guidance, and review checklists listed in References remain authoritative.

## Trigger

Use this context when creating, reviewing, or modifying user-facing UI, onboarding, dashboards, forms, workflows, agent-facing interfaces, approval flows, or generated app screens.

## Read Order

1. `.wwg/wiki/principles/ui-ux-simplicity-principles.md`
2. `.wwg/wiki/principles/accessibility-principles.md`
3. `.wwg/wiki/principles/ai-agent-interface-principles.md`
4. Relevant `.wwg/wiki/design-system/*.md` file
5. Relevant `.wwg/workspace/checklists/*.md` checklist

## Current State

- WWG owns the UI/UX simplicity, accessibility, and AI-agent interface principles as governed guidance.
- HomeDesk owns the user-facing runspace where these principles may be rendered or applied.
- Vorter may later consume runtime-sensitive UX guardrail candidates, but WWG does not execute agents, route tools/models, render UI, or mutate runtime evidence into accepted truth.
- The full UI/UX pack is profile-propagated for UI/app projects; non-UI projects stay lightweight unless they opt in.

## Canonical Terms

| Term | Meaning |
|---|---|
| WWG accepted truth | Canonical project truth promoted into the Wiki or accepted decision surfaces. |
| Vorter runtime evidence | Runtime observations, receipts, logs, tool output, or model/tool decisions owned by Vorter until reviewed and accepted. |
| HomeDesk | User-facing runspace and control surface. |
| Progressive disclosure | Showing the next useful layer first while keeping advanced control reachable. |
| Approval-first action | A risky action that waits for clear human approval before execution. |

## Decisions

- Simplicity reduces visible complexity, not available user control.
- Accessibility defaults to WCAG 2.2 AA unless the project records a different accepted decision.
- Agent-facing UI must preserve accountability through visible status, evidence, approvals, receipts, and uncertainty.
- Runtime evidence remains separate from accepted truth until reviewed through WWG-governed decision flow.

## Constraints

### Must

- Make the next useful action obvious.
- Reduce visible complexity, not user control.
- Use progressive disclosure for advanced options.
- Show system status.
- Make risky actions approval-first.
- Separate WWG accepted truth from Vorter runtime evidence.
- Use WCAG 2.2 AA as the default accessibility target.
- Provide useful empty, loading, error, and success states.

### Must Not

- Do not silently remove user control.
- Do not hide approval requirements.
- Do not claim accessibility compliance without checks.
- Do not merge runtime evidence into accepted truth.
- Do not override local project design decisions without WWG approval.

### Prefer

- Start with the next useful action, then reveal advanced controls.
- Use recommended defaults with transparent and reversible overrides.
- Show human-readable status before detailed logs.
- Use checklists before release or handoff.

### Avoid

- Feature cockpit overload.
- Hidden irreversible actions.
- Empty minimalism that removes useful orientation.
- Too many equal-priority cards or actions.
- Hiding evidence required for trust.

## Stop Conditions

- Stop when the change would remove user control without an accepted decision.
- Stop when risky actions can happen without approval.
- Stop when accessibility is claimed without evidence or checks.
- Stop when runtime evidence is presented as accepted truth.
- Stop when local project design decisions conflict with the proposed UI/UX guidance and WWG approval is absent.

## Output Contract

- UI change summary
- UX principle checks
- Accessibility checks
- Agent-interface checks, if relevant
- Risks and exceptions
- Files changed

## References

- `.wwg/wiki/principles/ui-ux-simplicity-principles.md`
- `.wwg/wiki/principles/accessibility-principles.md`
- `.wwg/wiki/principles/ai-agent-interface-principles.md`
- `.wwg/wiki/design-system/ui-ux-guiding-principles.md`
- `.wwg/wiki/design-system/accessibility-baseline.md`
- `.wwg/wiki/design-system/agent-interface-guidelines.md`
- `.wwg/workspace/checklists/ui-ux-review-checklist.md`
- `.wwg/workspace/checklists/accessibility-review-checklist.md`
- `.wwg/workspace/checklists/agent-interface-review-checklist.md`
