# Skills Folder

## Purpose

Orient maintainers to reusable AI skills.

## Compiled Truth

Skills define repeatable procedures agents can follow for ingestion, linting, context refresh, and task writing.

Governed skills should separate reusable package-side definitions from local project state.

- Executable skill specs should define purpose, trigger, inputs, preconditions, steps, required checks, stop conditions, output contract, and references.
- Skill policy docs, registry docs, resolver contracts, and runtime candidate contracts are not executable skill specs unless the file is explicitly named as a skill.
- WWG governs bundled skill definitions, metadata, recommendations, validation, and promotion.
- A project-local Skill Manifest should record recommended, enabled, disabled, referenced, copied, and local skills.
- The Workspace Skill Index should be the human/agent-readable view.
- Domain skills should be recommended by profile and evidence instead of copied into every project by default.
- Runtime activation decisions are outside WWG and belong to the future Vorter runtime boundary.
