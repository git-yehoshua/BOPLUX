---
type: principle-brief
status: active
mutability: high-friction
scope: "accessibility"
last_reviewed: 2026-05-20
---

# Accessibility Principles

## Purpose

Set the default accessibility reasoning baseline for projects with user-facing, staff-facing, or human-facing software surfaces.

Canonical WWG source: `.wwg/wiki/principles/accessibility-principles.md` in the WWG template repository.

## Default Target

Target WCAG 2.2 AA unless the project explicitly documents a different accessibility target in accepted Project Truth or accepted decisions.

Accessibility is a release requirement, not polish.

## Principles

- Keyboard access.
- Visible focus.
- Color contrast.
- Text alternatives.
- Semantic structure.
- Error identification and recovery.
- Form labels and instructions.
- Motion safety.
- Responsive layout.
- Accessible status updates.

## AI-Specific Accessibility Concerns

- Long-running agent tasks must expose status in text, not only animation.
- Receipts and logs should be readable, searchable where practical, and navigable by headings.
- Approval dialogs must be keyboard-accessible.
- Error states must explain what happened and what can be done next.

## Exceptions

Accessibility exceptions must be documented through WWG accepted decisions before release. Undocumented exceptions are unresolved governance risk, not design preference.

## Related Generated Surfaces

- `.wwg/wiki/design-system/accessibility-baseline.md`
- `.wwg/workspace/checklists/accessibility-review-checklist.md`
