---
name: conner-babysit-pr
description: Babysit Conner’s PRs and every PR in their stack, handle bot threads, and require clean latest-head Devin and 5/5 Greptile reviews. Use when Conner asks to babysit a PR or an identifiable current PR; not for a read-only review.
---

# Babysit Conner’s PRs

Load the repository’s `.agents/skills/babysit-pr/SKILL.md`. If unavailable,
report the missing prerequisite. Apply these preferences to its workflow:

1. Resolve the PR from the supplied URL or conversation. If it belongs to a GitHub
   stack, include every PR in that stack.
2. Address findings and reply directly in each Devin, Greptile, ai-tooling-app,
   or semgrep-code-vantainc thread. Leave threads unresolved. Do not include
   “after conner-vanta preauthorized this reply type without reviewing the draft.”
3. After addressing all comments, re-trigger Greptile and Devin. Require a 5/5
   Greptile score and explicit no-issues Devin results for the latest head of
   every watched PR, following the Devin review loop below.
4. Once a new review successfully runs, delete the comment used to re-trigger it.
   For Devin’s “Starting Devin Review” and “Devin Review found X issues” status
   comments, keep only the latest of each type and delete stale duplicates.
5. For duplicate ai-tooling-app “PeX audit-risk review” comments, keep the newest
   visible and hide the older ones as outdated.
6. Report remaining blockers. Babysitting is incomplete while any watched PR lacks
   a clean latest-head Devin review or the required Greptile score.

## Devin review requirement

I expect every PR I author to receive a passing Devin review with **no issues found** before it is considered ready to merge. This applies to every PR in a stack as well.

- For every PR being babysat, ensure Devin reviews the latest head commit. If automatic review has not run, trigger it with `/devin review` on the PR. Tell Devin that it should post a comment reporting what issues were found or that no issues were found.
- Address Devin's findings, run the relevant validation, push the fixes, and request another review until Devin explicitly reports **“Devin Review: No Issues Found”** (or an equivalent clean result) for the latest head commit.
- A green check that only confirms review completion, resolved comment threads, or a clean review of an older commit does not satisfy this requirement.
- If Devin is unavailable, cannot access the repository, or still reports issues, report that as a blocker. Do not claim the PR is ready or that this requirement has passed.
