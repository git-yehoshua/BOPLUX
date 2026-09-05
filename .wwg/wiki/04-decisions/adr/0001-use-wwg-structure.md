# ADR 0001: Use WWG Structure

## Status

Accepted

## Context

AI-agent-ready repositories need durable project memory, actionable agent instructions, and explicit governance checks. Mixing those responsibilities creates drift and makes future automation harder.

## Decision

Use the WWG structure with separate Wiki, Workspace, and Governance layers. Use a universal base for shared structure and profiles for project-type-specific additions.

## Consequences

Project truth has a clear home, agent instructions can be generated from that truth, and quality gates can be applied consistently. Maintainers must keep indexes and logs current when making meaningful changes.
