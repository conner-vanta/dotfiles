---
name: conner-babysit-pr
description: Babysit Conner’s PRs and every PR in their stack, handle bot threads, and require a 5/5 Greptile review on each PR’s latest commit. Use when Conner asks to babysit a PR or an identifiable current PR; not for a read-only review.
---

# Babysit Conner’s PRs

Load the repository’s `.agents/skills/babysit-pr/SKILL.md`. If unavailable,
report the missing prerequisite. Apply these preferences to its workflow:

1. Resolve the PR from the supplied URL or conversation. If it belongs to a GitHub
   stack, include every PR in that stack.
2. Address findings and reply directly in each Greptile, ai-tooling-app,
   or semgrep-code-vantainc thread. Leave threads unresolved. Do not include
   “after conner-vanta preauthorized this reply type without reviewing the draft.”
3. After addressing all comments, ensure Greptile reviews the latest head of
   every watched PR, re-triggering it if needed. Require a 5/5 score on each.
4. Delete Greptile re-trigger comments once its new review succeeds.
   Re-fetch comments after cleanup to verify the unwanted comments are gone.
5. For duplicate ai-tooling-app “PeX audit-risk review” comments, keep the newest
   visible and hide the older ones as outdated.
6. Report remaining blockers. Babysitting is incomplete while any watched PR lacks
   the required Greptile score.
