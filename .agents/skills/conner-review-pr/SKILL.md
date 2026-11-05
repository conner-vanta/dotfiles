---
name: conner-review-pr
description: Perform Conner’s read-only GitHub PR review with verified defects, priority, blocking status, origin, and practical fixes. Use for “review” followed by a PR URL; not for implementing feedback or babysitting.
---

# GitHub pull request review workflow (`review <PR_URL>`)

When the user asks to **review** a GitHub pull request with phrasing such as **`review https://github.com/OWNER/REPO/pull/123`**, treat the URL as **`PR_URL`** and perform a read-only code review. Do not change code, push commits, submit a GitHub review, or post comments unless the user explicitly asks.

## Preconditions

- Parse the owner, repository, and pull request number from **`PR_URL`**.
- Use GitHub pull request metadata and the diff as the source of truth. Inspect relevant surrounding code, tests, and repository instructions when needed to understand the change.
- If the pull request or repository cannot be accessed, report the error and stop. Do not invent diff contents or findings.

## Review process

1. Read the pull request description, commits, changed files, and complete diff against its base branch.
2. Identify the intended behavior and trace affected callers, data flows, tests, and interfaces far enough to evaluate the change in context.
3. Review the change for:
   - **Correctness**: logic errors, edge cases, regressions, error handling, concurrency, compatibility, and inadequate tests.
   - **Readability**: clarity, naming, unnecessary complexity, misleading comments, and maintainability.
   - **Code organization**: ownership boundaries, abstractions, duplication, cohesion, and consistency with repository conventions.
   - **Performance**: avoidable work, inefficient queries or loops, excessive allocations or network calls, and scalability risks.
   - **Security**: authorization, tenant isolation, validation, injection, sensitive-data exposure, unsafe defaults, and dependency risk.
4. When useful, spawn sub-agents to review individual categories in parallel. Give each sub-agent the same pull request and a distinct category, then independently verify and deduplicate their findings before presenting them.
5. Prefer concrete defects and actionable risks over stylistic preferences. Do not report a finding unless the changed code causes it or the pull request materially exposes or worsens it. For each confirmed finding, develop practical solution ideas rather than only describing the problem.

## Finding classification

Assign every finding both a priority and a merge recommendation:

- **P1**: high-impact correctness, security, data-loss, availability, or broadly breaking issue. Usually **blocking**.
- **P2**: material defect or maintainability/performance problem with meaningful impact but limited scope. Mark **blocking** when it should be fixed before merge; otherwise mark **non-blocking** and explain why follow-up is safe.
- **P3**: low-impact improvement, localized cleanup, or minor test/readability gap. Usually **non-blocking**.

Also classify the origin of every finding:

- **Introduced by this PR**: absent from the base branch and caused by the proposed change.
- **Pre-existing**: already present on the base branch. Pre-existing issues are normally non-blocking for this pull request unless the change makes them materially worse or unsafe to leave in the affected path.

Verify origin against the base branch rather than guessing from the diff. Keep priority and blocking status separate: priority describes impact; blocking status describes whether this pull request should merge before the issue is addressed.

## Review output

List findings first in priority order (**P1**, then **P2**, then **P3**). For each finding, include:

- a concise title;
- **Priority:** `P1`, `P2`, or `P3`;
- **Merge:** `Blocking` or `Non-blocking`;
- **Origin:** `Introduced by this PR` or `Pre-existing`;
- the affected file and line or smallest useful line range;
- a clear explanation of the failure mode or risk, including the conditions that trigger it; and
- one or more concrete solution ideas, identifying the recommended approach and relevant tradeoffs when alternatives exist. If the available context is insufficient to recommend a safe fix, state what information is needed rather than guessing.

Do not inflate the review with praise or speculative concerns. If there are no findings, say so explicitly and briefly note any residual risks or verification gaps, such as tests that could not be run. End with a one-line merge recommendation based on the findings.
