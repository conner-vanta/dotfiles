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
<One or two short sentences describing what changed. No bullet lists unless the user asks. If the pull request title conveys the changes well enough, then just write "TIN". Typically this should just be "TIN">

## Motivation
<Just write "[PEX-xxx]: {Title of the Jira ticket}" here where PEX-xxx is the actual Jira ticket ID. Be sure to include the square brackets. The Jira ticket ID can usually be parsed from the git branch name (pattern "conner/PEX-xxx")>

## Testing
<Just write "CI">

[PEX-xxx]: https://vanta.atlassian.net/browse/PEX-xxx
```

Guidelines:

- **Changes**: Stay to either "TIN" or **one or two sentences** total; name the behavioral or structural outcome, not every file touched.
- **Motivation**: Always write "[PEX-xxx]" where PEX-xxx is the Jira ticket ID. If you don't know the Jira ticket ID then just write "TODO"
- **Testing**: Always write "TODO"
- Do not include the phrase "Made-with: Cursor".
