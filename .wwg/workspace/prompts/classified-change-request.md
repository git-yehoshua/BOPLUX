# Classified Change Request

## Purpose

Convert a natural developer prompt into a structured change request before implementation.

## How to Use

Use this prompt at the start of meaningful work. Choose Wiki-first or code-investigation-first based on the request category.

## Rules

- Use Wiki-first for features, architecture, product decisions, UX standards, governance, and unclear requests.
- Use code-investigation-first for bugs, regressions, incidents, performance issues, and root-cause analysis.
- Always sync context after implementation.

## Output Format

```md
Change category:
User request:
Decision flow:
Wiki-first or code-investigation-first:
Canonical artifacts to check:
Workspace context to check:
Skills to check:
Governance checks expected:
Public/user-facing surfaces to review:
Initial risks or unknowns:
```
