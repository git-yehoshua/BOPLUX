# Deployment Model

## Purpose

Describe environments and release topology.

## Compiled Truth

The deployment model should capture environments, hosting, configuration, rollout, rollback, and observability.

## Runtime and Infrastructure Investigation

Deployment work must distinguish local behavior from deployed behavior. "Works locally" is not sufficient proof of architectural correctness.

Runtime configuration must be explicit, validated, and documented. Deployment fixes must not mask authoritative backend defects with client-side workarounds.

Validation should cover config present at runtime, secrets loaded correctly, database connection, migration/schema state, worker/queue flow if touched, cache/projection consistency, startup paths, request-time paths, and normal backend/API flows.
