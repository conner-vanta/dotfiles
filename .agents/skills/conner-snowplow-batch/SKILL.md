---
name: conner-snowplow-batch
description: Pick up a batch of unassigned SNOW-1 epic tickets with the fewest blockers in their titles, assign them to the user, and delegate one ticket per subagent. Use for “pick up a new batch of snowplow tickets”, “do more snowplow tickets”, or a request to take on a specified number of Snowplow tickets. Not for read-only backlog inspection or implementing a single named ticket.
---

# Pick up a Snowplow batch

Select work from [SNOW-1](https://vanta.atlassian.net/browse/SNOW-1), claim it for
the user, and carry each ticket through implementation, verification, and draft
PR creation using subagents. This skill authorizes delegation when invoked;
creating or editing the skill does not start a batch.

## 1. Establish the batch

- Use the requested positive integer as the batch size. If omitted, default to
  **3** and state that choice. “More” means a new batch of unassigned tickets,
  not resuming tickets already assigned to the user.
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

Fetch **all pages** of unassigned, unfinished direct children of the epic:

```sh
acli jira workitem search \
  --jql 'parent = SNOW-1 AND assignee IS EMPTY AND statusCategory != Done' \
  --fields key,summary,status,assignee --paginate --json
```

Parse the JSON and extract the integer from each summary’s `(N blockers)` or
`(N blocker)` suffix, case-insensitively. Rank by that integer ascending, then
by the numeric part of the issue key ascending for deterministic ties. For
example, 2 blockers ranks before 11; among equal counts, SNOW-9 precedes SNOW-10.
Use the title’s stated count, not issue links, live code analysis, or lexical
summary order. Never interpret a missing count as zero: exclude titles without
an unambiguous nonnegative integer count and report them separately.

Take the first X candidates. Show their keys, summaries, and blocker counts
before assignment as a progress update; no additional confirmation is needed.
If fewer are eligible, take the available candidates and report the shortfall.
If none qualify, report that and stop without creating branches or subagents.
On search/authentication failure, follow the override’s authentication recovery;
if still blocked, report the error rather than treating it as an empty backlog.

## 3. Claim and verify ownership

For each selected ticket, recheck eligibility immediately before assigning it.
Use a constrained query so a candidate that is no longer unassigned is excluded:

```sh
acli jira workitem assign \
  --jql 'key = SNOW-123 AND parent = SNOW-1 AND assignee IS EMPTY AND statusCategory != Done' \
  --assignee '@me' --yes --json
acli jira workitem view SNOW-123 --fields summary,description,assignee,status,parent --json
```

Substitute the real key and resolved assignee. Verify the assignee, epic, and
unfinished status from the read-back, and retain the fetched summary/description
for delegation. Empty required fields are a blocker; do not fabricate scope.
Query-based assignment reduces the race window but is not an atomic claim.
Never intentionally replace another assignee. If another user took a candidate,
skip it and select the next eligible ticket from a refreshed ranking. Do not
dispatch an agent without verified ownership. Report partial assignment failures;
do not silently unassign successfully claimed tickets or repeatedly retry a
failing mutation.

## 4. Delegate one ticket per subagent

Use subagent tools, not user-visible chat/thread creation. Queue tickets when the
batch exceeds available agent slots; create one subagent for each claimed ticket
as capacity becomes available. Keep a ledger of ticket, blocker count, assignee,
worktree, branch, agent, and result so no ticket is dispatched twice.

The parent performs the shared ticket workflow’s default-branch update once,
preserving unrelated changes. Prepare a separate Git worktree for each ticket
with its `conner/SNOW-XXX` branch from that updated default branch. Follow the
ticket workflow’s existing-branch handling rather than resetting branches. Never
have multiple agents check out branches or edit files in the same worktree.
Ensure each worktree can access the installed personal skills and required
repository tooling; pass absolute skill paths when the local copies are untracked.

Give each subagent:

- Its exact ticket key, Jira URL, and fetched summary/description.
- Its exclusive worktree path and branch, plus the updated base revision. State
  that the parent completed default-branch and branch setup, so the agent should
  continue at ticket loading/scope confirmation rather than redo checkout steps.
- Instructions to follow `conner-ticket-workflow`, `references/snow.md`, and
  `conner-pr-workflow`'s shared local review step, plus the repository migration
  skill when the ticket requires it. SNOW work needs no plan-mode gate, PEX
  template, or diagrams.
- The full completion scope: implement, run required verification, commit, run
  local Greptile, Codex, and Claude reviews for this ticket's diff, incorporate
  feedback and complete any required re-reviews, then push and create a draft PR
  with `[SNOW-XXX]` and `proj-snowplow`. Verify the Jira transition to In Progress
  without moving a later status backward. A missing review blocks that ticket's
  draft unless Conner explicitly waives it.
- Instructions to stay within its ticket, preserve other agents’ changes, and
  return its PR URL, validation and local-review results, retained timing/isolation
  evidence, and any blockers. Do not merge PRs or mark tickets Done merely for
  opening drafts.

Coordinate expensive builds, tests, and benchmarks across subagents. Baseline and
after timings must use comparable resources without competing batch workloads;
serialize measurement phases and pause other CPU-heavy batch work as needed.
Separate worktrees alone do not isolate CPU, memory, or shared test services.

## 5. Follow through and report

Monitor the subagents, handle actionable blockers, and dispatch queued work as
slots free up. Do not stop after spawning agents. Do not repeatedly dispatch a
ticket whose failure requires user input or an unavailable external prerequisite.

Return a compact table with ticket link, title blocker count, assignment,
PR link or blocker, and validation outcome. Report skipped candidates, shortages,
and claimed tickets that could not be completed. Distinguish draft PR creation
from merge readiness; ongoing PR babysitting is a separate workflow.
