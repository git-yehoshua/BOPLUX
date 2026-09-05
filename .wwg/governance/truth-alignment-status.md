# Truth Alignment Status

## Purpose

Define how WWG should describe alignment between Project Truth, requirements, implementation, tests, terminology, docs, and recent reports.

Truth Alignment Status complements drift scoring. A drift score can show that change happened, but the status explains what kind of change happened and whether it is accepted, undocumented, stale, contradictory, or risky.

Project drift is not always bad. Requirement evolution is normal when the user requests it or accepts it and the change is promoted into Project Truth or requirements documentation.

## Categories

### Requirement Evolution

A user-requested or intentionally accepted change in product direction, feature scope, architecture, terminology, or behavior.

Requirement evolution is allowed when documented in Project Truth, requirements, decisions, terminology, or another canonical Wiki artifact.

### Undocumented Requirement Change

A requirement evolution that appears in recent implementation, docs, reports, or agent summaries but has not yet been promoted into Project Truth or requirements documentation.

Undocumented requirement changes should be surfaced so the user can accept the change and sync truth, or reject it and restore alignment.

### Documentation Lag

Implementation and recent reports agree, but canonical Project Truth or core docs are behind.

Documentation lag is usually milder than implementation drift, but it still needs reconciliation before the project claims fresh alignment.

### Implementation Drift

Code behavior, architecture, or UI has moved away from Project Truth without a documented reason.

Implementation drift should be treated as a governance finding until the user accepts the new direction or the implementation is corrected.

### Regression / Quality Drift

A previously fixed issue appears to have returned, required tests are missing, or implementation quality declined relative to governance expectations.

Regression and quality drift are serious. They should receive stronger verification and should update regression guardrails when a missed bug, incident, or sign-off gap is discovered.

Test Enforcement is part of this category. Missing Test Required coverage maps to ORANGE / `pause_for_plan`; missing Regression Test Required coverage, removed/weakened tests, or failing core behavior tests map to RED / `stop`.

### Terminology Drift

Terms changed or multiplied without canonical terminology updates.

Terminology drift should be resolved by updating `.wwg/wiki/terminology.md` when the new term is accepted, or by reconciling code, UI copy, docs, reports, tests, and governance files back to canonical language.

## Banner Levels

### GREEN / Aligned

Project Truth, implementation, tests, and recent docs appear aligned. No action required.

Default execution gate: `allow`.

### YELLOW / Mild Truth Drift

Small assumptions, terminology changes, documentation lag, or minor requirement evolution were detected.

The user can continue, but should update Project Truth if the change is intentional.

Default execution gate: `warn`.

### ORANGE / Significant Truth Drift

Recent work appears to change product scope, architecture, behavior, persona, or quality expectations beyond current Project Truth.

Recommend pausing new implementation until the user accepts the change or syncs docs and truth.

Default execution gate: `pause_for_plan`. Exception: documentation lag may remain `warn` when it is clearly low-risk and does not affect scope, architecture, safety, payments, auth, persistence, production deployment, or verification quality.

### RED / Critical Alignment Break

Recent change conflicts with Project Truth, reintroduces a previously fixed issue, weakens required tests, or touches high-risk areas without proper documentation.

Recommend stopping new implementation and doing planning/reconciliation first.

Default execution gate: `stop`.

## Execution Gate Model

Truth Alignment Status tells what changed. Execution Gate tells what the agent should do next.

### ALLOW

The agent can continue normally.

### WARN

The agent can finish the current task, but should show a banner and recommended truth sync or reconciliation action.

### PAUSE_FOR_PLAN

The agent should not begin implementation yet. It should produce a planning/reconciliation review first.

### STOP

The agent should stop execution and require explicit user/agent resolution before further implementation.

## Stop-Level Triggers

WWG should return `stop` when meaningful evidence shows any of these:

- Direct contradiction with Project Truth, such as production payment claims when Project Truth says payment is mock-only.
- Reintroduced bug or regression, including failing regression coverage or weakened prior fixes.
- Missing Regression Test Required coverage for a fixed bug, high-risk failure path, or issue that should never return.
- High-risk domain change without Project Truth or governance updates. High-risk areas include payments, auth, authorization, security, user data, persistence/databases, financial settlement, production deployment, compliance behavior, and destructive actions.
- Required verification removed or weakened.
- Destructive or irreversible behavior, including data deletion, production deployment changes, governance file removal, audit/report/history removal, or canonical truth overwrite attempts.
- Canonical truth rewritten wholesale without a clear decision record.

## Pause-For-Plan Triggers

WWG should return `pause_for_plan` when meaningful evidence shows any of these:

- Major product scope change.
- Major architecture change.
- Major terminology or persona change.
- Significant docs/report mismatch against Project Truth.
- Meaningful implementation after which test quality is below governance expectation.
- Missing Test Required coverage for changed behavior.
- Recent requirements are ambiguous or conflicting.

Major non-risk requirement evolution should pause for planning instead of stopping. Requirement evolution is allowed; WWG pauses when the decision needs truth reconciliation before implementation continues.

## Warning-Only Triggers

WWG should return `warn` for low-risk drift such as minor terminology mismatch, small documentation lag, minor UI/copy changes not reflected in Project Truth, small report assumptions, low drift score with no high-risk area touched, or light tests when no meaningful behavior change was detected.

## Configurable Defaults

Projects may configure execution gate behavior in `wwg.project.yaml` or `.wwg/config/wwg.project.yaml`:

```yaml
truthAlignment:
  hardStops: true
  pauseOnOrange: true
  stopOnRed: true
  requireTestsForMeaningfulChanges: true
  highRiskAreas:
    - payments
    - auth
    - security
    - persistence
    - deployment
    - compliance
    - financial-settlement
```

