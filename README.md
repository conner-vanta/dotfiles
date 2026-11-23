# Personal agent workflows

`AGENTS.override.md` contains general push and authentication preferences.
Six `conner-*` skills in `.agents/skills/` cover ticket work, PEX/SNOW PR preparation, read-only
code review, stand-up drafts, PR babysitting, and Snowplow batch pickup. The ticket workflow applies to
all Jira projects; SNOW work proceeds without requiring plan mode.
The ticket skill loads separate `snow.md` and `pex.md` references. SNOW uses the
repository PR template without diagrams. The shared PR skill requires local
Greptile and Codex reviews and feedback resolution before draft creation
for both PEX and SNOW, including each PR in a Snowplow batch. It bundles the
[Ona review commands](.agents/skills/conner-pr-workflow/references/local-ai-reviews.md)
from the AI Code Reviews Guru card alongside its architecture diagram examples.

Say “do a batch of tickets from SNOW-1318” or supply the epic’s Jira URL.
`conner-snowplow-batch` picks three unassigned children by default. Give a
count to override it, for example “do 5 tickets from SNOW-1318”. “Do more
Snowplow tickets” continues with the same epic, or defaults to SNOW-1320 when
no epic is in context. The skill assigns the tickets to you, moves them to
In Progress, and follows the epic and ticket instructions in separate worktrees.
It normally opens one or two draft PRs grouped by Approval Bot eligibility.
Every migration PR stays under 1,000 additions plus deletions. Larger batches
or tickets get additional independent drafts, each targeting `main`.

The layout follows the [Agent Skills specification](https://agentskills.io/specification)
and [creation guidance](https://agentskills.io/skill-creation/best-practices).
Obsidian supplies the shared `migrate-to-vanta-testing`, `commit-and-pr`,
`greptile-code-review`, `local-code-review`, and `babysit-pr` skills that these
personal workflows build on.

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
Obsidian’s shared skills. Installation adds `/.agents/skills/conner-*/` to
Obsidian’s local Git exclude file, keeping personal skills out of commits without
editing the shared `.gitignore`. Re-running does not duplicate the ignore rule.
Already-tracked files are unaffected by ignore rules.
Re-running refreshes these copies; files removed or
renamed in dotfiles must be removed from the destination manually.
