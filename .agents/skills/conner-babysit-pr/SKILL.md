---
name: conner-babysit-pr
description: Babysit Conner’s PRs and every PR in their stack, handle bot threads, and require clean latest-head Devin and 5/5 Greptile reviews. Use when Conner asks to babysit a PR or an identifiable current PR; not for a read-only review.
---

# Babysit ("babysit {optional GitHub Pull Request Link or you can infer the Pull Request from the conversation context}")

Load the repository’s `.agents/skills/babysit-pr/SKILL.md` and follow its workflow. If unavailable, report the missing prerequisite. Additionally, be sure to reply to any Devin, Greptile, ai-tooling-app, or semgrep-code-vantainc comments directly in the thread. Do not resolve the comments. In your reply, do not include the text "after conner-vanta preauthorized this reply type without reviewing the draft." After addressing all comments, re-trigger Greptile and Devin reviews. It's important to get a 5/5 Greptile review score and Devin finds no issues. After a new Devin or Greptile review successfully runs, delete the comment that you used to re-trigger the Devin or Greptile review. Also, I noticed that Devin posts comments like "Devin Review found X issues" and "Starting Devin Review." for each review. Delete stale ones; only keep the latest one for each comment type. There should not be multiple for each of those comment types on the PR.

Also enforce the Devin review requirement in the sibling `conner-pr-workflow` skill: babysitting is not complete until Devin reports no issues found on the latest head commit of every PR being watched.

Also, if there are multiple comments from ai-tooling-app that provide the "PeX audit-risk review", hide all of them as "outdated" except for the most recent one. Keep only the most recent one on the pull request.

if the pull request is part of a GitHub stack, then babysit all of the pull requests in the stack.
