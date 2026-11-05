# Conner’s Obsidian preferences

Follow the repository’s `AGENTS.md` as well as these personal preferences.
Load only the skills relevant to the current request from `.agents/skills/`:

| Request                                     | Skill                                        |
| ------------------------------------------- | -------------------------------------------- |
| Do, work on, or start a PEX/SNOW ticket     | `conner-ticket-workflow`                     |
| Create/update my PR or assess its readiness | `conner-pr-workflow`                         |
| Review a GitHub PR                          | `conner-review-pr`                           |
| Draft my daily stand-up update              | `conner-standup`                             |
| Babysit my PR (including its stack)         | `conner-babysit-pr` and `conner-pr-workflow` |

These skills add personal preferences to the repository’s shared workflows;
they do not replace its implementation, testing, or security guidance.

## PR readiness

Every PR I author, including each stack layer, needs a clean Devin review of
its latest head before it is ready to merge. Follow `conner-pr-workflow` for
the review loop; report unavailable review as a blocker.

# Git push authorization

Normal, non-force pushes to the current feature or PR branch are
preauthorized when needed to complete my requested work, including
PR babysitting and CI fixes. Do not ask for separate confirmation.
Run relevant validation and keep Git hooks enabled.

# Authentication / Authorization Issues

If you run into any authentication / authorization issues with GitHub, Datadog, or any other service, then load the Ona shell exports and then try again. Usually this means an environment variables isn't set. Loading the shell exports will set the environment variables.
