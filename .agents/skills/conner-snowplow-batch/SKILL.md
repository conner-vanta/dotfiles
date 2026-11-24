---
name: conner-snowplow-batch
description: Pick up a batch of unassigned children from a Snowplow epic given by key or Jira URL, migrate them, and mark each independent PR ready for review after CI passes. Use for “do a batch of tickets from SNOW-1318”, “do more Snowplow tickets”, or a requested batch size. For a single named child, use conner-ticket-workflow.
---

# Pick up a Snowplow batch

Claim work from the selected epic for the user and delegate implementation and
verification per ticket. Aim for one or two draft PRs grouped by Approval Bot
eligibility. Open additional independent drafts whenever the size limit requires it.
This skill authorizes delegation when invoked;
creating or editing the skill does not start a batch.

## 1. Establish the batch

- Use the requested positive integer as the batch size. If omitted, default to
  **3** and state that choice. “More” means a new batch of unassigned tickets,
  not resuming tickets already assigned to the user.
- Extract the epic key from the request or its Jira browse URL. For “more” without a new epic, reuse
  the epic from the current batch. Default to SNOW-1320 when no epic is specified
  or established. The numeric part of an issue key is never a batch size.
- Set `snow_epic` to the resolved key (format `SNOW-<digits>`). Read it with
  `acli jira workitem view "$snow_epic" --fields issuetype,summary,description --json`.
  Verify it is a Snowplow epic and read its migration instructions and references.
  If the supplied epic is invalid or inaccessible, report the issue. Use the
  verified key throughout selection, claims, delegation, and PRs. State the
  epic and batch size before searching.
- Read the sibling `conner-ticket-workflow/SKILL.md`, its `references/snow.md`,
  and `conner-pr-workflow/SKILL.md` for the required reviews before draft creation.
  Confirm git, authenticated `acli`, subagent tools, and the repository’s required
  migration/verification tools are available before claiming tickets. Resolve the
  user's Jira identity with `acli jira auth status`; use `@me` only if the CLI is
  authenticated as that user. If the account differs, resolve the user's account
  ID before assigning work; do not assign tickets to a service account by mistake.
- Proceed without plan mode or an approval pause. Honor an explicit request for
  preview-only selection, a different batch size, or another stopping point.

## 2. Find and rank candidates

Fetch **all pages** of unassigned, unfinished direct children of the verified epic:

```sh
acli jira workitem search \
  --jql "parent = ${snow_epic} AND assignee IS EMPTY AND statusCategory != Done" \
  --fields key,summary,status,assignee --paginate --json
```

For workspace test migrations of any size, extract
`(N files)` or `(N file)` from the summary and rank by file count ascending, then
numeric issue key ascending. If the count is missing or ambiguous, read the
description’s `Test files found` field; if still unknown, rank after known counts
and report it as unknown. For other epics, follow any ordering in the epic
instructions, then use ascending numeric issue key as the tie-breaker or default.

Take up to the requested batch size. Show keys, summaries, and any file counts before
assignment as a progress update; no additional confirmation is needed.
If fewer are eligible, take the available candidates and report the shortfall.
If none qualify, report that and stop without creating branches or subagents.
On search/authentication failure, follow the override’s authentication recovery;
if still blocked, report the error rather than treating it as an empty backlog.

## 3. Claim and verify ownership

For each selected ticket, recheck eligibility immediately before assigning it.
Use a constrained query so a candidate that is no longer unassigned is excluded:

```sh
# Use the selected child's key as snow_ticket and the verified Jira identity as snow_assignee.
acli jira workitem assign \
  --jql "key = ${snow_ticket} AND parent = ${snow_epic} AND assignee IS EMPTY AND statusCategory != Done" \
  --assignee "$snow_assignee" --yes --json
acli jira workitem view "$snow_ticket" --fields summary,description,assignee,status,parent --json
```

Set the real key, its selected epic, and the resolved assignee. Verify the
assignee, epic, and unfinished status from the read-back, and retain the fetched summary/description
for delegation. Empty required fields are a blocker; do not fabricate scope.
Query-based assignment reduces the race window but is not an atomic claim.
Never intentionally replace another assignee. If another user took a candidate,
skip it and select the next eligible ticket from a refreshed ranking. Do not
dispatch an agent without verified ownership. Report partial assignment failures;
do not silently unassign successfully claimed tickets or repeatedly retry a
failing mutation.

After confirming ownership, move tickets in a To Do category to **In Progress**
with `acli jira workitem transition --key "$snow_ticket" --status "In Progress" --yes`.
Read each ticket back and verify its epic, owner, and status before dispatch.
Preserve later statuses. If a transition fails, reconcile the current state and
report any blocked claim while continuing the others.

## 4. Delegate one ticket per subagent

Use subagent tools, not user-visible chat/thread creation. Queue tickets when the
batch exceeds available agent slots; create one subagent for each claimed ticket
as capacity becomes available. Keep a ledger of ticket, epic, migration type,
ranking count, assignee, worktree, branch, agent, and result so no ticket is dispatched twice.

The parent performs the shared ticket workflow’s default-branch update once,
preserving unrelated changes. Prepare a separate Git worktree for each ticket
with its `conner/SNOW-XXX` branch from that updated default branch. Follow the
ticket workflow’s existing-branch handling rather than resetting branches. Never
have multiple agents check out branches or edit files in the same worktree.
Ensure each worktree can access the installed personal skills and required
repository tooling; pass absolute skill paths when the local copies are untracked.

Give each subagent:

- Its exact ticket key, Jira URL, parent epic, migration type, and fetched
  summary/description, affected paths, and applicable instructions from the epic.
