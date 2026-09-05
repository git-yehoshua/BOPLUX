# Skill Index

## Purpose

List reusable skills and their purpose.

## Compiled Truth

The skill index should include skill id, purpose, trigger, inputs, output contract, owner, and status.

The governed skill model should also include class, domain, source, materialization, recommendation reason, trust tier, approval area, and promotion status when registry and manifest support are available.

The Skill Index is the human/agent-readable view. The future machine-readable project state belongs in `.wwg/config/skill-manifest.yaml`.

Executable skill files should follow the generated Workspace skill format. Design contracts, registry docs, resolver docs, and runtime candidate docs should not be forced into executable skill shape.

## Base Skills

| Skill | Purpose | Primary Location |
|---|---|---|
| `wiki-ingest` | Convert raw notes and sources into filed wiki entries while preserving evidence. | `skill-specs/wiki-ingest.skill.md` |
| `wiki-lint` | Check wiki pages for missing sections, stale links, contradictions, and empty placeholders. | `skill-specs/wiki-lint.skill.md` |
| `context-refresh` | Regenerate workspace context from current wiki truth. | `skill-specs/context-refresh.skill.md` |
| `task-ticket-writer` | Turn requirements and governance gates into agent-ready task tickets. | `skill-specs/task-ticket-writer.skill.md` |

## Compiled Workspace Skills

Agent workflow skills compiled from Workspace templates, selected profiles, and Wiki skill specs belong in `workspace/skills/skill-index.md` after `wwg refresh-skills` or `wwg generate-workspace`.

## Maintenance Rule

When a reusable workflow changes, update this index and the relevant skill file. Do not leave stale skills after a canonical workflow decision.

Do not copy every bundled skill into every local workspace. Keep bundled domain skills as references or recommendations until the project profile, repository evidence, task, or user approval makes them relevant.
