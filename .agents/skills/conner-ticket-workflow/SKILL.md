---
name: conner-ticket-workflow
description: Carry out Conner’s Jira tickets in Obsidian, for any Jira project. Use when asked to do, work on, start, or implement a ticket such as PEX-123, SNOW-6, or another Jira issue key; not for read-only ticket lookup.
---

# Work on a Jira ticket

Use the requested issue key as `TICKET`. This workflow applies to all Jira projects.
Follow the steps in order unless the user changes scope or specifies a stopping
point. Git and authenticated `acli` are prerequisites: if either fails, report
the error and stop; never invent ticket content.

1. **Update the default branch.** Check out `main`, or `master` if it is the
   default and `main` does not exist. Pull using repository practice (fast-forward
   only if that is the norm), preserving unrelated working-tree changes.
2. **Prepare `conner/TICKET`.** Create the branch from the updated default branch.
   If it already exists locally, check it out and rebase or merge the updated
   default branch per repo practice; ask if ambiguous. Use a different naming
   rule only when the user specifies one.
3. **Read the ticket.** Run:

   ```sh
   acli jira workitem view TICKET --fields summary,description
   ```

   Treat command output as the source of truth. If required fields are empty or
   the command errors, report that and stop.

4. **Determine scope and relevant skills.** Use the fetched summary/description
   and targeted code exploration. If the relevant area is unclear, ask the user
   for files or directories before drafting a detailed plan; do not guess a file
   list. For backend Vitest migrations, load the repository’s
   `.agents/skills/migrate-vitest-to-default/SKILL.md` and its references, including
   the test isolation verifier guidance. That skill governs migration implementation
   and verification. Do not assume every SNOW ticket is a migration. If required
   tooling is missing after updating the checkout, report the prerequisite instead
   of inventing a replacement workflow.
5. **Plan and communicate the work.** Cover the goal, ordered tasks, affected areas,
   risks/unknowns, and verification. Consider independently reviewable stacked PRs;
   strongly prefer splitting work over 1,000 lines or across systems with different
   team ownership. Record compatibility and deployment order in the PR’s Deployment
   section. Include the branch and a one-line ticket summary. Use distinct checklist
   items with concrete repository commands or entry points when known:

   - [ ] **Unit tests:** add/update coverage for the ticket; name expected suites/files.
   - [ ] **Passing tests:** run relevant unit tests and iterate until green.
   - [ ] **Linter:** run the project linter and fix reported issues.
   - [ ] **oxfmt:** format every changed file and list the formatted files.

   Present the plan before substantial edits unless the user already asked for
   immediate implementation after planning. **SNOW tickets do not require plan
   mode or a plan-approval pause:** give a concise implementation outline in the
   current mode and proceed through implementation and verification. Honor an
   explicit request from the user to plan only or stop before implementation.

6. **Implement, verify, and open a draft PR.** Follow the plan, complete each check,
   and summarize commands and outcomes. Load the sibling `conner-pr-workflow` skill
   for PR formatting and project-specific rules: SNOW uses `[SNOW-XXX]` and
   `proj-snowplow`; PEX uses `[BE]`, `[FE]`, or `[BE + FE]`. Other Jira projects
   follow the repository’s PR conventions without inheriting PEX/SNOW rules.
