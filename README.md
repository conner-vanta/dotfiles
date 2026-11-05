# Personal agent workflows

`AGENTS.override.md` contains general preferences and routes requests to five
`conner-*` skills in `.agents/skills/`: ticket work, PR preparation, read-only
code review, stand-up drafts, and PR babysitting. Detailed PEX/SNOW rules live
in references; the PR skill bundles the architecture diagram examples.

The layout follows the [Agent Skills specification](https://agentskills.io/specification)
and [creation guidance](https://agentskills.io/skill-creation/best-practices).
Obsidian supplies the shared `migrate-vitest-to-default`, `commit-and-pr`, and
`babysit-pr` skills that these personal workflows build on.

Run `bash install.sh` as usual. After service setup, it copies the override to
`/workspaces/obsidian/AGENTS.override.md` and the complete skill directories to
`/workspaces/obsidian/.agents/skills/`. The `conner-*` names avoid collisions with
Obsidian’s shared skills. Re-running refreshes these copies; files removed or
renamed in dotfiles must be removed from the destination manually.
