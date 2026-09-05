# task-ticket-writer Skill

## Purpose

Turn requirements and governance gates into agent-ready task tickets.

## Trigger

- Use when work should be planned as an execution-ready ticket before implementation.
- Use when requirements, acceptance criteria, profile gates, or approval areas need to be explicit.
- Do not use when the user asked for immediate execution and the change is safe to perform directly.

## Inputs

- Requirement pages.
- Acceptance criteria.
- Profile gates.
- Relevant Governance rules.
- Current task notes and known constraints.

## Preconditions

- Requirements are sourced from Wiki truth, user instructions, or marked assumptions.
- Approval-gated areas are identified before drafting execution steps.
- The ticket can stay bounded, testable, and actionable.

## Steps

1. Inspect relevant Wiki pages and source evidence.
2. Identify scope, non-goals, acceptance criteria, and risks.
3. Map required Governance checks and approval gates.
4. Name expected files, artifacts, and validation commands when known.
5. Write the task ticket as an execution-ready prompt.
6. Summarize assumptions and unresolved questions.

## Required Checks

- Confirm the ticket has scope, inputs, expected outputs, checks, and report expectations.
- Confirm approval-gated work is not presented as pre-approved.
- Confirm the ticket preserves canonical terminology and layer boundaries.

## Stop Conditions

- Stop when requirements are too ambiguous to turn into execution steps.
- Stop when a high-risk change needs owner approval before planning can proceed.
- Stop when the ticket would invent project truth or hide unresolved decisions.

## Output Contract

- Task ticket with scope, files, checks, risks, approval gates, and report expectations.
- Assumptions and unresolved questions listed separately from accepted truth.
- References to source requirements and Governance files.

## References

- `.wwg/workspace/skill-format.md`
- `.wwg/workspace/skills/skill-spec-template.md`
