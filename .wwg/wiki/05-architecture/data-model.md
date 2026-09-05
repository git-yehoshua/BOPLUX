# Data Model

## Purpose

Describe core data entities and relationships.

## Compiled Truth

The data model should identify records, ownership, lifecycle, retention, and sensitive fields.

## Runtime Truth

| Concern | Authoritative Source | Derived / Cache / Projection | Forbidden Substitution |
|---|---|---|---|
| User identity | TBD | TBD | TBD |
| Business records | TBD | TBD | TBD |
| Runtime settings | TBD | TBD | TBD |
| Audit history | TBD | TBD | TBD |

Data-model changes must identify which records are authoritative, which are derived, and which must never be treated as persistence-critical truth. Agents must not move persistence-critical flows to non-authoritative systems.

Schema and migration state must be validated against deployed runtime when production behavior depends on it. Cache, queue, pub/sub, and projections must not become hidden sources of truth.
