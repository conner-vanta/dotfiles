---
name: conner-pr-workflow
description: Prepare or update Conner’s pull requests, including PEX templates, SNOW migration descriptions and Jira status. Use when creating or updating Conner’s PRs; not for read-only review of someone else’s PR.
---

# Prepare a pull request

Follow the repository’s `commit-and-pr` skill for branch, commit, draft PR, and
security-label standards when available. These personal preferences specialize
that workflow. An explicit user instruction takes precedence.

- For PEX PRs, prefix the title with `[BE]`, `[FE]`, or `[BE + FE]` for the
  affected application layers. Read [PEX PR requirements](references/pex-pr.md)
  for the exact body template and bundled architecture examples.
- For SNOW PRs, prefix the title with the actual ticket key, for example
  `[SNOW-6] Migrate cloud-data-capture-service tests to the default Vitest configuration`.
  Add the `proj-snowplow` GitHub label to every SNOW PR, including drafts and
  non-migration work, alongside the required security-risk label. Verify the
  labels after creation. Use the current repository PR template, not the PEX
  template.
- For SNOW Vitest migration PRs, read [concise migration descriptions](references/snow-pr.md).
  This overrides the migration skill’s longer evidence presentation, not its checks.
- When creating a SNOW draft PR, move its Jira ticket to **In Progress** and verify
  the resulting status. If already further along, do not move it backward.

For tickets from other Jira projects, follow repository PR conventions; the
PEX/SNOW title, label, template, and status rules above apply only to those projects.