- Its exclusive worktree path and branch, plus the updated base revision. State
  that the parent completed default-branch and branch setup, so the agent should
  continue at ticket loading/scope confirmation rather than redo checkout steps.
- Instructions to follow the implementation guidance in `conner-ticket-workflow`,
  `references/snow.md`, and the migration guidance for its epic and ticket.
  SNOW work needs no plan-mode gate, PEX template, or diagrams.
- Implement, run the required verification, and commit locally. Leave publishing,
  combined-diff reviews, and Jira status transitions to the parent.
- Instructions to stay within its ticket, preserve other agents’ changes, and
  return its commit SHA(s), validation results, migration evidence required by
  the selected skill, and any blockers.

### Follow the migration instructions

Use the epic instructions together with the child ticket’s scope and acceptance
criteria. For other migration types, follow the referenced workflow and checks,
resolving any named skill in the repository catalog. Apply the following steps
when the work is an `@vanta/testing` entrypoint migration.

Load `skills/workflows/migrate-to-vanta-testing/SKILL.md` from the updated
Obsidian checkout (or its installed skill path) and its classification, verification,
and PR references. Pass its absolute path to the subagent. This is the migration
skill announced in the [rollout thread](https://vantahq.slack.com/archives/C0C8FQ51KS7/p1795011194431819)
and merged in [PR #227850](https://github.com/VantaInc/obsidian/pull/227850).

- Migrate only the ticket’s workspace: add the workspace dependency, rewrite
  test-authoring imports to the matching level/runtime entrypoint, and rename
  tests to reflect their current classification. Preserve test logic and product
  behavior; follow the skill’s handling of fixtures, globals, service tests,
  unavailable exports, and filename collisions.
- Capture the pre-migration file/test inventory, check config/globs after renames,
  and verify that the same tests run afterward. Run the ticket’s scoped tests,
  typecheck, and lint plus the skill’s required checks. Retain classification,
  rename, count-parity, and edge-case evidence for the PR.
- If the work reveals a reusable gap, update the repository migration skill or
  its relevant reference and describe the finding for the batch PR. Keep
  package-specific details in PR evidence; coordinate overlapping shared-skill
  edits across agents.

Resolve missing migration skills through the repository skill catalog after the
checkout update. If a required skill or tool remains unavailable, report the
missing prerequisite rather than inventing a replacement workflow.

Coordinate expensive builds and tests across subagents. Separate worktrees alone
do not isolate CPU, memory, or shared test services.

## 5. Group and publish the batch

Monitor the subagents, handle actionable blockers, and dispatch queued work as
slots free up. Do not stop after spawning agents. Do not repeatedly dispatch a
ticket whose failure requires user input or an unavailable external prerequisite.

Read Obsidian’s [live Approval Bot workflow](https://github.com/VantaInc/obsidian/blob/main/.github/workflows/ai-dx-pr-approval-live.yml)
and [assessment runner](https://github.com/VantaInc/obsidian/blob/main/scripts/pr-approval/run-live-assessment.sh)
from current `main` to identify the policy used for new approvals. Use that policy’s
coverage rules, high-risk signals, and PR-wide limits. The current entry points are
the [coverage policy](https://github.com/VantaInc/obsidian/blob/main/scripts/pr-approval/src/policies/placeholder-with-coverage.json)
and [assessment registry](https://github.com/VantaInc/obsidian/blob/main/scripts/pr-approval/src/assessments/registry/definitions.ts).

- Group verified changes by likely Approval Bot eligibility. Frontdoor changes,
  uncovered paths, high-risk signals, and uncertain cases go to human review.
  Check coverage for the complete diff, including generated files, dependency
  changes, lockfiles, TypeScript, and Bazel files. Check current workflow preflight
  requirements and record the assessment for each final diff. The live workflow makes the
  actual decision after the draft is ready.
- Start with one draft per nonempty group. Apply the [migration PR size limit](../conner-ticket-workflow/references/snow.md#migration-pr-size)
  to **both** groups. Split at ticket boundaries first. If a single ticket is
  too large, split it by independently testable workspaces or sets of files.
  Include the dependencies and configuration each slice needs to pass on its
  own. Account for every ticket’s full scope across its drafts.
- Assemble each PR on its own branch from updated `main` and target `main`
  directly. Each must build, pass its checks, and be mergeable in any order.
  If a change cannot be divided into independently valid PRs under the cap,
  report the specific blocker and continue with the other work.
- Run scoped verification and the [SNOW draft PR workflow](../conner-ticket-workflow/references/snow.md#draft-pull-request)
  on each resulting diff, including local Greptile and Codex reviews. Recheck
  size and Approval Bot eligibility after review fixes or regrouping. Link every
  included ticket in each draft and verify its owner and In Progress or later status.

## 6. Mark each PR ready for review after CI

When I ask you to do a Snowplow batch, I explicitly request that you mark each
PR ready for review once its draft CI passes. If I ask you to keep the PRs in
draft or give an earlier stopping point, honor that request.

Monitor each draft’s CI on its latest commit. Fix actionable failures, run
relevant validation, push the fixes, and check CI again on the new commit.
As soon as the CI checks that run on drafts pass for a PR, run
`gh pr ready <PR-URL>` and verify that `gh pr view <PR-URL> --json isDraft`
returns `isDraft: false`. Promote each PR independently. Approval Bot evaluates
the PR after promotion. If a PR is blocked, record the reason and continue with
the others.

## 7. Report

Return a compact table with ticket link, file count if applicable, assignment,
Jira status, all associated PR links or blocker, and validation outcome. Include
each PR’s changed-line total and verified review state. For any PR still in
draft, give the reason. Report skipped candidates, shortages, and claimed
tickets that could not be completed. Babysitting after promotion is a separate
workflow.
