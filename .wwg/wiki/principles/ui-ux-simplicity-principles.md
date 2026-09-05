---
type: principle-brief
status: active
mutability: high-friction
scope: "ui-ux"
last_reviewed: 2026-05-20
---

# UI/UX Simplicity Principles

## Purpose

Provide governed UI/UX simplicity guidance for generated projects that have user-facing, staff-facing, or human-facing software surfaces.

Canonical WWG source: `.wwg/wiki/principles/ui-ux-simplicity-principles.md` in the WWG template repository.

## Scope

Use this principle when designing or reviewing layout, navigation, forms, dashboards, empty states, lists, cards, actions, status states, onboarding, and progressive disclosure.

## Non-Goals

- Do not treat this file as a component library.
- Do not force non-UI projects to behave like UI products.
- Do not hide project-specific truth, accepted decisions, or accessibility requirements.

## Core Rule

Reduce visible complexity, not user control.

## Principles

1. Start with the next useful action.
2. Reduce visible choices, not available power.
3. Organize before styling.
4. Prefer recognition over recall.
5. Use hierarchy to make priority obvious.
6. Use progressive disclosure for complexity.
7. Use smart defaults, but make them transparent and reversible.
8. Show status before details.
9. Prevent errors before explaining errors.
10. Simple does not mean empty.

## HomeDesk Interpretation

- Project Rooms should make the next useful action obvious.
- "Next 2 Hours" should be a first-class UX pattern when the product has planning or active-work surfaces.
- Readiness, warnings, approvals, artifacts, and receipts should be visible without overwhelming the user.

## Anti-Patterns

- Feature cockpit overload.
- Hidden irreversible actions.
- Too many equal-priority cards.
- Empty minimalism.
- Hiding evidence required for trust.

## References

- UX Magazine simplification guidance.
- John Maeda, Laws of Simplicity summaries.
- Nielsen Norman Group usability heuristics.
- GOV.UK service design guidance.
- WCAG 2.2.

## Related Generated Surfaces

- `.wwg/wiki/design-system/ui-ux-guiding-principles.md`
- `.wwg/workspace/checklists/ui-ux-review-checklist.md`
