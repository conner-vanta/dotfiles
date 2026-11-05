---
name: conner-ticket-workflow
description: Carry out Conner’s PEX or SNOW Jira tickets in Obsidian. Use for “do PEX-123”, “work on SNOW-6”, or starting implementation of either ticket type; not for read-only ticket lookup.
---

# Work on a Jira ticket

Use the issue key as `TICKET`. Honor an explicit change of scope or stopping point.
For PEX work, read [the PEX workflow](references/pex.md) before starting; it owns
planning, implementation, and validation. For SNOW work, follow the steps below.

## SNOW workflow

1. With git and authenticated `acli` available, check out `main` (or `master` if
   it is the default and `main` does not exist), then pull using repository practice.
   Preserve unrelated working-tree changes. Create `conner/TICKET` from the updated
   default branch. If it exists locally, check it out and rebase or merge the updated
   default branch per repo practice; ask if ambiguous.
2. Run `acli jira workitem view TICKET --fields summary,description`.
   If git or acli fails, or required ticket fields are empty, report and stop.
   Use fetched fields as the scope; never invent ticket text.
3. Determine the work from the ticket. For backend Vitest migrations, load the
   repository’s `.agents/skills/migrate-vitest-to-default/SKILL.md` and its
   references, including the test isolation verifier guidance. Do not assume all
   SNOW tickets are migrations. If required tooling is missing after updating the
   checkout, report the prerequisite instead of inventing a replacement workflow.
4. Present a concrete plan grounded in the ticket and code before substantial
   edits. Carry out implementation and verification through draft PR creation
   unless the user specifies another stopping point. For migrations, the repository
   migration skill governs implementation and verification.
5. Load the sibling `conner-pr-workflow` skill before preparing the draft PR.
   It owns SNOW titles, concise migration descriptions, Jira status, and Devin review.
