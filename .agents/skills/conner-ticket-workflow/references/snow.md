# SNOW tickets

Apply these rules to SNOW tickets alongside the shared Jira workflow.

## Implementation

SNOW work does not require plan mode or a plan-approval pause. Give a concise
implementation outline in the current mode, then proceed through implementation
and verification unless the user explicitly requests planning only or another
stopping point. Determine scope from the ticket; not every SNOW ticket is a
migration. For `@vanta/testing` level/runtime entrypoint migrations (including
SNOW-1320), follow `skills/workflows/migrate-to-vanta-testing/SKILL.md` (or its
installed skill path) and its references. Preserve current test classification
and behavior, verify before/after file and test inventories, and run the required
scoped checks.

## Draft pull request

Load the sibling `conner-pr-workflow` skill and complete its shared local
Greptile and Codex reviews and feedback resolution before creating a
draft PR. This applies to individual SNOW tickets and every PR in a Snowplow
batch. Then use the repository’s `commit-and-pr` skill and current PR template
with the SNOW requirements below. SNOW PRs do not require diagrams or PEX’s
template.

- Prefix the title with the actual ticket key, for example
  `[SNOW-763] Migrate ui-kit-agent-tools tests to @vanta/testing`.
- Add the `proj-snowplow` GitHub label to every SNOW PR, including drafts and
  non-migration work, alongside the required security-risk label. Verify both
  labels after creation.
- When creating the draft PR, move its Jira ticket to **In Progress** and verify
  the resulting status. If already further along, do not move it backward.

## Concise PR description preference

Keep every required repository template heading, but keep the prose short.
Prefer one or two sentences per section and omit repeated facts, boilerplate,
and detailed verification receipts. Use
[SNOW-13 PR #216963](https://github.com/VantaInc/obsidian/pull/216963) as a style
example, not as a source of results to copy.

For `@vanta/testing` entrypoint migration PRs, follow `migrate-to-vanta-testing`’s
PR reference for classification, naming changes, file/test count parity, config
changes, and edge cases. Include the scoped validation results and any reusable
migration-skill improvements discovered during the work.

Keep detailed inventories, diagnostics, reports, logs, and reproduction receipts in
the retained verification artifacts rather than expanding the PR description.
Still perform every required check. Disclose material failures, skipped required
checks, or unresolved limitations; concise presentation must not imply a pass
that was not obtained.

If the required skill or verification tool is unavailable after updating
the checkout, report the missing prerequisite rather than inventing a
replacement workflow.
