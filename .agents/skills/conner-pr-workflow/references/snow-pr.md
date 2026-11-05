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
