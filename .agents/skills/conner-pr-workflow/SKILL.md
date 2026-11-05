---
name: conner-pr-workflow
description: Prepare or update Conner’s pull requests, including PEX templates, SNOW migration descriptions and Jira status, and latest-commit Devin review. Use when creating, updating, or checking readiness of Conner’s PRs; not for read-only review of someone else’s PR.
---

# Prepare a pull request

Follow the repository’s `commit-and-pr` skill for branch, commit, draft PR, and
security-label standards when available. These personal preferences specialize
that workflow. An explicit user instruction takes precedence.

- For PEX PRs, read [PEX PR requirements](references/pex-pr.md), including the
  exact body template and bundled architecture examples.
- For SNOW PRs, prefix the title with the actual ticket key, for example
  `[SNOW-6] Migrate cloud-data-capture-service tests to the default Vitest configuration`.
  Use the current repository PR template, not the PEX template.
- For SNOW Vitest migration PRs, read [concise migration descriptions](references/snow-pr.md).
  This overrides the migration skill’s longer evidence presentation, not its checks.
- When creating a SNOW draft PR, move its Jira ticket to **In Progress** and verify
  the resulting status. If already further along, do not move it backward.

# Devin review requirement for all my PRs

I expect every PR I author to receive a passing Devin review with **no issues found** before it is considered ready to merge. This applies to every PR in a stack as well.

- When creating, updating, or babysitting my PRs, ensure Devin reviews the latest head commit. If automatic review has not run, trigger it with `/devin review` on the PR. Tell Devin that it should post a comment reporting what issues were found or that no issues were found.
- Address Devin's findings, run the relevant validation, push the fixes, and request another review until Devin explicitly reports **“Devin Review: No Issues Found”** (or an equivalent clean result) for the latest head commit.
- A green check that only confirms review completion, resolved comment threads, or a clean review of an older commit does not satisfy this requirement.
- If Devin is unavailable, cannot access the repository, or still reports issues, report that as a blocker. Do not claim the PR is ready or that this requirement has passed.
