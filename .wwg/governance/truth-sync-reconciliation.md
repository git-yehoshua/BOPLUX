# Truth Sync and Reconciliation

## Purpose

Define the report-first workflow for deciding what happens after Truth Alignment detects YELLOW, ORANGE, or RED issues.

Requirement evolution is normal. Not every mismatch is harmful drift. The decision is whether the new direction should be accepted into Project Truth or whether recent docs, reports, implementation, terminology, or tests should be reconciled back to current Project Truth.

## Decision Paths

### Accept as New Truth

Use when a recent feature, scope, architecture, terminology, or behavior change was intentional.

Expected result:

- Project Truth is updated.
- Terminology is updated if needed.
- Requirements, current-task, history, and decision docs are updated.
- Reports no longer present the accepted change as unresolved drift.

Natural prompt:

```txt
Tell the agent: "Accept this as an intentional requirement change and sync Project Truth, terminology, and requirements docs with the latest implementation and reports."
```

Backup CLI:

```bash
npm run wwg -- update-truth --target .
```

### Reconcile to Existing Truth

Use when recent changes are accidental, premature, or contradictory.

Expected result:

- Recent docs, reports, and copy are corrected.
- Implementation is adjusted when needed.
- Project Truth remains the authority.

Natural prompt:

```txt
Tell the agent: "Treat the latest mismatch as unintended drift and reconcile recent docs, reports, and implementation back to the current Project Truth."
```

Backup CLI:

```bash
npm run wwg -- reconcile --target .
```

### Investigate / Plan First

Use when the change may be valid but is too large or risky to accept automatically, especially payment, auth, security, persistence, major persona, business model, architecture, or conflicting-truth changes.

Expected result:

- A planning/reconciliation review report is generated.
- Canonical truth is not rewritten without explicit decision.

Natural prompt:

```txt
Tell the agent: "Pause implementation and create a planning review comparing Project Truth, recent docs, reports, tests, and implementation before making more changes."
```

Backup CLI:

```bash
npm run wwg -- plan --target .
```

### Regression / Quality Repair

Use when a previously fixed issue returns, tests are removed or weakened, meaningful behavior changed without tests, or quality gates are missing.

Expected result:

- Add or update regression tests.
- Document the regression or quality gap.
- Repair implementation and governance/reporting as needed.

Natural prompt:

```txt
Tell the agent: "Treat this as a regression or quality gap. Add or update meaningful tests, document the issue, and repair the implementation."
```

Backup CLI:

```bash
npm run wwg -- regression-check --target .
```

## CLI Support

- `wwg align-check --target .` writes the Truth Alignment report and recommends a decision path.
- `wwg update-truth --target .` writes a guided Project Truth update draft without silently editing canonical truth.
- `wwg reconcile --target .` writes suggested reconciliation actions without silently editing docs, reports, implementation, or tests.
- `wwg plan --target .` writes a planning/reconciliation review when intake planning is not available for the target.
- `wwg regression-check --target .` writes regression and quality repair guidance.

Truth Sync reports must prefer the selected decision path's natural prompt and backup CLI command over generic alignment-level defaults. For example, a `reconcile` report should show the Reconcile to Existing Truth prompt and `npm run wwg -- reconcile --target .` backup even when the underlying alignment status is YELLOW and generic alignment guidance would otherwise suggest `update-truth`.

## Planning Review Required Output

When the Execution Gate is `pause_for_plan`, WWG should generate a Planning Review Required result instead of implementation instructions.

Required top-level structure:

- `# WWG Planning Review Required`
- `## Why Planning Is Required`
- `## Current Project Truth`
- `## Proposed / Detected Change`
- `## Decision Needed`
- `## Recommended Natural Prompt`
- `## Backup CLI Commands`
- `## Suggested Next Actions`

Decision choices:

1. Accept as New Truth
2. Reconcile to Existing Truth
3. Split into New Requirement
4. Treat as Regression / Quality Repair

Natural prompt:

```txt
Tell the agent: "Pause implementation and create a planning review comparing Project Truth, recent docs, reports, tests, and implementation before making code changes."
```

Backup CLI:

```bash
npm run wwg -- plan --target .
```

## Execution Stopped Output

When the Execution Gate is `stop`, WWG should generate an Execution Stopped result.

Required top-level structure:

- `# WWG Execution Stopped`
- `## Why Execution Was Stopped`
- `## Required Resolution`
- `## Recommended Natural Prompt`
- `## Backup CLI Commands`

Resolution choices:

1. Confirm this is intentional and update Project Truth first.
2. Reconcile implementation/docs back to Project Truth.
3. Repair regression and add/update tests.
4. Create a planning review before proceeding.

Natural prompt:

```txt
Tell the agent: "Stop implementation. Resolve the Project Truth conflict or regression first, then continue."
```

Backup CLI:

```bash
npm run wwg -- align-check --target .
npm run wwg -- reconcile --target .
npm run wwg -- regression-check --target .
npm run wwg -- plan --target .
```

## Safety

This workflow is report-first and does not silently rewrite Project Truth. Execution Gate guidance tells the agent what to do next: `allow`, `warn`, `pause_for_plan`, or `stop`. Requirement evolution remains allowed, and normal non-risk changes should not stop execution. `stop` is reserved for meaningful risk such as direct Project Truth contradiction, regression, high-risk undocumented domain change, weakened verification, destructive or irreversible behavior, governance/audit/report/history removal, or canonical truth overwrite attempts.
