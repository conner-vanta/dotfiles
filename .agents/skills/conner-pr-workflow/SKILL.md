---
name: conner-pr-workflow
description: Prepare or update Conner’s PEX pull requests with local Greptile, Codex, and Claude reviews before draft creation, plus the required title prefix, body template, architecture diagrams, and UI evidence. Use for PRs tied to PEX tickets; not for SNOW tickets, other Jira projects, or read-only code review.
---

# Prepare a PEX pull request

Follow the repository’s `commit-and-pr` skill for branch, commit, draft PR, and
security-label standards when available. These personal preferences specialize
that workflow for PEX work. An explicit user instruction takes precedence.

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

Prefix the title with `[BE]`, `[FE]`, or `[BE + FE]` for the affected application
layers. Read [PEX PR requirements](references/pex-pr.md) for the exact body
template, architecture examples, frontend evidence, and deployment requirements.
