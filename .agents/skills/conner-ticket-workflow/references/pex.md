# PEX ticket workflow

Use the requested issue key as `TICKET`. Follow these steps in order unless the
user changes scope. Git and authenticated `acli` are prerequisites: if either
fails, report the error and stop; never invent ticket content.

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

4. **Plan from evidence.** Use only the fetched summary/description and targeted
   code exploration. If the relevant area is unclear, ask the user for files or
   directories before drafting a detailed plan; do not guess a file list. Cover
   the goal, ordered tasks, affected areas, risks/unknowns, and verification.
   Consider independently reviewable stacked PRs; strongly prefer splitting work
   over 1,000 lines or across systems with different team ownership. Record
   compatibility and deployment order in the PR’s Deployment section.
5. **Present the plan before substantial edits**, unless the user already asked
   for immediate implementation after planning. Include the branch and a one-line
   ticket summary. Use distinct checklist items with concrete repository commands
   or entry points when known:

   - [ ] **Unit tests:** add/update coverage for the ticket; name expected suites/files.
   - [ ] **Passing tests:** run relevant unit tests and iterate until green.
   - [ ] **Linter:** run the project linter and fix reported issues.
   - [ ] **oxfmt:** format every changed file and list the formatted files.

6. **Implement and verify.** Follow the plan, complete each check above, and
   summarize commands and outcomes. Load the sibling `conner-pr-workflow` skill
   to create the GitHub PR with the PEX format and review requirements.
