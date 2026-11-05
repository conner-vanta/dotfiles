# PEX pull requests

Use this format only for PEX work. Do not add sections, checklists, or boilerplate
unless requested. Write a concise one-sentence title describing the outcome;
prefix it with `[BE]`, `[FE]`, or `[BE + FE]` for the affected application layers.
Attach the `security-risk-low` label.

## Prepare the content

- **Changes:** use discrete bullets, each with a bold first sentence followed by
  one or two sentences explaining its motivation. Use `TIN` instead if the title
  sufficiently describes the change. Attach an architecture PNG with boxes named
  for real services/components and highlight the changed components. Use the
  [write-path](../assets/01-option-one-write-path.png) and
  [read-path](../assets/02-option-one-read-path.png) examples for style and detail;
  include before/after diagrams when helpful.
- **Motivation:** write `[PEX-xxx]: {actual Jira title}` using the real issue key
  (usually available from `conner/PEX-xxx`) and fetched title.
- **Testing:** always write `CI`. For frontend changes, also launch the local
  Vanta app and attach screenshots or a brief QuickTime-compatible MP4 showing
  the changed UI. Browser installation is authorized. On upload authentication
  failures, load Ona shell exports and retry; if still blocked, provide the media
  to the user as a downloadable ZIP.
- **Deployment:** enumerate preceding stack PRs and their deployment requirements:
  `#123 - deploy to prod first` or `#123 - no dependency on this PR`.
  Consider compatibility and whether an earlier PR must fully deploy before this
  one. Without dependencies, write `No dependencies`.

For GitHub authentication/authorization failures, load Ona shell exports and retry.
Replace placeholders in this template with the prepared content:

```markdown
## Changes

{Change bullets or TIN, plus architecture PNG}

## Motivation

[PEX-xxx]: {Actual Jira title}

## Testing

CI

{Frontend evidence, when applicable}

[PEX-xxx]: https://vanta.atlassian.net/browse/PEX-xxx

## Deployment

{Numbered predecessor PR list or No dependencies}
```
