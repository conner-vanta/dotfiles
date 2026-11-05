## GitHub pull requests

When opening or drafting a **GitHub pull request** for work tied to **`PEX-xxx`**, use **only** the following body structure. Do not add extra sections, checklists, or boilerplate unless the user asks for them in that thread.

Set the pull request **title** to a concise **one-sentence** description of the changes (summarize the outcome, not every file touched). If the changes touch the backend (e.g. web server, GraphQL resolvers, Mongo models, background jobs), then prefix the title with [BE]. If it touches the frontend, use [FE]. If it touches both, then prefix with [BE + FE].

### Labels

Attach the GitHub label **`security-risk-low`** to the pull request.

Use the exact level-two headings in the template below, including `## Deployment`:

```markdown
## Changes

<
Bullet points describing what changed. Each bullet point describes a discrete change. The first sentence of the bullet point should be bolded, and then the remaining one to two sentences should be motivation for that specific change

If the pull request title conveys the changes well enough, then just write "TIN".

Attach an architecture diagram as a PNG showing the different components or services that are involved. The style should be that boxes contain services or components with actual names from our system. See [write-path example](../assets/01-option-one-write-path.png) and [read-path example](../assets/02-option-one-read-path.png) for examples of the style and detail of the diagram. If helpful, generate a diagram illustrating the architecture before the change and after the change. Highlight the parts of the architecture that are changing.

If you run into any authentication / authorization issues with GitHub, especially CLI authentication, then load the Ona shell exports and then try again.

>

## Motivation

<Write "[PEX-xxx]: {Title of the Jira ticket}" here where PEX-xxx is the actual Jira ticket ID. Be sure to include the square brackets. The Jira ticket ID can usually be parsed from the git branch name (pattern "conner/PEX-xxx")>

## Testing

<
Always write "CI".

If the task includes frontend changes, then launch the Vanta app locally and take screenshots or a brief QuickTime-compatible MP4 recording showing the new user interface changes. If you're not able to attach these to the pull request due to an authentication or authorization issue, try loading Ona shell exports then try again. If it still fails, then just give them to me as a downloadable zip file. You are allowed to install a browser; you do not need to ask for permission.

>

[PEX-xxx]: https://vanta.atlassian.net/browse/PEX-xxx

## Deployment

<Document deployment order if there are any dependencies on other PRs. If we're creating a PR stack, determine if one of the earlier PRs needs to be merged and fully deployed before the current PR. If there are such dependencies, then enumerate the PRs that precede this current PR in the stack as a numbered list. For a PR that needs to be deployed before the current PR, then format the list entry like: "#{PR number} - deploy to prod first". For a PR that does not need to be deployed before the current PR, then format the list entry like "#{PR number} - no dependency on this PR". If there are no such dependencies for the current PR, just write "No dependencies".>
```
