# Monitoring

## Purpose

Define read-only production monitoring expectations for live system health, performance, reliability, and scale readiness.

## Compiled Truth

Production monitoring is a read-only evidence-gathering workflow. It should not modify code, config, deployments, secrets, data, or infrastructure unless the user explicitly asks for that.

Monitoring reports should be comparable over time. Reports must separate confirmed issues, watch-items, likely benign signals, and unknowns. Sampled logs must be described as sampled evidence, not full-census proof.

Monitoring findings may trigger bug-fix, runtime-infrastructure, regression-guardrail, or public-surface workflows, but should not silently execute fixes unless requested.

If findings reveal a repeatable workflow gap, update governance guardrails or recommend a guardrail update.
