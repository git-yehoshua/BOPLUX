# UI/UX Guiding Principles

## Purpose

Turn the governed UI/UX Simplicity Principle Brief into practical implementation guidance for this project.

Canonical principle source: `.wwg/wiki/principles/ui-ux-simplicity-principles.md`.

## Layout

- Put the next useful action where users naturally scan first.
- Keep related information together before adding visual decoration.
- Use spacing, alignment, and headings to make priority visible.

## Navigation

- Keep primary navigation stable.
- Prefer recognizable labels over clever names.
- Make the current location and available exits obvious.

## Forms

- Ask only for information needed now.
- Use clear labels, helper text, and validation near the field.
- Save advanced or rare fields for progressive disclosure.

## Dashboards

- Lead with status, risk, and next action.
- Avoid grids of equal-priority cards.
- Group operational details behind focused drill-down paths.

## Empty States

- Explain what is empty, why it matters, and what the user can do next.
- Do not use empty minimalism when users need orientation.

## Tables And Lists

- Make scan columns, sort order, filters, and row actions clear.
- Keep destructive or high-risk actions visually separate.
- Use detail panels or expansion for less common metadata.

## Cards

- Use cards for repeated items or genuinely grouped records.
- Avoid card piles when a list or table would be easier to compare.

## Buttons And Actions

- Make primary, secondary, and destructive actions visually distinct.
- Prefer one primary action per local decision area.
- Keep destructive actions approval-first and reversible where possible.

## Error States

- Prevent common errors before explaining them.
- Tell users what happened, what can be done next, and whether anything was saved.

## Loading And Status States

- Show status before details.
- Use text status for long-running work.
- Preserve context while loading details or logs.

## Onboarding

- Start with a useful first action.
- Reveal concepts as users need them.
- Keep power-user paths available after beginner defaults.

## Beginner And Power-User Modes

- Use beginner-friendly defaults.
- Let advanced users expand, override, inspect, and reverse decisions.
- Do not remove power to create an illusion of simplicity.

## Progressive Disclosure

- Start with the current goal.
- Reveal complexity through expandable sections, detail panels, advanced settings, and evidence views.
- Keep risky or irreversible actions visible enough to review before use.

## Recommended Default And Advanced Override

Use this pattern when the system can recommend a good path:

- Recommended default: show the safest useful option.
- Why: briefly explain the basis for the recommendation.
- Advanced override: provide the control without making beginners start there.
- Reversibility: explain how to undo or revise the choice.
