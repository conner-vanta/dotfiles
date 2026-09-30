# Jira ticket workflow (“do PEX-xxx”)

When the user asks you to **do** a Jira ticket, or phrasing like **“do PEX-123”**, **“work on PEX-123”**, or **“start PEX-123”** (where `PEX-123` is a Jira issue key), treat that issue key as **`TICKET`** and follow this workflow **in order**. Do not skip steps unless the user explicitly changes scope.

## Preconditions

- Assume a **git** repository and **Atlassian CLI (`acli`)** installed and already authenticated for Jira (`acli jira …` works).
- If `acli` or `git` fails, report the error and stop; do not invent ticket text.

## Steps

### 1. Update `main`

- Check out **`main`** (or **`master`** if that is the default branch and `main` does not exist).
- Run **`git pull`** (with fast-forward only if that is the repo norm; otherwise pull as the project usually does) so **`TICKET`** work starts from current upstream.

### 2. Create branch `conner/TICKET`

- From the updated default branch, create and check out a new branch named exactly:

  **`conner/TICKET`**

  Example: for `PEX-742`, the branch is **`conner/PEX-742`**.

- If that branch already exists locally, check it out and **rebase or merge** from the updated default branch per repo practice, or ask the user if there is ambiguity.

### 3. Load ticket summary and description

- Run (substitute the real issue key for `TICKET`):

  ```bash
  acli jira workitem view TICKET --fields summary,description
  ```

- Use the **command output as the source of truth** for summary and description. If the command errors or returns empty fields, say so and do not fabricate scope.

### 4. Plan from the ticket

- Build a **concrete implementation plan** grounded only in:
  - the fetched **summary** and **description**, and
  - what you can infer from the **current codebase** after brief, targeted exploration if needed.
- If you are **not sure which files or areas are relevant** (e.g. the ticket is vague, the repo is large, or multiple subsystems could apply), **stop and ask the user**—prompt them to list or point to **relevant files or directories** (paths in the repo, links, or paste) before you draft a detailed plan. Do not guess a file list and proceed as if it were certain.
- The plan should include: goal, ordered tasks, files or areas likely to touch, risks or unknowns, and how to verify (tests, manual checks). Keep it proportional to ticket size.
- The plan **must explicitly include** all of the following (with concrete commands or entry points taken from the repo when you know them, e.g. `package.json`, `Makefile`, CI config):
  - **Unit tests**: add or update unit tests for the behavior in the ticket; say which suites or files you expect to touch.
  - **Green tests**: run the relevant unit test command(s), **iterate until they pass**, and note what you ran.
  - **Linter**: run the project linter on the work, fix reported issues, and note what you ran.
  - **`oxfmt`**: run **`oxfmt`** on **all changed files** (format in place or per project convention), and list which files were formatted.
- Consider breaking the task into multiple discrete pull requests that can be stacked on top of each other and are independently reviewable. Consider things like: if multiple teams are required to review a pull request, can we split this pull request into multiple so that each pull request only requires review from one team.  if a pull request is over 1,000 lines of code or span multiple systems owned by different teams, we should strongly prefer to split it into multiple pull requests. Think about any backward compatibility and deployment order requirements these pull requests, and fill in those details in the deployment section (see GitHub pull request template below) 

### 5. Present the plan

- **Present the plan to the user** in clear sections before writing large amounts of code, unless they have already asked you to implement immediately after planning.
- Include the **branch name** (`conner/TICKET`) and a **one-line reminder** of the ticket summary so context is obvious.
- The presented plan must call out **unit tests**, **passing tests**, **linter**, and **`oxfmt` on changed files** as distinct checklist items so completion criteria are unambiguous.

### 6. When you implement after the plan

- Follow the plan, including: **write/update unit tests**, **run tests until they pass**, **run the linter and fix issues**, and **run `oxfmt` on every file you changed** before considering the work done. Summarize commands run and outcomes in your final message.
- Raise a **GitHub pull request** for these changes by following the GitHub pull request instructions below.

## Naming

- **`TICKET`**: the Jira issue key from the user message (e.g. `PEX-123`).
- **Branch**: always **`conner/<TICKET>`** unless the user specifies a different naming rule in that thread.

## GitHub pull requests

When opening or drafting a **GitHub pull request** for work tied to **`PEX-xxx`**, use **only** the following body structure. Do not add extra sections, checklists, or boilerplate unless the user asks for them in that thread.

Set the pull request **title** to a concise **one-sentence** description of the changes (summarize the outcome, not every file touched).  If the changes touch the backend (e.g. web server, GraphQL resolvers, Mongo models, background jobs), then prefix the title with [BE]. If it touches the frontend, use [FE]. If it touches both, then prefix with [BE + FE].

### Labels

Attach the GitHub label **`security-risk-low`** to the pull request.

Use these **exact** headings (`### Changes`, `### Motivation`, `### Testing`):

```markdown
## Changes
<One to four short sentences describing what changed. If the pull request title conveys the changes well enough, then just write "TIN". Typically this should just be "TIN">

## Motivation
<Just write "[PEX-xxx]: {Title of the Jira ticket}" here where PEX-xxx is the actual Jira ticket ID. Be sure to include the square brackets. The Jira ticket ID can usually be parsed from the git branch name (pattern "conner/PEX-xxx")>

## Testing
<Usually just write "CI".  if the task is for a frontend ticket, then consider launching the Vanta app locally and taking screenshots or a brief MP4 recording showing the new user interface changes. If it includes both frontend and backend changes, consider additionally collecting some sort of evidence showing that the backend also works as expected (for example, inspecting the backend jobs, inspecting the database, etc.). Feel free to include details, logs, or screenshots related to the backend as well >

[PEX-xxx]: https://vanta.atlassian.net/browse/PEX-xxx

## Deployment
<Document deployment order if there are any dependencies on other PRs, especially if we're creating a PR stack. Enumerate the PRs as a numbered list with each entry formatted like: "#{PR number} - deploy to prod then wait for a full deployment cycle for rollback safety OR no dependencies". If there are no dependencies, just write "No dependencies">
```

Guidelines:

- **Changes**: Stay to either "TIN" or **one or two sentences** total; name the behavioral or structural outcome, not every file touched.
- **Motivation**: Always write "[PEX-xxx]" where PEX-xxx is the Jira ticket ID. If you don't know the Jira ticket ID then just write "TODO"
- **Testing**: Always write "CI"
- Do not include the phrase "Made-with: Cursor".

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
