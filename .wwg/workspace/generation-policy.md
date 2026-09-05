# Generated Section Preservation Policy

## Purpose

Define how automation may update generated sections while preserving human-written content.

## How to Use

Use generated sections for catalogs, indexes, generated context, profile summaries, and report summaries when future CLI or WebApp tooling needs to update part of a file.

## Marker Format

```md
<!-- WWG_GENERATED:<SECTION_NAME>:START -->
Generated content here.
<!-- WWG_GENERATED:<SECTION_NAME>:END -->
```

## Rules

- Automation may update only content inside matching generated markers.
- Human-written content outside generated markers must be preserved.
- Generated markers must have stable names.
- Generated sections must not overlap.
- If a generated section cannot be safely updated, the agent must report the issue instead of rewriting the whole file.
- Generated sections are preferred for catalogs, indexes, generated context, profile summaries, and report summaries.
- Agents must not remove generated markers unless explicitly instructed.
- Upgrade or refresh automation must preserve local project truth and human-written content while updating only approved generated sections or explicitly reviewed files.

## Output Format

Reports should list generated sections updated, skipped, or blocked.
