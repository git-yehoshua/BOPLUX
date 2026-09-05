# Agent Interface Guidelines

## Purpose

Provide practical UI guidance for products where humans supervise agents, automation, evidence, approvals, artifacts, or receipts.

Canonical principle source: `.wwg/wiki/principles/ai-agent-interface-principles.md`.

## Agent Status

- Show what the agent is doing now.
- Distinguish queued, running, waiting, blocked, failed, cancelled, and complete states.
- Use text status for long-running work.

## Approval Gates

- Put risky actions behind explicit review and approval.
- Show what will happen, what evidence supports it, and what can be reversed.
- Keep approval dialogs keyboard-accessible.

## Receipts

- Link meaningful actions to receipts or logs.
- Include actor, action, inputs, outputs, evidence, timestamp, and approval state where relevant.

## Artifact Previews

- Let users inspect generated or modified artifacts before accepting them.
- Show provenance and current status beside previews.

## WWG Truth And Vorter Runtime Evidence

- Show accepted WWG truth separately from runtime evidence.
- Do not make runtime evidence appear accepted until a human or governed flow promotes it.
- Vorter may supply runtime evidence later, but WWG remains the source for governed truth and principles.

## Cost And Model Decision Visibility

- Where model/tool choices affect cost, quality, risk, or permissions, expose the decision basis through receipts or explanation.
- Avoid fake certainty about model output.

## Human Escalation

- Escalate when evidence is insufficient, risky action is requested, or project truth conflicts with runtime evidence.

## Risk Warnings

- Use warnings before risky actions, not after damage.
- Explain consequence, reversibility, and required approval.

## Undo And Rollback

- Make common actions reversible.
- For irreversible actions, require approval and leave a receipt.

## Progressive Logs

- Start with a human summary.
- Let users expand into steps and artifacts.
- Let power users inspect receipts, logs, sources, and tool details.
