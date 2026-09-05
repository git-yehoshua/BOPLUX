# Context Maintenance Matrix

## Purpose

Answer which canonical artifacts must be reviewed, which must be updated when behavior changes, which public surfaces need review, whether release/public drafts are required, whether skill updates are required, and which governance checks apply.

## Compiled Truth

The global project master context is the overview, not the only upkeep target. Update dedicated canonical context files when their domain truth changes.

Reference/history docs are not automatically updated unless explicitly refreshed or promoted. When in doubt, update the canonical doc first and leave reference/history docs unchanged unless the task needs them refreshed.

Profiles may extend the matrix with domain-specific rows.

## Canonical Families

Universal canonical families:

- project/product
- requirements
- domain/rules
- architecture/runtime
- data/persistence
- security/permissions
- ux/design
- operations/reliability
- public surfaces
- public discovery
- agent context/skills
- governance/release

Profile extension examples:

- game: mechanics, match lifecycle, economy, ranking, replay/spectator, anti-cheat
- fintech: payment flows, ledger/reconciliation, risk/compliance, provider integrations, audit
- agent-webapp: agent roles, tool permissions, memory boundaries, evaluation, prompt/skill registry

## Matrix

| Change Category | Canonical Artifacts Checked | Update When Behavior Changed | Public/User-Facing Surfaces to Review | Release/Public Draft Required | Skill Updates Required | Governance Checks |
|---|---|---|---|---|---|---|
| Major feature | project master context, requirements, domain/rules, architecture/runtime, UX/design | requirements, dedicated context, project master context if overview changes | release notes, docs, onboarding, admin/user notices | yes if user-facing | feature skill if workflow repeats | validation plan, quality gates, maintenance review |
| Bug fix with canonical behavior impact | known issues, affected canonical family, bug-fix skill, guardrail catalog | affected canonical docs only if truth changed | support notes, known issues, release note if user-visible | maybe | bug-fix or guardrail skill if workflow changed | regression guardrail, test plan, evidence standards |
| Architecture / runtime change | architecture/runtime, deployment model, runtime context, ADRs | runtime context, deployment model, ADRs | operational notices if user impact | maybe | runtime-infrastructure skill if workflow changed | operational readiness, approval matrix, evidence standards |
| Data model / persistence change | data/persistence, data model, Runtime Truth, migration notes | data model, runtime context, domain entities | migration notices if users/admins affected | maybe | migration/data skill if reusable | migration checks, rollback plan, approval matrix |
| Security / permissions change | security/permissions, constraints, human approval matrix | security model, governance context, role/permission docs | permission notices, trust/safety copy | yes when public/trust impact | security-review skill if workflow changed | security review, approval-gated review |
| UI / UX / design system change | UX/design, screens, design principles, content guidelines | UX context, screens, design source-of-truth | public UI copy, help docs, onboarding | maybe | design/update skill if reusable | UX QA, accessibility review |
| Public discovery / SEO / GEO change | public discovery context, public discovery page, route policy | public discovery context, public discovery docs | public metadata, sitemap, robots.txt, llms.txt | maybe | public-discovery maintenance skill | public discovery review, public-surface review |
| Public content / release-note change | public surfaces, glossary, content guidelines | public-surface docs, content guidelines | release notes, help docs, changelog, app store copy | yes | public-surface skill if workflow changed | public-surface review, approval matrix |
| Cloud / deployment / infrastructure change | architecture/runtime, deployment model, runbooks, monitoring | deployment model, runtime context, runbooks | status notices if user impact | maybe | runtime-infrastructure skill if workflow changed | operational readiness, rollback plan |
| Production monitoring / read-only audit | monitoring, operations report template, known issues | known issues or monitoring docs only if truth changed | status pages or customer notices if confirmed issue | maybe | production-monitoring skill if workflow changed | evidence standards, operational readiness |
| Regression guardrail / signoff learning | guardrail catalog, signoff learnings, test plan | guardrail catalog, signoff learnings, test plan | release notes if user-visible | maybe | regression-guardrail skill if workflow changed | regression guardrail catalog, release checklist |
| Recommendation capture / future-work candidate | recommendation policy, recommendation registry, current task, affected canonical family | recommendation registry only unless the item is explicitly promoted into active work or accepted truth | no unless public docs changed | no | no unless recurring workflow changed | recommendation policy, maintenance review |
| Agent behavior / prompt / skill change | agent context/skills, prompt registry, skill index | generated context, skill files, prompt files | tool capability notices if public | maybe | yes | tool permission review, context drift detection |
| Governance / approval policy change | governance/release, approval matrix, quality gates | governance docs, project master context if overview changes | stakeholder notices if policy affects users | maybe | governance skill if reusable | approval matrix, enforcement levels |
| Principle / durable reasoning change | principles, project truth, terminology, decisions, affected canonical family | principle brief, decisions, generated context, AGENTS guidance when agent behavior changes | docs or onboarding if public reasoning changes | maybe | context/skill maintenance skill if workflow changed | principle drift guard, maintenance review |
| Profile-specific domain rule change | profile docs, domain/rules, selected profile canonical families | profile docs, domain context, project master context if global | profile-specific public surfaces | maybe | profile skill if reusable | profile gates, approval matrix |
| Template-vs-project change | project master context, Project Truth, upstream template defaults, local generated files | local Project Truth first; update template defaults only when improving reusable standards | docs, reports, generated-project defaults if affected | maybe | context/skill maintenance skill if workflow changed | template-project drift check, migration review |
| Workspace generation | wiki source artifacts, workspace templates, registry selected profiles | generated Workspace sections, generation reports, registry last_generated.workspace | docs if command behavior changed | maybe | context/skill maintenance skill if workflow changed | generated marker check, context drift detection |
| Governance generation | wiki source artifacts, governance templates, registry selected profiles | generated Governance sections, generation reports, registry last_generated.governance | docs if command behavior changed | maybe | governance skill if workflow changed | approval matrix, generated marker check |
| Context refresh | dedicated Wiki context sources, registry, workspace context templates | generated context sections, refresh reports, registry last_generated.context | no unless public docs changed | no | context maintenance skill if workflow changed | context drift detection, evidence standards |
| Skill refresh | Wiki skill specs, workspace skill templates, profile skills | workspace skill files, skill index, refresh reports, registry last_generated.skills | no unless public docs changed | no | yes | generated marker check, maintenance review |
| Source intake | source index, raw source records, UX/design references, registry source metadata | source-index files, URL/note records, reference screenshots, design preferences | docs if intake behavior changed | no | source workflow skill if repeated | source validation, generated marker check, secret-file review |

## Maintenance Rule

If a change creates reusable procedure knowledge, update or create a skill. If a change alters agent instructions, update workspace context. If a change alters project truth, update the canonical wiki file first or immediately after implementation investigation.

---

## Maintenance Notes

- Keep rows current-state oriented.
- Route project-specific history to `log.md`, reports, changelog, or history docs.
- Add profile-specific rows only when they are reusable for generated projects.
