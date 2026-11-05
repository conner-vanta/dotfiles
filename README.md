# Personal agent workflows

`AGENTS.override.md` contains general push and authentication preferences.
Five `conner-*` skills in `.agents/skills/` cover ticket work, PEX PR preparation, read-only
code review, stand-up drafts, and PR babysitting. The ticket workflow applies to
all Jira projects; SNOW work proceeds without requiring plan mode.
The ticket skill loads separate `snow.md` and `pex.md` references. SNOW uses the
repository PR template directly, without diagrams or the personal PEX PR skill.
The PEX PR skill bundles its architecture diagram examples.

The layout follows the [Agent Skills specification](https://agentskills.io/specification)
and [creation guidance](https://agentskills.io/skill-creation/best-practices).
Obsidian supplies the shared `migrate-vitest-to-default`, `commit-and-pr`, and
`babysit-pr` skills that these personal workflows build on.

Run `bash install.sh` as usual. After service setup, it copies the override to
`/workspaces/obsidian/AGENTS.override.md` and the complete skill directories to
`/workspaces/obsidian/.agents/skills/`. The `conner-*` names avoid collisions with
Obsidian’s shared skills. Re-running refreshes these copies; files removed or
renamed in dotfiles must be removed from the destination manually.
