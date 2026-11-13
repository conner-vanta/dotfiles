# Local AI reviews before draft creation

Source: [AI Code Reviews](https://app.getguru.com/card/Tzgzb46c/AI-Code-Reviews),
retrieved November 13, 2026; card last modified November 10, 2026. The command
table below preserves the card's Ona instructions. The preparation and feedback
loop are Conner's requirements for this PR workflow, supplemented by Obsidian's
local review skills. Reading the live card is optional; its unavailability must
not prevent use of these saved instructions.

## Commands preserved from Guru

Enter these commands in the indicated agent session opened in the Ona checkout;
they are agent commands, not shell commands.

| Reviewer | Local command | Alternative from the card |
| --- | --- | --- |
| Greptile | `/greptile-code-review` skill | None listed |
| Codex | `/review` command | `$local-code-review` skill |
| Claude Code | `/code-review` slash command | `/local-code-review` skill |

Use one command per reviewer, with an explicit request to review the intended
base-to-head diff locally and return findings without edits or GitHub comments.
Prefer the shared `local-code-review` skill for Codex and Claude when available;
it loads Obsidian's reviewer guidance and applicable `CODE_REVIEW*.md` rules.
Run Codex and Claude in their respective clients: two invocations of the shared
skill in the same client do not provide both reviews. If a command requires an
existing PR, use its listed local skill alternative; do not create a draft to
obtain the review. PR comment triggers and automatic PR reviews do not satisfy
this pre-draft step.

### Greptile shell entry point in Obsidian

Read `.agents/skills/greptile-code-review/SKILL.md`. Its verified wrapper can be
run from the repository root without an existing PR:

```bash
.agents/skills/greptile-code-review/scripts/run-greptile-code-review.sh --base <base-ref>
```

Replace `<base-ref>` with the intended base branch. The wrapper also accepts
`DOC_TOOLS_BASE_REF`; without either, it resolves the remote's default branch.
For a stack, pass the parent branch explicitly. Use `refs/heads/<parent>` for a
local-only parent or `origin/<parent>` to select the remote parent unambiguously.
The wrapper reviews committed patches through the official Greptile CLI using
existing authentication. Do not use `--include` to add uncommitted files.

## Prepare a common review target

1. Resolve the intended PR base using `commit-and-pr`: the parent branch for a
   stack, the recorded release base for a hotfix, otherwise the default branch.
   Complete relevant validation and commit the intended changes with hooks
   enabled. Greptile does not review uncommitted work; commit intended fixes
   before each subsequent review round as well.
2. Record the base ref, its commit SHA, and `git rev-parse HEAD`. Give all three
   reviewers the same `<base-ref>...HEAD` target. Keep that target unchanged
   while collecting their results; unrelated working-tree edits are outside it.
   For the shared local skill, set `DOC_TOOLS_BASE_REF` in each reviewer session
   to the intended base and provide the explicit range. Check the actual base
   and head used by each review, especially when a wrapper fetches the base.
3. Keep review runs read-only and collect each reviewer's findings and completion
   status in the working session. The implementing agent handles fixes after
   collecting the reviews. A review must actually complete; a launched command,
   timeout, or missing output is not a clean result.

## Incorporate feedback and finish

1. Combine findings from all three reviewers and deduplicate them while retaining
   their sources. Check each finding against the code and applicable guidance.
   Fix confirmed issues, and record a concrete reason for dismissing a false
   positive, duplicate, or inapplicable suggestion. Do not silently drop feedback
   or apply suggestions that would introduce a regression. Surface unresolved
   findings to Conner and keep draft creation blocked while they remain unresolved.
2. Run relevant validation for the fixes, commit them, and rerun all three
   reviewers on the resulting diff. If the base or head changes, refresh the
   reviews so all three cover the final committed snapshot. Continue until no
   actionable findings remain and every finding has a recorded disposition.
3. Before creating the draft, summarize each reviewer's result, the reviewed base
   and head SHAs, fixes made, dismissed findings and reasons, and validation in
   the working session. Preserve the PEX PR body template; this review record
   does not require another PR section. Then follow `commit-and-pr` to push and
   create the draft. These AI reviews supplement human review.

If a reviewer or required skill is unavailable, report which review is missing
and why; keep the draft uncreated unless Conner explicitly waives it. For an
authentication/authorization failure, load the Ona shell exports and retry the
failed command once without printing credentials. If it still fails, report the
blocker instead of repeatedly retrying or treating it as a pass. Follow the
Greptile wrapper's bounded retry guidance for other errors and retain any review
or correlation ID. After a timeout, retrieve the existing result with:

```bash
greptile review show <id> --agent --no-color
```
