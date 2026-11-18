---
name: conner-snowplow-batch
description: Pick up unassigned Snowplow tickets from SNOW-1320 (@vanta/testing migration), assign them to the user, and delegate one ticket per subagent through migration and draft PR creation. Use for “pick up a new batch of snowplow tickets”, “do more snowplow tickets”, or a request to take on a specified number of Snowplow tickets. Not for read-only backlog inspection or implementing a single named ticket.
---

# Pick up a Snowplow batch

Select work from [SNOW-1320](https://vanta.atlassian.net/browse/SNOW-1320),
claim it for the user, and carry each ticket through implementation, verification, and draft PR creation
using subagents. This skill authorizes delegation when invoked;
creating or editing the skill does not start a batch.

## 1. Establish the batch

- Use the requested positive integer as the batch size. If omitted, default to
  **3** and state that choice. “More” means a new batch of unassigned tickets,
  not resuming tickets already assigned to the user.
- Use SNOW-1320 for `@vanta/testing` migrations and state the epic alongside
  the batch size.
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

Fetch **all pages** of unassigned, unfinished direct children of SNOW-1320:

```sh
acli jira workitem search \
  --jql 'parent = SNOW-1320 AND assignee IS EMPTY AND statusCategory != Done' \
  --fields key,summary,status,assignee,parent --paginate --json
```

These are backend/frontdoor workspace migrations with 1–4 test files. Extract
`(N files)` or `(N file)` from the summary and rank by file count ascending, then
numeric issue key ascending. If the count is missing or ambiguous, read the
description’s `Test files found` field; if still unknown, rank after known counts
and report it as unknown.

Take the first X candidates. Show their keys, summaries, and file counts before
assignment as a progress update; no additional confirmation is needed.
If fewer are eligible, take the available candidates and report the shortfall.
If none qualify, report that and stop without creating branches or subagents.
On search/authentication failure, follow the override’s authentication recovery;
if still blocked, report the error rather than treating it as an empty backlog.

## 3. Claim and verify ownership

For each selected ticket, recheck eligibility immediately before assigning it.
Use a constrained query so a candidate that is no longer unassigned is excluded:

```sh
snow_epic=SNOW-1320
snow_ticket=SNOW-763
acli jira workitem assign \
  --jql "key = ${snow_ticket} AND parent = ${snow_epic} AND assignee IS EMPTY AND statusCategory != Done" \
  --assignee '@me' --yes --json
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
  summary/description, including the canonical workspace and path.
- Its exclusive worktree path and branch, plus the updated base revision. State
  that the parent completed default-branch and branch setup, so the agent should
  continue at ticket loading/scope confirmation rather than redo checkout steps.
- Instructions to follow `conner-ticket-workflow`, `references/snow.md`, and
  `conner-pr-workflow`'s shared local review step, plus the repository migration
  skill selected below. SNOW work needs no plan-mode gate, PEX template, or diagrams.
- The full completion scope: implement, run required verification, commit, run
  local Greptile and Codex reviews for this ticket's diff, incorporate
  feedback and complete any required re-reviews, then push and create a draft PR
  with `[SNOW-XXX]` and `proj-snowplow`. Verify the Jira transition to In Progress
  without moving a later status backward. A missing review blocks that ticket's
  draft unless Conner explicitly waives it.
- Instructions to stay within its ticket, preserve other agents’ changes, and
  return its PR URL, validation and local-review results, migration evidence
  required by the selected skill, and any blockers. Do not merge PRs or mark
  tickets Done merely for opening drafts.

### Perform the @vanta/testing migration

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
  its relevant reference in the ticket’s PR and describe the finding. Keep
  package-specific details in PR evidence; coordinate overlapping shared-skill
  edits across agents.

Resolve missing migration skills through the repository skill catalog after the
checkout update. If a required skill or tool remains unavailable, report the
missing prerequisite rather than inventing a replacement workflow.

Coordinate expensive builds and tests across subagents. Separate worktrees alone
do not isolate CPU, memory, or shared test services.

## 5. Follow through and report

Monitor the subagents, handle actionable blockers, and dispatch queued work as
slots free up. Do not stop after spawning agents. Do not repeatedly dispatch a
ticket whose failure requires user input or an unavailable external prerequisite.

Return a compact table with ticket link, file count, assignment, PR link or
blocker, and validation outcome. Report skipped candidates, shortages,
and claimed tickets that could not be completed. Distinguish draft PR creation
from merge readiness; ongoing PR babysitting is a separate workflow.
