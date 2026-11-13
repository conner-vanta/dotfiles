---
name: conner-pr-workflow
description: Prepare or update Conner’s PEX and SNOW pull requests with local Greptile, Codex, and Claude reviews before draft creation and project-specific PR requirements. Use for PRs tied to PEX or Snowplow tickets, including Snowplow batches; not for other Jira projects or read-only code review.
---

# Prepare a PEX or SNOW pull request

Follow the repository’s `commit-and-pr` skill for branch, commit, draft PR, and
security-label standards when available. These personal preferences specialize
that workflow for PEX and SNOW work. An explicit user instruction takes precedence.

Before creating a draft PR, read and complete the
[local AI review workflow](references/local-ai-reviews.md). Run Greptile, Codex,
and Claude locally on Ona and incorporate their feedback before the shared
workflow's PR-creation step, including any stack command that creates drafts.
Conner authorizes sending the committed branch diff to Greptile for this workflow.
Keep the draft uncreated until all three reviews are complete and every finding
has a disposition, unless Conner explicitly waives a missing review. The bundled
reference preserves the commands from the
[AI Code Reviews Guru card](https://app.getguru.com/card/Tzgzb46c/AI-Code-Reviews)
so the workflow does not depend on that card remaining available.

After completing the shared review step, apply the matching project requirements:

- **PEX:** prefix the title with `[BE]`, `[FE]`, or `[BE + FE]` for the affected
  application layers. Read [PEX PR requirements](references/pex-pr.md) for the
  body template, architecture examples, frontend evidence, and deployment rules.
- **SNOW:** follow the [SNOW PR requirements](../conner-ticket-workflow/references/snow.md#draft-pull-request),
  using the repository template, `[SNOW-XXX]` title prefix, `proj-snowplow` and
  security-risk labels, and Jira status transition. SNOW PRs do not require
  diagrams or the PEX template. Apply the shared review step to every ticket's
  PR in a Snowplow batch as well as to individually requested SNOW PRs.
