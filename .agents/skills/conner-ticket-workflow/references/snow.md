# SNOW tickets

Apply these rules to SNOW tickets alongside the shared Jira workflow.

## Implementation

SNOW work does not require plan mode or a plan-approval pause. Give a concise
implementation outline in the current mode, then proceed through implementation
and verification unless the user explicitly requests planning only or another
stopping point. Determine scope from the ticket; not every SNOW ticket is a
Vitest migration. For migrations, follow the repository’s
`migrate-vitest-to-default` skill and its strict isolation verification requirements.

## Draft pull request

Use the repository’s `commit-and-pr` skill and current PR template directly.
Do not load `conner-pr-workflow` or apply PEX’s template or architecture-diagram
requirement. SNOW PRs do not require diagrams.

- Prefix the title with the actual ticket key, for example
  `[SNOW-6] Migrate cloud-data-capture-service tests to the default Vitest configuration`.
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

For Vitest migration PRs:

- **Changes:** briefly describe the runner change and any necessary test or
  configuration adaptations. Do not call it configuration-only if tests or
  implementation code changed.
- **Motivation:** link the ticket, explain the benefit, and report the measured
  before/after duration. Keep the overall duration improvement percentage and
  before/after values bold in the opening paragraph, above the timing table;
  do not move or repeat the percentage below the table. Retain the compact timing table with every reported
  phase and a short measurement command/context paragraph.
- **Testing:** after a successful strict check, write
  `Strict verification passed, using the @vanta/testing test isolation verifier.`
  Then include a fenced shell block containing the exact
  `just verify-test-isolation` CLI command that ran, including the workspace,
  project selection, and other options actually used. Fill in the real tool
  name and command; never leave `{tool name}` or `{tool cmd}` placeholders.
- **Deployment:** one short statement of actual dependencies or rollout needs.
- **AI Model used and major prompts used:** identify the actual model and tool
  concisely, for example `GPT-6 via Codex` when accurate.

Keep test inventories, diagnostics, reports, logs, and reproduction receipts in
the retained verification artifacts rather than expanding the PR description.
Still perform every required check. Disclose material failures, skipped required
checks, or unresolved limitations; concise presentation must not imply a pass
that was not obtained.

If the required skill or verification tool is unavailable after updating
the checkout, report the missing prerequisite rather than inventing a
replacement workflow.
