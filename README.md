# Personal agent workflows

`AGENTS.override.md` contains general push and authentication preferences.
Six `conner-*` skills in `.agents/skills/` cover ticket work, PEX PR preparation, read-only
code review, stand-up drafts, PR babysitting, and Snowplow batch pickup. The ticket workflow applies to
all Jira projects; SNOW work proceeds without requiring plan mode.
The ticket skill loads separate `snow.md` and `pex.md` references. SNOW uses the
repository PR template directly, without diagrams or the personal PEX PR skill.
The PEX PR skill bundles its architecture diagram examples.

Say “pick up a new batch of snowplow tickets” or “do more snowplow tickets” to
use `conner-snowplow-batch`. It defaults to three tickets, or accepts an explicit
count, ranks unassigned SNOW-1 children by the blocker counts in their titles,
assigns them to you, and delegates each to a subagent in a separate worktree.

The layout follows the [Agent Skills specification](https://agentskills.io/specification)
and [creation guidance](https://agentskills.io/skill-creation/best-practices).
Obsidian supplies the shared `migrate-vitest-to-default`, `commit-and-pr`, and
`babysit-pr` skills that these personal workflows build on.

## Validate skills

Install [uv](https://docs.astral.sh/uv/getting-started/installation/), then run:

```sh
bash scripts/validate-skills.sh
```

The script installs and runs the upstream [skills-ref](https://github.com/agentskills/agentskills/tree/main/skills-ref)
validator, pinned to a Git commit in `pyproject.toml` with dependencies recorded
in `uv.lock`. It validates every skill directory and fails if any skill is invalid
or no skills are present. This checks skill format, not the correctness of the
instructions. To update the validator, change its pinned revision and run `uv lock`.

GitHub Actions runs **Validate skills** on every push and on pull requests,
including drafts. The `main` ruleset requires this check from GitHub Actions
before allowing an update. Push a new commit to a feature branch first and wait
for validation; then merge its PR or push the validated commit to `main`.
An unchecked direct push is rejected rather than accepted while CI runs.
Branch protection is configured in GitHub repository settings, not by the workflow
file itself.

## Install

Run `bash install.sh` as usual. After service setup, it copies the override to
`/workspaces/obsidian/AGENTS.override.md` and the complete skill directories to
`/workspaces/obsidian/.agents/skills/`. The `conner-*` names avoid collisions with
Obsidian’s shared skills. Re-running refreshes these copies; files removed or
renamed in dotfiles must be removed from the destination manually.
