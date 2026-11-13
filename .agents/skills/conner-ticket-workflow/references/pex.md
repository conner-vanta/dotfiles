# PEX tickets

Apply these rules to PEX tickets alongside the shared Jira workflow.

For draft PR creation or updates, load the sibling `conner-pr-workflow` skill.
It owns the local Greptile, Codex, and Claude review step before draft creation,
feedback resolution, PEX body template, architecture diagrams, frontend evidence,
security-risk label, and deployment-order requirements.

Prefix the PR title with `[BE]`, `[FE]`, or `[BE + FE]` for the affected application
layers. These PEX requirements do not apply to SNOW tickets or other Jira projects.
