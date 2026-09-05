# Skill Format

## Purpose

Define the standard format for reusable WWG skills.

## How to Use

Use this structure when creating or updating an executable skill. Keep skill guidance grounded in Wiki truth, Workspace context, Governance checks, and local project evidence.

Do not treat public skill policy docs, resolver contracts, registry docs, or runtime candidate contracts as executable skill files.

## Rules

- Skills answer how an agent should perform a repeatable task.
- Skills must define trigger, inputs, preconditions, steps, required checks, stop conditions, output contract, and references.
- Procedures should use ordered steps.
- Commands should use fenced code blocks.
- Stop conditions should cover missing inputs, ambiguity, approval gates, safety, failed checks, and conflicts with canonical truth.
- Package-side bundled skill metadata remains canonical in the Skill Registry.
- Project-local skill state belongs in the Skill Manifest and local Workspace skill files.
- WWG may recommend candidate, eligible, restricted, disabled, or reference-only skills.
- WWG must not claim runtime skill activation, loading, injection, mounting, routing, or execution.
- Vorter owns future runtime activation, defer, block, ignore, and reference-only decisions.
- HomeDesk owns future user-facing visibility, approval, disabling, browsing, and overrides.

## Output Format

```md
# Skill Name

## Purpose

## Trigger

## Inputs

## Preconditions

## Steps

## Required Checks

## Stop Conditions

## Output Contract

## References
```

Write `Not applicable` only when the reason is stated. Existing skills may preserve approved aliases during gradual remediation when the alias satisfies the current WWG skill contract or generated governance guidance.

## Metadata Policy

Skill metadata decision: Option C.

The Skill Registry is canonical for package-side bundled skill metadata. Skill files do not require frontmatter. Lightweight frontmatter may be added only when readability improves and the frontmatter does not conflict with registry metadata.

## Evidence Expectations

Evidence-sensitive skills should state how claims map to the evidence ladder:

- confirmed
- likely
- hypothesis
- unknown

Do not present hypotheses as confirmed causes.

## References

- `.wwg/governance/skill-writer.md`
- `.wwg/workspace/skills/skill-spec-template.md`
- `docs/skills/skill-registry-and-manifest.md`
- `docs/skills/runtime-skill-candidate-contract.md`
