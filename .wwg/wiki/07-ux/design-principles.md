# Design Principles

## Purpose

Capture product-specific design rules.

## Compiled Truth

Design principles should guide layout, tone, density, accessibility, and interaction behavior.

## Default Lightweight Guidance

All generated projects may have human-facing outputs such as README files, reports, checklists, docs, CLI messages, or handoff artifacts. Keep those outputs clear, accessible, and action-oriented.

Do not assume every project is a UI product. Full UI/UX principle-pack surfaces are profile-propagated for app, web, agent interface, internal tool, mobile, and game projects rather than copied into every workspace.

## Design Source of Truth

UI/UX changes must review design source-of-truth files. Meaningful changes to visual language, component behavior, page layout, loading states, empty states, responsive behavior, or admin presentation must update design docs.

If a project has a standalone `DESIGN.md`, agents must treat it as canonical.

## Optional UI/UX Principle Pack

Projects with selected UI/app profiles may also receive:

- `.wwg/wiki/principles/ui-ux-simplicity-principles.md`
- `.wwg/wiki/principles/accessibility-principles.md`
- `.wwg/wiki/principles/ai-agent-interface-principles.md`
- `.wwg/wiki/design-system/`
- `.wwg/workspace/checklists/*ui-ux*`
