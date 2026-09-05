# System Overview

## Purpose

Describe the system at a high level.

## Compiled Truth

The system overview should capture components, responsibilities, boundaries, and major data flows.

## Runtime Truth

Runtime Truth declares which systems are authoritative, which are derived, and which must never become sources of truth.

| Concern | Authoritative Source | Derived / Cache / Projection | Forbidden Substitution |
|---|---|---|---|
| User identity | TBD | TBD | TBD |
| Business records | TBD | TBD | TBD |
| Runtime settings | TBD | TBD | TBD |
| Audit history | TBD | TBD | TBD |

Every generated project should explicitly declare authoritative storage. Cache, queue, and pub/sub systems must not silently become hidden sources of truth. Agents must not move persistence-critical flows to non-authoritative systems.

Runtime Truth must hold under deployed conditions, not only local development. Runtime suspects are hypotheses until verified by logs, config, reproduction, targeted checks, or deployment output.
