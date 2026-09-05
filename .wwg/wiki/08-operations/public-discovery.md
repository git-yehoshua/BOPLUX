# Public Discovery

## Purpose

Define public discovery, SEO, GEO, and AI crawler readiness for public WWG projects.

## Compiled Truth

Public discovery surfaces include canonical host policy, canonical URLs, redirect policy, metadata, Open Graph metadata, Twitter/X card metadata, sitemap, robots.txt, llms.txt, structured data / JSON-LD, index/noindex route policy, public route registry, Search Console/webmaster issues, and AI crawler or LLM discovery surfaces.

Every public project should declare a canonical production host. Legacy, staging, preview, and temporary hosts must not leak into production metadata.

## Public Route Policy

| Route Type | Default Index Policy | Sitemap | Notes |
|---|---:|---:|---|
| Marketing pages | index | include | Must use canonical metadata |
| Public docs | index | include | Only approved docs |
| Release notes / changelog | index | include | Only approved public entries |
| Public content hubs | index | include | Must avoid stale/generated junk |
| Auth/session routes | noindex | exclude | Never public discovery targets |
| Admin dashboards | noindex | exclude | Usually private |
| User dashboards | noindex | exclude | Private/account-specific |
| Operational routes | noindex | exclude | Health/debug/internal |
| Redirect-only routes | noindex | exclude | Canonical target should be indexed |
| Ephemeral/generated routes | noindex | exclude | Unless explicitly approved |
| Staging/preview routes | noindex | exclude | Must not appear in prod metadata |

## Rules

- Public metadata should be generated from canonical helpers or documented source-of-truth files.
- Indexable and noindex routes must be explicitly classified.
- Private, admin, auth, operational, redirect-only, and ephemeral routes should be noindex and excluded from sitemap by default.
- Public release notes, docs, changelogs, content hubs, and approved marketing pages may be indexable.
- `llms.txt` should list approved canonical public routes and project docs intended for AI/LLM discovery when applicable.
- Structured data should be used only when it truthfully describes the page.

## Validation Expectations

- Canonical URLs use production host.
- Sitemap contains only approved canonical URLs.
- robots.txt references canonical sitemap.
- Indexable pages have titles, descriptions, and canonical URLs.
- Open Graph and Twitter/X URLs match canonical URL.
- Private/admin/auth/ephemeral routes are noindex.
- llms.txt contains only approved canonical public routes.
- Structured data matches visible page truth.
