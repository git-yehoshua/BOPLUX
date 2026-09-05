# Codex Full Access Prompt

## Purpose

Provide a reusable prompt for common agent work.

## How to Use

Fill placeholders with project context, task scope, constraints, and validation commands.

## Rules

- Keep prompts grounded in wiki truth and governance gates.
- Developers may prompt naturally. Agents must execute structurally.
- Use execution-first mode by default when the user asks to fix, implement, investigate, debug, update, create, add, test, commit, or push.
- Use ticket-only mode only when explicitly requested.
- Use read-only-audit mode for monitoring, inspection, production health, log summaries, performance analysis, and issue hunting.
- Use approval-gated mode for production config, compliance-sensitive behavior, pricing, billing, permissions, security posture, legal/trust messaging, public customer notices, data deletion/migration, and irreversible operations.
- Do not present hypotheses as confirmed causes.
- Preserve human-written content outside generated markers.
- Report public-surface review and regression guardrail decisions when relevant.

## Output Format

Role, context, routed task, execution mode, implementation, validation, maintenance contract, governance checks, commit/push or PR status.
