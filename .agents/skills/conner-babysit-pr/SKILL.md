---
name: conner-babysit-pr
description: Babysit Conner’s PRs and every PR in their stack, handle bot threads, and require clean latest-head Devin and 5/5 Greptile reviews. Use when Conner asks to babysit a PR or an identifiable current PR; not for a read-only review.
---

# Babysit Conner’s PRs

Load the repository’s `.agents/skills/babysit-pr/SKILL.md` and the sibling
`conner-pr-workflow` skill. If the repository skill is unavailable, report the
missing prerequisite. Apply these preferences to its workflow:

1. Resolve the PR from the supplied URL or conversation. If it belongs to a GitHub
   stack, include every PR in that stack.
2. Address findings and reply directly in each Devin, Greptile, ai-tooling-app,
   or semgrep-code-vantainc thread. Leave threads unresolved. Do not include
   “after conner-vanta preauthorized this reply type without reviewing the draft.”
3. After addressing all comments, re-trigger Greptile and Devin. Require a 5/5
   Greptile score and explicit no-issues Devin results for the latest head of
   every watched PR, following `conner-pr-workflow`’s validation and retry loop.
4. Once a new review successfully runs, delete the comment used to re-trigger it.
   For Devin’s “Starting Devin Review” and “Devin Review found X issues” status
   comments, keep only the latest of each type and delete stale duplicates.
5. For duplicate ai-tooling-app “PeX audit-risk review” comments, keep the newest
   visible and hide the older ones as outdated.
6. Report remaining blockers. Babysitting is incomplete while any watched PR lacks
   a clean latest-head Devin review or the required Greptile score.
