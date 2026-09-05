# Domain Rules

## Purpose

Capture business rules and invariants.

## Compiled Truth

Rules should be precise enough to drive validation, tests, and agent implementation.

## Product Invariants

Product invariants are non-negotiable truths that must not be violated by implementation.

Profile starter examples:

### SaaS

- Tenant data must remain isolated.
- Authorization must be enforced server-side.
- Billing events must be auditable.

### Agent WebApp

- Tool permissions must be explicit.
- Human review is required for high-risk actions.
- Memory boundaries must be documented.

### Game

- Game outcomes must be deterministic when required.
- Server-authoritative systems must not move to the client.
- Replay/watch behavior must match authoritative match history.

### Fintech

- Money movement must be auditable.
- Reconciliation must be traceable.
- Compliance content is implementation planning support, not legal advice.

### Internal Tool

- Admin actions must be auditable.
- Permission changes must require review.
- Operational workflows must have owners.

### Mobile App

- Offline behavior must be explicit.
- Device permissions must be justified.
- App release requirements must be tracked.