## Truth Sync Decision Model

After YELLOW, ORANGE, or RED alignment is detected, WWG should guide a decision instead of assuming every mismatch is bad drift.

### Accept as New Truth

Use when the recent change is intentional and should become canonical.

Examples:

- A new feature was approved.
- Product scope expanded intentionally.
- Terminology changed intentionally.
- Architecture changed intentionally.

Expected result:

- Project Truth is updated.
- Terminology is updated if needed.
- Requirements, current-task, history, and decision docs are updated.
- Reports no longer treat the change as unresolved drift.

Natural prompt first:

```txt
Tell the agent: "Accept this as an intentional requirement change and sync Project Truth, terminology, and requirements docs with the latest implementation and reports."
```

Backup CLI:

```bash
npm run wwg -- update-truth --target .
```

### Reconcile to Existing Truth

Use when recent changes are accidental, premature, or contradictory.

Examples:

- Agent added unrequested feature scope.
- Recent report implies capabilities the app does not have.
- UI copy says production-ready when Project Truth says demo-only.
- Docs moved away from canonical terminology.

Expected result:

- Recent docs, reports, and copy are corrected.
- Implementation is adjusted when needed.
- Project Truth remains the authority.

Natural prompt first:

```txt
Tell the agent: "Treat the latest mismatch as unintended drift and reconcile recent docs, reports, and implementation back to the current Project Truth."
```

Backup CLI:

```bash
npm run wwg -- reconcile --target .
```

### Investigate / Plan First

Use when the change may be valid but is too large or risky to accept automatically.

Examples:

- Payment, auth, security, or persistence changes.
- Major persona or business model changes.
- New architecture direction.
- Conflicting sources of truth.

Expected result:

- A planning/reconciliation report is generated.
- No canonical truth rewrite is performed without explicit decision.

Natural prompt first:

```txt
Tell the agent: "Pause implementation and create a planning review comparing Project Truth, recent docs, reports, tests, and implementation before making more changes."
```

Backup CLI:

```bash
npm run wwg -- plan --target .
```

### Regression / Quality Repair

Use when a previously fixed issue returns or meaningful implementation happened without meaningful verification.

Examples:

- Fixed bug reintroduced.
- Test removed or weakened.
- Behavior changed without updated test.
- Quality gate missing.

Expected result:

- Add or update regression tests.
- Document the regression.
- Update governance/reporting if needed.

Natural prompt first:

```txt
Tell the agent: "Treat this as a regression or quality gap. Add or update meaningful tests, document the issue, and repair the implementation."
```

Backup CLI:

```bash
npm run wwg -- regression-check --target .
```

## Completion Banner Pattern

WWG report and completion summaries should prefer natural instructions first, then CLI commands as backup for technical users.

Example structure:

```txt
WWG STATUS: Mild Truth Drift

Recent work introduced small assumptions or documentation changes that may not yet be reflected in Project Truth.

Recommended decision:
Accept as New Truth

Recommended next step:
Tell the agent: "Sync Project Truth with the latest docs and reports if this was an intentional requirement change."

Backup CLI option:
npm run wwg -- update-truth --target .
```

## Drift Score Relationship

If a report still includes a drift score or `Drift status: NONE / LOW / MEDIUM / HIGH`, keep it. Interpret the score alongside Truth Alignment Status:

- A low score can still indicate undocumented requirement evolution.
- A medium score can be acceptable if it records intentional requirement evolution and truth was synced.
- Any regression, missing required verification, or contradiction with Project Truth should remain serious even when other docs appear consistent.

## First-Pass Rule-Based Detection

WWG may classify Truth Alignment with deterministic, explainable signals. First-pass detectors should prefer clear evidence over broad semantic guesses.

Examples of useful signals:

- Project Truth says payment, checkout, wallet, or settlement behavior is mock-only, while recent docs imply real production payment acceptance.
- Recent reports mention major scope such as dashboard, checkout, authentication, database, API, backend, persistence, payment, or wallet behavior that Project Truth does not list as accepted scope.
- Terminology shifts such as affiliate to partner, partner to affiliate, merchant to creator, or admin being introduced without canonical terminology updates.
- Meaningful behavior files changed without tests, a regression test, or a documented test exception.
- High-risk payment/auth/security/persistence files changed without verification or governance updates.
- Regression language appears, such as reintroduced, previously fixed, or bug returned.
- Build/test/check results fail for core behavior.
- Governance expects lint/typecheck/check scripts, but package scripts do not expose them.

Rule-based detection should produce specific reasons, not vague drift claims.

## Execution Scope

Execution gates should not block normal product evolution. User-requested non-risk feature changes should usually warn or pause for planning depending on size. STOP is reserved for critical conflicts, regressions, high-risk undocumented changes, weakened verification, destructive behavior, or canonical truth overwrite attempts.

## Standard Truth Alignment Report

Truth Sync and Reconciliation reports should use `.wwg/reports/truth-alignment-report.md` or a command-specific sibling report under `.wwg/reports/`.

Required sections:

- `# WWG Truth Alignment Report`
- `## Status`
- `## Execution Gate` or an equivalent gate line in Status
- `## Why This Was Flagged`
- `## Evidence`
- `## Recommended Natural Prompt`
- `## Backup CLI Commands`
- `## Suggested Project Truth Updates`
- `## Suggested Reconciliation Actions`
- `## Test / Quality Expectations`
- `## Decision Log Entry Draft`

Suggested Project Truth Updates must be drafts or bullets only. WWG must not silently overwrite canonical truth unless a future command explicitly implements confirmed editing behavior.
